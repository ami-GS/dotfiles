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

(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;対応する括弧に色をつける
(require 'paren)
(show-paren-mode 1)

(when (locate-library "company")
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (global-company-mode)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; (setq company-idle-delay nil) ; 自動補完をしない
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "<tab>") 'company-complete-selection))

(eval-after-load "irony"
  '(progn
     (custom-set-variables '(irony-additional-clang-options '("-std=c++11")))
     (add-to-list 'company-backends 'company-irony)
     (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
     (add-hook 'c-mode-common-hook 'irony-mode)))

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

(require 'highlight-symbol)
(setq highlight-symbol-colors '("RoyalBlue1" "SpringGreen1" "DeepPink1" "OliveDrab"))
(global-set-key (kbd "<f3>") 'highlight-symbol-at-point)
(global-set-key (kbd "ESC <f3>") 'highlight-symbol-remove-all)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)
(color-theme-billw)
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


;;;滑らかスクロール
(require 'smooth-scroll)
(smooth-scroll-mode t)

(require 'go-mode)
(require 'go-autocomplete)
(add-hook 'go-mode-hook
	  '(lambda()
	     (setq c-basic-offset 4)
	     (setq indent-tabs-mode t)
	     (local-set-key (kbd "M-.") 'godef-jump)
	     (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
	     (local-set-key (kbd "C-c i") 'go-goto-imports)
	     (local-set-key (kbd "C-c d") 'godoc)
	     (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
	     (gtags-mode 1)
	     ))
(add-hook 'before-save-hook 'gofmt-before-save)
(add-to-list 'auto-mode-alist '("\\.go$" . go-mode))

(require 'python)
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

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'auto-complete-c-headers)
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
	     (gtags-mode 1)
	     ; not sure below is working correctly
	     (setq ac-clang-complete-executable "clang-complete")
             (when (executable-find ac-clang-complete-executable)
	       ; need to install by hand
	       (require 'auto-complete-clang-async)
	       (setq ac-sources '(ac-source-clang-async))
	       (ac-clang-launch-completion-process))
	     ))
(add-hook 'c-mode-hook 'my:ac-c-headers-init)
(add-hook 'c-mode-hook 'gtags-mode)

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
                      :foreground "RoyalBlue4"
                      :background "RoyalBlue4"
                      :underline nil)
  (set-face-attribute 'whitespace-tab nil
                      :foreground "yellow4"
                      :background "yellow4"
                      :underline nil)
  (set-face-attribute 'whitespace-space nil
                      :foreground "gray40"
                      :background "gray20"
                      :underline nil)
  (global-whitespace-mode t)
  )
