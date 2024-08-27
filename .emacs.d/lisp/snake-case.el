;; https://imakado-2.hatenadiary.org/entry/20091209/1260323922
(defun decamelize (string)
  "Convert CamelCaseString to snake_case_string."
  (let ((case-fold-search nil))
    (downcase
     (replace-regexp-in-string
      "\\([A-Z]+\\)\\([A-Z][a-z]\\)" "\\1_\\2"
      (replace-regexp-in-string
       "\\([a-z\\d]\\)\\([A-Z]\\)" "\\1_\\2"
       string)))))

(defun camelcase-region (s e)
  (interactive "r")
  (let ((buf-str (buffer-substring-no-properties s e))
        (case-fold-search nil))
    (let* ((los (mapcar 'capitalize (split-string buf-str "_" t)))
           (str (mapconcat 'identity los "")))
      (delete-region s e)
      (insert str))))

(defun snakecase-region (s e)
  (interactive "r")
  (let ((buf-str (buffer-substring-no-properties s e))
        (case-fold-search nil))
      (let* ((str (decamelize buf-str)))
        (delete-region s e)
        (insert str))))
