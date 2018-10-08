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
   (not (instrumet ?))
   =>
   (assert (prof-musician (yes-or-no-p "Do you want to become a professional musician? (yes/no)? ")))
)

; Determine how serious user is to learn instrument
; Asked if user does not want to be a professional musician
(defrule determine-commitmnet ""
   (prof-musician no)
   (not (instrumet ?))
   =>
   (assert (instrument-commitment
      (ask-question "How committed are you to learning an instrument (very/mildly/not)? "
                    very mildly not))
	)
)

; Determine whether or not a user is okay with getting callusses
; Asked if user does not want to be a professional musician and is very serious about learning an instrument.
(defrule determine-callusses ""
   (instrument-commitment very)
   (not (instrumet ?))
   =>
   (assert (callusses (yes-or-no-p "Are you okay with getting callusses? (yes/no)? ")))
)

; Determine whether or not a user is a smoker
; Asked if user does not want to be a professional musician and is mildly serious about learning an instrument.
(defrule determine-smoker ""
   (instrument-commitment mildly)
   (not (instrumet ?))
   =>
   (assert (smoker (yes-or-no-p "Are you a smoker? (yes/no)? ")))
)

;;;********************
;;;* INSTRUMENT RULES *
;;;********************

; All of the following rules adapted from the repair rules in auto.clp

; User is okay with calluses reccomend guitar
(defrule callusses-yes-conclusion ""
   (callusses yes)
   (not (instrument ?))
   =>
   (assert (instrument "Guitar"))
)

; User is not okay with calluses reccomend piano
(defrule callusses-no-conclusion ""
   (callusses no)
   (not (instrument ?))
   =>
   (assert (instrument "Piano"))
)

; User is a smoker reccomend ukelele
(defrule smoker-yes-conclusion ""
   (smoker yes)
   (not (instrument ?))
   =>
   (assert (instrument "Ukelele"))
)

; User is no a smoker reccomend kazoo
(defrule smoker-no-conclusion ""
   (smoker no)
   (not (instrument ?))
   =>
   (assert (instrument "Kazoo"))
)

; User is not committed to learning an instrument reccomend kazoo
(defrule commitment-not-conclusion ""
   (instrument-commitment not)
   (not (instrument ?))
   =>
   (assert (instrument "Kazoo"))
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
  (printout t "What Instrument Should I Learn? - An Expert System.")
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