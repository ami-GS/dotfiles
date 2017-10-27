; package auto install
(require 'cl)
(defvar installing-package-list
  '(
    rtags
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
    golden-ratio
    ; issue? manually
    ac-c-headers
    company
    dockerfile-mode
    helm
    markdown-mode
    ))
(let ((not-installed (loop for x in installing-package-list
			   when (not (package-installed-p x))
			   collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))
