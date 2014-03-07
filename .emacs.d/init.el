(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'go-mode-load)
(add-hook 'go-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4)
	     (setq indent-tabs-mode t)
	     (local-set-key (kbd "M-.") 'godef-jump)
	     (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
	     (local-set-key (kbd "C-c i") 'go-goto-imports)
	     (local-set-key (kbd "C-c d") 'godoc)
	     (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)))

(add-hook 'before-save-hook 'gofmt-before-save)

(add-to-list 'load-path "~/.emacs.d/auto-complete")



;;;; auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode t)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
(ac-config-default)