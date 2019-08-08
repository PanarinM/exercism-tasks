;;; bob.el --- Bob exercise (exercism)

;;; Commentary:

;;; Code:

(defun yelled-p (input)
  "Whether string is considered yelled."
  (if
      (not (string= (upcase input) (downcase input)))
      (string= (upcase input) input)
    nil))

(defun yelled-question-p (input)
  "Whether string is a question and yelled."
  (and
   (yelled-p input)
   (string-suffix-p "?" input)))

(defun simple-question-p (input)
  "Whether string is a simple question."
  (string-suffix-p "?" input))

(defun silence-p (input)
  "Whether string is empty."
  (eq (string-trim input) ""))

(defun response-for (string)
  "Generate a Bob response to the string."
  (let ((input (string-trim string)))
    (cond
     ((yelled-question-p input) "Calm down, I know what I'm doing!")
     ((yelled-p input) "Whoa, chill out!")
     ((simple-question-p input) "Sure.")
     ((silence-p input) "Fine. Be that way!")
     (t "Whatever."))))

(provide 'bob)
;;; bob.el ends here
