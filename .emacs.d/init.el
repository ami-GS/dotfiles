(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse


;;C-hでbackspace
(keyboard-translate ?\C-h ?\C-?)
;;警告音をフラッシュに
(setq visible-bell t)
(setq make-backup-files nil)

;;;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(add-to-list 'ac-dictionary-directories (concat (getenv "HOME") "/.emacs.d/auto-complete/ac-dict"))
(ac-config-default)

(require 'highlight-symbol)
(setq highlight-symbol-colors '("RoyalBlue1" "SpringGreen1" "DeepPink1" "OliveDrab"))
(global-set-key (kbd "<f3>") 'highlight-symbol-at-point)
(global-set-key (kbd "ESC <f3>") 'highlight-symbol-remove-all)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)

;;
;(setq-default tab-width 4)

;;; 日本語環境設定
;;(set-language-environment "Japanese")

;;; 列数の表示
(column-number-mode 1)

;; 行番号表示
(require 'linum)
(global-linum-mode)

;;フリンジの色の変更
(set-face-background 'fringe "gray20")
(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "blue4")

;;load-pathに~/.emacs.dを追加
;(setq load-path (cons (concat (getenv "HOME") "/.emacs.d") load-path))

;;color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)
(color-theme-billw)
;;
(global-hl-line-mode t)
(require 'col-highlight)
(column-highlight-mode t)

;;対応する括弧に色をつける
(require 'paren)
(show-paren-mode 1)


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

;(require 'lua-mode)
;(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
;(require 'flymake-lua)
;(add-hook 'lua-mode-hook 'flymake-lua-load)

;(require 'matlab-mode)
;(add-to-list 'auto-mode-alist '("\\.m$" . matlab-mode))

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
	     ))
(add-hook 'c-mode-hook 'gtags-mode)

(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))
