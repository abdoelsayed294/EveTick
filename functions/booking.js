/**
 * Booking rules shared by the payment functions.
 *
 * Everything here is a JS port of what the Flutter app does today, so the
 * Cloud Functions and the app agree on the same Firestore structure:
 *
 *   events/{eventId}
 *     ticketTiers: [{ticketName, ticketDescription, ticketPrice, ticketQuantity}]
 *     seatingConfig: {layoutType, rows, seatsPerRow, seatMap:[{row, seats:[...]}],
 *                     sections:[{sectionName, capacity}]}
 *     ticketsSold, salesByDay.{dYYYYMMDD}
 *
 * Rates and helpers must stay identical to:
 *   lib/.../order_model.dart      (OrderPricing)
 *   lib/core/helpers/sales_day_key.dart
 *   lib/core/helpers/section_resolver.dart
 */

const SERVICE_FEE_RATE = 0.10;
const TAX_RATE = 0.05;

class BookingError extends Error {
  constructor(message, status = 400) {
    super(message);
    this.name = "BookingError";
    this.status = status;
  }
}

const round2 = (v) => Math.round(v * 100) / 100;

/** Same math as OrderPricing in Dart. */
function computePricing(subtotal) {
  const serviceFee = round2(subtotal * SERVICE_FEE_RATE);
  const taxes = round2(subtotal * TAX_RATE);
  const total = round2(subtotal + serviceFee + taxes);
  return {subtotal: round2(subtotal), serviceFee, taxes, total};
}

/** "d20261013" (UTC day). */
function salesDayKey(date) {
  const y = String(date.getUTCFullYear()).padStart(4, "0");
  const m = String(date.getUTCMonth() + 1).padStart(2, "0");
  const d = String(date.getUTCDate()).padStart(2, "0");
  return `d${y}${m}${d}`;
}

/** 0 -> A, 25 -> Z, 26 -> AA (same as _rowLabel in select_chair_cubit). */
function rowLabel(index) {
  const letters = 26;
  const last = String.fromCharCode(65 + (index % letters));
  if (index < letters) return last;
  return `${String.fromCharCode(65 + Math.floor(index / letters) - 1)}${last}`;
}

const normalize = (v) => String(v || "").trim().toLowerCase();

/** Port of resolveSectionName (events without seat picking). */
function resolveSectionName({ticketName, tierIndex, tiersCount, sectionNames}) {
  if (!sectionNames.length) return null;
  const ticket = normalize(ticketName);

  const exact = sectionNames.filter((s) => normalize(s) === ticket);
  if (exact.length === 1) return exact[0];

  const partial = sectionNames.filter((s) => {
    const name = normalize(s);
    return name && ticket && (name.includes(ticket) || ticket.includes(name));
  });
  if (partial.length === 1) return partial[0];

  if (sectionNames.length === tiersCount && tierIndex < sectionNames.length) {
    return sectionNames[tierIndex];
  }
  return null;
}

/**
 * Validates the request body and returns a clean selection:
 *   { tickets: [{tierIndex, quantity}], seats: [{rowIndex, seatIndex}] }
 * Prices and names are NOT taken from the client, only positions.
 */
function parseSelection(body) {
  const rawTickets = Array.isArray(body.tickets) ? body.tickets : [];
  const rawSeats = Array.isArray(body.seats) ? body.seats : [];

  if (rawTickets.length === 0) {
    throw new BookingError("Select at least one ticket");
  }

  const seenTiers = new Set();
  const tickets = rawTickets.map((t) => {
    const tierIndex = t && t.tierIndex;
    const quantity = t && t.quantity;
    if (!Number.isInteger(tierIndex) || tierIndex < 0) {
      throw new BookingError("Invalid ticket tier");
    }
    if (!Number.isInteger(quantity) || quantity <= 0) {
      throw new BookingError("Quantity must be a positive integer");
    }
    if (seenTiers.has(tierIndex)) {
      throw new BookingError("Duplicate ticket tier in request");
    }
    seenTiers.add(tierIndex);
    return {tierIndex, quantity};
  });

  const seenSeats = new Set();
  const seats = rawSeats.map((s) => {
    const rowIndex = s && s.rowIndex;
    const seatIndex = s && s.seatIndex;
    if (!Number.isInteger(rowIndex) || rowIndex < 0 ||
        !Number.isInteger(seatIndex) || seatIndex < 0) {
      throw new BookingError("Invalid seat");
    }
    const key = `${rowIndex}:${seatIndex}`;
    if (seenSeats.has(key)) throw new BookingError("Duplicate seat in request");
    seenSeats.add(key);
    return {rowIndex, seatIndex};
  });

  return {tickets, seats};
}

/**
 * Pure function: checks stock/seats against the event document and returns
 * what must be written. Same rules as placeOrder in the Flutter data source.
 *
 * @param {object} event  events/{id} data
 * @param {object} selection  output of parseSelection
 * @param {Date} now
 * @return {{updates: object, items: object[], seats: object[],
 *           sectionByTier: object, pricing: object, ticketCount: number}}
 */
