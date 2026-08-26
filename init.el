;; Emiliano Grilli's Emacs configuration

;; Vanilla emacs section (init.el):
;; it shoud work without requiring any external package
;; tested on emacs 30.1 on debian 13 trixie

;; Setting some variables
(setq
  Man-notify-method 'aggressive
  auto-revert-verbose t
  auto-save-default nil
  create-lockfiles nil
  desktop-save t
  help-window-select t
  inhibit-splash-screen t
  initial-scratch-message nil
  lisp-indent-offset 2
  make-backup-files nil
  ring-bell-function 'ignore
  shell-kill-buffer-on-exit t
  use-short-answers t
  visible-bell t)

(setq-default
  indent-tabs-mode nil
  tab-width 4)

(set-default indent-line-function 'insert-tab)

;; send customizations away from init.el (prot)
(setq custom-file (make-temp-file "emacs-custom-"))

;; Minor modes
(auto-save-visited-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(desktop-save-mode 1)
(electric-indent-mode 1)
(electric-pair-mode 1)
(fido-vertical-mode -1)
(global-auto-revert-mode 1)
(global-completion-preview-mode 1)
(global-visual-line-mode 1)
(menu-bar-mode -1)
(recentf-mode 1)
(repeat-mode 1)
(scroll-bar-mode -1)
(size-indication-mode 1)
(tool-bar-mode -1)
(tooltip-mode -1)
(which-key-mode 1)

;; Electric pair also for backtick
(setq electric-pair-pairs
  (quote
    ((34 . 34)
      (8216 . 8217)
      (8220 . 8221)
      (96 . 96))))

;; Theme
(setq modus-themes-headings
  '((1 . (variable-pitch 1.8))
     (2 . (1.5))
     (agenda-date . (1.5))
     (agenda-structure . (variable-pitch light 1.8))
     (t . (1.3))))
(setq modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))

(load-theme 'modus-vivendi-tinted t)

;; Font
(set-frame-font "Hack-15")
(set-face-attribute 'default t :font "Hack-15")
(add-to-list 'default-frame-alist '(font . "Hack-15" ))

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq frame-title-format
  '(:eval (format "Emacs - %s  [ %s ]"
            (buffer-name)
            last-command))
  icon-title-format t)

