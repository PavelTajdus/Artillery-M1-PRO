;===== START G-CODE (start kódu) =====================
;===== stroj: M1 PRO =========================
;===== rozměry: X260 Y260 Z260 =====================
;===== datum: 20250708 =====================
;===== Konfigurace teplot filamentu =====================
;Nozzle_Preheat_Temp:140 ; předehřev trysky (°C)
;Bed_Preheat_Temp:[bed_temperature_initial_layer_single] ; předehřev podložky (°C)
{if (nozzle_temperature_initial_layer[0] >250)};Filament_Common_Extrusion_Temp:[nozzle_temperature_initial_layer]{else};Filament_Common_Extrusion_Temp:250{endif} ; běžná teplota extruze filamentu (°C)
;Nozzle_Init_Layer_Temp:[nozzle_temperature_initial_layer] ; teplota trysky pro první vrstvu (°C)
;Filament_Softening_Temp:[nozzle_temperature_range_low] ; teplota měknutí filamentu (°C)

;===== Výchozí nastavení =====================
M106 S0  ; vypnout ofuk dílu (part cooling)
M141 S0  ; vypnout vyhřívání komory (PTC)
M106 P2 S0  ; vypnout ventilátor komory
M106 P1 S0  ; vypnout ventilátor PTC
M106 P3 S0  ; vypnout filtr/HEPA ventilátor
M220 S100 ; resetovat rychlost tisku (feedrate) na 100 %
M221 S100 ; resetovat průtok (flow) na 100 %
SET_VELOCITY_LIMIT VELOCITY=500; ; nastavit max. rychlost (mm/s)
SET_VELOCITY_LIMIT ACCEL=6000; ; nastavit zrychlení (mm/s^2)
SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0.2; ; minimální poměr ustálené rychlosti
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=5; ; rychlost ostrých rohů (mm/s)
G21; nastavit jednotky na milimetry
G90 ; nastavit absolutní souřadnice

;===== Předehřev během referencování (homingu) =====================
M106 P1 S153 ; zapnout ventilátor PTC na ~60 %

M140 S[bed_temperature_initial_layer_single]; ; nastavit teplotu podložky pro 1. vrstvu (nečekat)

{if filament_type[initial_no_support_extruder]=="ABS"} ; pokud je filament ABS
M106 P1 S255 ; PTC ventilátor na 100 %
M106 P2 S60 ; ventilátor komory ~24 %
G4 P5000 ; pauza 5 s pro ustálení proudění
M191 S47; ; čekat na ohřev komory na 47 °C
M141 S0; ; vypnout vyhřívání komory (pokud bylo aktivní)
{endif} ; konec podmínky ABS

{if filament_type[initial_no_support_extruder]=="PC"} ; pokud je filament PC
M106 P1 S255 ; PTC ventilátor na 100 %
M106 P2 S60 ; ventilátor komory ~24 %
G4 P5000 ; pauza 5 s
M191 S47; ; čekat na ohřev komory na 47 °C
M141 S{chamber_temperature[0]}; ; nastavit cílovou teplotu komory dle profilu
{endif} ; konec podmínky PC

{if filament_type[initial_no_support_extruder]=="ASA"} ; pokud je filament ASA
M106 P1 S255 ; PTC ventilátor na 100 %
M106 P2 S60 ; ventilátor komory ~24 %
G4 P5000 ; pauza 5 s
M191 S47; ; čekat na ohřev komory na 47 °C
M141 S{chamber_temperature[0]}; ; nastavit cílovou teplotu komory dle profilu
{endif} ; konec podmínky ASA

{if filament_type[initial_no_support_extruder]=="PA"} ; pokud je filament PA (nylon)
M106 P1 S255 ; PTC ventilátor na 100 %
M106 P2 S60 ; ventilátor komory ~24 %
G4 P5000 ; pauza 5 s
M191 S47; ; čekat na ohřev komory na 47 °C
M141 S{chamber_temperature[0]}; ; nastavit cílovou teplotu komory dle profilu
{endif} ; konec podmínky PA

{if filament_type[initial_no_support_extruder]=="PA-CF"} ; pokud je filament PA-CF (nylon s CF)
M106 P1 S255 ; PTC ventilátor na 100 %
M106 P2 S60 ; ventilátor komory ~24 %
G4 P5000 ; pauza 5 s
M191 S47; ; čekat na ohřev komory na 47 °C
M141 S{chamber_temperature[0]}; ; nastavit cílovou teplotu komory dle profilu
{endif} ; konec podmínky PA-CF

M106 P2 S0 ; vypnout ventilátor komory
M106 S0; ; vypnout ofuk dílu
G4 P500 ; pauza 0,5 s

;===== Čekání na ohřev a homing =====================
G28 ; referencování všech os
G1 X20 Y5.8 Z0.2 F18000 ; přejezd k okraji pro začátek čisticí linky

;===== Nastavit tiskové teploty =====================
M106 S120; ; zapnout ofuk dílu ~47 % (dle materiálu)
G4 P500 ; pauza 0,5 s
M104 S[first_layer_temperature]; ; nastavit teplotu trysky pro 1. vrstvu (nečekat)

{if (bed_temperature_initial_layer_single >0)} ; pokud je požadovaná teplota podložky > 0
M190 S[bed_temperature_initial_layer_single]; ; nastavit a počkat na teplotu podložky
{else} ; jinak jen nastavit bez čekání
M140 S[bed_temperature_initial_layer_single]; ; nastavit teplotu podložky (bez čekání)
{endif}

M109 S[first_layer_temperature]; ; počkat na teplotu trysky pro 1. vrstvu
M106 S0; ; vypnout ofuk dílu před první vrstvou (dle potřeby materiálu)
G4 P500 ; pauza 0,5 s

;===== Čisticí/extruzní linka (wipe) =====================
G1 X80 Y-0.5 Z5 F18000 ; přejezd nad začátek linky
M400 ; počkat na dokončení pohybů
G1 X80 Y-0.5 Z0.3 F600 ; spustit trysku k podložce
M400 ; počkat na dokončení pohybů

G92 E0 ; vynulovat čítač extruderu
G1 Z0.3 E8 F300 ; pomalá extruze pro naplnění trysky
M400 ; počkat na dokončení

G92 E0 ; vynulovat extruder
G1 X180 Y-0.5 Z0.3 F1800.0 E10.0;nakreslit linku (první tah)

G92 E0 ; vynulovat extruder
G1 X180 Y-2 Z0.3 F1800.0 E0.15;nakreslit linku (druhý tah)

G92 E0 ; vynulovat extruder
G1 X90 Y-2 Z0.3 F1800.0 E9;nakreslit linku (třetí tah)

G92 E0 ; vynulovat extruder
G1 X90 Y0 Z0.2 E0.2 F1800; zakončení linky

G92 E0 ; vynulovat extruder
G1 Z0.6 F600 ; odjezd nahoru
M400 ; počkat na dokončení

G1 X{first_layer_print_min[0]} Y{first_layer_print_min[1]} F9000 ; přejezd na start první vrstvy
M400 ; počkat na dokončení

;===== KONEC START G-CODE =====================