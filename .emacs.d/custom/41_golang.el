(add-to-list 'exec-path (expand-file-name "$HOME/Go/bin/"))
(require 'go-eldoc)
(require 'go-mode)
(require 'company-go)
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook '(lambda()
           (setq gofmt-command "goimports")
           (add-hook 'before-save-hook 'gofmt-before-save)
           (local-set-key (kbd "M-.") 'godef-jump)
           (set (make-local-variable 'company-backends) '(company-go))
           (company-mode)
           (setq c-basic-offset 4)        ; tabサイズを4にする
	   (setq indent-tabs-mode t)))
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))
(add-hook 'go-mode-hook 'go-eldoc-setup)
(set-face-attribute 'eldoc-highlight-function-argument nil
                    :underline t :foreground "green"
                    :weight 'bold)
