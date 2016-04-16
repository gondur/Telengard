*=$C000

; ---------- Memory Map Pointers ----------

CharGenRAM = $F800
VideoMatrix = $CC00
ColorRAM = $D800
Sprite_Config = $04B6
Sprite_Coords = $06AE
InnData = $0400
InnDataDest = VideoMatrix + $78
LocationData = $CAD4

; ---------- Floats ----------
FloatXO = $02A7
FloatYO = FloatXO + 5
FloatZO = FloatYO + 5
FloatW0 = FloatZO + 5
FloatQ = FloatW0 + 5
FloatScratch = FloatQ + 5

; ---------- Integers ----------
IntCX = FloatScratch + 5
IntCY = IntCX + 1
IntX = IntCY + 1
IntY = IntX + 1
IntZ = IntY + 1
IntH = IntZ + 1
IntL = IntH + 2
IntW = IntL + 2
IntSF3 = IntW + 2
IntSC = IntSF3 + 2
IntCL = IntSC + 2
IntScratch = IntCL + 2
P00 = IntScratch + 2
P01 = P00 + 2
P02 = P01 + 2
P03 = P02 + 2
P10 = P03 + 2
P11 = P10 + 2
P12 = P11 + 2
P13 = P12 + 2
P20 = P13 + 2
P21 = P20 + 2
P22 = P21 + 2
P23 = P22 + 2
P30 = P23 + 2
P31 = P30 + 2
P32 = P31 + 2
P33 = P32 + 2
CountY = P33 + 2
CountX = CountY + 1

; ------------------------------------------------------------------------------
; Copy section of display data
; ------------------------------------------------------------------------------

; X = Line counter (Counts down to zero)
; $02 = Column Counter
; $FB = Low Byte of 16-bit Source Address
; $FC = High Byte of 16-bit Source Address
; $FD = Low Byte of 16-bit Destination Address
; $FE = High Byte of 16-bit Destination Address

CopySource = $FB
CopyDest = $FD
ColumnCounter = $02

Copy_Line       LDY ColumnCounter       ; Initialize Column Counter
                DEY
Copy_Bytes      LDA ($FB),Y
                STA ($FD),Y
                DEY
                BPL Copy_Bytes
                CLC
                LDA $FB                 ; Increment Source Line Address
                ADC ColumnCounter
                STA $FB
                LDA $FC
                ADC #$00
                STA $FC
                CLC
                LDA $FD                 ; Increment Destination Line Address
                ADC #$28
                STA $FD
                LDA $FE
                ADC #$00
                STA $FE
                DEX                     ; Decrement Line Counter
                BNE Copy_Line
                RTS

; ------------------------------------------------------------------------------
; Clear bottom 5 rows of Video Matrix
; ------------------------------------------------------------------------------

Clear_Status    LDA #$20
                LDY #$00
Status_Loop     STA VideoMatrix + $320,Y
                INY
                CPY #$C8
                BNE Status_Loop
                RTS

; ------------------------------------------------------------------------------
; Reset Dungeon View
; ------------------------------------------------------------------------------

Clear_View_Chr  LDA #$20        ; Entry Point: Fill Dungeon View (22x20) Video Matrix with ASCII spaces
                STA $FE
                LDA #$CB
                JMP Converge
Clear_View_Clr  LDA #$09        ; Entry Point: Fill Dungeon View (22x20) Color RAM with Brown
                STA $FE
                LDA #$D7
Converge        STA $FC
                LDA #$FF
                STA $FB
                LDX #$14
Line_Loop       LDA $FE
                LDY #$16
Column_Loop     STA ($FB),Y
                DEY
                BNE Column_Loop
                CLC
                LDA $FB
                ADC #$28
                STA $FB
                LDA $FC
                ADC #$00
                STA $FC
                DEX
                BNE Line_Loop
                RTS

; ------------------------------------------------------------------------------
; Show Player's character graphics in Video Matrix
; ------------------------------------------------------------------------------

Show_PC_Chars   LDA #$06        ; Feather Color
                STA $D976
                LDA #$0F        ; Sword & Shield Color
                STA $D975
                STA $D99D
                STA $D9C5
                LDA #$78        ; Feather Character
                STA VideoMatrix + $176
                LDA #$79        ; Sword Character
                STA VideoMatrix + $175
                LDA #$7A        ; Sword & Shield Character
                STA VideoMatrix + $19D
                LDA #$5C        ; Shield Character
                STA VideoMatrix + $1C5
                RTS

; ------------------------------------------------------------------------------
; Remove Player's' character graphics from Video Matrix
; ------------------------------------------------------------------------------

Hide_PC_Chars   LDA #$20
                STA VideoMatrix + $175       ; Feather
                STA VideoMatrix + $176       ; Sword
                STA VideoMatrix + $19D       ; Sword & Shield
                STA VideoMatrix + $1C5       ; Shield.  Just shield.
                RTS

; ------------------------------------------------------------------------------
; Draw Horizontal Wall and Door
; ------------------------------------------------------------------------------

                ; IFW<2THENRETURN
