# no-ai-game-template

A simple template repository for a **0-AI game**: nothing in your game — code,
assets, or words — is AI-programmed, AI-developed, or AI-generated, with one
deliberate exception. **AI only does the project management and standup tasks to
keep you on track. Nothing else.**

Your AI assistant runs your backlog, your check-ins and your weekly standup: it
keeps one task in front of you, keeps the board honest, and hands you the next
action. It never writes code. It never makes assets. It never writes the game.
That is the whole job.

## The rule

- **You write every line of code.** No AI suggestions, completions, or "just a snippet".
- **You make every asset** (or hand-pick assets made by people). No AI images, audio,
  fonts, or "placeholder generation".
- **You write every word of the game.** Story, dialogue, characters, in-game text,
  store blurbs — no AI drafts, suggestions, or rewrites, not even one line.
- **AI manages the project only:** issues, priorities, blockers, due dates, check-ins,
  standup. It talks; you build — and you write.

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
- **Wiki upkeep** — the AI keeps a running wiki (Dev log, Lessons): pages live in
  `docs/wiki/` and publish with `sh scripts/wiki-sync.sh "message"`.
- **Agent rules** — `AGENTS.md` (+ `CLAUDE.md`) and `.github/copilot-instructions.md`.
- **Editor setup** — `.zed/`, `.vscode/`, `.exrc`, `.dir-locals.el` (AI off),
  `.editorconfig`, `.clang-format`, and a pre-commit format hook (`EDITORS.md`
  explains each).
- **Planning docs** — `PROJECT.md` (how the team works), `IDEAS.md` (scored idea ledger).

## Quickstart

From “generated from this template” to “first window on screen, backlog live” —
ten minutes of setup, plus the first raylib build.

### 1. Install the tools (once per machine)

You need: `git`, a C toolchain (`gcc` or `clang`) with `make`, [`gh`](https://cli.github.com)
for the board scripts, and `clang-format` for the commit hook.

**Linux — Debian/Ubuntu**

```sh
sudo apt update
sudo apt install -y build-essential git gh clang-format
sudo apt install -y xorg-dev libgl1-mesa-dev libasound2-dev   # raylib build deps
```

**Linux — Fedora**

```sh
sudo dnf install -y gcc make git gh clang-tools-extra
sudo dnf install -y alsa-lib-devel mesa-libGL-devel libX11-devel libXrandr-devel libXi-devel libXcursor-devel libXinerama-devel
```

**Linux — Arch**

```sh
sudo pacman -S --needed base-devel git gh clang alsa-lib mesa libx11 libxrandr libxi libxcursor libxinerama
```

**macOS**

```sh
xcode-select --install         # clang + make (git comes with it)
brew install gh clang-format
```

**Windows — recommended: WSL2 (Ubuntu)**

WSL runs the same environment the project's CI uses, and windows appear through WSLg
on Windows 11 / updated Windows 10.

```sh
wsl --install -d Ubuntu        # PowerShell, once; reboot if it asks
```

Then open Ubuntu and run the Debian/Ubuntu list above. Keep the repo inside the Linux
home (`~/code/...`), not under `/mnt/c` — builds are much faster there.

**Windows — native (MSYS2)**

Works, with two wrinkles: run everything from the MSYS2 **UCRT64** shell (PowerShell
and cmd can't run the Makefile's shell steps or the setup scripts), and install `gh`
and LLVM on the Windows side.

```sh
# install MSYS2 from msys2.org, open the "UCRT64" shell, then:
pacman -S --needed git make mingw-w64-ucrt-x86_64-gcc
# gh + clang-format — in PowerShell (reopen the MSYS2 shell afterwards):
#   winget install GitHub.cli
#   winget install LLVM.LLVM
```

### 2. Authenticate GitHub

```sh
gh auth login                  # SSH or HTTPS — it can upload a key or set up git credentials
gh auth refresh -s project     # the board script needs the "project" scope
```

Check `gh --version` — the backlog scripts need a recent `gh` (2.89+) for the
issue-dependency flags.

### 3. Create your repo from the template, and clone it

On GitHub: **Use this template** → **Create a new repository**, then clone it.
Or all at once from the CLI:

```sh
gh repo create my-game --template <owner>/no-ai-game-template --private --clone
cd my-game
```

### 4. Seed the plan (from the repo root)

```sh
sh scripts/setup-backlog.sh    # labels, milestones, starter issues, pinned “Start here”
sh scripts/setup-board.sh      # project board: Priority + Due fields and four views
```

The first script also enables the shipped pre-commit format hook for your clone
(`core.hooksPath=.githooks`) — staged C files are clang-formatted on every commit.

Then, once, in the project UI — **⋯ → Workflows** (GitHub has no API for these):
*Auto-add to project* with filter `is:issue is:open`, *Item closed → Status: Done*,
*Item reopened → Status: Todo*.

### 5. Build and run

```sh
make          # first run downloads and builds raylib (a few minutes, needs network)
make run      # a window opens; close it with ESC
```

### 6. Start working

Open the repo in your editor and accept the trust prompt once (Vim/Neovim users:
enable `exrc`) — `EDITORS.md` covers each editor and keeps AI completions off. Then
take the first ticket from the board, or open your AI assistant and say **`checkin`** —
it hands you exactly one next action.

On that first session the AI also asks one onboarding question: keep the shipped
C17 + raylib layout, or switch the project to another language/framework. Either
answer keeps the backlog intact — the layout is only a starting point.

Optional: the wiki needs one manual first page (the **Wiki** tab → *Create the first
page*) before `sh scripts/wiki-sync.sh` can publish the seeded Dev log / Lessons pages.

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
- The **wiki** stays current too: ask to see it, or edit pages yourself under
  `docs/wiki/` and publish with the sync script.
- Friday: say **`standup`** for the weekly review; the PM re-orders next week's
  short-list and re-dates the ready items.

That is it. The AI keeps you on track; the game is 100% yours.

## License

**MIT-0 (No Attribution)** — see `LICENSE`. Use it, modify it, ship it (commercially
or otherwise) with no payment, no conditions, and nothing owed. A credit is
welcome, but never required.
