10 PRINT"{clear}":POKE53280,0:POKE53281,0
20 POKE56,159:POKE644,159:CLR
30 SYS14548
40 PRINT"{clear}{white}{space*5}Avalon Hill presents:{down*3}":PRINT"{space*2}{reverse on}{cm +}{space*4}{cm m}{reverse off}"
50 PRINT"{space*3}{reverse on}{cm +}{cm m}{reverse off}{space*4}{reverse on}{cm +}{cm m}{reverse off}"TAB(38)"{reverse on}{cm +}{cm m}{reverse off}";
60 PRINT"{space*2}{reverse on}{cm +}{cm m}{cm +} {reverse off}{sh pound} {reverse on}{cm +}{cm m}{cm +} {reverse off}{sh pound} {reverse on}{cm +}{space*2}{reverse off}{sh pound} {reverse on}{cm +}{space*3}{cm m}{cm +}{space*3}{cm m}{reverse off} {reverse on}{cm +}{space*2}{reverse off}{sh pound}{reverse on}{cm +}{space*3}{cm m}{reverse off}"
70 PRINT" {reverse on}{cm +}{cm m}{cm +}{cm m}{cm n}{cm m}{cm +}{cm m}{cm +}{cm m}{cm n}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +} {reverse off} {reverse on}{cm +}{cm m}{reverse off}{space*2}{reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{reverse off}"
80 PRINT"{reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{cm n}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{cm n}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{space*2}{cm m}{reverse off} {reverse on}{cm pound}{space*2}{cm m} {cm +}{cm m}{reverse off}{space*3}{reverse on}{cm pound}{space*2}{cm m}{reverse off}"
90 PRINTTAB(19)"{reverse on}{cm +}{cm m}{reverse off}":PRINTTAB(16)"{reverse on}{cm +}{space*2}{cm m}{reverse off}"TAB(27)"{red}Remastered{white}{down}"
100 PRINTTAB(11)"(C)opyright 1983{down}"
!-------------------------------------------------------------------------------
!- Load "Disk Telengard" and run it
!-------------------------------------------------------------------------------
110 PRINT"{down}{right*5}{reverse on}{blue}Please wait while loading{down*2}"
120 PRINT"{black}load ";CHR$(34);"disk telengard";CHR$(34);",8{down*4}"
130 PRINT"run{up*8}{black}"
140 POKE631,13:POKE632,13:POKE198,2
150 END
!-------------------------------------------------------------------------------
!- Script to merge binary data and ML routines with this .prg file
!-------------------------------------------------------------------------------
!-
!-#!/bin/bash
!-
!-TELENGARD_PATH="${HOME}/var/docs/computers/Games/Telengard"
!-SOURCE_DIR="${TELENGARD_PATH}/remastered/builds"
!-DEST_DIR="${TELENGARD_PATH}/remastered/merge"
!-
!-cp "${SOURCE_DIR}/telengard.prg" "${DEST_DIR}/"
!-cat "${SOURCE_DIR}/telengard-character-set - lower.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-character-set - upper.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-sprites.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-inn.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-sprite-config.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-sprite-coordinates.bin" >> "${DEST_DIR}/telengard.prg"
!-cat "${SOURCE_DIR}/telengard-music.bin" >> "${DEST_DIR}/telengard.prg"
!-tail -c +3 "${SOURCE_DIR}/disk-telengard-ml.prg" >> "${DEST_DIR}/telengard.prg"
!-tail -c +3 "${SOURCE_DIR}/telengard-ml.prg" >> "${DEST_DIR}/telengard.prg"