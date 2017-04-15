
(defun cljr--delete-and-extract-sexp ()
  (let* ((beg (point))
         (end (cljr--point-after 'paredit-forward))
         (contents (buffer-substring beg end)))
    (delete-region beg end)
    contents))


;;;###autoload
(defun cljr-cycle-coll ()
  "Convert the coll at (point) from (x) -> {x} -> [x] -> -> #{x} -> (x) recur
See: https://github.com/clojure-emacs/clj-refactor.el/wiki/cljr-cycle-coll"
  (interactive)
  (save-excursion
    (while (and
            (> (point) 1)
            (not (eq (string-to-char "(") (char-after)))
            (not (string= "#{" (buffer-substring (point) (+ 2 (point)))))
            (not (eq (string-to-char "{") (char-after)))
            (not (eq (string-to-char "[") (char-after))))
      (backward-char))

    (cond
     ((eq (string-to-char "(") (char-after))
      (insert "{" (substring (cljr--delete-and-extract-sexp) 1 -1) "}"))

     ((eq (string-to-char "#") (char-after))
      (delete-char 1)
      (insert "(" (substring (cljr--delete-and-extract-sexp) 1 -1) ")"))

     ((eq (string-to-char "{") (char-after))
      (if (not (equal (string-to-char "#") (char-before)))
          (insert "[" (substring (cljr--delete-and-extract-sexp) 1 -1) "]")
        (backward-char)
        (delete-char 1)
        (insert "(" (substring (cljr--delete-and-extract-sexp) 1 -1) ")")))

     ((eq (string-to-char "[") (char-after))
      (insert "#{" (substring (cljr--delete-and-extract-sexp) 1 -1) "}"))

     ((equal 1 (point))
      (error "Beginning of file reached, this was probably a mistake.")))))
