;;; anagram.el --- Anagram (exercism)

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defun anagrams-for (base candidates)
  "Get anagrams of word BASE from CANDIDATES"
  (let ((candidates (cl-remove-if (lambda (x) (string= x base)) candidates))
        (base (prepare-string base)))
    (cl-remove-if-not
     (lambda (elem) (equal base (prepare-string elem)))
     candidates)))

(defun prepare-string (str)
  "Convert a STR to a usable list"
  (sort (split-string (downcase str) "") #'string<))

(provide 'anagram)
;;; anagram.el ends here
