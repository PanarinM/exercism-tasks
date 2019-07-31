;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(defun yelled? (input)
  (if
      (not (string= (upcase input) (downcase input)))
      (string= (upcase input) input)
    nil))

(defun yelled-question? (input)
  (and
   (yelled? input)
   (string-suffix-p "?" input)))

(defun simple-question? (input)
  (string-suffix-p "?" input))

(defun silence? (input)
  (eq (string-trim input) ""))

(defun response-for (string)
  (let ((input (string-trim string)))
    (cond
     ((yelled-question? input) "Calm down, I know what I'm doing!")
     ((yelled? input) "Whoa, chill out!")
     ((simple-question? input) "Sure.")
     ((silence? input) "Fine. Be that way!")
     (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here