function reserveInventory(event, selection, now) {
  const tiers = (event.ticketTiers || []).map((t) => ({...t}));
  let subtotal = 0;
  let ticketCount = 0;
  const items = [];

  for (const {tierIndex, quantity} of selection.tickets) {
    const tier = tiers[tierIndex];
    if (!tier) throw new BookingError("Ticket tier not found", 404);

    const price = Number(tier.ticketPrice);
    const stock = Number(tier.ticketQuantity);
    if (!Number.isFinite(price) || price <= 0) {
      throw new BookingError("Invalid ticket price");
    }
    if (!Number.isInteger(stock) || stock < 0) {
      throw new BookingError("Invalid available quantity");
    }
    if (stock < quantity) {
      throw new BookingError(`${tier.ticketName} tickets are not available anymore`);
    }

    tier.ticketQuantity = stock - quantity;
    subtotal += price * quantity;
    ticketCount += quantity;
    items.push({tierIndex, name: tier.ticketName, price, quantity});
  }

  const config = event.seatingConfig || null;
  const isSeated = !!config &&
    (config.layoutType || (config.seatMap && config.seatMap.length ?
      "seating" : "sections")) === "seating";

  const updates = {
    ticketTiers: tiers,
    ticketsSold: {increment: ticketCount},
    [`salesByDay.${salesDayKey(now)}`]: {increment: ticketCount},
  };

  const seats = [];
  const sectionByTier = {};

  if (isSeated) {
    if (selection.seats.length !== ticketCount) {
      throw new BookingError("Please select a seat for every ticket");
    }
    const seatingConfig = {...config};
    const seatMap = (config.seatMap || []).map((r) => ({...r}));

    for (const {rowIndex, seatIndex} of selection.seats) {
      const row = seatMap[rowIndex];
      const rowSeats = row ? [...(row.seats || [])] : null;
      const label = `${rowLabel(rowIndex)}${seatIndex + 1}`;
      if (!rowSeats || seatIndex >= rowSeats.length) {
        throw new BookingError(`Seat ${label} does not exist`);
      }
      if (rowSeats[seatIndex] !== "available") {
        throw new BookingError(
            `Seat ${label} was just taken, please choose another one`);
      }
      rowSeats[seatIndex] = "reserved";
      row.seats = rowSeats;
      seats.push({rowIndex, seatIndex, label});
    }
    seatingConfig.seatMap = seatMap;
    updates.seatingConfig = seatingConfig;
  } else {
    if (selection.seats.length > 0) {
      throw new BookingError("This event has no seat selection");
    }
    const sectionNames = ((config && config.sections) || [])
        .map((s) => String(s.sectionName || "").trim())
        .filter(Boolean);
    items.forEach((item) => {
      const section = resolveSectionName({
        ticketName: tiers[item.tierIndex].ticketName || item.name,
        tierIndex: item.tierIndex,
        tiersCount: tiers.length,
        sectionNames,
      });
      if (section) sectionByTier[item.tierIndex] = section;
    });
  }

  return {
    updates,
    items,
    seats,
    sectionByTier,
    ticketCount,
    pricing: computePricing(subtotal),
  };
}

/**
 * Pure function: reverses reserveInventory when a payment fails/expires.
 * `order` is the saved order doc; returns the event updates to apply.
 */
function releaseInventory(event, order) {
  const tiers = (event.ticketTiers || []).map((t) => ({...t}));
  for (const {tierIndex, quantity} of order.reservation.tiers) {
    if (tiers[tierIndex]) {
      tiers[tierIndex].ticketQuantity =
        Number(tiers[tierIndex].ticketQuantity) + quantity;
    }
  }
  const updates = {
    ticketTiers: tiers,
    ticketsSold: {increment: -order.ticketCount},
    [`salesByDay.${order.reservation.salesDay}`]: {increment: -order.ticketCount},
  };

  if (order.reservation.seats.length && event.seatingConfig) {
    const seatingConfig = {...event.seatingConfig};
    const seatMap = (seatingConfig.seatMap || []).map((r) => ({...r}));
    for (const {rowIndex, seatIndex} of order.reservation.seats) {
      const row = seatMap[rowIndex];
      if (row && row.seats && row.seats[seatIndex] === "reserved") {
        row.seats = [...row.seats];
        row.seats[seatIndex] = "available";
      }
    }
    seatingConfig.seatMap = seatMap;
    updates.seatingConfig = seatingConfig;
  }
  return updates;
}

module.exports = {
  SERVICE_FEE_RATE,
  TAX_RATE,
  BookingError,
  computePricing,
  salesDayKey,
  rowLabel,
  resolveSectionName,
  parseSelection,
  reserveInventory,
  releaseInventory,
};
