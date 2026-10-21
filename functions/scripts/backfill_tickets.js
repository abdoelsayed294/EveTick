/**
 * One-time script: creates `events/{eventId}/tickets/{orderId}` for orders
 * that were confirmed BEFORE createTicketOnOrderConfirmed existed.
 * Safe to run more than once (never touches a ticket that already exists).
 *
 *   cd functions
 *   gcloud auth application-default login      (once)
 *   GOOGLE_CLOUD_PROJECT=evetick-a2d16 node scripts/backfill_tickets.js
 */
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {createTicketDoc} = require("../tickets");

initializeApp();

async function main() {
  const db = getFirestore();
  const snap = await db.collection("orders")
      .where("status", "==", "confirmed").get();
  let created = 0;
  let skipped = 0;
  for (const doc of snap.docs) {
    const order = doc.data();
    if (!order.eventId) {
      skipped++;
      continue;
    }
    if (await createTicketDoc(db, doc.id, order)) created++;
    else skipped++;
  }
  console.log(`Done: ${created} ticket(s) created, ${skipped} skipped.`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
