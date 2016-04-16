*=$38D4

CharGenRAM = $F800
VideoMatrix = $CC00

BASIC_Length = 559              ; Length of BASIC Program
CP1_Length = 288                ; Length of Character Patch 1 (CP1)
CP2_Length = 224                ; Length of Character Patch 2 (CP2)
Sprites_Length = 7744           ; Length of Sprite Graphics Data
Sprite_Config_Length = 504      ; Length of Sprite Config Data
Sprite_Coordinates_Length = 240 ; Length of Sprite Coordinate Data
Inn_Video_Matrix_Length = 182   ; Length of Inn Video Matrix Data
Music_Length = 250              ; Length of Music Data
ML_Game_Routines_Length = 2509  ; Length of ML Game Routines

CP1_Source = 2048 + BASIC_Length
CP1_Dest = CharGenRAM + $2E0
CP2_Source = CP1_Source + CP1_Length
CP2_Dest = CharGenRAM + $720

Sprites_Source = CP2_Source + CP2_Length
Sprites_Dest = $D000

Inn_Video_Matrix_Source = Sprites_Source + Sprites_Length
Inn_Video_Matrix_Dest = $0400

Sprite_Control_Source = Inn_Video_Matrix_Source + Inn_Video_Matrix_Length
Sprite_Control_Dest = Inn_Video_Matrix_Dest + Inn_Video_Matrix_Length
Sprite_Control_Length = Sprite_Config_Length + Sprite_Coordinates_Length

Music_Source = Sprite_Control_Source + Sprite_Control_Length
Music_Dest = $9F00

ML_Game_Routines_Source = Music_Source + Music_Length
ML_Game_Routines_Dest = $C000

; Constants for ML Routines

XOExp = #$81
XOMantissa_4 = #$58
XOMantissa_3 = #$83
XOMantissa_2 = #$12
XOMantissa_1 = #$6E

YOExp = #$81
YOMantissa_4 = #$36
YOMantissa_3 = #$C2
YOMantissa_2 = #$26
YOMantissa_1 = #$82

ZOExp = #$81
ZOMantissa_4 = #$1F
ZOMantissa_3 = #$83
ZOMantissa_2 = #$7B
ZOMantissa_1 = #$4A

W0Exp = #$8D
W0Mantissa_4 = #$12
W0Mantissa_3 = #$B0
W0Mantissa_2 = #$00
W0Mantissa_1 = #$00

FloatXO = $02A7
FloatYO = FloatXO + 5
FloatZO = FloatYO + 5
FloatW0 = FloatZO + 5

; ------------------------------------------------------------------------------
; Initialize Telengard
; ------------------------------------------------------------------------------

; Clear Future Video Matrix

                LDA #<VideoMatrix
                STA $FD
                LDA #>VideoMatrix
                STA $FE
                LDX #$04
                LDY #$00
                LDA #$20
ClearVideoLoop  STA ($FD),Y
                INY
                BNE ClearVideoLoop
                INC $FE
                DEX
                BNE ClearVideoLoop

; Copy Character ROM to RAM

                SEI
                LDA $01                 ; Switch Character ROM in
                AND #$FB
                STA $01
                LDA #$00
                STA $FB
                STA $FD
                LDA #$D8
                STA $FC
                LDA #>CharGenRAM
                STA $FE
Loop1           LDY #$00                ; Copy characters from ROM to RAM
Loop2           LDA ($FB),Y
                STA ($FD),Y
                INY
                BNE Loop2
                INC $FC
                INC $FE
                LDA $FE
                CMP #$00
                BNE Loop1
                LDA $01                 ; Switch Character ROM out
                ORA #$04
                STA $01
                CLI

; Select VIC-II Bank 3 and setup Video Matrix and Character Set pointer

                LDA $DD02               ; Set CIA#2 Data Port Bits 0 and 1 to output
                ORA #$03
                STA $DD02
                LDA $DD00               ; Point VIC-II to bank 3
                AND #$FC
                STA $DD00
                LDA #$3E                ; Set VIC-II Character Memory and Video Matrix pointers
                STA $D018
                LDA #>VideoMatrix       ; Set BASIC Top Page of Screen Memory
                STA $0288

; Apply Character Set Patch #1

                LDA #<CP1_Length
                STA $02
                LDX #>CP1_Length
                LDA #<CP1_Source
                STA $FB
                LDA #>CP1_Source
                STA $FC
                LDA #<CP1_Dest
                STA $FD
                LDA #>CP1_Dest
                STA $FE
                JSR BlockCopy

