const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {
  onDocumentCreated,
  onDocumentDeleted,
} = require("firebase-functions/v2/firestore");
const {defineSecret, defineString} = require("firebase-functions/params");
const {verifyHmac} = require("./paymob");
const {getFirestore, FieldValue, Timestamp} = require("firebase-admin/firestore");
const {getAuth} = require("firebase-admin/auth");
const {initializeApp} = require("firebase-admin/app");
const axios = require("axios");
const {
  BookingError,
  parseSelection,
  reserveInventory,
} = require("./booking");

initializeApp();

const paymobSecretKey = defineSecret("PAYMOB_SECRET_KEY");
const paymobCardId = defineSecret("PAYMOB_CARD_ID");
const paymobWalletId = defineSecret("PAYMOB_WALLET_ID");
const paymobKioskId = defineSecret("PAYMOB_KIOSK_ID");

const paymobHmacSecret = defineSecret("PAYMOB_HMAC_SECRET");
// URL of the deployed paymobWebhook function. Optional: you can instead
// set it as "Transaction processed callback" in the Paymob dashboard.
const webhookUrl = defineString("PAYMOB_WEBHOOK_URL", {default: ""});

// Card / wallet are paid in minutes; kiosk (Aman, Masary) can take days.
const HOLD_MINUTES = {CARD: 15, WALLET: 15, KIOSK: 24 * 60};
const ALLOWED_METHODS = ["CARD", "WALLET", "KIOSK"];

/** Turns {increment: n} markers from booking.js into FieldValue.increment. */
function toFirestoreUpdates(updates) {
  const out = {};
  for (const [key, value] of Object.entries(updates)) {
    out[key] = value && typeof value === "object" &&
      Object.keys(value).length === 1 && "increment" in value ?
      FieldValue.increment(value.increment) : value;
  }
  return out;
}

/** Verifies the Firebase ID token sent as `Authorization: Bearer <token>`. */
async function requireUser(req) {
  const header = req.get("Authorization") || "";
  const match = header.match(/^Bearer (.+)$/);
  if (!match) throw new BookingError("Please login to continue", 401);
  try {
    return await getAuth().verifyIdToken(match[1]);
  } catch (e) {
    throw new BookingError("Invalid or expired login", 401);
  }
}

/**
 * POST /createPayment
 * Authorization: Bearer <Firebase ID token>
 * {
 *   eventId: string,
 *   paymentMethod: "CARD" | "WALLET" | "KIOSK",
 *   tickets: [{tierIndex: int, quantity: int}],      // events.ticketTiers[i]
 *   seats:   [{rowIndex: int, seatIndex: int}]       // seated events only
 * }
 *
 * The client only sends positions. Names, prices, fees and totals are all
 * computed here from Firestore, with the same rules as the app.
 */
