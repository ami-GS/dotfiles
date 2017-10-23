(golden-ratio-mode 1)
(setq golden-ratio-exclude-buffer-regexp '("\\*anything" "\\*helm"))
(setq golden-ratio-extra-commands
      '(windmove-left windmove-right windmove-down windmove-up))

(load "11_highlight.el")
(load "12_scrolling.el")
