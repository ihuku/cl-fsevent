(defpackage cl-fsevent
  (:use :cl)
  (:import-from :cffi
                :defcfun
                :load-foreign-library 
                :with-foreign-strings 
                :foreign-string-to-lisp)
  (:export :fsevent
           :ok
           :name
           :op
           :chmodp
           :wirtep
           :createp
           :wait-event))

(in-package :cl-fsevent)

(defun split (x str)
  (let ((pos (search x str))
        (size (length x)))
    (if pos
      (cons (subseq str 0 pos)
            (split x (subseq str (+ pos size))))
      (list str))))

(cffi:load-foreign-library
  (asdf:system-relative-pathname
    :cl-fsevent
    (cond ((equal "Darwin" (software-type))
           "lib/darwin/libfsevent.so")
          ((equal "Linux" (software-type))
           "lib/linux/libfsevent.so"))))

(cffi:defcfun "getevent" (:pointer :char)
  (str (:pointer :char)))

(defstruct fsevent
  result name op)

(defun get-event (str)
  (let* ((estr (cffi:foreign-string-to-lisp (getevent str)))
         (e (split ":" estr)))
    (make-fsevent :result (first e)
                  :name   (second e)
                  :op     (third e))))

(defun ok (event)
  (equal "OK" (fsevent-result event)))

(defun name (event)
  (fsevent-name event))

(defun op (event)
  (fsevent-op event))

(defun wait-event (path)
  (cffi:with-foreign-strings ((str path))
    (let ((event (get-event str)))
      event)))
