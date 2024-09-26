;Macro for parking the machine closer to the homming position to speed up the start up on next power on
;Created by @pacochorobo on 26/9/2024
;Las modified by @pacochorobo on 26/9/2024
;
;Paremeters XPreHome YPreHome and ZPreHome represents the coordinates for the parking position in the G53 machine coordinate system

#<XPreHome> = 5
#<YPreHome> = 1000
#<ZPreHome> = 145

G90 G21 ;Metric absolute for safety and good practices
G53 G0 #<ZPreHome> ;Move Z first
M0 (MSG, "Ready to park. Make sure path is cleared. Click continue to proceed)
G53 G0 #<XPreHome> #<YPreHome> ;Move XY

M2 ;End of program