; Apply Character Set Patch #2

                LDA #<CP2_Length
                STA $02
                LDX #>CP2_Length
                LDA #<CP2_Source
                STA $FB
                LDA #>CP2_Source
                STA $FC
                LDA #<CP2_Dest
                STA $FD
                LDA #>CP2_Dest
                STA $FE
                JSR BlockCopy

; Install Sprites

                SEI
                LDA $01                 ; Switch Kernal ROM and I/O out
                AND #$F9
                STA $01
                LDA #<Sprites_Length
                STA $02
                LDX #>Sprites_Length
                LDA #<Sprites_Source
                STA $FB
                LDA #>Sprites_Source
                STA $FC
                LDA #<Sprites_Dest
                STA $FD
                LDA #>Sprites_Dest
                STA $FE
                JSR BlockCopy
                LDA $01                 ; Switch Kernal ROM and I/O back in
                ORA #$06
                STA $01
                CLI

; Install Sprite Config

                LDA #<Sprite_Control_Length
                STA $02
                LDX #>Sprite_Control_Length
                LDA #<Sprite_Control_Source
                STA $FB
                LDA #>Sprite_Control_Source
                STA $FC
                LDA #<Sprite_Control_Dest
                STA $FD
                LDA #>Sprite_Control_Dest
                STA $FE
                JSR BlockCopy

; Install Inn Video Matrix Data

                LDA #<Inn_Video_Matrix_Length
                STA $02
                LDX #>Inn_Video_Matrix_Length
                LDA #<Inn_Video_Matrix_Source
                STA $FB
                LDA #>Inn_Video_Matrix_Source
                STA $FC
                LDA #<Inn_Video_Matrix_Dest
                STA $FD
                LDA #>Inn_Video_Matrix_Dest
                STA $FE
                JSR BlockCopy

; Install Music

                LDA #<Music_Length
                STA $02
                LDX #>Music_Length
                LDA #<Music_Source
                STA $FB
                LDA #>Music_Source
                STA $FC
                LDA #<Music_Dest
                STA $FD
                LDA #>Music_Dest
                STA $FE
                JSR BlockCopy

; Install ML Routines Set 1

                LDA #<ML_Game_Routines_Length
                STA $02
                LDX #>ML_Game_Routines_Length
                LDA #<ML_Game_Routines_Source
                STA $FB
                LDA #>ML_Game_Routines_Source
                STA $FC
                LDA #<ML_Game_Routines_Dest
                STA $FD
                LDA #>ML_Game_Routines_Dest
                STA $FE
                JSR BlockCopy

; Setup Constants for ML Routines

                LDA XOExp
                STA FloatXO
                LDA XOMantissa_4
                STA FloatXO + 1
                LDA XOMantissa_3
                STA FloatXO + 2
                LDA XOMantissa_2
                STA FloatXO + 3
                LDA XOMantissa_1
                STA FloatXO + 4

                LDA YOExp
                STA FloatYO
                LDA YOMantissa_4
                STA FloatYO + 1
                LDA YOMantissa_3
                STA FloatYO + 2
                LDA YOMantissa_2
                STA FloatYO + 3
                LDA YOMantissa_1
                STA FloatYO + 4

                LDA ZOExp
                STA FloatZO
                LDA ZOMantissa_4
                STA FloatZO + 1
                LDA ZOMantissa_3
                STA FloatZO + 2
                LDA ZOMantissa_2
                STA FloatZO + 3
                LDA ZOMantissa_1
                STA FloatZO + 4

                LDA W0Exp
                STA FloatW0
                LDA W0Mantissa_4
                STA FloatW0 + 1
                LDA W0Mantissa_3
                STA FloatW0 + 2
                LDA W0Mantissa_2
                STA FloatW0 + 3
                LDA W0Mantissa_1
                STA FloatW0 + 4

; Return to BASIC

                RTS

; ------------------------------------------------------------------------------
; Copy Memory Block
; ------------------------------------------------------------------------------

; $02 = Low Byte of 16-bit Block Size
; X = High Byte of 16-bit Block Size
; $FB = Low Byte of 16-bit Source Address
; $FC = High Byte of 16-bit Source Address
; $FD = Low Byte of 16-bit Destination Address
; $FE = High Byte of 16-bit Destination Address

BC_Source = $FB
BC_Dest = $FD
BC_Size = $02

BlockCopy       LDY #$00
                CPX #$00
                BEQ SetupSmallCopy
PageCopy        LDA ($FB),Y
                STA ($FD),Y
                INY
                BNE PageCopy
                INC $FC
                INC $FE
                DEX
                BNE PageCopy
SetupSmallCopy  LDX $02
                BEQ ExitBlockCopy
SmallCopy       LDA ($FB),Y
                STA ($FD),Y
                INY
                DEX
                BNE SmallCopy
ExitBlockCopy   RTS
