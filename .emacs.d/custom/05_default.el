
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;;フリンジの色の変更
(set-face-background 'fringe "gray20")
(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "blue4")

;;C-hでbackspace
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "M-h") 'backward-kill-word)
;;警告音をフラッシュに
(setq visible-bell t)
(setq make-backup-files nil)

;;
;(setq-default tab-width 4)

;;; 日本語環境設定
;;(set-language-environment "Japanese")


;;shellのPATH引き継ぎ
(exec-path-from-shell-initialize)

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
		      :foreground "gray40"
		      :underline t)
  (set-face-attribute 'whitespace-space nil
		      :foreground "gray40"
		      :underline nil)
  (global-whitespace-mode t)
  )

;;;カーソルの非選択画面での表示
(setq cursor-in-non-selected-windows nil)

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
