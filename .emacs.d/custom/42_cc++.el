(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hh\\'" . c++-mode))

;; (defun my:ac-c-headers-init ()
;;   (require 'auto-complete-c-headers)
;;   (add-to-list 'ac-sources 'ac-source-c-headers)
;;   ; check list by '>> gcc -xc++ -E -v -'
;;   (add-to-list 'achead:include-directories '"
;; ./
;; ./include
;; ../include
;; ../../include
;; /usr/include
;; /usr/local/include
;; /usr/include/c++
;; "))
;; (add-hook 'c-mode-common-hook 'my:ac-c-headers-init)

; depends on rtags
(add-hook 'c-mode-common-hook 'rtags-start-process-unless-running)
(add-hook 'c-mode-common-hook
	  '(lambda ()
	    (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
	    (local-set-key (kbd "M-;") 'rtags-find-symbol)
	    (local-set-key (kbd "M-@") 'rtags-find-references)
	    (local-set-key (kbd "M-,") 'rtags-location-stack-back)))

;; ;autoinclude for c++
;; (load "./cpp-auto-include.el")
;; (add-hook 'c++-mode-hook
;;   (lambda()
;;     (add-hook 'write-contents-functions
;;       (lambda()
;;         (save-excursion
;;           (cpp-auto-include)))
;;       nil t)))

;depends on flycheck
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

(require 'c-eldoc)
(add-hook 'c-mode-hook
          '(lambda ()
            (set (make-local-variable 'eldoc-idle-delay) 0.20)
            (c-turn-on-eldoc-mode)
            ))
(setq c-eldoc-buffer-regenerate-time 60)


(require 'irony)
(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++1z")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode))
  )

(require 'flycheck) ; error for
(when (require 'flycheck nil 'noerror)
  (custom-set-variables
   ;; エラーをポップアップで表示
   '(flycheck-display-errors-function
     (lambda (errors)
       (let ((messages (mapcar #'flycheck-error-message errors)))
         (popup-tip (mapconcat 'identity messages "\n")))))
   '(flycheck-display-errors-delay 0.5))
  (define-key flycheck-mode-map (kbd "C-M-n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-M-p") 'flycheck-previous-error)
  (add-hook 'c-mode-common-hook 'flycheck-mode))
(eval-after-load "flycheck"
  '(progn
     (when (locate-library "flycheck-irony")
       (flycheck-irony-setup))))

(add-hook 'c-mode-common-hook
	  '(lambda() ()
	    (c-set-style "stroustrup")
	    (setq indent-tabs-mode nil)     ; インデントは空白文字で行う（TABコードを空白に変換）
	    (c-set-offset 'innamespace 0)   ; namespace {}の中はインデントしない
	    (c-set-offset 'arglist-close 0) ; 関数の引数リストの閉じ括弧はインデントしない
		;not sure below is working correctly
	    (set (make-local-variable 'eldoc-idle-delay) 0.10)
	    (c-turn-on-eldoc-mode)
	    (setq ac-clang-complete-executable "clang-complete")
	    (when (executable-find ac-clang-complete-executable)
		; need to install by hand
	    (require 'auto-complete-clang-async)
	    (setq ac-sources '(ac-source-clang-async))
	    (ac-clang-launch-completion-process))))
