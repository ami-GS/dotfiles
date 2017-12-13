(require 'helm)
(helm-mode t)
(global-set-key (kbd "M-x") 'helm-M-x)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
;; For find-file etc.
(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
;; For helm-find-files etc.
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

(require 'helm-config)
(require 'helm-gtags)
(add-hook 'c-mode-hook 'helm-gtags-mode)
;; key bindings
(add-hook 'helm-gtags-mode-hook
          '(lambda ()
              (local-set-key (kbd "M-t") 'helm-gtags-find-tag)
              (local-set-key (kbd "M-r") 'helm-gtags-find-rtag)
              (local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
              (local-set-key (kbd "C-t") 'helm-gtags-pop-stack)))
