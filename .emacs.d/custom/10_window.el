(golden-ratio-mode 1)
(setq golden-ratio-exclude-buffer-regexp '("\\*anything" "\\*helm"))
(setq golden-ratio-extra-commands
      '(windmove-left windmove-right windmove-down windmove-up))

(require 'git-gutter)
(global-git-gutter-mode t)
(git-gutter:linum-setup) ; with linum

(load "11_highlight.el")
(load "12_scrolling.el")
