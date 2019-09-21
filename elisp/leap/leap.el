;;; leap.el --- Leap exercise (exercism)

;;; Commentary:

;;; Code:
(defun leap-year-p (year)
  "Determines, whether year should be considered a leap year"
  (cond ((multiple-p year 400) t)
        ((multiple-p year 100) nil)
        ((multiple-p year 4) t)))

(defun multiple-p (numb divisor)
  "Whether the number can be fully divided by divider."
  (equal (mod numb divisor) 0))

(provide 'leap)
;;; leap.el ends here
