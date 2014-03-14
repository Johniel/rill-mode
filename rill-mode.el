;;; rill-mode.el --- Rill major mode

;; Copyright (C) 2014 by

;; Author: ___Johniel
;; Keywords: rill

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defconst rill-mode-version "0.0.1"
  "The version of `rill-mode'.")

(defgroup rill nil
  "A Rill major mode."
  :group 'languages)

(defvar rill-mode-hook nil)

(defcustom rill-tab-width tab-width
  "The tab width to use when indenting."
  :type 'integer
  :group 'rill
  :safe 'integerp)

(add-to-list 'auto-mode-alist '("\\.rill\\'" . rill-mode))

;; Commands

(defun rill-compile-file ()
  (interactive)
  (message "ブーンwブーンw"))

(defvar rill-mode-map
  (let ((map (make-sparse-keymap)))
    ;; key bindings
    (define-key map (kbd "C-S-b") '(lambda () (interactvice) (message "文鳥美味しいです(^q^)")))
    map)
  "Keymap for `rill-mode'.")

;;
;; Define Language Syntax
;;

(defconst rill-def-regexp
  "\\<\\(def\\|class\\|\\)\\s-+\\(\\(?:\\sw\\|\\\\\\|_\\)+\\)?")

(defconst rill-boolean-keywords-regexp
  "\\<\\(true\\|\\<false\\)\\>")

(defconst rill-comment-regexp
  "\\(//.*$\\|/\\*.*\\*/\\)")

(defconst rill-def-var-regexp
  "\\(\\sw*\\)\\s-*:\\s-*\\(\\sw+\\)")

(defconst rill-keywords-regexp
  "\\<\\(return\\|val\\|extern\\|for\\|while\\|if\\|else\\)\\>[^_]")

(defconst rill-font-lock-keywords
  `(
    (,rill-def-regexp (1 font-lock-keyword-face)
                      (2 font-lock-type-face))
    (,rill-boolean-keywords-regexp . font-lock-keyword-face)
    (,rill-def-var-regexp (1 font-lock-variable-name-face)
                          (2 font-lock-type-face))
    (,rill-comment-regexp . font-lock-comment-face)
    (,rill-keywords-regexp . font-lock-keyword-face)
    ))

;;
;; Define Major Mode
;;

(defvar rill-mode-syntax-table
  (let ((st (make-syntax-table)))
    st)
  "Syntax table for `rill-mode'.")

(defvar rill-tab-width 4)

(defun rill-previous-indent ()
  (save-excursion
    (forward-line -1)
    (if (bobp)
        0
      (while (and (looking-at "^[ \t]*$") (not (bobp)))
        (forward-line -1))
      (current-indentation))))

(defsubst rill-insert-spaces (count)
  (insert-char (string-to-char " ") count))

(defun rill-indent-addtional-depth ()
  "1行に if () {} とか {{ みたいなのは知らない"
  (save-excursion
    (* rill-tab-width
       (if (looking-at ".*}.*$")
           -1
         (progn (beginning-of-line)
                (forward-line -1)
                (if (looking-at ".*{.*$") +1 0))))))

(defun rill-indent-line ()
  "Indent current line."
  (interactive)
  (beginning-of-line)
  (when (not (looking-at "[ \t]*$"))
    (while (looking-at "[ \t]")
      (delete-char 1))
    (rill-insert-spaces (+ (rill-indent-addtional-depth)
                           (rill-previous-indent)))))

(define-derived-mode rill-mode prog-mode "Rill"
  "Major mode for editing Rill."
  (setq rill-tab-width 4))

(defun rill-mode ()
  "Major mode for editing Rill"
  (interactive)
  (kill-all-local-variables)
  (set (make-local-variable 'font-lock-defaults) '(rill-font-lock-keywords))
  (set (make-local-variable 'indent-line-function) 'rill-indent-line)
  (set-syntax-table rill-mode-syntax-table)
  (use-local-map rill-mode-map)
  (setq major-mode 'rill-mode)
  (setq mode-name "Rill")
  (run-hooks 'rill-mode-hook))

(provide 'rill-mode)

;;; rill-mode.el ends here
