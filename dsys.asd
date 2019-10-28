(in-package #:asdf-user)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (asdf:load-system "asdf-hacks"))

(defsystem "dsys"
  :defsystem-depends-on ("asdf-hacks")
  :class asdf-hacks:dynamic-system
  :default-component-class asdf-hacks:dynamic-source
  :depends-on ("xxx-cl")
  :components ((:file "heroes")
               (:file "normal")))
