(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa" . "https://melpa.org/packages/")))

(setq treesit-language-source-alist
  '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.0.2")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (setq ef-themes-headings
    '((1 semibold  variable-pitch 1.6)
       (2 regular 1.4)
       (3 regular 1.3)
       (agenda-date 1.4)
       (agenda-structure variable-pitch light 1.6)
       (t variable-pitch))))

(use-package org-journal
  :ensure t
  :after org
  :pin nongnu
  :custom
  (org-journal-dir (concat (file-name-as-directory org-directory) "journal"))
  (org-journal-file-type 'yearly)
  (org-journal-file-format "%Y.org")
  (org-journal-date-format "%A, %d-%m-%Y")
  (org-journal-encrypt-journal nil)
  (org-journal-enable-encryption nil)
  (org-journal-enable-agenda-integration t)
  (org-extend-today-until 4)
  :bind
  ("C-c j" . org-journal-new-entry))

(with-eval-after-load 'org-journal
  (remove-hook 'calendar-today-visible-hook 'org-journal-mark-entries)
  (remove-hook 'calendar-today-invisible-hook 'org-journal-mark-entries))

(use-package restclient
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode))
  (add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode)))

(use-package ob-restclient
  :ensure t)

(use-package multiple-cursors
  :ensure t
  :pin nongnu
  :init
  (defun multiple-cursors-prefix ()
    (interactive)
    (set-transient-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "n") 'mc/mark-next-like-this)
        (define-key map (kbd "p") 'mc/mark-previous-like-this)
        (define-key map (kbd "a") 'mc/mark-all-like-this) map)
      t nil "Repeat with %k"))

  (define-key (current-global-map) (kbd "C-x n") 'multiple-cursors-prefix)

  :bind
  (("C-c u" . mc/edit-lines)))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package scratch
  :ensure t
  :bind (("C-c s" . scratch)))

(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-define-keys)
  (add-to-list 'drag-stuff-except-modes 'org-mode)
  :hook (after-init . drag-stuff-global-mode))

(use-package string-inflection
  :ensure t    
  :bind
  ("C-c i" . string-inflection-all-cycle))

(use-package chordpro-mode
  :ensure t
  :mode "\\.cho\\'")

(use-package abc-mode
  :ensure t
  :mode "\\.abc\\'")
