/* Prototype-only sample data. Replace this module with API/repository data in production. */
const sampleData = {
  match: {
    innings: "2nd innings",
    batting: "Harbour XI",
    bowling: "Riverside CC",
    score: 126,
    wickets: 4,
    overs: "14.2",
    runRate: "8.79",
    runsNeeded: 45,
    ballsRemaining: 34,
    requiredRate: "7.94",
    target: 171,
    venue: "Oval Community Ground",
    batters: [
      { name: "Arjun Rao", runs: 48, balls: 31, fours: 5, sixes: 2, striker: true, initials: "AR" },
      { name: "Dev Mehta", runs: 19, balls: 15, fours: 2, sixes: 0, striker: false, initials: "DM" }
    ],
    bowler: { name: "Samir Khan", figures: "3.2 - 0 - 28 - 1" },
    over: ["1", "4", "0", "2", "W", "1"],
    currentOver: ["1", "•"]
  },
  matches: [
    { home: "Harbour XI", away: "Riverside CC", homeScore: "126/4", awayScore: "170/7", overs: "14.2 ov", format: "T20", venue: "Oval Community Ground", status: "SAMPLE • 2nd innings", live: true },
    { home: "Northside Strikers", away: "East End CC", homeScore: "Starts 16:30", awayScore: "Today", overs: "T20", format: "T20", venue: "Northside Park", status: "UPCOMING", live: false },
    { home: "Meadowbrook XI", away: "City Wanderers", homeScore: "148/8", awayScore: "151/5", overs: "18.4 ov", format: "T20", venue: "Meadowbrook Oval", status: "COMPLETED", live: false }
  ],
  tournament: "Riverside Sunday League",
  teams: ["Harbour XI", "Northside Strikers", "Meadowbrook XI"]
};

const root = document.querySelector("#app-content");
const backdrop = document.querySelector("#sheet-backdrop");
const sheetContent = document.querySelector("#sheet-content");
let activePage = "live";
let liveFilter = "All";
let centreTab = "Summary";
let activeTournamentTab = "Standings";
let setupStep = 1;
let lastFocused = null;
let toastTimer;

function toast(message) {
  const region = document.querySelector(".toast-region");
  region.innerHTML = `<div class="toast-message" role="status">${message}</div>`;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { region.innerHTML = ""; }, 3200);
}

