;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 27/9/2024	*
;*	Units: G21 milimeters							*
;****************************************************	

;Macro for parking the machine at rapid speed at specific G53 coordinates
;Useful to park closer to the homing position before powering off the machine to speed up the start up on next power on
;Can be used also to position the machine at a specific point for manual tool changes, dust shoe access and many other cases;

; >>> Parameters XPreHome YPreHome and ZPreHome are the XYZ coordinates for the parking position in the G53 machine coordinate system

#<XPreHome> = 10
#<YPreHome> = 1090
#<ZPreHome> = 145

M5 ;Make sure spindle is off
G90 G21 ;Metric absolute for safety and good practices
G53 G0 Z[#<ZPreHome>] ;Move Z first
M0 (MSG,Ready to park. Make sure path is cleared. Click continue to proceed)
G53 G0 X[#<XPreHome>] Y[#<YPreHome>] ;Move XY

M2 ;End of program