exports.createPayment = onRequest(
    {secrets: [paymobSecretKey, paymobCardId, paymobWalletId, paymobKioskId]},
    async (req, res) => {
      try {
        if (req.method !== "POST") {
          throw new BookingError("Only POST requests are allowed", 405);
        }

        const decoded = await requireUser(req);
        const {eventId, paymentMethod} = req.body || {};

        if (!eventId || typeof eventId !== "string") {
          throw new BookingError("eventId is required");
        }
        if (!ALLOWED_METHODS.includes(paymentMethod)) {
          throw new BookingError("Unsupported payment method");
        }
        const selection = parseSelection(req.body);

        const integrationId = Number({
          CARD: paymobCardId,
          WALLET: paymobWalletId,
          KIOSK: paymobKioskId,
        }[paymentMethod].value());
        if (!Number.isInteger(integrationId)) {
          throw new BookingError("Invalid Paymob integration configuration", 500);
        }

        // Not secret (just the Paymob integration number): helps debugging.
        console.log("Paymob integration used:", paymentMethod, integrationId);

        const db = getFirestore();
        const eventRef = db.collection("events").doc(eventId);
        const userRef = db.collection("users").doc(decoded.uid);
        const orderRef = db.collection("orders").doc();

        const userSnap = await userRef.get();
        const user = userSnap.exists ? userSnap.data() : {};
        const attendeeName = String(user.name || decoded.name ||
          decoded.email || "").trim() || null;

        // Reserve stock + seats and create the order in ONE transaction
        // (same behaviour as placeOrder in the app, but status = pending).
        const now = new Date();
        const order = await db.runTransaction(async (tx) => {
          const snap = await tx.get(eventRef);
          if (!snap.exists) throw new BookingError("Event not found", 404);
          const event = snap.data();
          if (event.status && event.status !== "live") {
            throw new BookingError("This event is not open for booking");
          }

          const r = reserveInventory(event, selection, now);

          const doc = {
            orderId: orderRef.id,
            userId: decoded.uid,
            eventId,
            eventTitle: event.eventTitle || "",
            eventCoverImageUrl: event.coverImageUrl || "",
            eventStartAt: event.startAt || "",
            eventEndAt: event.endAt || "",
            eventCategory: event.eventCategory || "",
            eventLocation: event.eventLocation || null,
            attendeeName,
            tickets: r.items.map((t) => ({
              ticketName: t.name,
              ticketPrice: t.price,
              quantity: t.quantity,
              ...(r.sectionByTier[t.tierIndex] ?
                {sectionName: r.sectionByTier[t.tierIndex]} : {}),
            })),
            seats: r.seats.map((s) => ({
              row: s.rowIndex,
              seat: s.seatIndex,
              label: s.label,
            })),
            ticketCount: r.ticketCount,
            subtotal: r.pricing.subtotal,
            serviceFee: r.pricing.serviceFee,
            taxes: r.pricing.taxes,
            totalPrice: r.pricing.total,
            paymentMethod,
            status: "pending", // webhook -> "confirmed" / "failed"
            holdExpiresAt: Timestamp.fromMillis(
                now.getTime() + HOLD_MINUTES[paymentMethod] * 60 * 1000),
            // What must be given back if the payment fails or expires.
            reservation: {
              tiers: selection.tickets,
              seats: r.seats.map((s) => ({
                rowIndex: s.rowIndex,
                seatIndex: s.seatIndex,
              })),
              salesDay: Object.keys(r.updates)
                  .find((k) => k.startsWith("salesByDay."))
                  .replace("salesByDay.", ""),
            },
            createdAt: FieldValue.serverTimestamp(),
          };

          tx.update(eventRef, toFirestoreUpdates(r.updates));
          tx.set(orderRef, doc);
          return doc;
        });

        // Paymob requires: sum(items.amount * items.quantity) === amount.
        // So the fees and taxes are sent as items too, and the amount is the
        // exact sum of the items (in cents).
        const paymobItems = order.tickets.map((t) => ({
          name: t.ticketName,
          amount: Math.round(t.ticketPrice * 100),
          description: order.eventTitle || "Event ticket",
          quantity: t.quantity,
        }));
        if (order.serviceFee > 0) {
          paymobItems.push({
            name: "Service fee",
            amount: Math.round(order.serviceFee * 100),
            description: "Service fee",
            quantity: 1,
          });
        }
        if (order.taxes > 0) {
          paymobItems.push({
            name: "Taxes",
            amount: Math.round(order.taxes * 100),
            description: "Taxes",
            quantity: 1,
          });
        }
        const amountInCents = paymobItems.reduce(
            (sum, i) => sum + i.amount * i.quantity, 0);
        await orderRef.update({amountCents: amountInCents});

        const [firstName, ...rest] = (attendeeName || "Customer").split(" ");

        try {
          const paymob = await axios.post(
              "https://accept.paymob.com/v1/intention/",
              {
                amount: amountInCents,
                currency: "EGP",
                payment_methods: [integrationId],
                items: paymobItems,
                billing_data: {
                  first_name: firstName || "Customer",
                  last_name: rest.join(" ") || "NA",
                  email: decoded.email || user.email || "NA",
                  phone_number: user.phone || user.phoneNumber ||
                    "+201000000000",
                  apartment: "NA",
                  floor: "NA",
                  building: "NA",
                  street: "NA",
                  city: "Cairo",
                  state: "Cairo",
                  country: "EG",
                },
                special_reference: orderRef.id,
                ...(webhookUrl.value() ?
                  {notification_url: webhookUrl.value()} : {}),
              },
              {
                headers: {
                  "Authorization": `Token ${paymobSecretKey.value()}`,
                  "Content-Type": "application/json",
                },
              },
          );

          await orderRef.update({
            paymobIntentionId: paymob.data.id,
            paymobOrderId: paymob.data.intention_order_id,
          });

          return res.status(200).json({
            success: true,
            orderId: orderRef.id,
            amount: order.totalPrice,
            currency: "EGP",
            paymentMethod,
            clientSecret: paymob.data.client_secret,
          });
        } catch (paymobError) {
          // Paymob refused: give the seats/stock back and fail the order.
          await releaseOrder(db, orderRef.id, "failed");
          throw paymobError;
        }
      } catch (error) {
        if (error instanceof BookingError) {
          return res.status(error.status).json({
            success: false,
            message: error.message,
          });
        }
        const detail = error.response && error.response.data ?
          error.response.data : error.message;
        console.error("Create payment error:", detail);
        return res.status(500).json({
          success: false,
          message: "Failed to create payment",
        });
      }
    },
);