Draw_Wall_X     LDA IntW + 1
                BNE Exit_Wall_X
                LDA IntW
                CMP #$02
                BCC Exit_Wall_X
                ; Init Video Matrix Pointer
                CLC
                LDA IntL
                ADC #$FF
                STA $FB
                LDA IntL + 1
                ADC #>VideoMatrix - 1
                STA $FC
                ; FORQ=0TO6
                LDY #$06
                ; POKESC+L%+Q,161
Wall_X_Loop     LDA #$60
                STA ($FB),Y
                ; NEXTQ
                DEY
                BPL Wall_X_Loop
                ; IFW>2THENRETURN
                LDA IntW
                CMP #$03
                ; RETURN
                BEQ Exit_Wall_X
                ; Init Color RAM Pointer
                CLC
                LDA IntL
                ADC #$FF
                STA $FD
                LDA IntL + 1
                ADC #$D7
                STA $FE
                ; FORQ=2TO4
                LDY #$02
                ; POKECL-1+L%+Q,11
Door_X_Loop     LDA #$0B
                STA ($FD),Y
                ; POKESC+L%+Q,162
                LDA #$61
                STA ($FB),Y
                ; NEXTQ
                INY
                CPY #$05
                BNE Door_X_Loop                
                ; RETURN
Exit_Wall_X     RTS

; ------------------------------------------------------------------------------
; Draw Vertical Wall and Door
; ------------------------------------------------------------------------------

                ; IFW<2THENRETURN
Draw_Wall_Y     LDA IntW + 1
                BNE Exit_Wall_Y
                LDA IntW
                CMP #$02
                BCC Exit_Wall_Y
                ; Init Video Matrix Pointer
                CLC
                LDA IntL
                ADC #$FF
                STA $FB
                LDA IntL + 1
                ADC #>VideoMatrix - 1
                STA $FC
                ; FORQ=0TO6STEP40 (0 - 240)
                LDA #$00
                CLC
                ; POKESC+L%+Q,161
Wall_Y_Loop     TAY
                LDA #$60
                STA ($FB),Y
                ; NEXTQ
                TYA
                ADC #$28
                BCC Wall_Y_Loop
                ; IFW>2THENRETURN
No_Y_Doors      LDA IntW
                CMP #$03
                ; RETURN
                BEQ Exit_Wall_Y
                ; Init Color RAM Pointer
Render_Y_Doors  CLC
                LDA IntL
                ADC #$FF
                STA $FD
                LDA IntL + 1
                ADC #$D7
                STA $FE
                ; FORQ=2TO4 (80 - 160)
                LDA #$50
                ; POKECL-1+L%+Q,11
Door_Y_Loop     TAY
                LDA #$0B
                STA ($FD),Y
                ; POKESC+L%+Q,162
                LDA #$62
                STA ($FB),Y
                ; NEXTQ
                TYA
                ADC #$28
                CMP #$C8
                BNE Door_Y_Loop                
                ; RETURN
Exit_Wall_Y     RTS

; ------------------------------------------------------------------------------
; Render effect of Light spell
; ------------------------------------------------------------------------------

LightCharacter = #$5E
LightColor = #$07

; ------------------------- Determine Northwest Object -------------------------

; Line 15300
                ; IFFNS(P(0,0))=0THEN15320
Render_Light    LDA P00 + 1
                BEQ Calc_N_Light
; Line 15305
                ; IFFNUP(P(1,0))<2
Calc_NW_Light   LDA P10
                AND #$02
                BNE Calc_NW_Light2
                ; ANDFNLF(P(1,1))<2THEN15315
                LDA P11
                AND #$08
                BEQ Show_NW_Light
; Line 15310
                ; IFFNUP(P(1,1))>1
Calc_NW_Light2  LDA P11
                AND #$02
                BNE Calc_N_Light
                ; ORFNLF(P(0,1))>1THEN15320
                LDA P01
                AND #$08
                BNE Calc_N_Light
; Line 15315
                ; POKE49278,102
Show_NW_Light   LDA LightColor
                STA $D87E
                LDA LightCharacter
                STA VideoMatrix + $7E

; --------------------------- Determine North Object ---------------------------

; Line 15320
                ; IFFNS(P(0,1))<>0
Calc_N_Light    LDA P01 + 1
                BEQ Calc_NE_Light
                ; ANDFNUP(P(1,1))<2THEN
                LDA P11
                AND #$02
                BNE Calc_NE_Light
                ; POKE49284,102
Show_N_Light    LDA LightColor
                STA $D884
                LDA LightCharacter
                STA VideoMatrix + $84

; ------------------------- Determine Northeast Object -------------------------

; Line 15340
                ; IFFNS(P(0,2))=0THEN15360
Calc_NE_Light   LDA P02 + 1
                BEQ Calc_E_Light
; Line 15345
                ; IFFNUP(P(1,1))<2
                LDA P11
                AND #$02
                BNE Calc_NE_Light2
                ; ANDFNLF(P(0,2))<2THEN15355
                LDA P02
                AND #$08
                BEQ Show_NE_Light
; Line 15350
                ; IFFNUP(P(1,2))>1
Calc_NE_Light2  LDA P12
                AND #$02
                BNE Calc_E_Light
                ; ORFNLF(P(1,2))>1THEN15360
                LDA P12
                AND #$08
                BNE Calc_E_Light
; Line 15355
                ; POKE49290,102
Show_NE_Light   LDA LightColor
                STA $D88A
                LDA LightCharacter
                STA VideoMatrix + $8A