;; Windmove
(defun windmove-prefix ()
  (interactive)
  (set-transient-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "<left>") 'windmove-left)
      (define-key map (kbd "<right>") 'windmove-right)
      (define-key map (kbd "<up>") 'windmove-up)
      (define-key map (kbd "<down>") 'windmove-down) map)
    t nil "Repeat with %k"))

(define-key (current-global-map) (kbd "C-x w m") 'windmove-prefix)

(defun windmove-swap-prefix ()
  (interactive)
  (set-transient-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "<left>") 'windmove-swap-states-left)
      (define-key map (kbd "<right>") 'windmove-swap-states-right)
      (define-key map (kbd "<up>") 'windmove-swap-states-up)
      (define-key map (kbd "<down>") 'windmove-swap-states-down) map)
    nil))

(define-key (current-global-map) (kbd "C-x w p") 'windmove-swap-prefix)

;; Key bindings
(global-set-key (kbd "C-;") 'comment-line)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key [remap dabbrev-expand] 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-+") 'mark-word)
(global-set-key (kbd "<f8>") 'mode-line-other-buffer)
(global-set-key (kbd "C-c d") 'duplicate-dwim)

;; Save history
(use-package savehist
  :ensure nil
  :hook  (after-init . savehist-mode))

;; Org mode
(use-package org
  :ensure nil
  :defer t
  :config
  (org-babel-do-load-languages
    'org-babel-load-languages
    '((shell . t)
       (emacs-lisp . t)
       (python . t)
       (js . t)
       (sqlite . t)
       (restclient . t)
       (makefile . t)
       (C . t)
       (sql . t)))
  (setq
    org-agenda-include-diary t
    org-confirm-babel-evaluate nil
    org-ctrl-k-protect-subtree t
    org-cycle-separator-lines 0
    org-ellipsis " ⤵"
    org-hide-emphasis-markers t
    org-log-done 'time
    org-startup-indented t
    org-startup-folded 'showall
    org-directory "~/Documenti/org")
  ; man pages should be linkable!
  (require 'ol-man) 
  :mode ("\\.org\\'" . org-mode)
  :bind
  ("C-c l" . org-store-link)
  ("C-c C-o" . org-open-at-point-global)
  ("C-x C-a" . org-agenda))

(defun mil-org-file-link (basedir)
  (let ((file (read-file-name
                "File da linkare: " basedir)))
    (concat "[[file:" file "]]")))

(defun mil-midish-song-org-link ()
  (mil-org-file-link "~/Documenti/Musica/MidishSongs/"))

(defun mil-markdown-to-org-region (start end)
  "Convert Markdown formatted text in region (START, END) to Org.

This command requires that pandoc (man page `pandoc(1)') be
installed."
  (interactive "r")
  (shell-command-on-region
   start end
   "pandoc -f markdown -t org --wrap=preserve" t t))

(use-package org-capture
  :ensure nil
  :bind ("C-c c" . org-capture)
  :custom
  (org-capture-templates
    '(("x" "x selection" entry
      (file+olp+datetree "~/Documenti/org/reference.org")
      "* %?\n                 Entered on %U\n                 %x"
      :empty-lines-after 1 :unnarrowed t)
     ("e" "evento" entry (file "~/Documenti/org/emi.org") "* %? %T"
       :empty-lines-after 1)
     ("m" "MIDI")
     ("mr" "MIDI recording" entry
       (file+olp+datetree
         "~/Documenti/org/zettel/20250424122012-midi_multitrack_recording.org"
         "Instances")
       "** %^{Nome della sessione}\n- Key: %^{Tonalità}\n- Note: %^{Note}\n- Position: %(mil-midish-song-org-link)\n %?")
     ("p" "Protocol" entry
       (file+olp+datetree "~/Documenti/org/reference.org")
       "* %^{Title}\nSource: %u, %:link\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
     ("L" "Protocol Link" entry
       (file+olp+datetree "~/Documenti/org/reference.org")
       "* [[%:link][%:description]] \nCaptured On: %U\n%?"))))

;; Italian calendar names
(setq calendar-week-start-day 1
  calendar-day-name-array ["Domenica" "Lunedì" "Martedì" "Mercoledì"
                            "Giovedì" "Venerdì" "Sabato"]
  calendar-day-abbrev-array ["Dom" "Lun" "Mar" "Mer" "Gio" "Ven" "Sab"]
  calendar-day-header-array ["Do" "Lu" "Ma" "Me" "Gi" "Ve" "Sa"]
  calendar-month-name-array ["Gennaio" "Febbraio" "Marzo" "Aprile"
                              "Maggio" "Giugno" "Luglio" "Agosto"
                              "Settembre" "Ottobre" "Novembre"
                              "Dicembre"]
  calendar-month-abbrev-array ["Gen" "Feb" "Mar" "Apr" "Mag"
                                "Giu" "Lug" "Ago"
                                "Set" "Ott" "Nov" "Dic"]
  calendar-date-style 'european)

;; Italian Holidays
(setq holiday-general-holidays
  '((holiday-fixed 1 1 "Capodanno")
     (holiday-fixed 5 1 "Festa dei lavoratori")
     (holiday-fixed 4 25 "Festa della liberazione")
     (holiday-fixed 6 2 "Festa della repubblica")
     ))

(setq holiday-christian-holidays
  '((holiday-fixed 12 8 "Immacolata concezione")
     (holiday-fixed 12 25 "Natale")
     (holiday-fixed 12 26 "Santo Stefano")
     (holiday-fixed 1 6 "Epifania")
     (holiday-easter-etc -52 "Giovedì grasso")
     (holiday-easter-etc -47 "Martedì grasso")
     (holiday-easter-etc  -2 "Venerdì Santo")
     (holiday-easter-etc   0 "Pasqua")
     (holiday-easter-etc  +1 "Lunedì di Pasqua")
     (holiday-fixed 8 15 "Assunzione di Maria")
     (holiday-fixed 11 1 "Ognissanti")))

(setq calendar-holidays
  (append holiday-christian-holidays holiday-general-holidays))

;; Disable other holidays
(setq hebrew-holidays nil)
(setq islamic-holidays nil)
(setq oriental-holidays nil)
(setq general-holidays nil)

;; Other calendar/diary goodies
(setq cal-tex-diary t)
(setq calendar-mark-diary-entries-flag t)
(setq calendar-mark-holidays-flag t)

;; Custom toggles
(defun mil/toggle-line-numbers (args)
  "toggles display-line-numbers-mode"
  (interactive "P")
  (if (bound-and-true-p display-line-numbers-mode)
    (display-line-numbers-mode -1)
    (display-line-numbers-mode 1)))

(defun mil/toggle-whitespace (args)
  "toggles whitespace-mode"
  (interactive "P")
  (if (bound-and-true-p whitespace-mode)
    (whitespace-mode -1)
    (whitespace-mode 1)))

(defun mil/toggle-visual-line-mode (args)
  "toggles visual-line-mode"
  (interactive "P")
  (if(bound-and-true-p visual-line-mode)
    (visual-line-mode -1)
    (visual-line-mode 1)))

(global-set-key (kbd "<f12>") 'mil/toggle-line-numbers)
(global-set-key (kbd "S-<f12>") 'mil/toggle-whitespace)
(global-set-key (kbd "C-<f12>") 'mil/toggle-visual-line-mode)

;; Loads the section of the configuration dedicated to emacs packages
;; available in debian, comment the next line for disabling it.
(load-file (locate-user-emacs-file "provided-by-debian.el"))

(when
  (file-exists-p "~/private/init.el")
  (load "~/private/init.el"))
