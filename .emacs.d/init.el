(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;;フリンジの色の変更
(set-face-background 'fringe "gray20")
(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "blue4")

;;C-hでbackspace
(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "M-h") 'backward-kill-word)
;;警告音をフラッシュに
(setq visible-bell t)
(setq make-backup-files nil)

;;
;(setq-default tab-width 4)

;;; 日本語環境設定
;;(set-language-environment "Japanese")


;; 行番号表示
(require 'linum)
(global-linum-mode)

;;; 列数の表示
(column-number-mode 1)

(require 'tramp)
(setq tramp-default-method "ssh")


(defvar my/bg-color "#111111")
(progn
  (require 'whitespace)
  (setq whitespace-style
        '(
          face ; faceで可視化
          trailing ; 行末
          tabs ; タブ
          spaces ; スペース
          space-mark ; 表示のマッピング
          tab-mark
          ))
  (setq whitespace-display-mappings
        '(
          (space-mark ?\u3000 [?\u2423])
          (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])
          ))
  (setq whitespace-trailing-regexp  "\\([ \u00A0]+\\)$")
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-attribute 'whitespace-trailing nil
		      :foreground "DeepPink"
		      :background "DeepPink"
		      :underline t)
  (set-face-attribute 'whitespace-tab nil
;		      :background my/bg-color
		      :foreground "Deeppink"
		      :underline t)
  (set-face-attribute 'whitespace-space nil
		      :foreground "gray40"
		      :underline nil)
  (global-whitespace-mode t)
  )

;;;カーソルの非選択画面での表示
(setq cursor-in-non-selected-windows nil)

(add-to-list 'load-path "/usr/local/share/gtags")
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
	 (local-set-key "\M-t" 'gtags-find-tag)    ; jump to func
	 (local-set-key "\M-r" 'gtags-find-rtag)   ; jump back
	 (local-set-key "\M-s" 'gtags-find-symbol) ; jump to symbol
	 (local-set-key "\C-t" 'gtags-pop-stack)   ; back to prev buff
	 ))

(electric-pair-mode 1)
(setq electric-pair-pairs '(
			    (?\{ . ?\})
			    (?\' . ?\')
			    ))

;;color-theme
(load-theme 'tsdh-dark t)

;;
(global-hl-line-mode t)

;;対応する括弧に@で移動
(global-set-key "@" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
                ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
                (t (self-insert-command (or arg 1)))))

;;対応する括弧に色をつける
(require 'paren)
(show-paren-mode 1)
(setq show-paren-style 'mixed)

(when (locate-library "company")
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 1) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (global-company-mode)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection))
(setq completion-show-help nil)
(setq company-dabbrev-downcase 0)
(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))
(global-set-key [backtab] 'tab-indent-or-complete)

(require 'rtags)
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
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(rtags-start-process-maybe)

(add-hook 'c-mode-common-hook
	  '(lambda ()
	    (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
	    (local-set-key (kbd "M-;") 'rtags-find-symbol)
	    (local-set-key (kbd "M-@") 'rtags-find-references)
	    (local-set-key (kbd "M-,") 'rtags-location-stack-back)))

(require 'irony)
(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++11")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)
     (add-hook 'c++-mode-common-hook 'irony-mode)))

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

; if there is rtagsc
(require 'flycheck-rtags)
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)
(add-hook 'c++-mode-common-hook #'my-flycheck-rtags-setup)

(require 'c-eldoc)
(add-hook 'c-mode-hook
          '(lambda ()
            (set (make-local-variable 'eldoc-idle-delay) 0.20)
            (c-turn-on-eldoc-mode)
            ))
(setq c-eldoc-buffer-regenerate-time 60)

(require 'highlight-symbol)
(setq highlight-symbol-colors '("RoyalBlue1" "SpringGreen1" "DeepPink1" "OliveDrab"))
(global-set-key (kbd "<f3>") 'highlight-symbol-at-point)
(global-set-key (kbd "ESC <f3>") 'highlight-symbol-remove-all)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;;滑らかスクロール
(require 'smooth-scroll)
(smooth-scroll-mode t)

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
(add-hook 'python-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (setq indent-level 4)
	     (setq python-indent 4)
	     (setq tab-width 4)
	     (gtags-mode 1)
	     ))
(setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
(require 'jedi-core)
(setq jedi:complete-on-dot t)
(setq jedi:use-shortcuts t)
(add-hook 'python-mode-hook 'jedi:setup)
(add-to-list 'company-backends 'company-jedi) ; backendに追加

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(defun my:ac-c-headers-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  ; check list by '>> gcc -xc++ -E -v -'
  (add-to-list 'achead:include-directories '"
./
/usr/include
/usr/local/include
/usr/include/c++
"))

(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hh\\'" . c++-mode))
(add-hook 'c++-mode-hook
	  '(lambda()
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
(add-hook 'c-mode-hook 'my:ac-c-headers-init)

(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

(require 'helm)
(helm-mode t)
(global-set-key (kbd "M-x") 'helm-M-x)

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
