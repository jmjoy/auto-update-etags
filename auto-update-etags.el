(defvar-local update-async-lock (make-mutex "update-async-lock"))

(defun auto-update-etags--update-file (file)
  (message file))

(setq file-name "hehhe")

(defun auto-update-etags--update-async ()
  (let ((current-file-name (buffer-file-name)))
    (when current-file-name
      (make-thread (lambda ()
                       (message (format "HEHE2: %s" file-name))
                       ;; (with-mutex update-async-lock
                       ;;   (auto-update-etags--update-file current-file-name))
                       )))))

(define-minor-mode auto-update-etags-mode
  "Update etags TAGS file on save."
  (if auto-update-etags-mode
      (add-hook 'after-save-hook 'auto-update-etags--update-async nil 'local)
    (remove-hook 'after-save-hook 'auto-update-etags--update-async 'local))
  (setq tags-revert-without-query t))

(provide 'auto-update-etags)


