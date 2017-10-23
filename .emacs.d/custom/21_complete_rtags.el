(require 'company-rtags)
(setq rtags-completions-enabled t)
(eval-after-load 'company
  '(add-to-list
    'company-backends 'company-rtags))
(setq rtags-autostart-diagnostics t)
(rtags-enable-standard-keybindings)
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(rtags-start-process-maybe)

(add-hook 'c-mode-common-hook
	  '(lambda ()
	    (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
	    (local-set-key (kbd "M-;") 'rtags-find-symbol)
	    (local-set-key (kbd "M-@") 'rtags-find-references)
	    (local-set-key (kbd "M-,") 'rtags-location-stack-back)))
