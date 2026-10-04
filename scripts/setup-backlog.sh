#!/bin/sh
# One-shot: seed labels, milestones, and a starter issue set.
# Run from the repo root, after the repo exists and gh is authenticated.
#
# shellcheck disable=SC2016  # backticks in the issue bodies are literal markdown
set -e

REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
echo "Seeding backlog for $REPO"

# --- labels -----------------------------------------------------------
gh label create setup    --color fbca04 --force --description "Environment and setup work"
gh label create learning --color 5319e7 --force --description "Skill building, not shipping"
gh label create design   --color 1d76db --force --description "Decisions and writing, no code"
gh label create feature  --color 0e8a16 --force --description "New game behaviour"
gh label create polish   --color d4c5f9 --force --description "Feel, art, audio"
gh label create playtest --color c2e0c6 --force --description "Human feedback sessions"
gh label create ship     --color bfd4f2 --force --description "Packaging, stores, launch"
gh label create ready    --color 2cbe4e --force --description "Workable now — clears itself when you assign yourself"

# --- milestones -------------------------------------------------------
gh api --silent repos/"$REPO"/milestones -f title="M0 — Setup & first window" -f description="Weekend 1: the template builds and your first element is on screen."
gh api --silent repos/"$REPO"/milestones -f title="M1 — Core loop"           -f description="Weekends 2-3: input, feedback, a number that grows."
gh api --silent repos/"$REPO"/milestones -f title="M2 — Progression"         -f description="Weekends 3-5: the idle loop — the game plays itself a little."
gh api --silent repos/"$REPO"/milestones -f title="M3 — Saving"              -f description="Weekend 6: progress survives restarts."
gh api --silent repos/"$REPO"/milestones -f title="M4 — Feel & polish"       -f description="Weekends 7-9: juice, art, audio — all hand-made."
gh api --silent repos/"$REPO"/milestones -f title="M5 — Ship"                -f description="Weekends 10-12: package, store page, launch."

# --- issues -----------------------------------------------------------
issue() {
  title=$1; ms=$2; label=$3; body=$4
  gh issue create --title "$title" --milestone "$ms" --label "$label" --body "$body"
}

