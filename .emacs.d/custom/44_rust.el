(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
(require 'company-racer)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook #'flycheck-rust-setup)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