; --------------------------- Determine East Object ----------------------------

; Line 15360
                ; IFFNS(P(1,2))<>0
Calc_E_Light    LDA P12 + 1
                BEQ Calc_SE_Light
                ; ANDFNLF(P(1,2))<2THEN
                LDA P12
                AND #$08
                BNE Calc_SE_Light
                ; POKE49530,102
Show_E_Light    LDA LightColor
                STA $D97A
                LDA LightCharacter
                STA VideoMatrix + $17A

; ------------------------- Determine Southeast Object -------------------------

; not finished here yet
; Line 15380
                ; IFFNS(P(2,2))=0THEN15400
Calc_SE_Light   LDA P22 + 1
                BEQ Calc_S_Light
; Line 15385
                ; IFFNUP(P(2,2))<2
                LDA P22
                AND #$02
                BNE Calc_SE_Light2
                ; ANDFNLF(P(1,2))<2THEN15395
                LDA P12
                AND #$08
                BEQ Show_SE_Light
; Line 15390
                ; IFFNUP(P(2,1))>1
Calc_SE_Light2  LDA P21
                AND #$02
                BNE Calc_S_Light
                ; ORFNLF(P(2,2))>1THEN15400
                LDA P22
                AND #$08
                BNE Calc_S_Light
; Line 15395
                ; POKE49770,102
Show_SE_Light   LDA LightColor
                STA $DA6A
                LDA LightCharacter
                STA VideoMatrix + $26A

; --------------------------- Determine South Object ---------------------------

; Line 15400
                ; IFFNS(P(2,1))<>0
Calc_S_Light    LDA P21 + 1
                BEQ Calc_SW_Light
                ; ANDFNUP(P(2,1))<2THEN
                LDA P21
                AND #$02
                BNE Calc_SW_Light
                ; POKE49764,102
Show_S_Light    LDA LightColor
                STA $DA64
                LDA LightCharacter
                STA VideoMatrix + $264

; ------------------------- Determine Southwest Object -------------------------

; Line 15420
                ; IFFNS(P(2,0))=0THEN15440
Calc_SW_Light   LDA P20 + 1
                BEQ Calc_W_Light
; Line 15425
                ; IFFNUP(P(2,0))<2
                LDA P20
                AND #$02
                BNE Calc_SW_Light2
                ; ANDFNLF(P(1,1))<2THEN15435
                LDA P11
                AND #$08
                BEQ Show_SW_Light
; Line 15430
                ; IFFNUP(P(2,1))>1
Calc_SW_Light2  LDA P21
                AND #$02
                BNE Calc_W_Light
                ; ORFNLF(P(2,1))>1THEN15440
                LDA P21
                AND #$08
                BNE Calc_W_Light
; Line 15435
                ; POKE49758,102
Show_SW_Light   LDA LightColor
                STA $DA5E
                LDA LightCharacter
                STA VideoMatrix + $25E

; --------------------------- Determine West Object ----------------------------

; Line 15440
                ; IFFNS(P(1,0))<>0
Calc_W_Light    LDA P10 + 1
                BEQ Exit_Light
                ; ANDFNLF(P(1,1))<2THEN
                LDA P11
                AND #$08
                BNE Exit_Light
                ; POKE49518,102
Show_W_Light    LDA LightColor
                STA $D96E
                LDA LightCharacter
                STA VideoMatrix + $16E
; Line 15499
                ; Return to BASIC
Exit_Light      RTS

; ------------------------------------------------------------------------------
; Multiplication (Thanks, Rodnay Zaks!)
; ------------------------------------------------------------------------------

Multiplier = $FB
Multiplicand = $FC
Multiply_Result = $FD

Multiply_8      LDA #$00
                STA Multiply_Result
                LDX #$08
Multiplier_Loop LSR Multiplier
                BCC No_Add
                CLC
                ADC Multiplicand
No_Add          ROR A
                ROR Multiply_Result
                DEX
                BNE Multiplier_Loop
                STA $FE ;Multiply_Result + 1
                RTS

; ------------------------------------------------------------------------------
; 16-bit Addition
; ------------------------------------------------------------------------------

Add16_Operand_1 = $FB
Add16_Operand_2 = $FD
Add16_Result = $02FE

Add_16          CLC
                LDA Add16_Operand_1
                ADC Add16_Operand_2
                STA Add16_Result
                LDA $FC ; Add16_Operand_1 + 1
                ADC $FE ; Add16_Operand_2 + 1
                STA Add16_Result + 1
                RTS

; ------------------------------------------------------------------------------
; Disable detection of RUN/STOP key press
; ------------------------------------------------------------------------------

Disable_RUNSTOP JSR $FFEA
                LDA #$FF
                STA $91
                JMP $EA34

; ------------------------------------------------------------------------------
; Show Altar character graphics in Video Matrix
; ------------------------------------------------------------------------------

