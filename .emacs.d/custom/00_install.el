; package auto install
(defvar my-favorite-package-list
  '(rtags
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
    yaml-mode
    ; issue? manually
    ;auto-complete-c-header
    golden-ratio
    dockerfile-mode
    helm
    markdown-mode)
  "packages to be installed")
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))
