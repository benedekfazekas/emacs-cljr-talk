
(defun clojure-delete-and-extract-sexp ()
  "Delete the surrounding sexp and return it."
  (let ((begin (point)))
    (forward-sexp)
    (let ((result (buffer-substring begin (point))))
      (delete-region begin (point))
      result)))

(defun clojure--convert-collection (coll-open coll-close)
  "Convert the collection at (point) by unwrapping it an wrapping it between COLL-OPEN and COLL-CLOSE."
  (save-excursion
    (while (and
            (not (bobp))
            (not (looking-at "(\\|{\\|\\[")))
      (backward-char))
    (when (or (eq ?\# (char-before))
              (eq ?\' (char-before)))
      (delete-char -1))
    (when (and (bobp)
               (not (memq (char-after) '(?\{ ?\( ?\[))))
      (user-error "Beginning of file reached, collection is not found"))
    (insert coll-open (substring (clojure-delete-and-extract-sexp) 1 -1) coll-close)))

;;;###autoload
(defun clojure-convert-collection-to-list ()
  "Convert collection at (point) to list."
  (interactive)
  (clojure--convert-collection "(" ")"))

;;;###autoload
(defun clojure-convert-collection-to-quoted-list ()
  "Convert collection at (point) to quoted list."
  (interactive)
  (clojure--convert-collection "'(" ")"))

;;;###autoload
(defun clojure-convert-collection-to-map ()
  "Convert collection at (point) to map."
  (interactive)
  (clojure--convert-collection "{" "}"))

;;;###autoload
(defun clojure-convert-collection-to-vector ()
  "Convert collection at (point) to vector."
  (interactive)
  (clojure--convert-collection "[" "]"))

;;;###autoload
(defun clojure-convert-collection-to-set ()
  "Convert collection at (point) to set."
  (interactive)
  (clojure--convert-collection "#{" "}"))
