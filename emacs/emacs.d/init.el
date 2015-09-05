;;; init.el --- svenax' init emacs file
;;;
;;; Commentary:
;;; This is my init file. There are many init files like it,
;;; but this one is mine.
;;;
;;; This file is my entire Emacs configuration, except for some small use of
;;; custom.el. It depends heavily on `use-package' by John Wiegley.

;;; Code:

;;;_* Startup

(defconst emacs-start-time (current-time))

(unless noninteractive
  (message "Loading %s..." load-file-name))

;; Turn off stuff I don't like ...
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No silly messages at startup
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

;;;_* Load paths and customizations

(load (expand-file-name "load-path" (file-name-directory load-file-name)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;;;_* Setup packages

(require 'use-package)
(use-package package
  :init (progn (add-to-list 'package-archives
                            '("melpa" . "http://melpa.milkbox.net/packages/") t)
               (package-initialize)))

;;;_** Package configuration
(use-package ace-jump-mode
  :ensure ace-jump-mode
  :init (setq ace-jump-mode-scope 'window)
  :bind (("C-\\" . ace-jump-mode)
         ("C-|" . ace-jump-char-mode)))
(use-package auto-complete-config
  :ensure auto-complete
  :diminish auto-complete-mode
  :init (progn (ac-config-default)
               (setq ac-comphist-file (expand-file-name "ac-comphist.dat" user-var-directory))))
(use-package emmet-mode
  :ensure emmet-mode
  :init (progn (add-hook 'sgml-mode-hook 'emmet-mode)
               (add-hook 'html-mode-hook 'emmet-mode)
               (add-hook 'css-mode-hook  'emmet-mode)))
(use-package expand-region
  :ensure expand-region
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))
(use-package fuzzy-match
  :ensure fuzzy-match)
(use-package highlight-symbol
  :ensure highlight-symbol
  :bind (("C-, h" . highlight-symbol-at-point)
         ("C-, n" . highlight-symbol-next)
         ("C-, p" . highlight-symbol-prev)
         ("C-, f" . highlight-symbol-query-replace)
         ("C-, r" . highlight-symbol-remove-all)))
(use-package ido
  :init (ido-mode t))
(use-package ido-ubiquitous
  :ensure ido-ubiquitous)
(use-package js2-mode
  :ensure js2-mode
  :init (add-to-list 'auto-mode-alist '("\\.js\\(x\\|xinc\\)?\\'" . js2-mode)))
(use-package js2-refactor
  :ensure js2-refactor)
(use-package markdown-mode
  :ensure markdown-mode
  :mode ("\\.\\(txt\\|markdown\\|md\\)\\'" . markdown-mode))
(use-package move-text
  :ensure move-text
  :init (move-text-default-bindings))
(use-package multiple-cursors
  :ensure multiple-cursors
  :bind (("C-c C-C" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-c c c" . mc/edit-lines)
         ("C-c c e" . mc/edit-ends-of-lines)
         ("C-c c a" . mc/edit-beginnings-of-lines)
         ("C-c c d" . mc/mark-all-dwim)))
(use-package php-mode
  :ensure php-mode
  :mode ("\\.\\(php\\|phtml\\)\\'" . php-mode))
(use-package powerline
  :ensure powerline
  :init (powerline-default-theme))
(use-package projectile
  :ensure projectile
  :init (progn (projectile-global-mode t)
               (setq projectile-cache-file
                     (expand-file-name "projectile.cache" user-var-directory))
               (setq projectile-known-projects-file
                     (expand-file-name "projectile-bookmarks.eld" user-var-directory))
               (setq projectile-completion-system 'default)))
(use-package smartparens-config
  :ensure smartparens
  :init (smartparens-global-mode t))
(use-package smart-mode-line
  :ensure smart-mode-line
  :init (progn (setq sml/theme 'light)
               (setq sml/name-width 32)
               (setq sml/mode-width 'full)
               (setq sml/col-number-format "%c")
               (setq sml/line-number-format "%l")
               (add-to-list 'sml/replacer-regexp-list '("^:Work:webarch-desktop/" ":WD:"))
               (add-to-list 'sml/replacer-regexp-list '("^/Sources/Work/" ":Work:"))
               (sml/setup)))
(use-package smex
  :ensure smex
  :init (smex-initialize)
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))
(use-package string-inflection
  :ensure string-inflection
  :bind ("C-, C-u" . string-inflection-cycle))
(use-package whole-line-or-region
  :ensure whole-line-or-region)
(use-package yasnippet
  :ensure yasnippet
  ; No need to set `yas-snippets-dir', the defaults are good for now
  :diminish yas-minor-mode
  :init (yas-global-mode 1))

;;;_** Mode mappings and hooks

