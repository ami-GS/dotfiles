(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
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

(setq make-backup-files nil)

(add-hook 'before-save-hook 'gofmt-before-save)
(add-to-list 'load-path "~/.emacs.d/auto-complete")

;;折りたたみ
(add-hook 'python-mode-hook
		  '(lambda()
			 (hs-minor-mode 1))
		  )
(define-key global-map (kbd "C-x /") 'hs-toggle-hiding)

(require 'highlight-symbol)
(setq highlight-symbol-colors '("RoyalBlue1" "SpringGreen1" "DeepPink1" "OliveDrab"))
(global-set-key (kbd "<f3>") 'highlight-symbol-at-point)
(global-set-key (kbd "ESC <f3>") 'highlight-symbol-remove-all)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;;; auto-complete
(require 'auto-complete-config)
;;(global-auto-complete-mode t)
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/ac-dict")
;;(ac-config-default)
