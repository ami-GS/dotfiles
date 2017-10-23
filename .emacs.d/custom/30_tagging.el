(add-to-list 'load-path "/usr/local/share/gtags")
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
	 (local-set-key "\M-t" 'gtags-find-tag)    ; jump to func
	 (local-set-key "\M-r" 'gtags-find-rtag)   ; jump back
	 (local-set-key "\M-s" 'gtags-find-symbol) ; jump to symbol
	 (local-set-key "\C-t" 'gtags-pop-stack)   ; back to prev buff
	 ))

(require 'rtags)
;bellow cause error
;(setq rtags-rdm-includes "/usr/local/include")
;(setq rtags-rdm-includes "./")
;(setq rtags-rdm-includes "/usr/include")

(require 'company-rtags)
(setq rtags-completions-enabled t)
(eval-after-load 'company
  '(add-to-list
    'company-backends 'company-rtags))
(setq rtags-autostart-diagnostics t)
(rtags-enable-standard-keybindings)
(rtags-start-process-maybe)

; if there is rtagsc
(require 'flycheck-rtags)
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
; c-mode-common-hook is also called by c++-mode