Show_Altar_Chrs LDA #$08        ; Flame Color
                STA $D922
                STA $D924
                LDA #$09        ; Torch Color
                STA $D94A
                STA $D94C
                LDA #$02        ; Rug Color
                STA $D99A
                STA $D99B
                STA $D99C
                LDA #$77        ; Left Flame Character
                STA VideoMatrix + $122
                LDA #$76        ; Right Flame Character
                STA VideoMatrix + $124
                LDA #$75        ; Torch Character
                STA VideoMatrix + $14A
                STA VideoMatrix + $14C
                LDA #$E4        ; Left Rug Character
                STA VideoMatrix + $19A
                LDA #$A0        ; Center Rug Character
                STA VideoMatrix + $19B
                LDA #$E5        ; Right Rug Character
                STA VideoMatrix + $19C
                RTS

; ------------------------------------------------------------------------------
; Remove Altar character graphics from Video Matrix
; ------------------------------------------------------------------------------

Hide_Altar_Chrs LDA #$20
                STA VideoMatrix + $122
                STA VideoMatrix + $124
                STA VideoMatrix + $14A
                STA VideoMatrix + $14C
                STA VideoMatrix + $19A
                STA VideoMatrix + $19B
                STA VideoMatrix + $19C
                RTS

; ------------------------------------------------------------------------------
; Re-Plot
; ------------------------------------------------------------------------------

                ; Initialize counters
                LDA #$00
                STA CountY
                STA CountX
                STA $02
                ; Pointer to P00
                LDA #$D8
                STA $FB
                LDA #$02
                STA $FC

; ----------------------- Generate Seeds in 4x4 Grid ---------------------------

Calculate_Y     CLC
                LDA IntCY
                ADC CountY
                SEC
                SBC #$01
                STA IntY
Calculate_X     CLC
                LDA IntCX
                ADC CountX
                SEC
                SBC #$01
                STA IntX
Get_Room_Value  JSR Calculate_Seed
                LDA IntH
                LDY $02
                STA ($FB),Y
                INY
                LDA IntH + 1
                STA ($FB),Y
                INY
                STY $02
                INC CountX
                LDA CountX
                CMP #$04
                BNE Calculate_X
                LDA #$00
                STA CountX
                INC CountY
                LDA CountY
                CMP #$04
                BNE Calculate_Y

; --------------------------- Clear Dungeon View -------------------------------

                JSR Clear_View_Chr
                JSR Clear_View_Clr

; ------------------------------ Draw Dungeon ---------------------------------

Draw_Dungeon    LDA #$00
                STA IntL + 1
                STA IntW + 1
                ; IFFNUP(P(1,1))>1
Check_P11_P01   LDA P11
                AND #$02
                BNE Check_P10_P11
                ; ORFNLF(P(0,1))>1
                LDA P01
                AND #$08
                BNE Check_P10_P11
                ; L%=4:W=FNUP(P(0,0)):GOSUB10050
Draw_P00_X      LDA #$04
                STA IntL
                LDA P00
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; IFFNUP(P(1,0))>1
Check_P10_P11   LDA P10
                AND #$02
                BNE Check_P11_UP
                ; ORFNLF(P(1,1))>1
                LDA P11
                AND #$08
                BNE Check_P11_UP
                ; L%=4:W=FNLF(P(0,0)):GOSUB10075
Draw_P00_Y      LDA #$04
                STA IntL
                LDA P00
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNUP(P(1,1))>1
Check_P11_UP    LDA P11
                AND #$02
                BNE Check_P11_P02
                ; L%=10:W=FNUP(P(0,1)):GOSUB10050
Draw_P01_X      LDA #$0A
                STA IntL
                LDA P01
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; W=FNLF(P(0,1)):GOSUB10075
Draw_P01_Y      LDA P01
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; L%=16:W=FNLF(P(0,2)):GOSUB10075
Draw_P02_Y      LDA #$10
                STA IntL
                LDA P02
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNUP(P(1,1))>1
Check_P11_P02   LDA P11
                AND #$02
                BNE Check_P12_P12
                ; ORFNLF(P(0,2))>1
                LDA P02
                AND #$08
                BNE Check_P12_P12
                ; L%=16:W=FNUP(P(0,2)):GOSUB10050
Draw_P02_X      LDA #$10
                STA IntL
                LDA P02
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; IFFNUP(P(1,2))>1
Check_P12_P12   LDA P12
                AND #$02
                BNE Check_P12
                ; ORFNLF(P(1,2))>1
                LDA P12
                AND #$08
                BNE Check_P12
                ; L%=22:W=FNLF(P(0,3)):GOSUB10075
Draw_P03_Y      LDA #$16
                STA IntL
                LDA P03
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNLF(P(1,2))>1
Check_P12       LDA P12
                AND #$08
                BNE Check_P21_P22
                ; L%=256:W=FNUP(P(1,2)):GOSUB10050
Draw_P12_X      LDA #$00
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P12
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; L%=262:W=FNLF(P(1,3)):GOSUB10075
Draw_P13_Y      LDA #$06
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P13
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; L%=496:W=FNUP(P(2,2)):GOSUB10050
Draw_P22_X      LDA #$F0
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P22
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; IFFNUP(P(2,1))>1
Check_P21_P22   LDA P21
                AND #$02
                BNE Check_P22_P12
                ; ORFNLF(P(2,2))>1
                LDA P22
                AND #$08
                BNE Check_P22_P12
                ; L%=736:W=FNUP(P(3,2)):GOSUB10050
