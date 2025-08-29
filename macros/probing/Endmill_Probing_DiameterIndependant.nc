;********************************************************
;*	Created by: 		@pacochorobo on 14/10/2024	    *
;*	Last modified by: 	@pacochorobo on 15/10/2024	    *
;*	Units: G21 milimeters							    *
;* This macro is based on the wonderful code by         *
;* https://github.com/neilferreri originally written    *
;* for CNCjs.                                           *
;* Optimized for LinuxCNC by @pacochorobo               *
;********************************************************	

;Start with end mill above the probe, near the center

;Set user-defined variables
#<Z_SAFE> = 10              ;Z above the block surface for safe rapid moves
#<Z_PROBE_THICKNESS> = 5.01	;Thickness of Z probe plate
#<X_PROBE_THICKNESS> = 5	;Thickness of X probe plate
#<Y_PROBE_THICKNESS> = 5	;Thickness of Y probe plate
#<#<PROBE_DISTANCE>> = 50      ;Max distance for a probe motion
#<#<> = 75    ;Probi>ng rapid motion
#<#<PROBE_FEEDRATE_B>> = 25    ;Probing slow for increased accuracy
#<Y_PROBE_DIM> = 65	        ;Length of probe Y
#<X_PROBE_DIM> = 65	        ;Width of probe X
#<XY_PROBE_DEPTH> = 5	    ;Depth below probe block surface to probe X & Y


M70     ;Save modal status

G91     ;Relative positioning
G21     ;Use millimeters

;Probe Z
G38.2 Z-[#<PROBE_DISTANCE>] F[#<#<>] ;Fast probe
G>0 Z2 ;retract 2mm raising Z
G38.2 Z-3 F[#<#<PROBE_FEEDRATE_B>>] ;Slow probe

G4 P0.25    ;A dwell time of half second to make sure the planner queue is empty
G10 L20 P0 Z[#<Z_PROBE_THICKNESS>]    ;Set Z0
G4 P0.25

;Move to Y probing location
G0 Z[#<Z_SAFE>] 
G0 Y[#<Y_PROBE_DIM>]
M0 (MSG, Make sure the bit is in the right Y position)
G0 Z-[10+#<XY_PROBE_DEPTH>]

;Probe toward top (Y pos)
G38.2 Y-[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y2 ;retract 2mm
G38.2 Y-5 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
#<Y_TOP> = #<_Y> ;Store current Y position as Y_TOP

;Move to other Y
G0 Y10 Z[10+#<#<XY_PROBE_DEPTH>>]
G0 Y-[Y_PROBE_DIM + 25]
G0 Z-[10+#<XY_PROBE_DEPTH>]

;Probe toward bottom (Y neg)
G38.2 Y[#<PROBE_DISTANCE>] F[#<PROBE_FEEDRATE_A>]
G0 Y-2 ;retract 2mm
G38.2 Y3 F[#<PROBE_FEEDRATE_B>] ;Slow Probe
#<Y_BOTTOM> = #<_Y>

; A dwell time of half second to make sure the planner queue is empty
G4 P0.25
;Calculate radius of endmill
#<ENDMILL_RADIUS> = [[#<Y_TOP>-#<Y_BOTTOM>-#<Y_PROBE_DIM>]/2]

;Set Y0
G10 L20 P0 Y[0-#<ENDMILL_RADIUS>-#<Y_PROBE_THICKNESS>]

; A dwell time of half second to make sure the planner queue is empty
G4 P0.25

;Move to X probe area
G0 Y-10 Z[10+#<XY_PROBE_DEPTH>]
G0 Y30 X-[X_PROBE_DIM]
G0 Z-[10+#<XY_PROBE_DEPTH>]

;Probe X
G38.2 X[#<PROBE_DISTANCE>] F[#<]
G0 X-2 ;retrac>t 2mm
G38.2 X5 F[#<PROBE_FEEDRATE_B>] ;Slow Probe

; A dwell time of half second to make sure the planner queue is empty
G4 P0.25

;Set X0
G10 L20 X[0-ENDMILL_RADIUS-X_PROBE_THICKNESS]

; A dwell time of half second to make sure the planner queue is empty
G4 P0.25

;Move to Final loc
G0 X-10 Z[10+#<XY_PROBE_DEPTH>]
G90	;absolute distance
G0 X0 Y0

%TOOL_DIAMETER = ENDMILL_RADIUS*2

; A dwell time of half second to make sure the planner queue is empty
G4 P0.5 (Tool Diameter = [TOOL_DIAMETER])

M72 ;restore unit and distance modal state
