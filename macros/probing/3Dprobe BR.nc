;****************************************************
;*	Created by: 		@pacochorobo on 14/10/2024	*
;*	Last modified by: 	@pacochorobo on 05/11/2026	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: USE ONLY NORMALLY OPEN PROBES        *
;****************************************************	

;Macro to probe Z TOP X RIGHT Y BOTTOM corner using a 3D probe. You can use a known diam end mill also.
;The 3D probe has a stylus end ball of 1mm 
;My unit has a yaw displacement is 0.02mm over the lenght of the tip so PROBE_RADIUS = 0.98. Please calculate yours for maximum accuracy
;X offset after probing is end ball radius - yaw displacement
;If you plan on using an end mill or calibrated rod, please adjust the offset accordingly
;This macro will probe first Z, so the probe need to be positioned inwards the probing plate at the maximum distance defined by MAX_PROBE_DISTANCE

#<PLATE_HOLE_DIAM> = 15		;Diameter of the hole in the plate where tool is positioned first
#<PROBE_RADIUS> = 1.5875    ;Radius of the probe (or tool)
#<Z_OFFSET> = 5.06          ;Probe Z compensation
#<X_OFFSET> = 10         	;Probe X compensation
#<Y_OFFSET> = 10          	;Probe Y compensation
#<MAX_PROBE_DISTANCE> = 15  ;Maximum distance for probing. Try the same hole diam FOR SAFETY to begin with
#<RAPID_PROBING> = 50       ;Max speed for probing
#<Z_SAFE> = 5               ;Safe height for rapids ABOBE THE SURFACE LEVEL
#<Z_BOTTOM> = 4           	;Max DISTANCE in Z axis BELOW THE SURFACE LEVEL
#<PROBE_RETRACT> = 2		;Distance to retract after probing

#<Z_PLUNGE> = [#<Z_SAFE>+#<Z_BOTTOM>]

G21 G91 ;Set units to mm and activate relative mode
(MSG, Please make sure the probe is connected and working. USE ONLY NORMALLY OPEN PROBES!)
M0 
(DEBUG, Make sure you are probing BOTTOM RIGHT CORNER. Position the probe within #<MAX_PROBE_DISTANCE> mm from the origin point)
M0


;MOVE TOOL OUT OF THE HOLE
G0 X-[#<PLATE_HOLE_DIAM>] Y[#<PLATE_HOLE_DIAM>]

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
G10 L20 P0 Z[#<Z_OFFSET>] ;This offset is POSITIVE because we are probing Z down

;RISE Z AND GET TO THE X PROBING POSITION. 
G0 Z[#<Z_SAFE>]
G0 X[#<PLATE_HOLE_DIAM>+#<MAX_PROBE_DISTANCE>+#<PROBE_RADIUS>*2] Y-[#<PLATE_HOLE_DIAM>] ;Taking into account we moved X and Y by PLATE_HOLE_DIAM already.

;You may comment next line after testing the routing if you don't need this safety message
(MSG, Please make sure the probe is in the right X spot and Z can be safely plunged down)
M0
G0 Z-[#<Z_PLUNGE>]

;PROBE X
G38.2 X[-#<MAX_PROBE_DISTANCE>] F[#<RAPID_PROBING>] ;Probing rapid. IMPORTANT!! This is only for Normally OPEN devices!!!!
G0 X1 ;Retract and start kissing routine ;)
G38.2 X-2 F40	
G4 P.25
G38.4 X2 F20
G4 P.25
G38.2 X-2 F10
G4 P.25
G38.4 X2 F5
G4 P.25
G10 L20 P0 X[#<PROBE_RADIUS>+#<X_OFFSET>] ;This offset is POSITIVE because we are probing X RIGHT
G0 X[#<PROBE_RETRACT>] ;Retract from edge because probe is touching

;RISE Z AND GET TO THE Y PROBING POSITION
G0 Z[#<Z_PLUNGE>] ;move up the same distance we plunged down
G0 X[-#<MAX_PROBE_DISTANCE>] Y-[#<MAX_PROBE_DISTANCE>+#<PROBE_RADIUS>*2]

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
G10 L20 P0 Y-[#<PROBE_RADIUS>+#<Y_OFFSET>] ;This offset is NEGATIVE because we are probing Y BOTTOM
G0 Y-[#<PROBE_RETRACT>] ;Retract from edge because probe is touching

G0 Z[#<Z_PLUNGE>] ;move up the same distance we plunged down. Now we are in SAFE Z.

;Move to origin. Please comment or uncomment this lines as needed
G90 ;Back to absolute mode
G0 X0 Y0
;G0 Z0

M2