Draw_P32_X      LDA #$E0
                STA IntL
                LDA #$02
                STA IntL + 1
                LDA P32
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; IFFNUP(P(2,2))>1
Check_P22_P12   LDA P22
                AND #$02
                BNE Check_P21
                ; ORFNLF(P(1,2))>1
                LDA P12
                AND #$08
                BNE Check_P21
                ; L%=502:W=FNLF(P(2,3)):GOSUB10075
Draw_P23_Y      LDA #$F6
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P23
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNUP(P(2,1))>1
Check_P21       LDA P21
                AND #$02
                BNE Check_P21_P21
                ; L%=496:W=FNLF(P(2,2)):GOSUB10075
Draw_P22_Y      LDA #$F0
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P22
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; L%=730:W=FNUP(P(3,1)):GOSUB10050
Draw_P31_X      LDA #$DA
                STA IntL
                LDA #$02
                STA IntL + 1
                LDA P31
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; L%=490:W=FNLF(P(2,1)):GOSUB10075
Draw_P21_Y      LDA #$EA
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P21
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNUP(P(2,1))>1
Check_P21_P21   LDA P21
                AND #$02
                BNE Check_P20_P11
                ; ORFNLF(P(2,1))>1
                LDA P21
                AND #$08
                BNE Check_P20_P11
                ; L%=724:W=FNUP(P(3,0)):GOSUB10050
Draw_P30_X      LDA #$D4
                STA IntL
                LDA #$02
                STA IntL + 1
                LDA P30
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; IFFNUP(P(2,0))>1
Check_P20_P11   LDA P20
                AND #$02
                BNE Check_P11_LF
                ; ORFNLF(P(1,1))>1
                LDA P11
                AND #$08
                BNE Check_P11_LF
                ; L%=484:W=FNLF(P(2,0)):GOSUB10075
Draw_P20_Y      LDA #$E4
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P20
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; IFFNLF(P(1,1))>1
Check_P11_LF    LDA P11
                AND #$08
                BNE Draw_P11_Y
                ; L%=484:W=FNUP(P(2,0)):GOSUB10050
Draw_P20_X      LDA #$E4
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P20
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; L%=244:W=FNLF(P(1,0)):GOSUB10075
Draw_P10_Y      LDA #$F4
                STA IntL
                LDA #$00
                STA IntL + 1
                LDA P10
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; W=FNUP(P(1,0)):GOSUB10050
Draw_P10_X      LDA P10
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; L%=250:W=FNLF(P(1,1)):GOSUB10075
Draw_P11_Y      LDA #$FA
                STA IntL
                LDA #$00
                STA IntL + 1
                LDA P11
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; W=FNUP(P(1,1)):GOSUB10050
Draw_P11_X      LDA P11
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; L%=256:W=FNLF(P(1,2)):GOSUB10075
Draw_P12_Y      LDA #$00
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P12
                LSR
                LSR
                AND #$03
                STA IntW
                JSR Draw_Wall_Y
                ; L%=490:W=FNUP(P(2,1)):GOSUB10050
Draw_P21_X      LDA #$EA
                STA IntL
                LDA #$01
                STA IntL + 1
                LDA P21
                AND #$03
                STA IntW
                JSR Draw_Wall_X
                ; Return to BASIC
                RTS

; ------------------------------------------------------------------------------
; Calculate Seed Values for Re-Plot
; ------------------------------------------------------------------------------

; ------------------------------------ X+XO ------------------------------------

                ; Put X in FAC1
Calculate_Seed  LDA #$00
                LDY IntX
                JSR $B391
                ; Put XO pointer in AY
                LDA #<FloatXO
                LDY #>FloatXO
                ; Add FAC1 to memory
                JSR $B867
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ------------------------------------ Y+YO ------------------------------------

                ; Put Y in FAC1
                LDA #$00
                LDY IntY
                JSR $B391
                ; Put YO pointer in AY
                LDA #<FloatYO
                LDY #>FloatYO
                ; Add FAC1 to memory
                JSR $B867
                ; Round FAC1
                JSR $BC1B

; ------------------------------- (X+XO)*(Y+YO) --------------------------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ------------------------------------ Z+ZO ------------------------------------

                ; Put Z in FAC1
                LDA #$00
                LDY IntZ
                JSR $B391
                ; Put ZO pointer in AY
                LDA #<FloatZO
                LDY #>FloatZO
                ; Add FAC1 to memory
                JSR $B867
                ; Round FAC1
                JSR $BC1B

; ---------------------------- (X+XO)*(Y+YO)*(Z+ZO) ----------------------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ------------------------------------ X*XO ------------------------------------

                ; Put X in FAC1
                LDA #$00
                LDY IntX
                JSR $B391
                ; Put XO pointer in AY
                LDA #<FloatXO
                LDY #>FloatXO
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Round FAC1
                JSR $BC1B

; ------------------------ X*XO + (X+XO)*(Y+YO)*(Z+ZO) -------------------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Add FAC1 to memory
                JSR $B867
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ------------------------------------ Y*YO ------------------------------------

                ; Put Y in FAC1
                LDA #$00
                LDY IntY
                JSR $B391
                ; Put YO pointer in AY
                LDA #<FloatYO
                LDY #>FloatYO
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Round FAC1
                JSR $BC1B

