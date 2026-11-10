/**
 * Check-in tickets for the organizer app.
 *
 * The attendee's QR code contains the order id (see ticket_card.dart), and the
 * organizer app looks the scanned code up in
 *   events/{eventId}/tickets/{orderId}
 *     { orderId, userId, attendeeName, ticketName, ticketCount,
 *       checkedIn: false, createdAt }
 * This trigger creates that document when an order becomes `confirmed`.
 * (The organizer app writes checkedIn / checkedInAt / checkedInBy later.)
 */
const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

const ALREADY_EXISTS = 6;

/** Fields of the check-in document, built from an order document. */
function ticketDocFromOrder(orderId, order) {
  const ticketName = (order.tickets || [])
      .map((t) => `${t.sectionName || t.ticketName || ""} × ${t.quantity || 1}`)
      .join(", ");
  return {
    orderId,
    userId: order.userId,
    attendeeName: order.attendeeName || null,
    ticketName,
    ticketCount: order.ticketCount || 1,
    checkedIn: false,
    createdAt: FieldValue.serverTimestamp(),
  };
}

/**
 * create() (not set) so a retried trigger or a re-run backfill can never
 * reset a ticket that was already checked in.
 */
async function createTicketDoc(db, orderId, order) {
  try {
    await db.doc(`events/${order.eventId}/tickets/${orderId}`)
        .create(ticketDocFromOrder(orderId, order));
    return true;
  } catch (e) {
    if (e.code === ALREADY_EXISTS) return false;
    throw e;
  }
}

exports.createTicketOnOrderConfirmed = onDocumentWritten(
    "orders/{orderId}",
    async (event) => {
      const after = event.data && event.data.after && event.data.after.data();
      if (!after || after.status !== "confirmed" || !after.eventId) return;

      const before = event.data.before && event.data.before.data();
      if (before && before.status === "confirmed") return;

      const created = await createTicketDoc(
          getFirestore(), event.params.orderId, after);
      console.log("check-in ticket", event.params.orderId,
          created ? "created" : "already existed");
    },
);

exports.createTicketDoc = createTicketDoc;
