/**
 * One-time script: creates `users/{organizerId}/followers/{uid}` for the
 * follows that existed BEFORE onFollowCreated started mirroring them.
 * Safe to run more than once.
 *
 *   cd functions
 *   gcloud auth application-default login      (once)
 *   GOOGLE_CLOUD_PROJECT=evetick-a2d16 node scripts/backfill_followers.js
 */
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();

async function main() {
  const db = getFirestore();
  const snap = await db.collectionGroup("following").get();
  const writer = db.bulkWriter();
  let count = 0;
  for (const doc of snap.docs) {
    const uid = doc.ref.parent.parent.id; // users/{uid}/following/{organizerId}
    const ref = db.collection("users").doc(doc.id)
        .collection("followers").doc(uid);
    writer.set(ref, {createdAt: doc.data().createdAt || FieldValue.serverTimestamp()});
    count++;
  }
  await writer.close();
  console.log(`Done: ${count} follow(s) mirrored.`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