; ----------------------- X*XO+Y*YO + (X+XO)*(Y+YO)*(Z+ZO) ---------------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Add FAC1 to memory
                JSR $B867
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ------------------------------------ Z*ZO ------------------------------------

                ; Put Z in FAC1
                LDA #$00
                LDY IntZ
                JSR $B391
                ; Put ZO pointer in AY
                LDA #<FloatZO
                LDY #>FloatZO
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Round FAC1
                JSR $BC1B

; ------------------ Q = X*XO+Y*YO+Z*ZO + (X+XO)*(Y+YO)*(Z+ZO) -----------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Add FAC1 to memory
                JSR $B867
                ; Round FAC1
                JSR $BC1B
                ; Store FAC1 in floatQ with rounding
                LDX #<FloatQ
                LDY #>FloatQ
                JSR $BBD4

; ----------------------------------- INT(Q) -----------------------------------

                ;Perform INT()
                JSR $BCCC

; --------------------------------- Q - INT(Q) ---------------------------------

                ; Put FloatQ pointer in AY
                LDA #<FloatQ
                LDY #>FloatQ
                ; Subtract FAC1 from memory
                JSR $B850
                ; Round FAC1
                JSR $BC1B

; ---------------------------- H% = (Q - INT(Q))*W0 ----------------------------

                ; Put W0 pointer in AY
                LDA #<FloatW0
                LDY #>FloatW0
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Round FAC1
                JSR $BC1B
                ; Convert FAC1 to Unsigned INT
                JSR $B7F7
                ; Store result to IntH
                LDA $14
                STA IntH
                LDA $15
                STA IntH + 1

; ----------------------------- IF FNS(H%)>#$05 --------------------------------

                CLC
                LDA $15
                CMP #$06
                BCC Check_H_Low

; -------------------------------- H% AND TH -----------------------------------

                LDA #$00
                STA IntH + 1

; ----------------------------- IF INT(H%/TF)>0 --------------------------------

Check_H_Low     LDA IntH + 1
                BEQ Jump_Gate_X
                JMP Q_x_10
Jump_Gate_X     JMP Check_X_Bounds

; ---------------------------------- Q*10 --------------------------------------

                ; Copy FloatScratch into FAC1
Q_x_10          LDA #<FloatQ
                LDY #>FloatQ
                JSR $BBA2
                ; Multiply FAC1 by 10
                JSR $BAE2
                ; Round FAC1
                JSR $BC1B
                ; Store FAC1 in FloatScratch
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD7

; -------------------------------- INT(Q*10) -----------------------------------

                ;Perform INT()
                JSR $BCCC

; ------------------------------ Q*10-INT(Q*10) --------------------------------

                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Subtract FAC1 from memory
                JSR $B850
                ; Store FAC1 in FloatScratch with rounding
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; --------------------------- (Q*10-INT(Q*10))*15 ------------------------------

                LDA #$00
                LDY #$0F
                ; (convert INT (AY) to Float in FAC1)
                JSR $B391
                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Round FAC1
                JSR $BC1B
                ; Store FAC1 in FloatScratch
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; -------------------------- (Q*10-INT(Q*10))*15+1 -----------------------------

                LDA #$BC
                LDY #$B9
                ; Add FAC1 to memory
                JSR $B867
                ; Round FAC1
                JSR $BC1B

; ------------------------ INT(Q*10-INT(Q*10))*15+1) ---------------------------

                ;Perform INT()
                JSR $BCCC
                ; Store FAC1 in FloatScratch
                LDX #<FloatScratch
                LDY #>FloatScratch
                JSR $BBD4

; ---------------------- INT(Q*10-INT(Q*10))*15+1)*TF --------------------------

                LDA #$01
                LDY #$00
                ; (convert INT (AY) to Float in FAC1)
                JSR $B391
                ; Put FloatScratch pointer in AY
                LDA #<FloatScratch
                LDY #>FloatScratch
                ; Multiply FAC1 with memory
                JSR $BA28
                ; Copy FAC1 to FAC2
                JSR $BC0C

; -------------------------------- (H%ANDTH) -----------------------------------

                LDY IntH
                LDA #$00
                ; (convert INT (AY) to Float in FAC1)
                JSR $B391

; -------------- H%=(INT(Q*10-INT(Q*10))*15+1)*TF)OR(H%ANDTH) ------------------

                ; FAC1 OR FAC2 -> FAC1
                JSR $AFE6
                ; Convert FAC1 to Unsigned INT
                JSR $B7F7
                ; Store result to IntH
                LDA $14
                STA IntH
                LDA $15
                STA IntH + 1

; ------------------------------- IFX=1ORX=201 ---------------------------------

Check_X_Bounds  LDA #$01
                CMP IntX
                BEQ Modify_X_Wall
                LDA #$C9
                CMP IntX
                BNE Check_Y_Bounds

; ------------------------------ THENH%=H%OR12 ---------------------------------

Modify_X_Wall   LDA IntH
                ORA #$0C
                STA IntH

; ------------------------------- IFY=1ORY=201 ---------------------------------

Check_Y_Bounds  LDA #$01
                CMP IntY
                BEQ Modify_Y_Wall
                LDA #$C9
                CMP IntY
                BNE Exit_Seed_Calc

; ------------------------------- THENH%=H%OR3 ---------------------------------

Modify_Y_Wall   LDA IntH
                ORA #$03
                STA IntH

