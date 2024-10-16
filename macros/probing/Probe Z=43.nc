;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 02/9/2024	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Simple macro to probe Z TOP of a part.

#<Z_OFFSET> = 43 ;Thickness of the probe for normal probes or the stylus displacement in case of using a 3D Probe
#<MAX_PROBE_DISTANCE> = 20 ;Maximum distance for probing.
#<PROBE_RAPID_FEEDRATE> = 50 ;Max speed for probing


M70 ;Save modal state
G21 
G91 ;Set units to mm and activate relative mode
M0 (MSG, Please make sure the probe is connected and working.)

G38.2 Z-[#<MAX_PROBE_DISTANCE>] F[#<PROBE_RAPID_FEEDRATE>]	;Probing rapid. IMPORTANT!! This is only for Normally OPEN probes!!!!
G0 Z1
G38.2 Z-2 F40	;Little kisses routine ;)
G4 P.25
G38.4 Z2 F20
G4 P.25
G38.2 Z-2 F10
G4 P.25
G38.4 Z2 F5
G4 P.25

G10 L20 P0 Z[#<Z_OFFSET>]

M72 ;Restore modal state and end of macro