;; Adobe Extend Script

(add-hook 'html-mode-hook #'(lambda nil (setq sgml-mode t)))

;;;_** Functions
(defun sa-query-replace ()
  "Go to the top of the buffer, then execute `query-replace'."
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (call-interactively 'query-replace)))

(defun sa-replace-string ()
  "Go to the top of the buffer, then execute `replace-string'."
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (call-interactively 'replace-string)))

(defun sa-remove-line-breaks ()
  "Remove line endings in current paragraph."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun sa-join-lines ()
  "Join the current line with the line beneath it."
  (interactive)
  (delete-indentation 1))

(defun sa-kill-whole-line (&optional arg)
  "A simple wrapper around command `kill-whole-line' that respects indentation."
  (interactive "p")
  (kill-whole-line arg)
  (back-to-indentation))

(defun sa-smart-open-line-above ()
  "Insert an empty line above the current line."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun sa-smart-open-line (arg)
  "Insert an empty line after the current line."
  (interactive "P")
  (if arg
      (sa-smart-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))

(defun sa-pad-line-ending ()
  "Pad out the line with the last character."
  (interactive)
  (end-of-line)
  (let ((f (symbol-value 'fill-column)))
    (insert-char (char-before) f)
    (move-to-column f)
    (kill-line)))

(defun sa-clean-elpa-readme ()
  "Remove downloaded readme files from the elpa directory."
  (interactive)
  (let ((files (file-expand-wildcards "~/.emacs.d/elpa/*.txt")))
    (while files
      (delete-file (car files) t)
      (setq files (cdr files)))))

(defun duplicate-region (beg end)
  "Insert a copy of the region between BEG and END after the region."
  (interactive "r")
  (save-excursion
    (goto-char end)
    (insert (buffer-substring beg end))))

(defun duplicate-line-or-region (prefix)
  "Duplicate either the current line or any current region."
  (interactive "*p")
  (whole-line-or-region-call-with-region 'duplicate-region prefix t))

(defun swap-window-positions ()         ; Stephen Gildea
   "*Swap the positions of this window and the next one."
   (interactive)
   (let ((other-window (next-window (selected-window) 'no-minibuf)))
     (let ((other-window-buffer (window-buffer other-window))
           (other-window-hscroll (window-hscroll other-window))
           (other-window-point (window-point other-window))
           (other-window-start (window-start other-window)))
       (set-window-buffer other-window (current-buffer))
       (set-window-hscroll other-window (window-hscroll (selected-window)))
       (set-window-point other-window (point))
       (set-window-start other-window (window-start (selected-window)))
       (set-window-buffer (selected-window) other-window-buffer)
       (set-window-hscroll (selected-window) other-window-hscroll)
       (set-window-point (selected-window) other-window-point)
       (set-window-start (selected-window) other-window-start))
     (select-window other-window)))

;;;_** Defaults and such
(put 'dired-find-alternate-file 'disabled nil)
(setq user-full-name "Sven Axelsson"
      user-mail-address "sven@textalk.se"
      desktop-dirname user-var-directory
      desktop-path (list desktop-dirname)
      desktop-basefilename "emacs-desktop")
(setq tramp-debug-buffer nil)
(setq whitespace-display-mappings
      '((space-mark 32 [183] [46])
        (newline-mark 10 [8629 10])
        (tab-mark 9 [9655 9] [92 9])))

;;;_** Key bindings
(global-unset-key (kbd "C-x C-z"))
(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-x C-n"))

(bind-key "A-d" 'duplicate-line-or-region)
(bind-key "A-j" 'sa-join-lines)
(bind-key "A-k" 'sa-kill-whole-line)
(bind-key "A-<RET>" 'sa-smart-open-line)

(bind-key "RET" 'newline-and-indent)
(bind-key "M-<SPC>" 'cycle-spacing)

(bind-key "C-, M-%" 'sa-query-replace)
(bind-key "C-, C-%" 'sa-replace-string)
(bind-key "C-, p" 'sa-pad-line-ending)
(bind-key "C-, s" 'swap-window-positions)
(bind-key "C-, o" 'ff-find-other-file)

;;;_* Post initialization

(load-theme 'solarized-light)
(server-start)

(when window-system
  (let ((elapsed (float-time (time-subtract (current-time)
                                            emacs-start-time))))
    (message "Loading %s...done (%.3fs)" load-file-name elapsed))
  (add-hook 'after-init-hook
            `(lambda ()
               (let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
                 (message "Loading %s...done (%.3fs) [after-init]" ,load-file-name elapsed)))
            t))

;; Local Variables:
;;   mode: emacs-lisp
;;   mode: allout
;;   outline-regexp: "^;;;\\([*]+\\)"
;; End:

;;; init.el ends here
