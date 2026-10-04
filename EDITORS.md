# Editors — no AI completions in this project

This project follows a **no-AI development rule**: every line of code and every
asset is made by hand. To keep that rule airtight, AI **edit predictions / inline
completions** are disabled for this project, per editor, without touching anyone's
global settings. Chat assistants remain available as the **tutor and project
management lane only**, bound by `AGENTS.md`: they explain in words and run your
backlog — they never write or suggest code, and never add assets.

| Editor | Repo-local file | What it does |
| --- | --- | --- |
| Zed | `.zed/settings.json` | `edit_predictions.provider: "none"` |
| VS Code | `.vscode/settings.json` | Copilot completions + next-edit suggestions off; inline suggestions off |
| Vim / Neovim | `.exrc` | `Copilot disable` + `g:copilot_enabled = v:false` (requires `exrc` enabled) |
| Emacs | `.dir-locals.el` | Turns `copilot-mode` off in this project (best effort; depends on your Copilot package) |
| JetBrains (IDEA / CLion) | — | No reliable repo-scoped switch; see below |

## Per editor

### Zed
Nothing to do — `.zed/settings.json` applies automatically. Accept the worktree
trust prompt once, if it appears.

### VS Code
Nothing to do — open the folder and the workspace settings apply. Optional:
format-on-save via `"[c]": { "editor.formatOnSave": true }`. The *EditorConfig
for VS Code* extension is recommended if you rely on `.editorconfig`
(VS Code doesn't read it natively; the native equivalents are already set).

### Vim / Neovim
`.exrc` is only read when `exrc` is enabled: `set exrc` in Vim (add `set secure`
as a safety belt), or `vim.o.exrc = true` in Neovim.

### Emacs
Emacs asks once to approve the directory-local eval — accept it. Works for
packages that provide `copilot-mode`; other integrations vary.

### JetBrains (IntelliJ IDEA, CLion)
JetBrains settings are IDE-global — there is no per-project AI toggle. While
working on this repo: `Settings → Tools → GitHub Copilot` → disable, and
`Settings → Tools → AI Assistant` → disable. CLion does read `.clang-format`:
`Settings → Editor → Code Style → C/C++ → Enable ClangFormat` (use `.clang-format`).

### Anything else
Turn off AI completions in that editor's settings; if it supports repo-local
configuration, add it here.

## Formatting

The spec lives in **`.clang-format`** (Allman braces, 4-space indent, 80 columns,
aligned consecutive assignments). Tool of choice: **clang-format** (fast single
binary, understood by every editor above); install with
`sudo apt install clang-format` or `pacman -S clang`.

- **`.editorconfig`** — indentation/newlines for editors that support it
  (Zed, Vim, Emacs, JetBrains read it natively; VS Code needs the EditorConfig
  extension).
- **Pre-commit hook** — `.githooks/pre-commit` auto-formats staged `.c`/`.h`
  files, re-stages them, and prints what changed. One-time setup per clone:

      git config core.hooksPath .githooks

  It re-stages whole files (simple by design) and refuses with a clear message
  if `clang-format` is not installed. Bypass once with `git commit --no-verify`
  — you should almost never need to.
- Manual: `clang-format -i main.c` (format now) · `clang-format main.c` (preview).
