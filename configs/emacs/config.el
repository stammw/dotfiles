;;; .doom.d/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Jean-Christophe BEGUE")
(setq user-mail-address "begue.jc@gmail.com")

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Hide title bar and other decorations
(set-frame-parameter nil 'undecorated t)

;; Apparence
(load-theme 'doom-tomorrow-night t)
(setq display-line-numbers-type nil)
(setq doom-font "FiraCode Nerd Font:pixelsize=14:foundry=CTDB:weight=normal:slant=normal:width=normal:spacing=90:scalable=true")

(after! projectile
  (dolist (item '(".cargo" ".mypy_cache"))
    (add-to-list 'projectile-globally-ignored-directories item)))

(after! forge
  (add-to-list 'forge-alist '("gitlab.fb.int" "gitlab.fb.int/api/v4" "gitlab.fb.int" forge-gitlab-repository)))

;; (add-hook! 'prog-mode #'rainbow-delimiters-mode)

;; Always compile from project root, and save all files
(defun save-all-and-compile ()
  "Automate compile workflow."
  (interactive)
  (save-some-buffers 1)
  (if (get-buffer-process "*compilation*")
      (kill-compilation))
  (projectile-compile-project 'projectile-project-compilation-cmd))

(defun save-all-and-recompile ()
  "Automate compile workflow."
  (interactive)
  (save-some-buffers 1)
  (if (get-buffer-process "*compilation*")
      (kill-compilation))
  (recompile))

(defun rustic-save-all-and-compile ()
  "Automate compile workflow."
  (interactive)
  (save-some-buffers 1)
  (if (get-buffer-process "*compilation*")
      (kill-compilation))
  (rustic-compile))

(defun rustic-save-all-and-recompile ()
  "Automate compile workflow."
  (interactive)
  (save-some-buffers 1)
  (if (get-buffer-process "*compilation*")
      (kill-compilation))
  (rustic-recompile))

(after! evil-escape
  (evil-escape-mode 1)
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-unordered-key-sequence t)
  (setq evil-escape-excluded-major-modes (list 'magit-status-mode 'magit-refs-mode 'magit-log-mode)))

(add-hook! org-mode (org-bullets-mode 1))

(after! org-journal
  (setq org-journal-file-type 'weekly)
  (setq org-journal-dir "/home/jc/Documents/Journal/weeks/")
  (setq org-journal-file-format "%Y%m-%W.org"))

(after! lsp-mode
  (setq lsp-signature-auto-activate nil))

(after! lsp-python-ms
  (setq lsp-python-ms-executable (executable-find "python-language-server")))

;; Lang C / C++
(setq-default ff-search-directories '("." "../src" "../include" "../include/*"))
(add-hook 'cc-mode-hook #'+format|disable-on-save)

;; Documentation
(add-hook! adoc-mode
  (ispell-change-dictionary "fr")
  (add-to-list 'auto-mode-alist '("\\.adoc" . adoc-mode))
  (flyspell-mode t))

(setq rustic-lsp-server 'rust-analyzer)
(add-hook! rustic-mode
  (rainbow-delimiters-mode 1))

(map!
 ;; Window Movements
 "M-h"    #'evil-window-left
 "M-j"    #'evil-window-down
 "M-k"    #'evil-window-up
 "M-l"    #'evil-window-right

 :nv "C-h"    #'beginning-of-line-text
 :nv "C-j"    #'(lambda () (interactive) (next-line 5))
 :nv "C-k"    #'(lambda () (interactive) (previous-line 5))
 :nv "C-l"    #'end-of-line

 :m "<f6>" #'save-all-and-compile
 :m "<f5>" #'save-all-and-recompile
 :i "<f5>" #'(lambda () (interactive) (evil-escape) (save-all-and-recompile))
 :i "<f5>" #'(lambda () (interactive) (evil-escape) (save-all-and-compile))

 (:map compilation-mode-map
   :nv "h" #'evil-backward-char)

 (:after evil-org
   :map evil-org-mode-map
   :n "M-l" #'evil-window-right
   :n "M-h" #'evil-window-left
   :v "M-h" #'outline-demote
   :v "M-h" #'outline-promote)

 (:map c-mode-map
   :m "gh" #'ff-find-other-file)

 (:after rustic
   :map rustic-mode-map
   :m "<f6>" #'rustic-save-all-and-compile
   :m "<f5>" #'rustic-save-all-and-recompile
   :i "<f5>" #'(lambda () (interactive) (evil-escape) (rustic-save-all-and-recompile))
   :i "<f5>" #'(lambda () (interactive) (evil-escape) (rustic-save-all-and-compile)))


 :leader
 :desc "Find file in project"  "SPC"  #'helm-projectile
 :desc "Find file in project"  "k"  #'+popup/raise
 (:prefix "TAB"
   :desc "Next workspace"      "l" #'+workspace/switch-right
   :desc "Previous workspace"  "h" #'+workspace/switch-left)
 (:prefix "t"
   :desc "Treemacs"            "t" #'treemacs-select-window)
 (:prefix "o"
   :desc "Toogle treemacs"     "p" #'+treemacs/toggle)
 (:prefix "w"
  :desc "Ace window"          "w" #'ace-window
  :desc "Ace swap window"     "S" #'ace-swap-window)

 (:prefix "c"
   :desc "Format buffer"          "f" #'lsp-format-buffer
   :desc "Toggle line comment"    "l" #'evilnc-comment-or-uncomment-lines
   :desc "Comment block"          "b" #'comment-region
   :desc "Copy and comment lines" "y" #'evilnc-copy-and-comment-lines))
