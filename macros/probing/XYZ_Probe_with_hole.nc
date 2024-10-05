;********************************************************
;*	Created by: 		@pacochorobo on 01/10/2024	    *
;*	Last modified by: 	@pacochorobo on 04/10/2024	    *
;*	Units: G21 milimeters							    *
;* This macro is based on the wonderful code by         *
;* https://github.com/neilferreri originally written    *
;* for CNCjs.                                           *
;* Optimized for LinuxCNC by @pacochorobo               *
;********************************************************	

;Use this macro only with a Z probe plate with a hole in the corner.
;Make sure the bit is aprox at the hole center and below the surface of the touch probe. 
;It is recommended to eye-ball it to the hole center. 
;Please make sure that parameter PROBE_MAJOR_RETRACT plus your biggest bit diameter shouldn't exceed the hole diameter.

; Set user-defined variables
#<Z_PROBE_THICKNESS> = 5.08	;Thickness of the probe plate
#<PROBE_DISTANCE> = 20  ;Max distance for probing. No more than the hole diameter
#<PROBE_FEEDRATE_A> = 75 ;Rapid probe
#<PROBE_FEEDRATE_B> = 25 ;Slow probe to increase precision
#<PROBE_MAJOR_RETRACT> = 5  ;Retract distance after probing one side. This number plus your biggest bit diameter shouldn't exceed the hole diameter.
#<Z_PROBE> = 15	; Lift out of hole and Max Z probe. This number should be at least the probe's lips thickness. Shouldn't be bigger than PROBE_DISTANCE.
#<Z_PROBE_KEEPOUT> = 10	; Distance (X&Y) from edge of hole for Z probe 
#<Z_FINAL> = 50	; Final height above probe.

M70 ;Save modal state
G91 ; Relative positioning
G21 ;Use millimeters

M0 (MSG, Please make sure the bit is positioned inside the hole and the probe is properly connected)

; Probe toward right side of hole with a maximum probe distance
G38.2 X[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 X-2 ;retract 2mm
G38.2 X3 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
#<X_RIGHT> = #<_X>
G0 X-[#<PROBE_MAJOR_RETRACT>]	;Big retract prior probing the other side

; Probe toward left side of hole with a maximum probe distance
G38.2 X-[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 X2 ;retract 2mm
G38.2 X-3 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P.25 ;Pause before storing value
#<X_LEFT> = #<_X>
#<X_CHORD> = #<X_RIGHT> - #<X_LEFT>
G0 X[#<X_CHORD>/2]
; A dwell time of one second to make sure the planner queue is empty
G4 P1
#<X_CENTER> = #<_X>	;get X-value of hole center for some reason
G10 L20 P0 X0 ;set X0 in current WCS

; Probe toward top side of hole with a maximum probe distance
G38.2 Y[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y-2 ;retract 2mm
G38.2 Y3 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
#<Y_TOP> = #<_Y>
G0 Y-[#<PROBE_MAJOR_RETRACT>]	;retract

; Probe toward bottom side of hole with a maximum probe distance
G38.2 Y-[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y2 ;retract 2mm
G38.2 Y-3 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G4 P0.25 ;Pause before storing the value
#<Y_BTM> = #<_Y>
#<Y_CHORD> = #<Y_TOP> - #<Y_BTM>
#<HOLE_RADIUS> = #<Y_CHORD>/2
G0 Y[#<HOLE_RADIUS>]
; A dwell time of one second to make sure the planner queue is empty
G4 P1
#<Y_CENTER> = #<_Y>	;get Y-value of hole center for some reason
G10 L20 P0 Y0

;Raise Z above the plate surface
G0 Z[#<Z_PROBE>]
(DEBUG, Hole radius: #<HOLE_RADIUS>) ;Comment this line if you don't need to display hole radius every time
M0 (MSG, XY completed. Click to proceed with Z Probe)

;Rapid to XY coordinates on the plate surface for Z probe location
G0 X[#<HOLE_RADIUS> + #<Z_PROBE_KEEPOUT>] Y[#<HOLE_RADIUS> + #<Z_PROBE_KEEPOUT>]

; Probe Z
G38.2 Z-[#<Z_PROBE>] F[#<PROBE_FEEDRATE_A>]
G0 Z2 ;retract 2mm
G38.2 Z-5 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
G10 L20 P0 Z[#<Z_PROBE_THICKNESS>]
G0 Z[#<Z_FINAL>]	;raise Z
G90	;absolute distance
G0 X0 Y0
;G0 Z0 ;Comment or uncomment this line depending if you want to go to Z0 or not at the end of the routine

M72 ;restore modal state
;End of macro