/**
 * Notifications written by the server into
 *   users/{uid}/notifications/{id}
 *   { type, title, body, isRead: false, createdAt, eventId? }
 * The app only reads them (see firestore.rules: `allow create: if false`).
 *
 * Every notification has a fixed id (e.g. `ticket_confirmed_<orderId>`) and is
 * written with create(), so a retried / duplicated trigger can never send the
 * same notification twice.
 */
const {
  onDocumentCreated,
  onDocumentWritten,
} = require("firebase-functions/v2/firestore");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

const {
  isLive,
  isUpcoming,
  soldInLastDays,
  rankEvents,
} = require("./notification_rules");

const ALREADY_EXISTS = 6;

function notificationDoc({type, title, body, eventId}) {
  return {
    type,
    title,
    body,
    isRead: false,
    createdAt: FieldValue.serverTimestamp(),
    ...(eventId ? {eventId} : {}),
  };
}

function notificationRef(db, uid, id) {
  return db.collection("users").doc(uid).collection("notifications").doc(id);
}

/** Sends one notification. Silently skips it if it was already sent. */
async function sendNotification(db, uid, id, data) {
  try {
    await notificationRef(db, uid, id).create(notificationDoc(data));
    return true;
  } catch (e) {
    if (e.code === ALREADY_EXISTS) return false;
    throw e;
  }
}

/** Sends the same notification to many users (fan-out, rate limited). */
async function sendToMany(db, uids, id, data) {
  if (!uids.length) return 0;
  const writer = db.bulkWriter();
  let sent = 0;
  for (const uid of uids) {
    writer.create(notificationRef(db, uid, id), notificationDoc(data))
        .then(() => {
          sent++;
        })
        .catch((e) => {
          if (e.code !== ALREADY_EXISTS) {
            console.error("notification failed", uid, e.message);
          }
        });
  }
  await writer.close();
  return sent;
}

/**
 * 1) "Ticket Confirmed": when an order becomes `confirmed` (Paymob webhook
 * moves it from `pending`). Also covers an order created already confirmed.
 */
exports.onOrderConfirmed = onDocumentWritten("orders/{orderId}", async (event) => {
  const after = event.data && event.data.after && event.data.after.data();
  if (!after || after.status !== "confirmed" || !after.userId) return;

  const before = event.data.before && event.data.before.data();
  if (before && before.status === "confirmed") return;

  const title = String(after.eventTitle || "").trim();
  const sent = await sendNotification(
      getFirestore(),
      after.userId,
      `ticket_confirmed_${event.params.orderId}`,
      {
        type: "ticket_confirmed",
        title: "Ticket Confirmed",
        body: title ?
          `Your booking for "${title}" is confirmed. See you there!` :
          "Your booking is confirmed. See you there!",
        eventId: after.eventId,
      },
  );
  console.log("ticket confirmed notification", after.userId,
      event.params.orderId, sent ? "sent" : "already sent");
});

/**
 * 2) "New Event": when an event goes live, every follower of its organizer
 * gets a notification. Followers are read from `users/{organizerId}/followers`
 * (mirrored from `users/{uid}/following/{organizerId}` in index.js).
 */
exports.onEventPublished = onDocumentWritten("events/{eventId}", async (event) => {
  const after = event.data && event.data.after && event.data.after.data();
  if (!after || !after.organizerId || !isLive(after)) return;

  const before = event.data.before && event.data.before.data();
  if (before && isLive(before)) return; // it was already live

  const now = new Date();
  if (!isUpcoming(after, now)) return;

  const db = getFirestore();
  const organizerId = after.organizerId;

  const followers = await db.collection("users").doc(organizerId)
      .collection("followers").select().get();
  const uids = followers.docs.map((d) => d.id).filter((id) => id !== organizerId);
  if (!uids.length) {
    console.log("new event: no followers for", organizerId);
    return;
  }

  const organizer = await db.collection("users").doc(organizerId).get();
  const organizerName = String(
      (organizer.exists && organizer.data().name) || "").trim();
  const eventTitle = String(after.eventTitle || "").trim() || "a new event";

  const sent = await sendToMany(db, uids, `new_event_${event.params.eventId}`, {
    type: "new_event",
    title: organizerName ?
      `New event from ${organizerName}` : "New Event Near You!",
    body: `${eventTitle} is now open for booking.`,
    eventId: event.params.eventId,
  });
  console.log("new event notified", event.params.eventId, sent);
});

/**
 * 3) "Top selling" / "Trending": every 3 hours the events are ranked with the
 * same rules as the home badges. An event that just earned a badge is sent to
 * all registered users (not guests, not its own organizer), once per badge.
 * `topSellingNotified` / `trendingNotified` on the event remember that.
 */
