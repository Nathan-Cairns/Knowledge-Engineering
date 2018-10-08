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

;;;***************
;;;* QUERY RULES *
;;;***************

; All query rules are based on the uses of the 
; yes-or-no-p and ask-question deffunction uses in auto.clp
	   
; Start rule, ask the user if they want to be a professional musician
(defrule determine-instrument-goals ""
   (not (prof-musician ?))
   (not (has-instrumet ?))
   =>
   (assert (prof-musician (yes-or-no-p "Do you want to become a professional musician? (yes/no)? ")))
)

; Determine how serious user is to learn instrument
; Asked if user does not want to be a professional musician
(defrule determine-commitmnet ""
   (prof-musician no)
   (not (instrumet ?))
   =>
   (assert (instrument-commitement
      (ask-question "How committed are you to learning an instrument" (Very/Midly/Not)? "
                    very mildly not))
	)
)

; Determine what instrument user should play based on whether they want calluses or not
; Asked if user is very committed to learning an instrument and does not want to be a professional musician
(defrule determine-instrument-goals ""
   (not (prof-musician ?))
   (not (instrumet ?))
   =>
   (assert (prof-musician (yes-or-no-p "Do you want to become a professional musician? (yes/no)? ")))
)

;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;;********************************

; Print the system banner
; Adapted from auto.clp
(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "What Instrument Should I Learn? Expert System")
  (printout t crlf crlf))

; Print the instrument the user should learn
; Adapted from auto.clp
(defrule print-instrument ""
  (declare (salience 10))
  (instrument ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Instrument to Learn:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))