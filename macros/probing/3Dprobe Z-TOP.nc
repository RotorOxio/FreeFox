;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 02/9/2024	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Simple macro to probe Z TOP of a part using a 3D probe. You can use a known diam end mill also.
;This 3D probe has a stylus end ball of 1mm 
;My unit has a Z displacement of 0.02mm. Please calculate yours for maximum accuracy
;If you plan on using an end mill or calibrated rod, please adjust the offset to 0 or as desired.


#<Z_OFFSET> = -0.02
#<MAX_PROBE_DISTANCE> = 25 ;Maximum distance for probing.
#<RAPID_PROBING> = 50 ;Max speed for probing


M70 ;Save modal state
G21 G91 ;Set units to mm and activate relative mode
M0 (MSG, Please make sure the probe is connected and working.)  ;Safety message

G38.2 Z-[#<PROBE_DISTANCE>] F[#<PROBE_RAPID_FEEDRATE>]	;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 Z1   ;Retract and start the little kisses routine ;)      
G38.2 Z-2 F40	
G4 P.25
G38.4 Z2 F20
G4 P.25
G38.2 Z-2 F10
G4 P.25
G38.4 Z2 F5
G4 P.25

G10 L20 P0 #<Z_OFFSET>
G90 ;Back to absolute mode
M72 ;Restore modal state and end of macro