url=$(issue '📌 Start here — how this project runs' 'M0 — Setup & first window' 'setup' \
'Read `PROJECT.md` first — it explains the weekly rhythm, the check-in and standup rituals, and how work is ordered. Milestones M0–M5 are the roadmap; work top to bottom inside each one.

Done when: you have read it and know what a Friday standup looks like.')
num=${url##*/}
gh issue pin "$num" >/dev/null 2>&1 || true

# ---- M0 --------------------------------------------------------------
issue 'M0.1 — Run the starter template' 'M0 — Setup & first window' 'setup' \
'Run `make`, then `make run`. You should get a raylib window that closes with ESC.

Done when: the window opens and closes on your machine, and you can explain out loud what the `while` loop in `main.c` is doing.'

issue 'M0.2 — Understand every line of main.c' 'M0 — Setup & first window' 'learning' \
'Go through `main.c` and add a plain-English comment above each line you could not write from memory. The full raylib API lives in `external/raylib/src/raylib.h` — read the function names there.

Done when: every line has a comment in your own words (not copied from docs).'

issue 'M0.3 — Pick a working title and a one-sentence pitch' 'M0 — Setup & first window' 'design' \
'Example shape: "A tiny game about one stubborn idea." Write yours at the top of `PROJECT.md`.

Done when: title and pitch are committed.'

issue 'M0.4 — Make the window yours' 'M0 — Setup & first window' 'feature' \
'Change the window title, size, and background colour in `main.c`.

Done when: it looks chosen on purpose, not default.'

issue 'M0.5 — Draw your first game element' 'M0 — Setup & first window' 'feature' \
'Draw one shape (a circle or a rectangle) where the core thing of your game will sit. Look up: `DrawCircle`, `DrawRectangle`.

Done when: the shape appears exactly where you want it, at the size you want.'

# ---- M1 --------------------------------------------------------------
issue 'M1.1 — Make input count' 'M1 — Core loop' 'feature' \
'Track a number (score, count — whatever your game counts) and add 1 for each meaningful input: a click, a key press, or both. Look up: `IsMouseButtonPressed`, `GetKeyPressed`. Print it with `TraceLog` for now.

Done when: the input prints an increasing number; other input does nothing.'

issue 'M1.2 — Show it on screen' 'M1 — Core loop' 'feature' \
'Replace the console print with text drawn in the window. Look up: `DrawText`, `MeasureText`.

Done when: the number updates the instant you interact.'

issue 'M1.3 — Make big numbers readable' 'M1 — Core loop' 'feature' \
'Format the number with commas (12,431). You will stare at this number for hours. Look up: `snprintf`.

Done when: a number in the millions is readable at a glance.'

issue 'M1.4 — Input feedback' 'M1 — Core loop' 'polish' \
'The screen reacts visibly to input: a dip, a flash, a small pop.

Done when: you can tell an input registered with the sound muted.'

issue 'M1.5 — Sound for the interaction' 'M1 — Core loop' 'polish' \
'Find or record a short sound yourself (hand-made or hand-picked — no AI generation), then load and play it. Look up: `InitAudioDevice`, `LoadSound`, `PlaySound`.

Done when: every input plays instantly — no delay, no crackle.'

issue 'M1.6 — Delta time lesson' 'M1 — Core loop' 'learning' \
'Make a dot cross the screen at a constant, frame-rate-independent speed using `GetFrameTime`. Then set `SetTargetFPS` to 30, 60, and 144 — the dot must cross in the same wall-clock time at all three settings.

Done when: you can explain in one sentence why speed is multiplied by frame time, and the observed crossing time is identical at all three settings.'

# ---- M2 --------------------------------------------------------------
issue 'M2.1 — Design the upgrade list' 'M2 — Progression' 'design' \
'Write 5 upgrades (name, base cost, effect) plus 1 manual-action upgrade as a table in `docs/design.md`. Pacing rule: the cheapest upgrade is affordable within the first 60 seconds; the last one within about 30 minutes.

Done when: the table is committed and roughly obeys the pacing rule.'

issue 'M2.2 — First purchasable upgrade' 'M2 — Progression' 'feature' \
'Hardcode one buyable upgrade. After buying it, progress rises on its own.

Done when: the number increases with no interaction.'

issue 'M2.3 — Tick production with delta time' 'M2 — Progression' 'feature' \
'Drive the automatic progress from frame time, not frame count.

Done when: one upgrade adds exactly 1 unit per second (verify over 30 seconds) and the observed rate is identical at 30 vs 144 FPS.'

issue 'M2.4 — Shop panel' 'M2 — Progression' 'feature' \
'Draw a shop area with one row: upgrade name, owned count, cost. Look up: `DrawRectangle`, `DrawText`. UI layout is just maths.

Done when: the row is readable and does not overlap the game area.'

issue 'M2.5 — Buying logic' 'M2 — Progression' 'feature' \
'Clicking the row buys it: subtract the cost, owned count +1, refuse when too poor. Grey out unaffordable rows.

Done when: buying works and an unaffordable row visibly refuses.'

# ---- M3 --------------------------------------------------------------
issue 'M3.1 — Choose the save format' 'M3 — Saving' 'design' \
'Recommendation: a plain text file, one `key value` line per field — easy to read and hand-edit while learning. Decide the file name and where it lives (next to the binary for now), and record the decision in `docs/design.md`.

Done when: format, keys, and path are written down.'

issue 'M3.2 — Save and load' 'M3 — Saving' 'feature' \
'Write the save when the window closes; load it at startup. A missing file is normal, not an error — first launch starts fresh.

Done when: quit, relaunch — progress is back; and deleting the save file gives a clean fresh game with no crash.'

# ---- M4 --------------------------------------------------------------
issue 'M4.1 — Lock the visual style' 'M4 — Feel & polish' 'design' \
'Pick 3-5 colours (hex) and one font — hand-made or hand-picked only. Put them in `docs/design.md` and use them consistently.

Done when: the game no longer uses default debug colours.'

# ---- M5 --------------------------------------------------------------
issue 'M5.1 — Release build' 'M5 — Ship' 'ship' \
'Add a `make release` path: -O2, no debug info, smaller binary.

Done when: the release binary runs identically and is noticeably smaller.'

issue 'M5.2 — Store page text' 'M5 — Ship' 'design' \
'Short description, long description, tags, price. The store also needs capsule images, screenshots, and eventually a trailer — all hand-made.

Done when: the store text is ready to paste.'

echo "Backlog seeded: 22 issues across 6 milestones."
