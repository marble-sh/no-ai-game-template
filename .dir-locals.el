;;; -*- no-byte-compile: t -*-
;; This project is no-AI for code and assets — no AI completions in this repo.
;; Best-effort for Emacs Copilot packages: turn copilot-mode off for buffers
;; that visit this project. Emacs asks you to approve these dir-locals once.
((nil . ((eval . (when (fboundp 'copilot-mode)
                   (copilot-mode -1))))))
