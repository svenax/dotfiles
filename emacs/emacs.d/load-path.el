;;; load-path.el

(when (featurep 'aquamacs)
  ; Use the standard Emacs path
  (setq user-emacs-directory "~/.emacs.d"))

(defconst user-var-directory
  (expand-file-name "var/" user-emacs-directory))
(defconst user-snippets-directory
  (expand-file-name "snippets/" user-emacs-directory))
(defconst user-lisp-directory
  (expand-file-name "lisp/" user-emacs-directory))
(defconst user-site-lisp-directory
  (expand-file-name "site-lisp/" user-emacs-directory))

(defun add-to-load-path (path &optional dir)
  (let ((dirpath (expand-file-name path (or dir user-emacs-directory))))
    (if (not (equal dirpath user-emacs-directory))
        (setq load-path
              (cons (expand-file-name path (or dir user-emacs-directory)) load-path)))))

;; Add top-level lisp directories, in case they were not setup by the
;; environment.
(dolist (dir (nreverse
              (list user-lisp-directory
                    user-site-lisp-directory)))
  (dolist (entry (nreverse (directory-files-and-attributes dir)))
    (if (cadr entry)
        (add-to-load-path (car entry) dir))))

(mapc #'add-to-load-path
      (nreverse
       (list
        ;user-emacs-directory
        ;; Add other special directories here
        )))

(let ((cl-p load-path))
  (while cl-p
    (setcar cl-p (file-name-as-directory
                  (expand-file-name (car cl-p))))
    (setq cl-p (cdr cl-p))))

(setq load-path (delete-dups load-path))

(provide 'load-path)
