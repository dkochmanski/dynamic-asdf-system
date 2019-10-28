(defpackage #:asdf-hacks
  (:use #:cl)
  (:export #:dynamic-system
           #:dynamic-source
           #:*whoosh*))
(in-package #:asdf-hacks)

(defparameter *whoosh* t)

(defclass dynamic-system (asdf:system) ())
(defclass dynamic-source (asdf:cl-source-file) ())

(defmethod asdf:component-depends-on :around (operation (system dynamic-system))
  (mapcar (lambda (dependency)
            (destructuring-bind (op &rest deps) dependency
              (list* op (mapcar
                         (lambda (dep)
                           ;; DEP may be something like (:version
                           ;; "flexichain" "1.5.1"), (:require "foo")
                           ;; and god knows what else - please send
                           ;; complaints to Fare.
                           (let ((string-dep (ignore-errors (asdf:coerce-name dep))))
                             (if (and string-dep
                                      (>= (length string-dep) 4)
                                      (string-equal string-dep "xxx-" :end1 4 :end2 4))
                                 (concatenate 'string
                                              (case *whoosh*
                                                ((t)       "host-")
                                                ((nil)     "native-")
                                                (otherwise (error "whoosh!")))
                                              (subseq string-dep 4))
                                 ;; If we can't parse a dependency or
                                 ;; it doesn't start with "xxx-"
                                 ;; return it verbatim.
                                 dep)))
                         deps))))
          (call-next-method)))

(defmethod asdf:component-pathname ((component dynamic-source))
  (let ((pathname (call-next-method)))
    (if (string= (pathname-name pathname) "heroes")
        (make-pathname :name (case *whoosh*
                               ((t)       "might")
                               ((nil)     "magic")
                               (otherwise (error "whoosh!")))
                       :defaults pathname)
        pathname)))
