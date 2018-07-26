(require 'etags)

(defvar auto-update-etags/update-async-lock (make-mutex "auto-update-etags/update-async-lock"))

(defvar auto-update-etags/update-buffers-queue nil)

(defun auto-update-etags/consume-update-buffers ()
  (when-let ((buffer (pop auto-update-etags/update-buffers-queue)))
    (with-current-buffer buffer
      (let ((-buffer-file-name (buffer-file-name))
            (-tags-file-name tags-file-name))
        (setq -buffer-file-name "/home/jmjoy/works/world/v3/include/easy/easy_order_class.inc.php")
        (setq -tags-file-name "/home/jmjoy/works/TAGS")
        (when (and -buffer-file-name -tags-file-name)
          (let ((tags-file-directory (file-name-directory -tags-file-name)))
            (when (string-prefix-p tags-file-directory -tags-file-name)
              (let ((file-relative-name -buffer-file-name tags-file-directory))
                ))))))))

(defun auto-update-etags/update-buffer ()
  (when (buffer-file-name)
    (push (current-buffer) auto-update-etags/update-buffers-queue)
    (make-thread (lambda ()
                   (with-demoted-errors "Auto update etags error: %s"
                     (with-mutex auto-update-etags/update-async-lock
                       (auto-update-etags/consume-update-buffers)))))))

(define-minor-mode auto-update-etags-mode
  "Update etags TAGS file on save."
  :variable nil
  (if auto-update-etags-mode
      (add-hook 'after-save-hook 'auto-update-etags/update-buffer nil 'local)
    (remove-hook 'after-save-hook 'auto-update-etags/update-buffer 'local))
  (setq tags-revert-without-query t))

(provide 'auto-update-etags)