/**
 * Gives stock + seats of a pending order back and sets its final status.
 * Safe to call twice (only acts on orders still "pending").
 * Will also be used by the Paymob webhook (next step) for failed payments.
 */
async function releaseOrder(db, orderId, finalStatus) {
  const {releaseInventory} = require("./booking");
  const orderRef = db.collection("orders").doc(orderId);
  await db.runTransaction(async (tx) => {
    const orderSnap = await tx.get(orderRef);
    if (!orderSnap.exists || orderSnap.data().status !== "pending") return;
    const order = orderSnap.data();
    const eventRef = db.collection("events").doc(order.eventId);
    const eventSnap = await tx.get(eventRef);
    if (eventSnap.exists) {
      tx.update(eventRef, toFirestoreUpdates(
          releaseInventory(eventSnap.data(), order)));
    }
    tx.update(orderRef, {status: finalStatus});
  });
}

/**
 * POST /paymobWebhook?hmac=...   (Paymob "Transaction processed callback")
 *
 *  - bad / missing HMAC            -> 401, nothing changes
 *  - success                       -> order "confirmed" (amount re-checked)
 *  - success but hold already gone -> order "refund_needed" (refund by hand)
 *  - failed attempt                -> only recorded; the hold stays so the
 *                                     customer can retry on the same page,
 *                                     and expirePendingOrders frees it later
 *  - pending (kiosk waiting)       -> ignored
 * Always answers 200 for valid callbacks so Paymob does not keep retrying.
 */
exports.paymobWebhook = onRequest(
    {secrets: [paymobHmacSecret]},
    async (req, res) => {
      if (req.method !== "POST") return res.status(405).send("POST only");

      const body = req.body || {};
      const obj = body.obj;
      if (body.type !== "TRANSACTION" || !obj) {
        return res.status(200).send("ignored");
      }
      if (!verifyHmac(obj, req.query.hmac, paymobHmacSecret.value())) {
        console.warn("Paymob webhook: invalid HMAC");
        return res.status(401).send("invalid hmac");
      }

      try {
        const db = getFirestore();
        const paymobOrderId = obj.order && obj.order.id;

        // Find our order: by Paymob order id, else by special_reference.
        let orderRef = null;
        if (paymobOrderId != null) {
          const q = await db.collection("orders")
              .where("paymobOrderId", "==", paymobOrderId).limit(1).get();
          if (!q.empty) orderRef = q.docs[0].ref;
        }
        const specialRef = obj.order && obj.order.merchant_order_id;
        if (!orderRef && specialRef) {
          const ref = db.collection("orders").doc(String(specialRef));
          if ((await ref.get()).exists) orderRef = ref;
        }
        if (!orderRef) {
          console.warn("Paymob webhook: order not found", paymobOrderId);
          return res.status(200).send("order not found");
        }

        const success = obj.success === true || obj.success === "true";
        const pending = obj.pending === true || obj.pending === "true";
        if (pending && !success) return res.status(200).send("pending");

        await db.runTransaction(async (tx) => {
          const snap = await tx.get(orderRef);
          const order = snap.data();
          const payment = {
            paymobTransactionId: obj.id,
            paymentUpdatedAt: FieldValue.serverTimestamp(),
          };

          if (!success) {
            if (order.status === "pending") {
              tx.update(orderRef, {
                ...payment,
                lastPaymentError: obj.data && obj.data.message ?
                  String(obj.data.message) : "Payment failed",
              });
            }
            return;
          }

          if (order.status === "confirmed") return; // duplicate callback

          const expectedCents = order.amountCents != null ?
            order.amountCents : Math.round(order.totalPrice * 100);
          if (Number(obj.amount_cents) !== expectedCents) {
            console.error("Paymob webhook: amount mismatch", orderRef.id);
            tx.update(orderRef, {...payment, status: "amount_mismatch"});
            return;
          }

          tx.update(orderRef, {
            ...payment,
            // Hold expired and seats were released before the money came.
            status: order.status === "pending" ? "confirmed" : "refund_needed",
            paidAt: FieldValue.serverTimestamp(),
          });
        });

        return res.status(200).send("ok");
      } catch (error) {
        console.error("Paymob webhook error:", error.message);
        return res.status(500).send("error"); // Paymob will retry
      }
    },
);

