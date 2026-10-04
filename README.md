# no-ai-game-template

A simple template repository for a **0-AI game**: nothing in your game is
AI-programmed, AI-developed, or AI-generated — with one deliberate exception.
**AI only does the project management and standup tasks to keep you on track.
Nothing else.**

Your AI assistant runs your backlog, your check-ins and your weekly standup: it
keeps one task in front of you, keeps the board honest, and hands you the next
action. It never writes code. It never makes assets. That is the whole job.

## The rule

- **You write every line of code.** No AI suggestions, completions, or "just a snippet".
- **You make every asset** (or hand-pick assets made by people). No AI images, audio,
  fonts, or "placeholder generation".
- **AI manages the project only:** issues, priorities, blockers, due dates, check-ins,
  standup. It talks; you build.

The repo ships the enforcement, so the rule is more than a promise: `AGENTS.md` binds
every AI tool that opens the repository, and editor configs turn AI code completions
off for Zed, VS Code, Vim/Neovim, and Emacs.

## What's in the box

- **C17 + raylib starter** — `main.c`, `Makefile` (raylib pinned, fetched on first
  build), plus CI that builds and headless-smoke-tests every push.
- **Backlog helpers** — `scripts/setup-backlog.sh` creates labels, milestones and a
  starter issue set; `scripts/setup-board.sh` creates the project board with
  Priority + Due fields, four focused views, and the ready/blocked flow.
- **Automation** — `ready` clears when you assign yourself (and returns if you
  unassign); completing a ticket re-runs the regression gate and auto-assigns the
  next ready ticket (WIP 1 permitting); issues become ready automatically when
  their blockers close; a daily check-in nudge and a Friday standup digest land on
  the pinned issue.
- **Agent rules** — `AGENTS.md` (+ `CLAUDE.md`) and `.github/copilot-instructions.md`.
- **Editor setup** — `.zed/`, `.vscode/`, `.exrc`, `.dir-locals.el` (AI off),
  `.editorconfig`, `.clang-format`, and a pre-commit format hook (`EDITORS.md`
  explains each).
- **Planning docs** — `PROJECT.md` (how the team works), `IDEAS.md` (scored idea ledger).

## Quickstart

1. **Create a repo from this template** — *Use this template* → *Create a new
   repository*, or:
   `gh repo create my-game --public --template <owner>/no-ai-game-template`.
2. **Seed the plan** (needs `gh` with the `project` scope — `gh auth refresh -s project`):

       sh scripts/setup-backlog.sh
       sh scripts/setup-board.sh

3. **Open it in your editor.** Accept the trust prompts once (Zed / Emacs). If you
   use Vim/Neovim, enable `exrc` to pick up the AI-off settings.
4. `make run` — get a window on screen, then start your first issue.

## How a session looks

- Open a session and say **`checkin`** — the PM reconciles the board and hands you
  one next action.
- Start a task by **assigning yourself**: the `ready` label clears automatically.
- Finish a task by **closing it as completed** — regression re-runs and the next
  ready ticket is assigned to you automatically (unless you still hold open work).
- Unassign a ticket to put it back in the ready set.
- Every open issue is either `ready` or *Is blocked by* another issue — nothing in between.
- **Priorities and due dates** (P1 = ready/next up, P2 = next milestone, P3 = later;
  soft, sized to your real hours) are the PM's upkeep — ask any time; they are re-tuned
  at check-ins and standups.
- Friday: say **`standup`** for the weekly review; the PM re-orders next week's
  short-list and re-dates the ready items.

That is it. The AI keeps you on track; the game is 100% yours.

## License

**MIT-0 (No Attribution)** — see `LICENSE`. Use it, modify it, ship it (commercially
or otherwise) with no payment, no conditions, and nothing owed. A credit is
welcome, but never required.