; --------------------------------- RETURN -------------------------------------

Exit_Seed_Calc  RTS

; ------------------------------------------------------------------------------
; Sprite Handler
; ------------------------------------------------------------------------------

ConfigStart = Sprite_Config
CoordsStart = Sprite_Coords
Sprite0Pointer = VideoMatrix + $3F8

SpriteEnableRegister = $D015
SpriteForegroundPriorityRegister = $D01B
SpriteMulticolorEnableRegister = $D01C
SpriteExpandXRegister = $D01D
SpriteExpandYRegister = $D017
SpriteMulticolor0Register = $D025
SpriteMulticolor1Register = $D026
SpriteColor0Register = $D027
Sprite0HorizontalPositionRegister = $D000
Sprite0VerticalPositionRegister = $D001

SpriteGroup = $02BB
GroupIndex = SpriteGroup + 1
Record = GroupIndex + 1
SpritePointer = Record + 2
ControlBit1 = SpritePointer + 1
ControlBit2 = ControlBit1 + 1
ControlBit3 = ControlBit2 + 1
Coordinates = ControlBit3 + 1
SpriteMulticolorEnable = Coordinates + 1
SpriteEnable = SpriteMulticolorEnable + 1
Sprite0Color = SpriteEnable + 1
CoordinatePointer = Sprite0Color + 8

Sprite_Handler  LDA SpriteGroup
                CMP #$01
                BEQ Calc_Index_1
                CMP #$02
                BEQ Calc_Index_2
                CMP #$03
                BEQ Calc_Index_3
                CMP #$04
                BEQ Calc_Index_4
                CLC
                LDA #$26
                ADC GroupIndex
                JMP Get_Entry_Pntr
Calc_Index_1    DEC GroupIndex
                LDA GroupIndex
                JMP Get_Entry_Pntr
Calc_Index_2    CLC
                LDA #$13
                ADC GroupIndex
                JMP Get_Entry_Pntr
Calc_Index_3    CLC
                LDA #$19
                ADC GroupIndex
                JMP Get_Entry_Pntr
Calc_Index_4    CLC
                LDA #$22
                ADC GroupIndex
Get_Entry_Pntr  STA $FB
                LDA #$0C
                STA $FC
                JSR Multiply_8
                LDA #<ConfigStart
                STA $FB
                LDA #>ConfigStart
                STA $FC
                JSR Add_16
                LDA $02FE
                STA $FB
                LDA $02FF
                STA $FC
Read_Record     LDY #$00
                ; Get Sprite Pointer field from record
                LDA ($FB),Y
                STA SpritePointer
                ; Get Control field from record
                INY
                LDA ($FB),Y
                AND #$20
                STA ControlBit1
                LDA ($FB),Y
                AND #$40
                STA ControlBit2
                LDA ($FB),Y
                AND #$80
                STA ControlBit3
                ; Get Coordinates field from record
                LDA ($FB),Y
                AND #$1F
                STA Coordinates
                ; Get Foreground Priority field from record
                INY
                LDA ($FB),Y
                STA SpriteForegroundPriorityRegister
                ; Get Expand X field from record
                INY
                LDA ($FB),Y
                LDX ControlBit3
                BEQ Enable_Hor_Exp
                ORA SpriteExpandXRegister
Enable_Hor_Exp  STA SpriteExpandXRegister
                ; Get Expand Y field from record
                INY
                LDA ($FB),Y
                LDX ControlBit3
                BEQ Enable_Ver_Exp
                ORA SpriteExpandYRegister
Enable_Ver_Exp  STA SpriteExpandYRegister
                ; Get Multicolor field from record
                INY
                LDA ($FB),Y
                STA SpriteMulticolorEnable
                LDX ControlBit2
                BEQ Enable_MC
                ORA SpriteMulticolorEnableRegister
Enable_MC       STA SpriteMulticolorEnableRegister
                ; Get Sprite Enable field from record
                INY
                LDA ($FB),Y
                STA SpriteEnable
                ; Set multicolor sprite colors
                INY
                LDA SpriteMulticolorEnable
                BEQ Init_Sprite_Clr
                LDA ($FB),Y
                AND #$F0
                CLC
                LSR
                LSR
                LSR
                LSR
                STA SpriteMulticolor0Register
                LDA ($FB),Y
                AND #$0F
                STA SpriteMulticolor1Register
                ; Get Sprite Color fields from record
Init_Sprite_Clr INY
                STY $FD
                LDA #$00
                STA $FE
                JSR Add_16
                LDA $02FE
                STA $FB
                LDA $02FF
                STA $FC
                LDY #$03
                LDX #$07
Get_Sprite_Clr  LDA ($FB),Y
                AND #$0F
                STA Sprite0Color,X
                DEX
                LDA ($FB),Y
                LSR
                LSR
                LSR
                LSR
                AND #$0F
                STA Sprite0Color,X
                DEX
                DEY
                BPL Get_Sprite_Clr
                ; Set Sprite Colors
                LDY #$08
                LDA #$00
                STA $02
                SEC
Sprite_Colors   ROR $02
                BEQ Calc_Coord_Pntr
                DEY
                LDA SpriteEnable
                AND $02
                BEQ Sprite_Colors
                LDA Sprite0Color,Y
                STA SpriteColor0Register,Y
                JMP Sprite_Colors
                ; Set pointer to coordinate data