/**
 * Every 5 minutes: frees stock + seats of pending orders whose hold ended.
 * (No composite index needed: filters by status only, expiry checked here.)
 */
exports.expirePendingOrders = onSchedule("every 5 minutes", async () => {
  const db = getFirestore();
  const snap = await db.collection("orders")
      .where("status", "==", "pending").limit(200).get();
  const now = Date.now();
  for (const doc of snap.docs) {
    const hold = doc.data().holdExpiresAt;
    if (hold && hold.toMillis() <= now) {
      try {
        await releaseOrder(db, doc.id, "expired");
      } catch (e) {
        console.error("expire failed", doc.id, e.message);
      }
    }
  }
});

/**
 * Keeps `users/{organizerId}.followers` in sync with the documents
 * `users/{uid}/following/{organizerId}` (created / deleted by the app).
 * Clients cannot write the counter themselves (see firestore.rules).
 * @param {string} organizerId  the organizer's uid
 * @param {number} delta  +1 or -1
 */
async function changeFollowers(organizerId, delta) {
  try {
    await getFirestore().collection("users").doc(organizerId).update({
      followers: FieldValue.increment(delta),
    });
  } catch (e) {
    console.error("followers update failed", organizerId, e.message);
  }
}

/**
 * Mirrors the follow into `users/{organizerId}/followers/{uid}`, so the
 * followers of an organizer can be found with one simple query (used by
 * onEventPublished in notifications.js). Only the server reads/writes it.
 */
async function setFollowerMirror(organizerId, uid, follows) {
  try {
    const ref = getFirestore().collection("users").doc(organizerId)
        .collection("followers").doc(uid);
    if (follows) {
      await ref.set({createdAt: FieldValue.serverTimestamp()});
    } else {
      await ref.delete();
    }
  } catch (e) {
    console.error("followers mirror failed", organizerId, uid, e.message);
  }
}

exports.onFollowCreated = onDocumentCreated(
    "users/{uid}/following/{organizerId}",
    async (event) => {
      const {uid, organizerId} = event.params;
      await Promise.all([
        changeFollowers(organizerId, 1),
        setFollowerMirror(organizerId, uid, true),
      ]);
    },
);

exports.onFollowDeleted = onDocumentDeleted(
    "users/{uid}/following/{organizerId}",
    async (event) => {
      const {uid, organizerId} = event.params;
      await Promise.all([
        changeFollowers(organizerId, -1),
        setFollowerMirror(organizerId, uid, false),
      ]);
    },
);

// Notifications written for the app (see notifications.js).
const notifications = require("./notifications");
exports.onOrderConfirmed = notifications.onOrderConfirmed;
exports.onEventPublished = notifications.onEventPublished;
exports.notifyHotEvents = notifications.notifyHotEvents;
exports.sendPushOnNotification = notifications.sendPushOnNotification;
