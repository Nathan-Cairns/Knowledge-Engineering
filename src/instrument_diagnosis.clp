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
; Asked if...
; User does not want to be a professional musician 
; User is very serious about learning an instrument
(defrule determine-callusses ""
   (instrument-commitment very)
   (not (instrumet ?))
   =>
   (assert (callusses (yes-or-no-p "Are you okay with getting callusses? (yes/no)? ")))
)

; Determine whether or not a user is a smoker
; Asked if...
; User does not want to be a professional musician 
; User is mildly serious about learning an instrument
(defrule determine-smoker ""
   (instrument-commitment mildly)
   (not (instrumet ?))
   =>
   (assert (smoker (yes-or-no-p "Are you a smoker? (yes/no)? ")))
)

; Determine whether if the user wants to make noise, does not want to make noise
; or sometimes wants to make noise
; Asked if user does want to be a professional musician
(defrule determine-noise ""
   (prof-musician yes)
   (not (instrumet ?))
   =>
   (assert (noise
      (ask-question "Do you want to make a lot of noise (yes/no/sometimes)? "
                    yes no sometimes))
	)
)

; Determine whether or not the user likes the spotlight
; Asked if...
; User wants to be a professional musician
; User sometimes wants to make a lot of noise
(defrule determine-spotlight ""
   (noise sometimes)
   (not (instrumet ?))
   =>
   (assert (spotlight (yes-or-no-p "Do you like the spotloght? (yes/no)? ")))
)

; Determine whether or not the user can sing
; Asked if...
; User wants to be a professional musician
; User likes to make noise sometimes
; User likes the spotlight
(defrule determine-sing ""
   (spotlight yes)
   (not (instrumet ?))
   =>
   (assert (sing (yes-or-no-p "Can you sing? (yes/no)? ")))
)

; Determine what genre the user likes
; Asked if...
; User wants to be a professional musician
; User wants to make noise sometimes
; User does not like the spotlight
(defrule determine-genre ""
   (spotlight no)
   (not (instrumet ?))
   =>
   (assert (genre
      (ask-question "What genre? (rock/electronic/country)? "
                    rock electronic country))
	)
)

; Determine if user is a team player
; Asked if...
; User wants to be a professional musician
; User wants to make noise sometimes
; User does not like the spotlight
; User likes Rock
(defrule determine-team-player ""
   (genre rock)
   (not (instrumet ?))
   =>
   (assert (team-player (yes-or-no-p "Are you a team player? (yes/no)? ")))
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

; User wants to make a lot of noise reccomend drums
(defrule noise-yes-conclusion ""
   (noise yes)
   (not (instrument ?))
   =>
   (assert (instrument "Drums"))
)

; User does not want to make a lot of noise reccomend keyboard
(defrule noise-no-conclusion ""
   (noise no)
   (not (instrument ?))
   =>
   (assert (instrument "Keyboard"))
)

; User can sing reccomend singing
(defrule sing-yes-conclusion ""
   (sing yes)
   (not (instrument ?))
   =>
   (assert (instrument "Vocals"))
)

; User can't sing reccomend guitar
(defrule sing-no-conclusion ""
   (sing no)
   (not (instrument ?))
   =>
   (assert (instrument "Guitar"))
)

; User likes electronic music reccomend synthesizer
(defrule genre-electronic-conclusion ""
   (genre electronic)
   (not (instrument ?))
   =>
   (assert (instrument "Synthesizer"))
)

; User likes country reccomend acoustic guitar
(defrule genre-country-conclusion ""
   (genre country)
   (not (instrument ?))
   =>
   (assert (instrument "Acoustic Guitar"))
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