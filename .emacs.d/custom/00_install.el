; package auto install
(defvar my-favorite-package-list
  '(exec-path-from-shell
    rtags
    company
    company-go
    company-irony
    company-rtags
    company-c-headers
    irony
    git-gutter
    flycheck
    flycheck-rtags
    c-eldoc
    highlight-symbol
    auto-highlight-symbol
    smooth-scroll
    go-eldoc
    go-mode
    python
    python-mode
    py-autopep8
    flymake-python-pyflakes
    jedi-core
    company-jedi
    rust-mode
    racer
    flycheck-rust
    company-racer
    yaml-mode
    ; issue? manually
    ;auto-complete-c-header
    golden-ratio
    dockerfile-mode
    helm
    helm-gtags
    markdown-mode
    origami)
  "packages to be installed")
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))

(defun download_another_packages ()
  (interactive)
  (shell-command-to-string "git clone https://github.com/syohex/emacs-cpp-auto-include $HOME/.emacs.d/custom/emacs-cpp-auto-include && cp $HOME/.emacs.d/custom/emacs-cpp-auto-include/cpp-auto-include.el  $HOME/.emacs.d/custom/cpp-auto-include.el"))

(if (file-exists-p "$HOME/.emacs.d/custom/cpp-auto-include.el")
    nil
    (download_another_packages)
)
