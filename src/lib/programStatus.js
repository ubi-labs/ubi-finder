/**
 * Classify a program for the catalog's quick status filters.
 *
 * @param {Record<string, any>} program
 * @param {string} statusKey
 */
export function matchesProgramStatus(program, statusKey) {
  const appStatus = (program.application_status || "").toLowerCase();
  const programStatus = (program.status || "").toLowerCase();
  const payoutStatus = (program.payout_status || "").toLowerCase();

  const isPlanned = programStatus === "planned" || appStatus.includes("planned") || programStatus === "upcoming";
  const isHistorical = programStatus === "closed" || programStatus === "completed" || appStatus.includes("pilot completed") || payoutStatus.includes("completed");
  const isClosedOngoing = !isHistorical && (
    programStatus === "active_closed" ||
    appStatus.includes("no longer accepting") ||
    appStatus.includes("referral") ||
    (payoutStatus.includes("ongoing") && appStatus.includes("no longer"))
  );
  const isAccepting = !isPlanned && !isHistorical && !isClosedOngoing && (
    programStatus === "active_open" ||
    appStatus.includes("accepting") ||
    programStatus === "active" ||
    program.distribution_type === "daily_claim_protocol" ||
    program.distribution_type === "lottery_raffle"
  );

  switch (statusKey) {
    case "accepting_applications":
      return isAccepting;
    case "planned":
      return isPlanned;
    case "closed_ongoing":
      return isClosedOngoing;
    case "closed_historical":
      return isHistorical;
    case "all":
    default:
      return true;
  }
}

/**
 * Classify a program's primary source.
 * Possible values: 'stanford' | 'government' | 'community'
 *
 * @param {Record<string, any>} program
 * @returns {'stanford' | 'government' | 'community'}
 */
export function getProgramSource(program) {
  if (
    program.data_source === "government_sites" ||
    program.distribution_type === "permanent_statewide"
  ) {
    return "government";
  }
  if (
    program.data_source === "stanford_basic_income_lab" ||
    !!program.stanford_experiment_id
  ) {
    return "stanford";
  }
  return "community";
}

/**
 * Check if a program matches a source filter key.
 *
 * @param {Record<string, any>} program
 * @param {string} sourceKey
 */
export function matchesProgramSource(program, sourceKey) {
  if (!sourceKey || sourceKey === "all") return true;
  return getProgramSource(program) === sourceKey;
}
