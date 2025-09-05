;===== G-CODE START =====================
;===== machine: M1 PRO =========================
;===== date: 20250729 =====================

;===== Raise Z-Axis =====================
M400 ; wait for buffer to clear
G90
G92 E0 ; zero the extruder
G1 E-3 F1800 ; retract

{if max_layer_z < printable_height}G1 Z{z_offset+min(max_layer_z+2, printable_height)} F300 ; Move print head up{endif} 
G1 X260 Y250 F3600 ; move to safe pos 
M400
TIMELAPSE_TAKE_FRAME
{if max_layer_z < 50}G1 Z50 F300 ; Move print head further up{endif}
;===== Default Settings =====================
M400
M106 S255
M141 S0
M106 P1 S255
M104 S160
G4 P10000
M109 S160
M106 S0  ;turn off cool fan
M141 S0  ;turn off PTC
M106 P2 S0  ;turn off chamber fan
M106 P1 S0  ;turn off PTC fan
M106 P3 S0  ;turn off filter fan
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
SET_VELOCITY_LIMIT VELOCITY=500;
SET_VELOCITY_LIMIT ACCEL=6000;
SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0.2;
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=5;
G21; set units to millimeters
M104 S0
M140 S0
M400
M84 X Y Z E ; disable motors
M400
;===== G-CODE END =====================