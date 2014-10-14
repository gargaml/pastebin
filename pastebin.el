(defun build-data (code language)
  (let ((xs `(("api_dev_key" . "b6b08f6fe01257141dedc8879d32eb63")
	      ("api_option" . "paste")
	      ("api_paste_code" . ,code)
	      ("api_paste_format" . ,language))))
    (mapconcat (lambda (x)
		 (let ((k (url-hexify-string (car x)))
		       (a (url-hexify-string (cdr x))))
		   (concat k "=" a)))
	       xs
	       "&")))

(defun process-request (url data)
  (let ((url-request-method "POST")
	(url-request-extra-headers '(("Content-type" . "application/x-www-form-urlencoded")))
	(url-request-data data))
    (let* ((b (url-retrieve-synchronously url)))
      (switch-to-buffer b)
      (let* ((s (line-beginning-position))
	     (e (line-end-position))
	     (url (buffer-substring-no-properties s e)))
	(x-select-text url)
	(switch-to-buffer (previous-buffer))))))

(defun pastebin (code language)
  (let* ((d (build-data code language)))
    (process-request "http://pastebin.com/api/api_post.php" d)))
    

(defun pastebin-region (start end)
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list s (point-min) (point-max))))
  (let ((code (buffer-substring-no-properties start end))
	(language (read-string "language: ")))
    (pastebin code language)))


