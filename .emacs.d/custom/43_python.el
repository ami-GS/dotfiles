;(flymake-mode t)
(require 'python)
(require 'python-mode)
(require 'py-autopep8)
(require 'flymake-python-pyflakes)
(flymake-python-pyflakes-load)
(setq py-autopep8-options '("--max-line-length=200"))
(setq flycheck-flake8-maximum-line-length 200)
(py-autopep8-enable-on-save)
;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)          ; バッファ全体のコード整形
;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)   ; 選択リジョン内のコード整形
;; 保存時にバッファ全体を自動整形する
(add-hook 'before-save-hook 'py-autopep8-before-save)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
(require 'jedi-core)
(with-eval-after-load 'company
  (add-hook 'python-mode-hook
            (lambda ()
              (add-to-list 'company-backends 'company-jedi))))

(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq indent-level 4)
	    (setq python-indent 4)
	    (setq tab-width 4)
	    (setq jedi:complete-on-dot t)
	    (setq jedi:use-shortcuts t)
	    (setq auto-complete-mode nil) ; IMPORTANT!!! to use company in stead of auto-complete
	    (jedi:setup)
	    )
	  )
