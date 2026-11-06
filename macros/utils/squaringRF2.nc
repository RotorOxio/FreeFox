;****************************************************
;*	Created by: 		@pacochorobo on 03/10/2025	*
;*	Last modified by: 	@pacochorobo on 03/10/2025	*
;*	Units: G21 milimeters							*
;*  Squaring wizard for RedFox2 CNC machine			*
;****************************************************	

;Simple macro is designed to help squaring the RedFox2 CNC machine.
;Using trigonometry over a triangle defined like:
;A side of the triangle: X axis
;B side of the triangle: Y axis
;C hypothenuse of the triangle

#<X_DISTANCE> = 600 		;Side A of the triangle
#<Y_DISTANCE> = 800 		;10mm of the probe plate side thickness + 3mm of endmill radius
#<EXPECTED_HYP> = 1000		;Set this value as the expected hypothenuse for a perfect squared machine
#<CALCULATED_HYP> = 0		;Real calculated hypothenuse


M70 ;Save modal state
G21 G91 ;Set units to mm and activate relative mode
M5 	;STOP SPINDLE, for safety reasons

M0 (MSG, Please mark the current location as the ORIGIN)
M0 (DEBUG, Please make sure the X axis will be able to travel #<X_DISTANCE> mm)
G0 X[#<X_DISTANCE>]
M0 (MSG, Please mark the current location A)
M0 (DEBUG, Please make sure the Y axis will be able to travel #<Y_DISTANCE> mm)
G0 Y[#<Y_DISTANCE>]
M0 (MSG, Please mark the current location B)
M0 (DEBUG, Please make sure the distance between ORIGIN and B is #<EXPECTED_HYP> mm)

M72
M2


