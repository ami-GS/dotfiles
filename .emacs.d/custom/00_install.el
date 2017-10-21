; package auto install
(defvar my-favorite-package-list
  '(rtags
    company-rtags
    irony
    flycheck
    flycheck-rtags
    c-eldoc
    highlight-symbol
    auto-highlight-symbol
    smooth-scroll
    go-eldoc
    go-mode
    company-go
    python
    python-mode
    py-autopep8
    flymake-python-pyflakes
    jedi-core
    yaml-mode
    ; issue? manually
    ;auto-complete-c-header
    ;company-mode
    dockerfile-mode
    helm
    markdown-mode)
  "packages to be installed")
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))
