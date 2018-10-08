;;; Header adapted from auto.clp
;;;======================================================
;;;   What Instrument Should I Learn?
;;;
;;;     This expert system informs the user
;;;     what instrument they should learn.
;;;
;;;     To execute, merely load, reset and run.
;;;		
;;;		Author: Nathan Cairns
;;;		upi: ncai762
;;;======================================================

;;****************
;;* DEFFUNCTIONS *
;;****************

; Copied from auto.clp
; Defines a question
(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer
)

; Copied from auto.clp
; Defines a yes or no question
(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no
	)
)
