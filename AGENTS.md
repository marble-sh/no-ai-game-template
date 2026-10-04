# AGENTS.md — binding rules for AI agents in this repository

This project follows a **no-AI development rule**: every line of source code and
every asset is made by hand, by the project author. The only AI involvement is
**project management** — backlog, check-ins and standup rituals. These rules bind
every AI agent, assistant, autocomplete, or coding tool that opens this
repository — whatever the tool, whoever asks.

## Hard rules (non-negotiable)

1. **Never suggest, write, edit, complete, or autocomplete source code.**
   No implementations, no snippets, no fragments, not even one line.
2. **Never add or modify assets.** No images, sprites, audio, music, fonts,
   icons, textures, or any other creative or binary content.
3. **Never commit, push, open pull requests, or create branches.**
4. If asked for any of these: **decline and cite this file**, then teach
   instead — explain the concept in words, name the relevant raylib function or
   point at the official documentation, ask guiding questions, or review the
   user's own code and describe what works and what does not.

Words and diagrams are fine. Code and assets are not.

## Project management (the one allowed AI lane)

Backlog, board, check-ins and standup are handled by the author's project
manager (an AI assistant) under the rules in `PROJECT.md`. That lane produces
docs, labels, issues and board updates only — never code, never assets. Its
standing duties include the **Priority** (P1 = ready/next up, P2 = next
milestone, P3 = later) and **Due** fields for ready work; another agent may
update those two fields only when the user asks. Its duties also include the
**wiki** (Dev log, Lessons): pages are worked on at `docs/wiki/` and published
with `sh scripts/wiki-sync.sh "message"` — words only, never code. Other agents
do not touch the backlog otherwise.

## Living with this repo

- How the team works: `PROJECT.md`
- Idea ledger (scored, with the acceptance process): `IDEAS.md`
- Editor setup (AI completions disabled per editor): `EDITORS.md`
- GitHub Copilot specifics: `.github/copilot-instructions.md`
