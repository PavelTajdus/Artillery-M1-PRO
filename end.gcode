;===== G-CODE KONEC (start ukončovacího kódu) =====================
;===== stroj: M1 PRO =========================
;===== datum: 20250729 =====================

;===== Zdvih osy Z =====================
M400 ; počkat na vyprázdnění bufferu
G90 ; absolutní souřadnice
G92 E0 ; vynulovat extruder
G1 E-3 F1800 ; retrakce 3 mm

{if max_layer_z < printable_height}G1 Z{z_offset+min(max_layer_z+2, printable_height)} F300 ; zvednout hlavu nad poslední vrstvu{endif} 
G1 X260 Y250 F3600 ; přesun na bezpečnou pozici 
M400 ; počkat na dokončení
TIMELAPSE_TAKE_FRAME ; snímek pro timelapse
{if max_layer_z < 50}G1 Z50 F300 ; zvednout hlavu výše (pokud je nízko){endif}
;===== Výchozí akce při ukončení =====================
M400 ; počkat na dokončení
M106 S255 ; krátké ofouknutí (lze upravit dle potřeby)
M141 S0 ; vypnout vyhřívání komory (PTC)
M106 P1 S255 ; PTC ventilátor na 100 % (ochlazení hlavy/komory)
M104 S160 ; snížit teplotu trysky na 160 °C (bez čekání)
G4 P10000 ; pauza 10 s (chladnutí)
M109 S160 ; počkat na 160 °C
M106 S0  ; vypnout ofuk dílu
M141 S0  ; vypnout PTC
M106 P2 S0  ; vypnout ventilátor komory
M106 P1 S0  ; vypnout PTC ventilátor
M106 P3 S0  ; vypnout filtr/HEPA ventilátor
M220 S100 ; reset rychlosti tisku
M221 S100 ; reset průtoku
SET_VELOCITY_LIMIT VELOCITY=500; ; max. rychlost (mm/s)
SET_VELOCITY_LIMIT ACCEL=6000; ; zrychlení (mm/s^2)
SET_VELOCITY_LIMIT MINIMUM_CRUISE_RATIO=0.2; ; min. poměr ustálené rychlosti
SET_VELOCITY_LIMIT SQUARE_CORNER_VELOCITY=5; ; rychlost v rozích (mm/s)
G21; nastavit milimetry
M104 S0 ; vypnout ohřev trysky
M140 S0 ; vypnout ohřev podložky
M400 ; počkat na dokončení
M84 X Y Z E ; vypnout motory (odpojit proud)
M400 ; počkat na potvrzení
;===== KONEC G-CODE =====================