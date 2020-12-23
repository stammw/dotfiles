;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

;;; Examples:

;; Use the latest version.
(package! better-jumper :pin "e25c634f6a")

(package! evil-snipe :disable t)
(package! evil-escape)
(package! adoc-mode)
(package! yasnippet-snippets)
(package! python-black)
(package! groovy-mode)
(package! rg)
(package! jinja2-mode)
(package! string-inflection)
(package! jenkinsfile-mode :recipe
  (:host github
   :repo "john2x/jenkinsfile-mode"
   :branch "master"))
(package! org-bullets)
(package! meson-mode)
(package! bitbake)
