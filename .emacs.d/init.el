(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/custom")
;automatically install packages
(load "00_install.el")
;default settings which don't need extra packages
(load "05_default.el")
;window settings
(load "10_window.el")
;company
(load "20_complete.el")
;tagging
(load "30_tagging.el")
;languages
(load "40_languages.el")
;helm
(load "50_helm.el")

