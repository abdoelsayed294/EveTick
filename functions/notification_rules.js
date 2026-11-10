/**
 * Pure rules behind the notifications (no Firebase here, so they are easy to
 * test): which events are open, and which ones earn a "top selling" /
 * "trending" badge. Keep the numbers in sync with HomeRanking in the app
 * (lib/features/home/logic/home_ranking.dart).
 */
// Same numbers as HomeRanking in the app (home_ranking.dart).
const MIN_SOLD_FOR_TOP_SELLING = 10;
const MIN_RECENT_SOLD_FOR_TRENDING = 5;
const MAX_TRENDING = 3;

/** An event with no `status` is treated as live (same rule as booking). */
function isLive(event) {
  return !event.status || event.status === "live";
}

/** True while the event has not finished (unknown dates count as open). */
function isUpcoming(event, now) {
  const end = Date.parse(event.endAt || event.startAt || "");
  return Number.isNaN(end) || end >= now.getTime();
}

/** Tickets sold in the last [days] UTC days, from `salesByDay`. */
function soldInLastDays(salesByDay, days, now) {
  if (!salesByDay || typeof salesByDay !== "object") return 0;
  const first = Date.UTC(
      now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() - (days - 1));
  let total = 0;
  for (const [key, value] of Object.entries(salesByDay)) {
    const m = /^d(\d{4})(\d{2})(\d{2})$/.exec(key);
    if (!m || typeof value !== "number") continue;
    const day = Date.UTC(Number(m[1]), Number(m[2]) - 1, Number(m[3]));
    if (day >= first) total += value;
  }
  return total;
}

/**
 * Port of HomeRanking.badges: the single best seller is TOP SELLING, then up
 * to MAX_TRENDING events with enough sales this week are TRENDING.
 * @param {Array<{id: string, ticketsSold: number, soldLast7Days: number}>} events
 * @return {Map<string, string>} eventId -> "top_selling" | "trending"
 */
function rankEvents(events) {
  const badges = new Map();

  const bySold = events
      .filter((e) => e.ticketsSold >= MIN_SOLD_FOR_TOP_SELLING)
      .sort((a, b) => b.ticketsSold - a.ticketsSold);
  if (bySold.length) badges.set(bySold[0].id, "top_selling");

  const trending = events
      .filter((e) => !badges.has(e.id) &&
        e.soldLast7Days >= MIN_RECENT_SOLD_FOR_TRENDING)
      .sort((a, b) => b.soldLast7Days - a.soldLast7Days);
  for (const e of trending.slice(0, MAX_TRENDING)) {
    badges.set(e.id, "trending");
  }
  return badges;
}

module.exports = {isLive, isUpcoming, soldInLastDays, rankEvents};
