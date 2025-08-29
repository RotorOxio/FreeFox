;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 29/08/2025	*
;*	Units: G21 milimeters							*
;****************************************************	

;********************** WARINING ************************
;Use this macro WITH NORMALLY OPEN DEVICES ONLY		*
;********************************************************

;Macro for semi automated tool changes. USE IT ONLY WITH NORMALLY OPEN probes or toolsetters.
;USES THE CURRENT TOOL POSITION TO TOUCH THE THE TOOL SETTER, THAT MUST BE POSITIONED JUST BELOW. Calculates the Z offset between the current tool and the new tools and applies it to the current WCS.

; User-defined variables
#<SAFE_HEIGHT> = 145	;Z position in machine coordinates to raise the spindle. Make sure it is a safe height in machine coordinates

;Toolsetter or probe location.X AND Y NOT USED IN THIS VERSION OF THE Macro
#<TOOL_PROBE_Z> = 75 ;Z coordinate in G53 for the toolsetter location. Use your LONGEST tool as a reference to calculate this value.

#<PROBE_DISTANCE> = 50 ;Max distance in Z axis from the tip of tool to the toolsetter surface. Recommended to use your SHORTEST bit as a reference to define this value
#<PROBE_RAPID_FEEDRATE> = 75 ;Rapid feed rate when probing in mm/min

; Keep a backup of current work position JUST IN CASE
#<X0> = #<_X>
#<Y0> = #<_Y>
#<Z0> = #<_Z>

M70	;Save modal state
G21 ;Enter metric mode
M5  ;Stop spindle for safety reasons
G90	;Absolute positioning

G53 G0 Z[#<SAFE_HEIGHT>] ;Raise Z first for safety
M0 (MSG, Raising Z. Click continue when ready)
M0 (MSG, Please make sure the probe is connected and working. Use only N-O probes!)
G53 G0 Z[#<TOOL_PROBE_Z>] ;Move to Z probing height

; In position for current tool probing. Enter relative mode.
G91
G38.2 Z-[#<PROBE_DISTANCE>] F[#<PROBE_RAPID_FEEDRATE>] ;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!! 
G0 Z2
G38.2 Z-5 F40	;Little kisses ;)  Repeating the probing at lower speeds each time to increase the precision. Make a pause on each touch.
G4 P.25
G38.4 Z10 F20
G4 P.25
G38.2 Z-2 F10
G4 P.25
G38.4 Z10 F5
G4 P.25

;This is the current tool Z toolsetter offset
#<ORIGINAL_TOOL> = #<_Z>
G4 P1
G0 Z5

;Back to absolute mode
G90
G53 G0 Z[#<SAFE_HEIGHT>]


;Pause for manual tool change & probing
M0 (MSG, Change your tool now. Click continue when ready)

;After the tool change, go back to Z probing height
G53 G0 Z[#<TOOL_PROBE_Z>]
M0 (MSG, Please make sure the probe is connected and working. Use only N-C probes!)

;Back to relative mode and repeat the probing sequence
G91
G38.2 Z-[#<PROBE_DISTANCE>] F[#<PROBE_RAPID_FEEDRATE>]	;Probing rapid. IMPORTANT!! This is only for Normally CLOSED devices!!!!
G0 Z2
G38.2 Z-5 F40	;Little kisses routine ;)
G4 P.25
G38.4 Z10 F20
G4 P.25
G38.2 Z-2 F10
G4 P.25
G38.4 Z10 F5
G4 P.25

; Update Z offset for new tool
G10 L20 P0 Z[#<ORIGINAL_TOOL>]

G90 ;Back to absolute mode and raise to safe height
G53 G0 Z[#<SAFE_HEIGHT>]

; Pause to remove the touch plate if neccessary, remove wire and clear the path back to the workpiece.
M0 (MSG, Remove touch plate and wires if neccessary)

; Restore modal state
M72