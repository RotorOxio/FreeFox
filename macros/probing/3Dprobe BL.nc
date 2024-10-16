;****************************************************
;*	Created by: 		@pacochorobo on 14/10/2024	*
;*	Last modified by: 	@pacochorobo on 14/10/2024	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Macro to probe Z TOP X LEFT Y BOTTOM corner using a 3D probe. You can use a known diam end mill also.
;The 3D probe has a stylus end ball of 1mm 
;My unit has a yaw displacement is 0.02mm over the lenght of the tip so PROBE_RADIUS = 0.98. Please calculate yours for maximum accuracy
;X offset after probing is end ball radius - yaw displacement
;If you plan on using an end mill or calibrated rod, please adjust the offset accordingly
;This macro will probe first Z, so the probe need to be positioned inwards the probing plate at the maximum distance defined by MAX_PROBE_DISTANCE

#<PROBE_RADIUS> = 0.98      ;3D probe stylus is 1mm radius minus 0.02 of yaw deflection
#<Z_OFFSET> = 0.02         ;3D probe stylus z compensation
#<MAX_PROBE_DISTANCE> = 10  ;Maximum distance for probing.
#<RAPID_PROBING> = 50       ;Max speed for probing
#<Z_SAFE> = 5               ;Safe height for rapids ABOBE THE SURFACE LEVEL
#<Z_BOTTOM> = 3            	;Max DISTANCE in Z axis BELOW THE SURFACE LEVEL
#<PROBE_RETRACT> = 2		;Distance to retract after probing

#<Z_PLUNGE> = [#<Z_SAFE>+#<Z_BOTTOM>]

M70 ;Save modal state
G21 G91 ;Set units to mm and activate relative mode
M0 (MSG, Please make sure the probe is connected and working. USE ONLY NORMALLY OPEN PROBES!)
M0 (DEBUG, Make sure you are probing BOTTOM LEFT CORNER. Position the probe within #<MAX_PROBE_DISTANCE> mm from the origin point)

;PROBE Z
G38.2 Z-[#<MAX_PROBE_DISTANCE>] F[#<RAPID_PROBING>]	;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 Z1   ;Retract and start the little kisses routine ;)      
G38.2 Z-2 F40	
G4 P.25
G38.4 Z2 F20
G4 P.25
G38.2 Z-2 F10
G4 P.25
G38.4 Z2 F5
G4 P.25
G10 L20 P0 Z-[#<Z_OFFSET>] ;This offset is negative because we are probing Z down

;RISE Z AND GET TO THE X PROBING POSITION. 
G0 Z[#<Z_SAFE>]
G0 X-[#<MAX_PROBE_DISTANCE>]

;You may comment next line after testing the routing if you don't need this safety message
M0 (MSG, Please make sure the probe is in the right X spot and Z can be safely plunged down)
G0 Z-[#<Z_PLUNGE>]

;PROBE X
G38.2 X[#<MAX_PROBE_DISTANCE>] F[#<RAPID_PROBING>] ;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 X-1 ;Retract and start kissing routine ;)
G38.2 X2 F40	
G4 P.25
G38.4 X-2 F20
G4 P.25
G38.2 X2 F10
G4 P.25
G38.4 X-2 F5
G4 P.25
G10 L20 P0 X-[#<PROBE_RADIUS>] ;This offset is negative because we are probing X LEFT
G0 X-[#<PROBE_RETRACT>] ;Retract from edge because probe is touching

;RISE Z AND GET TO THE Y PROBING POSITION
G0 Z[#<Z_PLUNGE>] ;move up the same distance we plunged down
G0 X[#<MAX_PROBE_DISTANCE>] Y-[#<MAX_PROBE_DISTANCE>]

;You may comment next line after testing the routing if you don't need this safety message
M0 (MSG, Please make sure the probe is in the right Y spot and Z can be safely plunged down)
G0 Z-[#<Z_PLUNGE>] ;move z down

;PROBE Y
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
G10 L20 P0 Y-[#<PROBE_RADIUS>] ;This offset is negative because we are probing Y LEFT
G0 Y-[#<PROBE_RETRACT>] ;Retract from edge because probe is touching

G0 Z[#<Z_PLUNGE>] ;move up the same distance we plunged down. Now we are in SAFE Z.

;Move to origin. Please comment or uncomment this lines as needed
G0 X0 Y0
;G0 Z0

M72 ;Restore modal state and end of macro