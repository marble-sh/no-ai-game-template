# [Your Game] — Project Guide

Working title: _to be decided_
Pitch: _one sentence, your words_
Setup choice: _not chosen yet — the AI asks once at first run: keep C17 + raylib, or switch?_

Goal: a small desktop game, written in C with raylib.

Ports only if the finished game earns them.

**No AI-made code, assets, or writing.** You write every line of code, you make or
hand-pick every asset, and you write the game's story, dialogue and text yourself.
AI runs the project management only — backlog, check-ins, standup. The rules for AI
tools live in `AGENTS.md`.

## Build

- `make` — first run fetches and builds raylib (network needed once), then builds `./game`.
- `make run` — build and launch.
- `make clean` / `make distclean` — remove the binary / also the fetched raylib.
- raylib version is pinned in the Makefile (`RAYLIB_VERSION`).

## How we work

- **One task at a time.** WIP limit is 1: finish it or park it before opening another.
- **Definition of done:** builds, runs, feels right, pushed to GitHub.
- **The board:** Issues tab, grouped into milestones. The Project view is the
  dashboard; it carries a **Priority** field (P1 = next up, P2 = next milestone,
  P3 = later) and a **Due** date field for ready work.
- **Ready or blocked.** Every open issue is either labeled `ready` (workable now,
  with a soft due date) or linked *Is blocked by* a specific earlier issue.
  Nothing sits unclassified.
- **Assign yourself to start.** Assigning an issue removes its `ready` label
  automatically. Due dates are soft targets, re-tuned at every check-in — not promises.
- **Finish by closing the issue as *completed*.** If nothing else is assigned, the
  first ticket in the ready set is auto-assigned to you, and the regression gate
  (build + headless smoke) re-runs on the latest code. Unassigning a ticket puts it
  back in the ready set.
- A task you cannot finish in two evenings is too big — say so at a check-in and
  it will be cut down.

## Check-ins and backlog upkeep

The project manager (your AI assistant, driven by the files in this repo) owns the
backlog. Whenever you open a session and a day or more has passed since the last
pass, it reconciles the board — Ready set, blockers, priorities, due dates — then
hands you the one next action. Say **"checkin"** for a ~2-minute pass at any time.
GitHub timers post a daily check-in nudge and a Friday standup digest on the pinned
issue — the timers are reminders; the pass itself happens when you open a session.

## Weekly standup (last evening of your week — default Friday, 15 min)

Open your editor in this project and say **"standup"**. The PM reviews the board
and asks:

1. What moved since last check-in?
2. What got stuck, and what did you learn?
3. What is the ONE thing for next week?
4. Time check: did the plan match your real available hours?

Then it massages the backlog: rolls the milestone gates (Ready set, Priorities),
re-dates ready items against your real hours, splits oversized tasks, and records
decisions on the relevant issues.

## Automations (already wired — nothing to install)

- Assign → `ready` clears. Unassign (or re-open with nobody on it) → `ready` comes
  back, blockers permitting. A daily sweep readies tickets whose blockers all closed;
  a ticket someone holds is never re-marked ready.
- Close as *completed* → regression runs on the default branch, and the first
  unassigned `ready` ticket (top of the Next up view) is auto-assigned to you —
  skipped with a note while you still hold open work (WIP 1).
- **Priority & due dates** are the PM's stewardship: P1 = ready/next up, P2 = next
  milestone, P3 = later; ready items carry soft due dates sized to ~5 h/week, re-tuned
  at every check-in and standup. Another AI assistant may adjust them only when you
  ask it to.
- One-time clicks in the project UI (there is no API for these): enable the built-in
  workflows *Auto-add to project* (filter `is:issue is:open`), *Item closed → Status:
  Done* and *Item reopened → Status: Todo*; sort the *Next up* view by Priority, then Due.
- **The wiki** keeps the human-readable story (Dev log, Lessons): pages are worked on
  at `docs/wiki/` and published with `sh scripts/wiki-sync.sh "message"`. It is
  refreshed at every check-in and standup. Words only — the wiki never carries code.

## Time budget (starting assumption — calibrate at the first standup)

- Two 1-hour weeknights + one 2–3 hour weekend block ≈ 5 h/week.
- Progress you can see beats code you are proud of. Ship the ugly one.

## When you are stuck

- Stuck >30 min: comment on the issue with what you tried. That is what standup is for.
- raylib API: `external/raylib/src/raylib.h` is the reference; runnable examples
  ship in `external/raylib/examples` and at raylib.com.
- You can ask AI to explain concepts, in words — never to write the code.
