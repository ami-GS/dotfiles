(require 'python-mode)

; need pip install jedi, pyflakes

(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "/usr/local/bin/pyflakes"  (list local-file) ; might need pip install -U pyflakes
	    )))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

(defun flymake-show-help ()
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))
(add-hook 'post-command-hook 'flymake-show-help)

(custom-set-faces
  '(flymake-errline ((((class color)) (:background "red")))))

;(require 'py-autopep8)
;(setq py-autopep8-options '("--max-line-length=200"))
;(setq flycheck-flake8-maximum-line-length 200)
;(py-autopep8-enable-on-save)
;(add-hook 'before-save-hook 'py-autopep8-before-save)
;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)          ; バッファ全体のコード整形
;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)   ; 選択リジョン内のコード整形

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
