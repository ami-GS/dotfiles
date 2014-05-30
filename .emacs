;;load init.el
(load (expand-file-name (concat (getenv "HOME") "/.emacs.d/init")))

;;
(setq-default tab-width 4)

;;; 日本語環境設定
(set-language-environment "Japanese")

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
(setq load-path (cons "~/.emacs.d/python" load-path))

;;color-theme
(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)

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

;; 文字数カウント関数
(defun count-char-region (start end)
  (interactive "r")
  (save-excursion          ;;これと
    (save-restriction ;;これは オマジナイ。 (ちゃんと調べましょう (爆))
      (let ((lf-num 0))          ;;改行文字の個数用、初期化している。
        (goto-char start) ;;指定領域の先頭に行く。
        (while (re-search-forward "[\n\C-m]" end t) ;;改行文字のカウント
          (setq lf-num (+ 1 lf-num))) ;;(つまり、 search できる度に 1 足す)
        (message "%d 文字 (除改行文字) : %d 行 : %d 文字 (含改行文字)"
                 (- end start lf-num) (count-lines start end) (- end start))))))


(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

;;yasnippet
;;(add-to-list 'load-path
;;			 "~/.emacs.d/plugins/yasnippet")
;;(require 'yasnippet)
;;(yas-global-mode 1)

(require 'go-mode-load)
(add-hook 'go-mode-hook
      '(lambda()
         (setq c-basic-offset 4)
         (setq indent-tabs-mode t)
         (local-set-key (kbd "M-.") 'godef-jump)
         (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
         (local-set-key (kbd "C-c i") 'go-goto-imports)
         (local-set-key (kbd "C-c d") 'godoc)
         (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)))

(require 'python)
(require 'jedi)
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(add-hook 'python-mode-hook
		  'jedi:setup
		  (function (lambda ()
					  (setq indent-tabs-mode nil)
					  (setq indent-level 4)
					  (setq python-indent 4)
					  (setq tab-width 4)
					  )))
(setq jedi:complete-on-dot t)

;;js2-mode
(add-to-list 'load-path "~/.emacs.d")
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(eval-after-load "js2"
  '(progn (setq js2-mirror-mode nil)))

(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))
