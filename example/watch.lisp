(require :cl-fsevent)

(defun start-watching (path-to-file-or-directory)
  (sb-thread:make-thread
    (lambda ()
      (format t "watching ~A ...~%" path-to-file-or-directory)
      (loop
        (let ((event (cl-fsevent:wait-event path-to-file-or-directory)))
          (cond ((cl-fsevent:ok event)
                 (format t "File => ~A, Event => ~A~%"
                         (cl-fsevent:name event)
                         (cl-fsevent:op event)))
                (t
                 (format t "Error: ~A~%" event)
                 (format t "exit watching ...~%")
                 (return))))))))

;; (start-watching "path-to-file-or-dir")
