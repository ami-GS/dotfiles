(golden-ratio-mode 1)
(setq golden-ratio-exclude-buffer-regexp '("\\*anything" "\\*helm"))
(setq golden-ratio-extra-commands
      '(windmove-left windmove-right windmove-down windmove-up))


(require 'origami)
(global-origami-mode t)
(global-set-key (kbd "C-\\") 'origami-toggle-node)


;(require 'git-gutter)
;(global-git-gutter-mode t)
;(git-gutter:linum-setup) ; with linum
;(global-git-gutter+-mode)


(load "11_highlight.el")
(load "12_scrolling.el")
