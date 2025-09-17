;****************************************************
;*	Created by: 		@pacochorobo on 17/09/2025	*
;*	Last modified by: 	@pacochorobo on 17/09/2025	*
;*	Units: G21 milimeters							*
;*  IMPORTANT: REMOVE ALL TOOLS!!!!!!!!             *
;****************************************************

M0 (MSG, Please remove all tools from the spindle)
M3 S8000	;Start spindle at 8000rpm
G4 P20		;Pause program during 20 sec
M3 S10000	
G4 P10		;Pause program during 10 sec
M3 S12000	
G4 P10		
M3 S14000	
G4 P10		
M3 S16000	
G4 P10		
M3 S18000	
G4 P10		
M3 S20000	
G4 P10		
M3 S22000	
G4 P10		
M3 S24000	
G4 P10		
M5			;Stop spindle
M2			;End of program

	



	