function navTo(page) {
  activePage = page;
  document.querySelectorAll(".nav-item").forEach((item) => {
    const selected = item.dataset.page === page;
    item.classList.toggle("is-active", selected);
    item.setAttribute("aria-current", selected ? "page" : "false");
  });
  renderPage();
  root.focus({ preventScroll: true });
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function heading(title, subtitle, action = "") {
  return `<div class="page-heading"><div><h1>${title}</h1><p>${subtitle}</p></div>${action}</div>`;
}

function showScore() {
  const match = sampleData.match;
  return `<section class="live-page" aria-label="Live scoring prototype">
    <div class="demo-banner"><span><strong>Sample only</strong> · not live</span><span class="sync-label"><i class="sync-icon" aria-hidden="true"></i> Local · not synced</span></div>
    <article class="scoreboard" aria-label="${match.batting} ${match.score} for ${match.wickets}">
      <div class="scoreboard-top"><div><div class="innings-line">${match.innings}<span aria-hidden="true">·</span>${match.batting} batting</div><div class="match-name">${match.batting} <span style="opacity:.66">vs</span> ${match.bowling}</div><div class="match-venue">${match.venue}</div></div><span class="live-indicator">DEMO</span></div>
      <div class="score-main"><span class="score-value">${match.score}</span><span class="score-separator">/</span><span class="score-wickets">${match.wickets}</span></div>
      <div class="score-meta"><span><strong>${match.overs}</strong> overs</span><span class="divider"></span><span>CRR <strong>${match.runRate}</strong></span></div>
      <div class="target-line">Target <strong>${match.target}</strong><span aria-hidden="true"> · </span>${match.runsNeeded} needed from ${match.ballsRemaining} balls <span aria-hidden="true">· </span>RRR <strong>${match.requiredRate}</strong></div>
      <div class="match-progress" aria-label="72 percent of overs completed"><span></span></div>
    </article>

    <section aria-labelledby="batters-heading"><div class="section-heading"><h2 id="batters-heading">At the crease</h2><button class="text-button" data-action="match-centre">Match details</button></div>
      <div class="player-card">
        ${match.batters.map((batter) => `<div class="player-row"><div class="player-info"><span class="batter-badge">${batter.initials}</span><span class="player-name">${batter.name}${batter.striker ? '<span class="striker-tag">• STRIKER</span>' : ''}</span></div><div class="player-stats"><span><strong>${batter.runs}</strong> (${batter.balls})</span><span class="boundaries">4s ${batter.fours} · 6s ${batter.sixes}</span></div></div>`).join("")}
        <div class="bowler-line"><span><span class="bowler-label">Bowling</span><strong>${match.bowler.name}</strong></span><span class="bowler-figures">${match.bowler.figures}</span></div>
      </div>
    </section>

    <section aria-labelledby="over-heading"><div class="section-heading"><h2 id="over-heading">Current over</h2><span class="over-hint">Over 15 · 2 of 6 legal balls</span></div>
      <div class="over-panel"><div class="over-topline"><span class="over-title">Samir Khan</span><span class="over-hint">Last 6: 1 · 4 · 0 · 2 · W · 1</span></div>
        <div class="delivery-list" aria-label="Current over deliveries">${match.currentOver.map((ball) => `<span class="delivery ${ball === "W" ? "wicket" : ball === "4" || ball === "6" ? "boundary" : ""}" aria-label="${ball === "W" ? "Wicket" : ball === "•" ? "Dot ball" : `${ball} runs`}">${ball}</span>`).join("")}${Array.from({ length: 6 - match.currentOver.length }, (_, index) => `<span class="delivery pending" aria-label="${index === 0 ? "Next delivery" : "Upcoming delivery"}">·</span>`).join("")}</div>
        <div class="over-legend"><span class="legend-item"><i class="legend-dot"></i> Dot / runs</span><span class="legend-item"><i class="legend-dot boundary"></i> Boundary</span><span class="legend-item"><i class="legend-dot wicket"></i> Wicket</span><span class="legend-item"><i class="legend-dot extra"></i> Extra</span></div>
      </div>
    </section>

    <section class="scoring-area" aria-label="Scoring controls"><div class="run-grid">${[0, 1, 2, 3, 4, 6].map((run) => `<button class="run-button ${run === 4 || run === 6 ? "boundary-run" : ""}" data-run="${run}" aria-label="Record ${run} runs">${run}</button>`).join("")}</div>
      <div class="control-row"><button class="action-button extras" data-action="extras"><span class="action-symbol" aria-hidden="true">+</span>Extras</button><button class="action-button wicket" data-action="wicket"><span class="action-symbol" aria-hidden="true">W</span>Wicket</button><button class="action-button undo" data-action="undo"><span class="action-symbol" aria-hidden="true">↶</span>Undo</button></div>
    </section>
    <p class="scoring-disclaimer">Controls are a visual prototype. No ball is recorded, saved, or synced.</p>
  </section>`;
}

function renderHome() {
  return `<div class="page-view">${heading("Good afternoon, Alex", "Your cricket, all in one place.", `<button class="primary-button" data-action="create-match">＋ New match</button>`)}
    <section class="surface" style="padding:0; overflow:hidden"><div style="padding:14px 14px 0"><div class="surface-title">Continue scoring <button class="text-button" data-page="live">Open</button></div></div><div class="match-card" style="border:0; border-radius:0; padding-top:0"><div class="match-card-top"><span class="match-tag">SAMPLE MATCH</span><span>Oval Community Ground</span></div><div class="match-card-teams"><div class="team-score-stack"><div class="team-score"><span class="team-monogram">HX</span>Harbour XI<small>126/4</small></div><div class="team-score"><span class="team-monogram">RC</span>Riverside CC<small>170/7</small></div></div><button class="card-link" data-page="live">Score</button></div><div class="card-meta">2nd innings · 14.2 overs · Sample data only</div></div></section>
    <div class="stats-grid"><button class="stat-box" data-page="teams" style="text-align:left;cursor:pointer"><span>My teams</span><strong>03</strong><span>Squads & player stats</span></button><button class="stat-box" data-page="tournaments" style="text-align:left;cursor:pointer"><span>Tournaments</span><strong>01</strong><span>Standings & fixtures</span></button></div>
    <section><div class="section-heading"><h2>Upcoming</h2><button class="text-button" data-page="live">All matches</button></div><article class="match-card"><div class="match-card-top"><span class="match-tag">TODAY · 4:30 PM</span><span>T20</span></div><div class="match-card-teams"><div class="team-score-stack"><div class="team-score"><span class="team-monogram">NS</span>Northside Strikers</div><div class="team-score"><span class="team-monogram">EE</span>East End CC</div></div><span class="card-meta">Northside Park</span></div></article></section>
    <section><div class="section-heading"><h2>Recent result</h2><button class="text-button" data-action="result">View result</button></div><article class="match-card"><div class="match-card-top"><span>Meadowbrook XI vs City Wanderers</span><span class="match-tag">COMPLETED</span></div><p class="card-meta" style="margin:9px 0 0">City Wanderers won by 5 wickets · Player of the Match: N. Patel</p></article></section>
  </div>`;
}

function renderLiveMatches() {
  const matches = sampleData.matches.filter((match) => liveFilter === "All" || (liveFilter === "Live" && match.live) || (liveFilter === "Upcoming" && match.status === "UPCOMING") || (liveFilter === "Completed" && match.status === "COMPLETED"));
  return `<div class="page-view">${heading("Matches", "Follow club cricket, wherever you are.")}
    <input class="search-field" type="search" placeholder="Search teams or venue" aria-label="Search matches" data-match-search>
    <div class="filter-row" role="group" aria-label="Filter matches">${["All", "Live", "Upcoming", "Completed"].map((filter) => `<button class="filter-chip ${liveFilter === filter ? "is-selected" : ""}" data-filter="${filter}" aria-pressed="${liveFilter === filter}">${filter}</button>`).join("")}</div>
    <div class="match-list" id="match-list">${matches.map((match) => matchCard(match)).join("") || `<div class="empty-state"><div class="empty-mark">0</div><h3>No ${liveFilter.toLowerCase()} matches</h3><p>There are no sample matches in this category right now.</p></div>`}</div>
    <p class="scoring-disclaimer">Sample fixtures for visual preview. Live match data is not connected.</p></div>`;
}

function matchCard(match) {
  return `<article class="match-card" data-match-searchable="${match.home} ${match.away} ${match.venue}"><div class="match-card-top"><span class="match-tag">${match.status}</span><span>${match.format}</span></div><div class="match-card-teams"><div class="team-score-stack"><div class="team-score"><span class="team-monogram">${match.home.split(" ").map((word) => word[0]).join("")}</span>${match.home}<small>${match.homeScore}</small></div><div class="team-score"><span class="team-monogram">${match.away.split(" ").map((word) => word[0]).join("")}</span>${match.away}<small>${match.awayScore}</small></div></div><button class="card-link" data-action="${match.status === "COMPLETED" ? "result" : "match-centre"}">${match.status === "COMPLETED" ? "Result" : "View score"}</button></div><div class="card-meta">${match.overs} · ${match.venue}</div></article>`;
}

function renderTournaments() {
  return `<div class="page-view">${heading("Tournaments", "Fixtures, standings and season stats.", `<button class="primary-button" data-action="create-tournament">＋ Create</button>`)}
    <article class="surface" style="padding:0;overflow:hidden"><div style="padding:16px;background:var(--green);color:white"><span style="font-size:9px;font-weight:800;letter-spacing:.7px;opacity:.82">ACTIVE · SAMPLE</span><h2 style="margin:6px 0 2px;font:800 18px Manrope,sans-serif">${sampleData.tournament}</h2><p style="margin:0;color:rgba(255,255,255,.82);font-size:11px">T20 · 8 teams · League stage</p></div><div style="padding:14px"><div class="subtabs" role="tablist">${["Standings", "Fixtures", "Stats"].map((tab) => `<button class="subtab ${activeTournamentTab === tab ? "is-selected" : ""}" data-tournament-tab="${tab}" role="tab" aria-selected="${activeTournamentTab === tab}">${tab}</button>`).join("")}</div><div id="tournament-panel">${renderTournamentPanel()}</div></div></article>
    <div class="empty-state"><div class="empty-mark">+</div><h3>Run your own tournament</h3><p>Set up teams, fixtures and standings from one place.</p><button class="secondary-button" data-action="create-tournament">Create tournament</button></div>
    <p class="scoring-disclaimer">Standings shown are sample data, not official results.</p></div>`;
}

function renderTournamentPanel() {
  if (activeTournamentTab === "Fixtures") return `<div class="match-list" style="margin-top:10px">${sampleData.matches.map((match) => `<div class="setting-row"><span>${match.home} vs ${match.away}</span><span style="color:var(--muted);font-size:10px">${match.status === "UPCOMING" ? "Today, 4:30 PM" : match.overs}</span></div>`).join("")}</div>`;
  if (activeTournamentTab === "Stats") return `<div class="stats-grid" style="margin-top:10px"><div class="stat-box"><span>Top run-scorer</span><strong>Arjun Rao</strong><span>248 runs</span></div><div class="stat-box"><span>Top wicket-taker</span><strong>Samir Khan</strong><span>11 wickets</span></div></div>`;
  return `<div class="table-wrap" style="margin-top:10px"><table><thead><tr><th>TEAM</th><th>P</th><th>PTS</th><th>NRR</th></tr></thead><tbody><tr><td>Harbour XI</td><td>5</td><td>8</td><td>+1.24</td></tr><tr><td>Northside Strikers</td><td>5</td><td>6</td><td>+0.48</td></tr><tr><td>Meadowbrook XI</td><td>5</td><td>6</td><td>+0.16</td></tr><tr><td>Riverside CC</td><td>5</td><td>4</td><td>−0.21</td></tr></tbody></table></div>`;
}

function renderTeams() {
  return `<div class="page-view">${heading("My teams", "Squads and club performance.", `<button class="primary-button" data-action="create-team">＋ Create team</button>`)}
    ${sampleData.teams.map((team, index) => `<article class="match-card"><div class="match-card-teams" style="margin:0"><div class="team-score"><span class="team-monogram" style="width:38px;height:38px;border-radius:11px">${team.split(" ").map((word) => word[0]).join("")}</span><span>${team}</span></div><button class="card-link" data-action="team-detail" data-team="${team}">Squad</button></div><div class="card-meta" style="margin:10px 0 0">${index === 0 ? "18 players · 12 matches · 8 wins" : "15 players · 8 matches · 5 wins"}</div></article>`).join("")}
    <section class="surface"><div class="surface-title">Team tools</div><div class="setting-row"><span>Invite teammates</span><button class="text-button" data-action="invite">Invite</button></div><div class="setting-row"><span>Player statistics</span><button class="text-button" data-action="player-profile">View</button></div></section></div>`;
}

function renderProfile() {
  return `<div class="page-view">${heading("Profile", "Manage your account and preferences.")}
    <div class="profile-hero"><div class="profile-initials">AR</div><div><h2>Alex Rivera</h2><p>Scorer · Harbour XI</p></div><button class="close-sheet" style="margin-left:auto;border-color:rgba(255,255,255,.3);background:transparent;color:#fff" data-action="edit-profile" aria-label="Edit profile">✎</button></div>
    <div class="stats-grid"><div class="stat-box"><span>Matches scored</span><strong>24</strong></div><div class="stat-box"><span>Season</span><strong>2025–26</strong></div></div>
    <section class="surface"><div class="surface-title">Preferences</div><div class="setting-row"><span>Offline status</span><span style="color:var(--amber);font-size:10px;font-weight:800">LOCAL PREVIEW</span></div><div class="setting-row"><span>Notifications</span><button class="toggle" role="switch" aria-checked="true" aria-label="Notifications"></button></div><div class="setting-row"><span>Appearance</span><div class="segmented"><button class="is-selected" data-theme="light">Light</button><button data-theme="dark">Dark</button></div></div><div class="setting-row"><span>Language</span><button class="text-button" data-action="language">English⌄</button></div></section>
    <section class="surface"><div class="surface-title">Account & support</div>${["Account security", "Help & feedback", "Privacy policy", "Terms of service"].map((text) => `<div class="setting-row"><span>${text}</span><span aria-hidden="true" style="color:var(--quiet)">›</span></div>`).join("")}<div class="setting-row"><button class="text-button" data-action="sign-out" style="color:var(--red)">Sign out</button></div></section>
    <p class="scoring-disclaimer">CricScore prototype · Sample statistics are illustrative and unverified.</p></div>`;
}

function renderMatchCentre(tab = "Summary") {
  centreTab = tab;
  const match = sampleData.match;
  let panel = `<div class="surface"><div class="surface-title">Current innings <span class="match-tag">SAMPLE</span></div><div class="score-main" style="color:var(--green);margin:4px 0 5px"><span class="score-value" style="font-size:42px">${match.score}</span><span class="score-separator" style="font-size:28px">/</span><span class="score-wickets" style="font-size:34px">${match.wickets}</span></div><div class="card-meta">${match.batting} · ${match.overs} overs · CRR ${match.runRate}</div><p style="margin:13px 0 0;color:var(--navy);font-size:11px;font-weight:700">Target ${match.target} · ${match.runsNeeded} runs needed · RRR ${match.requiredRate}</p></div><div class="surface"><div class="surface-title">Recent over-by-over</div><div class="setting-row"><span>Over 13</span><strong>11 runs</strong></div><div class="setting-row"><span>Over 14</span><strong>9 runs, 1 wicket</strong></div><div class="setting-row"><span>Over 15 (in progress)</span><strong>1 run</strong></div></div><div class="surface"><div class="surface-title">At the crease</div><div class="setting-row"><span>Arjun Rao · 48 (31)</span><strong>●</strong></div><div class="setting-row"><span>Dev Mehta · 19 (15)</span><strong></strong></div><div class="setting-row"><span>Samir Khan · 3.2–0–28–1</span><strong>Bowling</strong></div></div>`;
  if (tab === "Scorecard") panel = `<div class="surface"><div class="surface-title">Harbour XI · 2nd innings · 126/4</div><div class="table-wrap"><table><thead><tr><th>BATTER</th><th>R</th><th>B</th><th>4s</th><th>6s</th><th>SR</th></tr></thead><tbody><tr><td>Arjun Rao *</td><td>48</td><td>31</td><td>5</td><td>2</td><td>154.8</td></tr><tr><td>Dev Mehta</td><td>19</td><td>15</td><td>2</td><td>0</td><td>126.7</td></tr><tr><td>Extras</td><td colspan="5">9 (w 5, nb 2, b 1, lb 1)</td></tr><tr><td><strong>Total</strong></td><td colspan="5"><strong>126/4 (14.2 ov)</strong></td></tr></tbody></table></div></div><div class="surface"><div class="surface-title">Bowling · Riverside CC</div><div class="table-wrap"><table><thead><tr><th>BOWLER</th><th>O</th><th>M</th><th>R</th><th>W</th><th>ECON</th></tr></thead><tbody><tr><td>Samir Khan</td><td>3.2</td><td>0</td><td>28</td><td>1</td><td>8.40</td></tr><tr><td>Jay Shah</td><td>3</td><td>0</td><td>25</td><td>2</td><td>8.33</td></tr></tbody></table></div></div>`;
  if (tab === "Commentary") panel = `<div class="surface"><div class="surface-title">Over 15 <span class="card-meta">Samir Khan</span></div>${["15.2 · Arjun Rao · 1 run · Worked to midwicket", "15.1 · Arjun Rao · Dot ball · Defended", "14.6 · Dev Mehta · 1 run · Pushed to cover", "14.5 · Dev Mehta · FOUR · Driven through extra cover", "14.4 · Dev Mehta · WICKET · Caught at long-on"].map((event) => `<div class="setting-row"><span>${event}</span></div>`).join("")}</div>`;
  if (tab === "Statistics") panel = `<div class="stats-grid"><div class="stat-box"><span>Run rate</span><strong>8.79</strong></div><div class="stat-box"><span>Required rate</span><strong>9.39</strong></div></div><div class="chart-placeholder">Run rate graph<br><strong>Chart preview · sample data</strong></div><div class="chart-placeholder">Partnerships<br><strong>Arjun Rao + Dev Mehta · 37 runs</strong></div>`;
  return `<div class="page-view">${heading("Match centre", `${match.batting} vs ${match.bowling}`, `<button class="secondary-button" data-page="live">Back to scoring</button>`)}<div class="demo-banner"><span>Sample match · not live data</span><span class="sync-label">Local only</span></div><div class="subtabs" role="tablist">${["Summary", "Scorecard", "Commentary", "Statistics"].map((name) => `<button class="subtab ${tab === name ? "is-selected" : ""}" data-centre-tab="${name}" role="tab" aria-selected="${tab === name}">${name}</button>`).join("")}</div>${panel}</div>`;
}

function renderResult() {
  return `<div class="page-view">${heading("Match result", "Riverside Sunday League · Sample result")}
    <article class="scoreboard" style="text-align:center"><span class="live-indicator" style="display:inline-flex">COMPLETED</span><h2 style="margin:14px 0 5px;font:800 21px Manrope,sans-serif">City Wanderers won</h2><p style="margin:0;color:rgba(255,255,255,.82);font-size:12px">by 5 wickets · with 8 balls remaining</p></article>
    <div class="stats-grid"><div class="stat-box"><span>Player of the Match</span><strong>N. Patel</strong><span>62 runs · 4 wickets</span></div><div class="stat-box"><span>Best batting</span><strong>N. Patel</strong><span>62 (38 balls)</span></div></div>
    <section class="surface"><div class="surface-title">Final scores</div><div class="setting-row"><span>Meadowbrook XI</span><strong>148/8 · 20 ov</strong></div><div class="setting-row"><span>City Wanderers</span><strong>151/5 · 18.4 ov</strong></div></section>
    <div class="demo-banner"><span>This is illustrative sample data.</span><span>Not an official result</span></div><button class="primary-button" data-action="share-result">Share scorecard</button><button class="secondary-button" data-page="home">Return to Home</button></div>`;
}

function renderPlayerProfile() {
  return `<div class="page-view">${heading("Player profile", "Career record · Sample statistics")}
    <div class="profile-hero"><div class="profile-initials">NP</div><div><h2>Nikhil Patel</h2><p>City Wanderers · All-rounder</p></div></div>
    <div class="demo-banner"><span>Sample statistics</span><span>Unverified</span></div>
    <div class="stats-grid"><div class="stat-box"><span>Matches</span><strong>32</strong></div><div class="stat-box"><span>Runs</span><strong>684</strong></div><div class="stat-box"><span>Wickets</span><strong>28</strong></div><div class="stat-box"><span>Batting average</span><strong>28.5</strong></div><div class="stat-box"><span>Strike rate</span><strong>138.7</strong></div><div class="stat-box"><span>Best bowling</span><strong>4/18</strong></div></div>
    <section class="surface"><div class="surface-title">Recent performances</div><div class="setting-row"><span>City Wanderers vs Meadowbrook XI</span><strong>62 · 4/18</strong></div><div class="setting-row"><span>City Wanderers vs Northside</span><strong>31 · 1/24</strong></div></section></div>`;
}

function renderPage() {
  if (activePage === "home") root.innerHTML = renderHome();
  else if (activePage === "live") root.innerHTML = showScore();
  else if (activePage === "tournaments") root.innerHTML = renderTournaments();
  else if (activePage === "teams") root.innerHTML = renderTeams();
  else if (activePage === "profile") root.innerHTML = renderProfile();
  else if (activePage === "match-centre") root.innerHTML = renderMatchCentre(centreTab);
  else if (activePage === "result") root.innerHTML = renderResult();
  else if (activePage === "player-profile") root.innerHTML = renderPlayerProfile();
}

function openSheet(content) {
  lastFocused = document.activeElement;
  sheetContent.innerHTML = content;
  backdrop.hidden = false;
  document.body.style.overflow = "hidden";
  backdrop.querySelector("button, select, input")?.focus({ preventScroll: true });
}

function closeSheet() {
  backdrop.hidden = true;
  document.body.style.overflow = "";
  sheetContent.innerHTML = "";
  lastFocused?.focus?.();
}

function sheetHeader(title, subtitle) {
  return `<div class="sheet-title-row"><div><h2 id="sheet-title">${title}</h2><p>${subtitle}</p></div><button class="close-sheet" data-action="close-sheet" aria-label="Close">×</button></div>`;
}

function openExtras() {
  openSheet(`${sheetHeader("Add extras", "Choose the delivery type to preview the scoring flow.")}<div class="sheet-options">${[["Wide", "Wd"], ["No-ball", "Nb"], ["Bye", "B"], ["Leg-bye", "Lb"], ["Penalty runs", "P"]].map(([label, mark]) => `<button class="sheet-option" data-extra="${label}">${label}<span>${mark}</span></button>`).join("")}</div><div class="demo-banner" style="margin-top:13px"><span>Preview only</span><span>No score will be changed</span></div>`);
}

function openWicket() {
  openSheet(`${sheetHeader("Record wicket", "Dismissal details · preview only")}
    <label class="form-field">Dismissal type<select aria-label="Dismissal type"><option>Bowled</option><option>Caught</option><option>Run out</option><option>LBW</option><option>Stumped</option><option>Hit wicket</option><option>Retired out</option></select></label>
    <label class="form-field">Dismissed batter<select aria-label="Dismissed batter"><option>Arjun Rao (striker)</option><option>Dev Mehta (non-striker)</option></select></label>
    <label class="form-field">Fielder (where applicable)<select aria-label="Fielder"><option>Select fielder</option><option>Samir Khan</option><option>Jay Shah</option><option>Other fielder</option></select></label>
    <div class="sheet-actions"><button class="secondary-button" data-action="close-sheet">Cancel</button><button class="primary-button" data-action="confirm-wicket">Continue</button></div>
    <div class="demo-banner" style="margin-top:12px"><span>Prototype only</span><span>No wicket is recorded</span></div>`);
}

function openSetup() {
  setupStep = 1;
  renderSetupStep();
}

function renderSetupStep() {
  const steps = [
    { title: "Choose teams", text: "Select the two sides for this match.", body: `<label class="form-field">Team A<select><option>Harbour XI</option><option>Northside Strikers</option><option>Create a team…</option></select></label><label class="form-field">Team B<select><option>Riverside CC</option><option>Meadowbrook XI</option><option>Create a team…</option></select></label>` },
    { title: "Match format", text: "Start with a familiar format.", body: `<div class="sheet-options">${["T10", "T20", "ODI-style", "Custom overs", "Test-style", "Tennis-ball"].map((x) => `<button class="sheet-option" data-setup-choice>${x}<span>›</span></button>`).join("")}</div>` },
    { title: "Match details", text: "Set the ground and playing conditions.", body: `<label class="form-field">Overs per innings<input type="number" value="20" min="1"></label><label class="form-field">Players per team<input type="number" value="11" min="2"></label><label class="form-field">Venue<input value="Oval Community Ground"></label><label class="form-field">Match date<input type="date" value="2026-10-11"></label>` },
    { title: "Playing XI", text: "Choose players and substitutes.", body: `<div class="setting-row"><span>Arjun Rao</span><input type="checkbox" checked aria-label="Select Arjun Rao"></div><div class="setting-row"><span>Dev Mehta</span><input type="checkbox" checked aria-label="Select Dev Mehta"></div><div class="setting-row"><span>Rohan Das</span><input type="checkbox" checked aria-label="Select Rohan Das"></div><div class="setting-row"><span>Substitutes</span><button class="text-button">Add players</button></div>` },
    { title: "Toss", text: "Record the toss result.", body: `<label class="form-field">Toss won by<select><option>Harbour XI</option><option>Riverside CC</option></select></label><label class="form-field">Elected to<select><option>Bat</option><option>Field</option></select></label>` },
    { title: "Opening players", text: "Confirm the first batters and bowler.", body: `<label class="form-field">Striker<select><option>Arjun Rao</option><option>Dev Mehta</option></select></label><label class="form-field">Non-striker<select><option>Dev Mehta</option><option>Arjun Rao</option></select></label><label class="form-field">Opening bowler<select><option>Samir Khan</option><option>Jay Shah</option></select></label>` }
  ];
  const step = steps[setupStep - 1];
  openSheet(`${sheetHeader(`New match · ${setupStep} of 6`, step.text)}<div class="stepper" aria-label="Step ${setupStep} of 6">${steps.map((_, index) => `<span class="${index < setupStep ? "done" : ""}"></span>`).join("")}</div><h3 style="margin:0 0 10px;color:var(--navy);font:800 14px Manrope,sans-serif">${step.title}</h3>${step.body}<div class="sheet-actions">${setupStep > 1 ? '<button class="secondary-button" data-action="setup-back">Back</button>' : '<button class="secondary-button" data-action="close-sheet">Cancel</button>'}<button class="primary-button" data-action="setup-next">${setupStep === 6 ? "Start match" : "Continue"}</button></div><p class="scoring-disclaimer" style="margin-top:11px">Setup preview only · no match is created or saved.</p>`);
}

function showTeamDetail(team) {
  openSheet(`${sheetHeader(team, "Squad · sample roster")}<div class="stats-grid"><div class="stat-box"><span>Players</span><strong>18</strong></div><div class="stat-box"><span>Matches</span><strong>12</strong></div></div><div class="setting-row"><span>Arjun Rao · Batter · #18</span><span>›</span></div><div class="setting-row"><span>Dev Mehta · All-rounder · #07</span><span>›</span></div><div class="setting-row"><span>Rohan Das · Bowler · #22</span><span>›</span></div><div class="sheet-actions"><button class="secondary-button" data-action="invite">Invite teammates</button><button class="primary-button" data-action="player-profile">Player stats</button></div>`);
}

function renderPageAfterSheet(page) {
  closeSheet();
  activePage = page;
  renderPage();
}

function onClick(event) {
  const nav = event.target.closest("[data-page]");
  if (nav) { navTo(nav.dataset.page); return; }
  const run = event.target.closest("[data-run]");
  if (run) { toast(`Preview only: ${run.dataset.run} runs selected. Nothing was recorded or synced.`); return; }
  const filter = event.target.closest("[data-filter]");
  if (filter) { liveFilter = filter.dataset.filter; renderPage(); return; }
  const centre = event.target.closest("[data-centre-tab]");
  if (centre) { centreTab = centre.dataset.centreTab; root.innerHTML = renderMatchCentre(centreTab); return; }
  const tournamentTabButton = event.target.closest("[data-tournament-tab]");
  if (tournamentTabButton) { activeTournamentTab = tournamentTabButton.dataset.tournamentTab; renderPage(); return; }
  const extra = event.target.closest("[data-extra]");
  if (extra) { const selected = extra.dataset.extra; closeSheet(); toast(`${selected} selected in preview. No delivery was recorded.`); return; }
  if (event.target.closest("[data-setup-choice]")) { toast("Format selected for preview only."); return; }
  const action = event.target.closest("[data-action]")?.dataset.action;
  if (!action) return;
  if (action === "extras") openExtras();
  else if (action === "wicket") openWicket();
  else if (action === "undo") openSheet(`${sheetHeader("Undo last delivery?", "This would remove the most recent recorded ball.")}<div class="demo-banner"><span>Nothing has been recorded in this prototype.</span></div><div class="sheet-actions"><button class="secondary-button" data-action="close-sheet">Cancel</button><button class="primary-button" data-action="undo-confirm">Preview undo</button></div>`);
  else if (action === "close-sheet") closeSheet();
  else if (action === "confirm-wicket") { closeSheet(); toast("Wicket details selected for preview. Nothing was recorded."); }
  else if (action === "undo-confirm") { closeSheet(); toast("Preview only: no delivery was undone."); }
  else if (action === "create-match") openSetup();
  else if (action === "setup-next") { if (setupStep < 6) { setupStep += 1; renderSetupStep(); } else { closeSheet(); toast("Match setup preview complete. No match was created."); } }
  else if (action === "setup-back") { setupStep = Math.max(1, setupStep - 1); renderSetupStep(); }
  else if (action === "match-centre") { activePage = "match-centre"; centreTab = "Summary"; renderPage(); }
  else if (action === "result") { activePage = "result"; renderPage(); }
  else if (action === "player-profile") { renderPageAfterSheet("player-profile"); }
  else if (action === "team-detail") showTeamDetail(event.target.closest("[data-team]").dataset.team);
  else if (action === "create-team") toast("Team creation is a prototype placeholder. No team was saved.");
  else if (action === "create-tournament") toast("Tournament creation is a prototype placeholder. No tournament was saved.");
  else if (action === "invite") toast("Invitations are not connected in this prototype.");
  else if (action === "share-result") toast("Share/export is not connected in this prototype.");
  else if (action === "edit-profile") toast("Profile editing is not connected in this prototype.");
  else if (action === "language" || action === "sign-out") toast("Account settings are not connected in this prototype.");
}

root.addEventListener("click", onClick);
document.querySelector(".bottom-nav").addEventListener("click", onClick);
sheetContent.addEventListener("click", onClick);
backdrop.addEventListener("click", (event) => { if (event.target === backdrop) closeSheet(); });
document.addEventListener("keydown", (event) => { if (event.key === "Escape" && !backdrop.hidden) closeSheet(); });
root.addEventListener("input", (event) => {
  if (!event.target.matches("[data-match-search]")) return;
  const query = event.target.value.trim().toLowerCase();
  document.querySelectorAll("[data-match-searchable]").forEach((card) => { card.hidden = !card.dataset.matchSearchable.toLowerCase().includes(query); });
});

document.addEventListener("click", (event) => {
  const themeButton = event.target.closest("[data-theme]");
  if (!themeButton) return;
  document.querySelectorAll("[data-theme]").forEach((button) => button.classList.toggle("is-selected", button === themeButton));
  if (themeButton.dataset.theme === "dark") toast("Dark theme preview is not implemented yet.");
});

renderPage();
