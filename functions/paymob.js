const crypto = require("crypto");

/**
 * Paymob "Transaction processed callback" HMAC check.
 * Paymob signs these fields of `obj`, concatenated in this exact order,
 * with HMAC-SHA512 and your account's HMAC secret (Paymob dashboard ->
 * Settings -> Account info -> HMAC). It arrives as the `hmac` query param.
 */
const HMAC_FIELDS = [
  "amount_cents",
  "created_at",
  "currency",
  "error_occured",
  "has_parent_transaction",
  "id",
  "integration_id",
  "is_3d_secure",
  "is_auth",
  "is_capture",
  "is_refunded",
  "is_standalone_payment",
  "is_voided",
  "order.id",
  "owner",
  "pending",
  "source_data.pan",
  "source_data.sub_type",
  "source_data.type",
  "success",
];

const read = (obj, path) =>
  path.split(".").reduce((o, k) => (o == null ? undefined : o[k]), obj);

function computeHmac(obj, secret) {
  const data = HMAC_FIELDS.map((f) => {
    const v = read(obj, f);
    return v === undefined || v === null ? "" : String(v);
  }).join("");
  return crypto.createHmac("sha512", secret).update(data).digest("hex");
}

function verifyHmac(obj, receivedHmac, secret) {
  if (!obj || typeof receivedHmac !== "string" || !secret) return false;
  const expected = Buffer.from(computeHmac(obj, secret), "hex");
  let received;
  try {
    received = Buffer.from(receivedHmac, "hex");
  } catch (e) {
    return false;
  }
  return expected.length === received.length &&
    crypto.timingSafeEqual(expected, received);
}

module.exports = {computeHmac, verifyHmac, HMAC_FIELDS};