exports.notifyHotEvents = onSchedule("every 3 hours", async () => {
  const db = getFirestore();
  const now = new Date();

  const snap = await db.collection("events").limit(500).get();
  const events = snap.docs
      .filter((d) => isLive(d.data()) && isUpcoming(d.data(), now))
      .map((d) => {
        const data = d.data();
        return {
          id: d.id,
          ref: d.ref,
          data,
          ticketsSold: Number(data.ticketsSold) || 0,
          soldLast7Days: soldInLastDays(data.salesByDay, 7, now),
        };
      });

  const badges = rankEvents(events);

  // Say what was seen, so a run that sends nothing can be understood.
  console.log("hot events: read", snap.size, "events,", events.length,
      "live and upcoming");
  for (const e of events) {
    if (e.ticketsSold || e.soldLast7Days) {
      console.log("hot events: candidate", e.id, JSON.stringify({
        title: e.data.eventTitle,
        ticketsSold: e.ticketsSold,
        soldLast7Days: e.soldLast7Days,
        badge: badges.get(e.id) || "none",
        topSellingNotified: !!e.data.topSellingNotified,
        trendingNotified: !!e.data.trendingNotified,
      }));
    }
  }
  console.log("hot events: badges", JSON.stringify([...badges]));

  const fresh = events.filter((e) => {
    const badge = badges.get(e.id);
    return badge === "top_selling" ? !e.data.topSellingNotified :
      badge === "trending" ? !e.data.trendingNotified : false;
  });
  if (!fresh.length) {
    console.log("hot events: nothing new to notify");
    return;
  }

  const users = await db.collection("users")
      .where("isGuest", "==", false).select().get();
  const allUids = users.docs.map((d) => d.id);
  console.log("hot events: audience", allUids.length, "registered users");

  for (const e of fresh) {
    const badge = badges.get(e.id);
    const title = String(e.data.eventTitle || "").trim() || "An event";
    const topSelling = badge === "top_selling";

    const uids = allUids.filter((id) => id !== e.data.organizerId);
    if (!uids.length) {
      // Nobody to tell yet: do not mark it as notified, try again next run.
      console.log("hot events: no recipients for", badge, e.id);
      continue;
    }
    const sent = await sendToMany(db, uids, `${badge}_${e.id}`, {
      type: "hot_deal",
      title: topSelling ? `Top Selling: ${title}` : `Trending: ${title}`,
      body: topSelling ?
        `${title} is the best selling event right now. Get your tickets before they run out!` :
        `${title} is trending this week. Don't miss out!`,
      eventId: e.id,
    });

    await e.ref.update({
      [topSelling ? "topSellingNotified" : "trendingNotified"]: true,
    });
    console.log("hot event notified", badge, e.id, sent);
  }
});

/**
 * 4) Push: every notification written to `users/{uid}/notifications/{id}`
 * (by any of the functions above) is also sent to that user's devices.
 * The app saves each device token in `users/{uid}/fcmTokens/{token}`.
 * Tokens that Firebase says are dead are deleted here.
 */
const DEAD_TOKEN_ERRORS = [
  "messaging/registration-token-not-registered",
  "messaging/invalid-registration-token",
];

exports.sendPushOnNotification = onDocumentCreated(
    "users/{uid}/notifications/{id}",
    async (event) => {
      const n = event.data && event.data.data();
      if (!n) return;
      const {uid, id} = event.params;
      console.log("push: notification created", uid, id, n.type);

      const db = getFirestore();
      const tokensRef = db.collection("users").doc(uid).collection("fcmTokens");
      const tokens = (await tokensRef.get()).docs.map((d) => d.id);
      if (!tokens.length) {
        console.log("push: no device tokens for", uid, "- nothing sent");
        return;
      }

      const result = await getMessaging().sendEachForMulticast({
        tokens,
        notification: {title: n.title, body: n.body},
        // Read by the app when the push is tapped.
        data: {
          notificationId: id,
          type: String(n.type || ""),
          ...(n.eventId ? {eventId: String(n.eventId)} : {}),
        },
        android: {priority: "high"},
        apns: {payload: {aps: {sound: "default"}}},
      });

      // A token-specific failure while another token worked means the payload
      // is fine and that device token is stale, so it is removed too.
      const dead = [];
      result.responses.forEach((r, i) => {
        if (r.success || !r.error) return;
        console.log("push failed for token", tokens[i].slice(0, 12), "...",
            r.error.code, r.error.message);
        const stale = DEAD_TOKEN_ERRORS.includes(r.error.code) ||
          (r.error.code === "messaging/invalid-argument" &&
            result.successCount > 0);
        if (stale) dead.push(tokens[i]);
      });
      await Promise.all(dead.map((t) => tokensRef.doc(t).delete()));
      console.log("push sent", uid, result.successCount, "ok",
          result.failureCount, "failed");
    },
);
