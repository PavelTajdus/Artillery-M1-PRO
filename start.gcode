;===== START G-CODE  =====================
;===== machine: M1 PRO =========================
;===== size: X260 Y260 Z260 =====================
;===== date: 20250708 =====================
;===== Filament Temperature Configuration =====================
;Nozzle_Preheat_Temp:140
;Bed_Preheat_Temp:[bed_temperature_initial_layer_single]
{if (nozzle_temperature_initial_layer[0] >250)};Filament_Common_Extrusion_Temp:[nozzle_temperature_initial_layer]{else};Filament_Common_Extrusion_Temp:250{endif}
;Nozzle_Init_Layer_Temp:[nozzle_temperature_initial_layer]
;Filament_Softening_Temp:[nozzle_temperature_range_low]

;===== Default Settings =====================
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
G90

;===== Preheat While Zeroing =====================
M106 P1 S153

M140 S[bed_temperature_initial_layer_single];

{if filament_type[initial_no_support_extruder]=="ABS"}
M106 P1 S255
M106 P2 S60
G4 P5000
M191 S47;
M141 S0;
{endif}

{if filament_type[initial_no_support_extruder]=="PC"}
M106 P1 S255
M106 P2 S60
G4 P5000
M191 S47;
M141 S{chamber_temperature[0]};
{endif}

{if filament_type[initial_no_support_extruder]=="ASA"}
M106 P1 S255
M106 P2 S60
G4 P5000
M191 S47;
M141 S{chamber_temperature[0]};
{endif}

{if filament_type[initial_no_support_extruder]=="PA"}
M106 P1 S255
M106 P2 S60
G4 P5000
M191 S47;
M141 S{chamber_temperature[0]};
{endif}

{if filament_type[initial_no_support_extruder]=="PA-CF"}
M106 P1 S255
M106 P2 S60
G4 P5000
M191 S47;
M141 S{chamber_temperature[0]};
{endif}

M106 P2 S0
M106 S0;
G4 P500

;===== Wait heating =====================
G28
G1 X20 Y5.8 Z0.2 F18000

;===== Set Print Temperature =====================
M106 S120;
G4 P500
M104 S[first_layer_temperature];

{if (bed_temperature_initial_layer_single >0)}
M190 S[bed_temperature_initial_layer_single];
{else}
M140 S[bed_temperature_initial_layer_single];
{endif}

M109 S[first_layer_temperature];
M106 S0;
G4 P500

;===== Wipe Nozzle Extrude Line =====================
G1 X80 Y-0.5 Z5 F18000
M400
G1 X80 Y-0.5 Z0.3 F600
M400

G92 E0
G1 Z0.3 E8 F300
M400

G92 E0
G1 X180 Y-0.5 Z0.3 F1800.0 E10.0;draw line

G92 E0
G1 X180 Y-2 Z0.3 F1800.0 E0.15;draw line

G92 E0
G1 X90 Y-2 Z0.3 F1800.0 E9;draw line

G92 E0
G1 X90 Y0 Z0.2 E0.2 F1800;

G92 E0
G1 Z0.6 F600
M400

G1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} F9000
M400

;===== END G-CODE  =====================