Calc_Coord_Pntr LDA Coordinates
                BNE Coord_Table
                LDY Sprite0HorizontalPositionRegister + 2
                STY Sprite0HorizontalPositionRegister
                LDY Sprite0VerticalPositionRegister + 2
                STY Sprite0VerticalPositionRegister
                JMP Set_Pointers
Coord_Table     SEC
                SBC #$01
                STA $FB
                LDA #$10
                STA $FC
                JSR Multiply_8
                LDA #<CoordsStart
                STA $FB
                LDA #>CoordsStart
                STA $FC
                JSR Add_16
                LDA $02FE
                STA $FB
                LDA $02FF
                STA $FC
                ; Initialize loop to read coordinates record
Set_Coordinates LDA #<Sprite0HorizontalPositionRegister
                STA $FD
                LDA #>Sprite0HorizontalPositionRegister
                STA $FE
                LDY #$00
                LDA #$00
                STA $02
                SEC
                ; Get record and set coordinates and pointers for active sprites in object
Coord_Loop      ROL $02
                BEQ Set_Pointers
                LDA SpriteEnable
                AND $02
                BEQ Skip_Coords
                LDA ($FB),Y
                STA ($FD),Y
                INY
                LDA ($FB),Y
                STA ($FD),Y
                INY
                JMP Coord_Loop
Skip_Coords     INY
                INY
                JMP Coord_Loop
                ; Display object
Set_Pointers    LDA #<Sprite0Pointer
                STA $FB
                LDA #>Sprite0Pointer
                STA $FC
                LDX SpritePointer
                LDA #$00
                STA $02
                TAY
                SEC
Pointer_Loop    ROL $02
                BEQ Enable_Sprites
                LDA SpriteEnable
                AND $02
                BEQ Skip_Pointer
                TXA
                STA ($FB),Y
                INX
Skip_Pointer    INY
                JMP Pointer_Loop
Enable_Sprites  LDA ControlBit1
                BEQ Disable_Sprites
                LDA SpriteEnableRegister
                ORA SpriteEnable
                STA SpriteEnableRegister
                RTS
Disable_Sprites LDA SpriteEnable
                ORA #$E0
                STA SpriteEnableRegister
                RTS

; ------------------------------------------------------------------------------
; Draw Inn
; ------------------------------------------------------------------------------

                ; Set Color RAM Values
Draw_Inn        LDA #$0C
                STA $D880
                STA $D881
                STA $D94A
                STA $D94B
                STA $D972
                STA $D973
                STA $D974
                LDX #$A6
                STX $FB
                LDX #$D8
                STX $FC
                LDY #$05
                JSR Set_Screen_Area
                LDA #$02
                LDX #$CE
                STX $FB
                LDY #$05
                JSR Set_Screen_Area
                LDX #$F6
                STX $FB
                LDY #$05
                JSR Set_Screen_Area
                LDX #$1E
                STX $FB
                INC $FC
                LDY #$05
                JSR Set_Screen_Area
                LDA #$09
                STA $D922
                ; Copy Inn Video Matrix Data to Video Matrix
                LDX #$0E
                LDA #$0D
                STA $02
                LDA #<InnData
                STA $FB
                LDA #>InnData
                STA $FC
                LDA #<InnDataDest
                STA $FD
                LDA #>InnDataDest
                STA $FE
                JSR Copy_Line
                RTS
Set_Screen_Area STA ($FB),Y
                DEY
                BPL Set_Screen_Area
                RTS

; ------------------------------------------------------------------------------
; Explored Locations Handler
; ------------------------------------------------------------------------------

Track_Locations LDY #$64
                LDX #$02
Read_X_Coords   LDA #<LocationData
                STA $FB
                LDA #>LocationData
                STA $FC
Read_X_Loop     DEY
                BMI Store_Result
                LDA ($FB),Y
                CMP $02C5
                BNE Read_X_Loop
Read_Y_Coords   LDA #$64
                CLC
                ADC $FB
                STA $FB
                LDA #$00
                ADC $FC
                STA $FC
                LDA ($FB),Y
                CMP $02C6
                BNE Read_X_Coords
Read_Z_Coords   LDA #$64
                CLC
                ADC $FB
                STA $FB
                LDA #$00
                ADC $FC
                STA $FC
                LDA ($FB),Y
                CMP $02C9
                BNE Read_X_Coords
Location_Found  LDA #$01
                STA $02FD
                RTS
Store_Result    LDA #$00
                STA $02FD
Update_Log      LDY $02FC
                LDA #<LocationData
                STA $FB
                LDA #>LocationData
                STA $FC
                LDA $02C5
                STA ($FB),Y
                LDA #$64
                CLC
                ADC $FB
                STA $FB
                LDA #$00
                ADC $FC
                STA $FC
                LDA $02C6
                STA ($FB),Y
                LDA #$64
                CLC
                ADC $FB
                STA $FB
                LDA #$00
                ADC $FC
                STA $FC
                LDA $02C9
                STA ($FB),Y
                INY
                STY $02FC
                CPY #$64
                BNE Leave_Tracking
                LDY #$00
                STY $02FC
Leave_Tracking  RTS