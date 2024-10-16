;****************************************************
;*	Created by: 		@pacochorobo on 11/6/2024	*
;*	Last modified by: 	@pacochorobo on 02/9/2024	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Simple macro to probe Y BOTTOM size of a part using a 3D probe. You can use a known diam end mill also.
;This 3D probe has a stylus end ball of 1mm 
;My unit has a yaw displacement is 0.02mm over the lenght of the tip. Please calculate yours for maximum accuracy
;Y offset after probing is end ball radius - yaw displacement
;If you plan on using an end mill or calibrated rod, please adjust the offset accordingly

#<Y_OFFSET> = 0.98
#<MAX_PROBE_DISTANCE> = 25 ;Maximum distance for probing.
#<RAPID_PROBING> = 50 ;Max speed for probing
#<PROBE_RETRACT> = 5

M70 ;Save modal state
G21 G91 ;Set units to mm and activate relative mode
M0 (MSG, Please make sure the probe is connected and working)  

G38.2 Y[#<MAX_PROBE_DISTANCE>] F[#<RAPID_PROBING>] ;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 Y-1 ;Retract and start kissing routine ;)
G38.2 Y2 F40	
G4 P.25
G38.4 Y-2 F20
G4 P.25
G38.2 Y2 F10
G4 P.25
G38.4 Y-2 F5
G4 P.25

G10 L20 P0 Y-[#<Y_OFFSET>]
G0 Y-[#<PROBE_RETRACT>] ;Retract from material

M72 ;Restore modal state
;End of macro