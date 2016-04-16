1 REM TELENGARD/64 V4.18 (C)COPYRIGHT 1981 ORION SOFTWARE - ALL RIGHTS RESERVED
2 REM Telengard Remastered v1.0 - 2016-02-09 - Remastering by Eric B. Pratt
3 GOSUB905:GOTO113
!-------------------------------------------------------------------------------
!- Generate Dungeon View
!-------------------------------------------------------------------------------
!- set border color to medium gray if Time Stop is active; black otherwise
4 POKEBD,0:IFSF(9)>0THENPOKEBD,12
!- Display all Player sprites and set Player Sprite color to black if invisible
5 SYSRA:POKESG,5:POKEGI,1:SYSDS:IFSF(6)>0THENPOKEC9+7,0:POKEC9+6,0:POKEC9+5,0
!- Draw dungeon and set some grid values for later use
6 POKE709,CX:POKE710,CY:POKE713,CZ:SYSRP:P12=PEEK(740):P21=PEEK(746)
!- Decide if light spell is active.  If so, render it.
7 IFSF(3)>0THENSYSRL
!- Fall through to Spell Effects status refresh
!-------------------------------------------------------------------------------
!- Refresh Spell Effects Status
!-------------------------------------------------------------------------------
8 GOSUB106:PRINT"{up*2}{blue}":FORI=1TO11:IFSF(I)<1THEN11
9 IFPOS(0)>19THENPRINT:PRINT"{up*2}{blue}";
10 PRINTMID$("STRGDTRPLGHTPROTLEVTINVSFEARASTWTMSTRSEDDRNK",I*4-3,4)":";
11 NEXT:PRINT"{white}";:L%=PEEK(739)*TF+PEEK(738):RETURN
!-------------------------------------------------------------------------------
!- Load Character Menu
!-------------------------------------------------------------------------------
12 PRINT:PRINT:PRINT"{white}Loading character list";
!-------------------------------------------------------------------------------
!- Get List of Sequential Files
!-------------------------------------------------------------------------------
13 A=0:OPEN1,8,0,"$":FORN=1TO28:GET#1,W$:NEXT
14 GET#1,W$,W$,W$,W$
15 IFSTTHEN22
16 GET#1,W$:IFW$<>Q$THEN15
17 GET#1,X$
18 GET#1,W$:IFW$<>Q$THENX$=X$+W$:GOTO18
19 GET#1,W$:IFW$="s"THENPRINT" .";:E$(A)=X$:A=A+1:IFA>MMTHEN22
20 IFW$<>""THEN19
21 GOTO14
22 CLOSE1
23 PRINT"{clear}{down*2}{reverse on}{light gray}  Character Name    Level    Permadeath {reverse off}"
!-------------------------------------------------------------------------------
!- Check for Available Characters
!-------------------------------------------------------------------------------
24 IFA>0THEN29
25 PRINTTAB(9)"{light green}No characters on disk!{light gray}"
26 PRINT"{down}"TAB(8)"Press any key to go back"
27 GETC$:IFC$=""THEN27
28 RETURN
!-------------------------------------------------------------------------------
!- Get Character Information and Display Menu
!-------------------------------------------------------------------------------
29 TC=0:FORI=0TOA-1:OPEN2,8,15:OPEN1,8,3,"0:"+E$(I)+",s,r":INPUT#2,ER,ER$
30 IFER<>0THENCLOSE1:CLOSE2:NEXT
31 INPUT#1,TN$:INPUT#1,TV:IFTV=4.18THEN33
32 CLOSE1:CLOSE2:NEXT
33 TC$(I,0)=E$(I)
34 TC$(I,1)=TN$:IFLEFT$(TN$,2)="sv"THENTC$(I,1)=MID$(TN$,3)
35 FORJ=0TO5:INPUT#1,CQ:NEXT:INPUT#1,TC$(I,2):CLOSE1:CLOSE2
36 TC$(I,3)="Yes":IFLEFT$(TN$,2)="sv"THENTC$(I,3)="No"
37 PRINT"{green} "TC$(I,1)TAB(22)TC$(I,2)TAB(33)TC$(I,3):TC=TC+1:NEXT
!-------------------------------------------------------------------------------
!- Make Menu Interactive
!-------------------------------------------------------------------------------
38 IN=4:MT=IN+TC-1:J=2
39 TP=IN-4:IFJ=0THENPRINT"{up}":GOTO42
40 IFJ=1THENPRINT"{down}":GOTO42
41 PRINT"{home}";:FORI=1TOIN:PRINT"{down}";:NEXT
42 PRINT" {reverse on}{space*38}{reverse off}"
43 PRINT"{up} {reverse on}"TC$(TP,1)TAB(22)TC$(TP,2)TAB(33)TC$(TP,3)"{reverse off}"
44 GETC$:IFC$=""THEN44
45 IFC$=CHR$(13)THEND$=TC$(TP,1):PRINT"{clear}":RETURN
46 IFC$=CHR$(145)THEN51
47 IFC$=CHR$(17)THEN53
48 IFC$="d"THEN55
49 IFC$="b"THEN151
50 GOTO44
!- Move select bar up
51 IFIN=4THEN39
52 GOSUB61:IN=IN-1:GOTO39
!- Move select bar up
53 IFIN=MTTHEN39
54 GOSUB61:IN=IN+1:GOTO39
!- Delete Character
55 PRINT"{home}"TAB(10)"Are you sure? (Y/N)"
56 GETC$:IFC$=""THEN56
57 IFC$="y"THEN60
58 IFC$="n"THENPRINT"{home}"TAB(10)"{space*19}":GOTO39
59 GOTO56
60 OPEN1,8,15,"s0:"+TC$(TP,0):CLOSE1:GOTO13
!-------------------------------------------------------------------------------
!- Unselect Menu Option
!-------------------------------------------------------------------------------
61 PRINT"{up}{space*39}"
62 PRINT"{up} "TC$(TP,1)TAB(22)TC$(TP,2)TAB(33)TC$(TP,3):RETURN
!-------------------------------------------------------------------------------
!- Delay, Draw Room Feature, Clear Text, and Reposition Cursor
!-------------------------------------------------------------------------------
63 GOSUB65
!-------------------------------------------------------------------------------
!- Clear Text Output and Reposition Cursor
!-------------------------------------------------------------------------------
64 SYSC5:GOSUB106:RETURN
!-------------------------------------------------------------------------------
!- Delay 1 Second and Draw Room Feature
!-------------------------------------------------------------------------------
65 TI$="000000"
66 IFTI<60THEN66:IFANTHENGOSUB857
67 RETURN
!-------------------------------------------------------------------------------
!- Get User Command
!-------------------------------------------------------------------------------
68 POKE198,0
69 IFANTHEN852
70 FORQ=1TO400:GETC$:IFC$=""THEN75
71 IFC$<>CHR$(3)THENRETURN
72 POKEBD,2:PRINT"{pink}PAUSED{white}{left*6}";
73 GETC$:IFC$<>CHR$(3)THEN73
74 POKEBD,0:PRINT"{space*6}{left*6}";:GOTO69
75 NEXT:IFNM$="Demo"THEN69
76 C$="{cm +}":RETURN
!-------------------------------------------------------------------------------
!- Display Blank Character Sheet
!-------------------------------------------------------------------------------
77 PRINT"{home}":PRINTTAB(23)"{up}{light blue}"NP$
78 PRINTTAB(23)"{gray}Level":PRINTTAB(23)"STR"TAB(31)"CON"
79 PRINTTAB(23)"INT"TAB(31)"DEX":PRINTTAB(23)"WIS"TAB(31)"CHR"
80 PRINTTAB(23)"HP":PRINTTAB(23)"SU":PRINTTAB(23)"EX":PRINTTAB(23)"GD"
81 PRINTTAB(24)MA$(1):PRINTTAB(24)MA$(2):PRINTTAB(24)MA$(3):RETURN
!-------------------------------------------------------------------------------
!- Character Sheet Routines
!-------------------------------------------------------------------------------
!- Display Character Level
!-------------------------------------------------------------------------------
82 PRINT"{home}{down}{white}"TAB(28)STR$(LV)" ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Strength
!-------------------------------------------------------------------------------
83 POKESP,1:PRINT:PRINTTAB(26)STR$(S(0))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Intelligence
!-------------------------------------------------------------------------------
84 POKESP,1:PRINT:PRINTTAB(34)STR$(S(1))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Wisdom
!-------------------------------------------------------------------------------
85 POKESP,2:PRINT:PRINTTAB(26)STR$(S(2))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Constitution
!-------------------------------------------------------------------------------
86 POKESP,2:PRINT:PRINTTAB(34)STR$(S(3))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Dexterity
!-------------------------------------------------------------------------------
87 POKESP,3:PRINT:PRINTTAB(26)STR$(S(4))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Charisma
!-------------------------------------------------------------------------------
88 POKESP,3:PRINT:PRINTTAB(34)STR$(S(5))"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Hit Points
!-------------------------------------------------------------------------------
89 POKESP,4:PRINT:PRINTTAB(25)"{green}"STR$(CH)"{gray}/{white}"MID$(STR$(HP),2)"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Spell Units
!-------------------------------------------------------------------------------
90 POKESP,5:PRINT:PRINTTAB(25)"{purple}"STR$(CS)"{gray}/{white}"MID$(STR$(SU),2)"  ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Experience Points
!-------------------------------------------------------------------------------
91 C$=LEFT$(STR$(EX),14):POKESP,6:PRINT
92 PRINTTAB(25)"{white}";C$;LEFT$("{space*10}",14-LEN(C$)):GOTO106
!-------------------------------------------------------------------------------
!- Display Character Gold
!-------------------------------------------------------------------------------
93 C$=LEFT$(STR$(GD),14):POKESP,7:PRINT
94 PRINTTAB(25)"{white}";C$;LEFT$("{space*10}",14-LEN(C$)):GOTO106
!-------------------------------------------------------------------------------
!- Display Character Sword
!-------------------------------------------------------------------------------
95 IFI(1)>0THENPOKESP,8:PRINT:PRINTTAB(30)"+"MID$(STR$(I(1)),2);" ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Armor
!-------------------------------------------------------------------------------
96 IFI(2)>0THENPOKESP,9:PRINT:PRINTTAB(30)"+"MID$(STR$(I(2)),2);" ":GOTO106
!-------------------------------------------------------------------------------
!- Display Character Shield
!-------------------------------------------------------------------------------
97 IFI(3)>0THENPOKESP,10:PRINT:PRINTTAB(31)"+"MID$(STR$(I(3)),2);" ":GOTO106
!-------------------------------------------------------------------------------
!- Display Extra Inventory
!-------------------------------------------------------------------------------
98 POKESP,11:PRINT:FORI=4TO10:IFI<4THENIFI(I)>=0THEN100
99 IFI(I)<1THEN105
100 PRINTTAB(24);:IFI>7THEN104
101 PRINT"{gray}"MA$(I)"{white}";:IFI(I)>0THENPRINT" +"MID$(STR$(I(I)),2);" ";:GOTO103
102 PRINT"{space*4}";
103 PRINT:GOTO105
104 PRINTSTR$(I(I))" {gray}"MA$(I)   "{white}"
105 NEXT:PRINTTAB(23)"{space*16}";:GOTO106
!-------------------------------------------------------------------------------
!- Position cursor at column 1 row 21
!-------------------------------------------------------------------------------
106 PRINT"{home}{down*20}";:RETURN
!-------------------------------------------------------------------------------
!- TURN SOUND OFF
!-------------------------------------------------------------------------------
107 FORFQ=0TO24:POKEF+FQ,0:NEXT:RETURN
!-------------------------------------------------------------------------------
!- SETUP FOR SOUND EFFECT
!-------------------------------------------------------------------------------
108 FORFQ=0TO2:POKEF+5+FQ*7,18:POKEF+6+FQ*7,244:F(FQ)=17:NEXT:POKEFV,10:RETURN
!-------------------------------------------------------------------------------
!- Clear Monster Track
!-------------------------------------------------------------------------------
109 FORQ=1TO20:M%(Q)=0:L%(Q)=0:H%(Q)=0:NEXT:GOTO843
!-------------------------------------------------------------------------------
!- Clear Monster Encounter From Screen
!-------------------------------------------------------------------------------
110 POKESP,18:PRINT:PRINTTAB(21);"{space*17}"
111 GOSUB64:POKESE,TE:RETURN
!-------------------------------------------------------------------------------
!- Delay Loop
!-------------------------------------------------------------------------------
112 FORQ=1TO100:NEXT:RETURN
!-
!- ****************************************************************************
!- ******************                                        ******************
!- ******************           Main Program Start           ******************
!- ******************                                        ******************
!- ****************************************************************************
!-
!-------------------------------------------------------------------------------
!- Define Functions
!-------------------------------------------------------------------------------
113 DEFFNUP(H)=HAND3:DEFFNLF(H)=INT(H/4)AND3:DEFFNR(H)=INT(RND(1)*H+1)
114 DEFFNS(H)=INT(H/TF):DEFFNRD(H)=H-INT(H/10)*10
!-------------------------------------------------------------------------------
!- Define Floats
!-------------------------------------------------------------------------------
115 VB=250:FZ=53270:CL=55296:SP=214:WW=64256:IB=198:SC=52224:EL=51924
116 TF=256:TH=255:CP=53248:SL=53240:XX=CP+16:SE=CP+21:YE=CP+23:XE=CP+29
117 MC=CP+28:M1=CP+37:M2=CP+38:C9=CP+39:BK=CP+33:BD=CP+32:TE=224:SG=699:GI=700
118 JC=0:BM=49152:C5=BM+40:DV=BM+53:DC=BM+62:DP=BM+102:EP=BM+139:RL=BM+309
119 SA=BM+618:RA=BM+679:RP=BM+703:CR=BM+1414:DS=BM+1825:DI=BM+2266:TL=BM+2370
!-------------------------------------------------------------------------------
!- Define Strings
!-------------------------------------------------------------------------------
120 S$="STRINTWISCONDEXCHR":CM$="wxadshqpc82465{right}"+CHR$(20)+"{down}.{f1}{f3}{f5}{f7}"
121 MO$="gnoll{space*3}kobold{space*2}skeletonhobbit{space*2}zombie{space*2}orc{space*5}fighter mummy{space*3}"
122 MO$=MO$+"elf{space*5}ghoul{space*3}dwarf{space*3}troll{space*3}wraith{space*2}ogre{space*4}minotaur"
123 MO$=MO$+"giant{space*3}specter vampire demon{space*3}dragon{space*2}"
124 T$="refusesilvergold{space*2}gems{space*2}jewels":Q$=CHR$(34)
125 B$="red{space*3}yellowgreen blue"
!-------------------------------------------------------------------------------
!- DIM Arrays
!-------------------------------------------------------------------------------
126 MM=19:DIME$(MM),TC$(MM,3),S(5),SF(11),MI$(10),MA$(10),I(10),SP$(36)
127 DIMB(4),BW(23),PW(7),CL(5),NT%(59),F(2),M%(20),L%(20),H%(20),Z$(9,2),OH%(5)
128 DIMOK%(11)
!-------------------------------------------------------------------------------
!- Populate Selected Arrays
!-------------------------------------------------------------------------------
129 FORI=1TO36:READSP$(I):NEXT:FORI=0TO2:FORK=0TO9:READZ$(K,I):NEXTK,I
130 FORI=0TO23:READBW(I):NEXT:CL(1)=1:CL(2)=5:CL(3)=12:CL(4)=2:CL(5)=0
131 LC(1)=15:LC(2)=13:LC(3)=15:LC(4)=10:LC(5)=11
132 P1(0)=7:P1(1)=5:P1(2)=14:P1(3)=6:P1(4)=4:P1(5)=2:P1(6)=8
133 P2(0)=2:P2(1)=8:P2(2)=7:P2(3)=5:P2(4)=14:P2(5)=6:P2(6)=4
134 P3(0)=8:P3(1)=7:P3(2)=5:P3(3)=14:P3(4)=6:P3(5)=4:P3(6)=2
135 MI$(1)="sword":MA$(1)="Sword":MI$(2)="armor":MA$(2)="Armor"
136 MI$(3)="shield":MA$(3)="Shield":MI$(4)="elven cloak":MA$(4)="Elvn Clk"
137 MI$(5)="elven boots":MA$(5)="Elvn Bts":MI$(6)="ring of regeneration"
138 MA$(6)="Ring Reg":MI$(7)="ring of protection":MA$(7)="Ring Prot"
139 MI$(8)="scroll of rescue":MA$(8)="Scrl Resc":MI$(9)="potion of healing"
140 MA$(9)="Pot Heal":MI$(10)="potion of strength":MA$(10)="Pot Strg"
!-------------------------------------------------------------------------------
!- INIT CHAR GRAPHIC CHANGES
!-------------------------------------------------------------------------------
141 FORI=0TO23:POKEWW+I,BW(I):NEXT
!-------------------------------------------------------------------------------
!- Initialize Remaining Arrays
!-------------------------------------------------------------------------------
142 FORI=0TO7:PW(I)=2^I
143 NEXT:FORI=0TOMM:E$(I)="":FORJ=0TO3:TC$(I,J)="":NEXT:NEXT
144 FORI=0TO4:B(I)=0:NEXT:FORI=0TO5:S(I)=0:NEXT:FORI=0TO11:SF(I)=0:NEXT
145 FORI=0TO10:I(I)=0:NEXT:FORI=0TO59:NT%(I)=0:NEXT:FORI=0TO2:F(I)=0:NEXT
146 FORI=0TO20:M%(I)=0:L%(I)=0:H%(I)=0:NEXT
!-------------------------------------------------------------------------------
!- SETUP SOUND
!-------------------------------------------------------------------------------
147 F=54272:F1=F:F2=F+7:F3=F+14:FV=F+24:FT=40704:FC=40849:F4=F+4:F5=F+11
148 F6=F+18:I=8098:R=61176/64814:FORK=59TO0STEP-1:NT%(K)=INT(I):I=I*R:NEXT
149 POKEF+27,TH:FORQ=0TO24:POKEF+Q,0:NEXT
!-------------------------------------------------------------------------------
!- Initialize Sprites
!-------------------------------------------------------------------------------
150 POKE53274,0:POKESE,0:POKEM1,0:POKEM2,0:POKEXX,0:POKEXE,0:POKEYE,0:POKEMC,0
!-------------------------------------------------------------------------------
!- Title Screen
!-------------------------------------------------------------------------------
151 PRINT"{clear}{white}"TAB(11)"Welcome to{down*3}":PRINT"{space*2}{reverse on}{cm +}{space*4}{cm m}{reverse off}"
152 PRINT"{space*3}{reverse on}{cm +}{cm m}{reverse off}{space*4}{reverse on}{cm +}{cm m}{reverse off}"TAB(38)"{reverse on}{cm +}{cm m}{reverse off}";
153 PRINT"{space*2}{reverse on}{cm +}{cm m}{cm +} {reverse off}{sh pound} {reverse on}{cm +}{cm m}{cm +} {reverse off}{sh pound} {reverse on}{cm +}{space*2}{reverse off}{sh pound} {reverse on}{cm +}{space*3}{cm m}{cm +}{space*3}{cm m}{reverse off} {reverse on}{cm +}{space*2}{reverse off}{sh pound}{reverse on}{cm +}{space*3}{cm m}{reverse off}"
154 PRINT" {reverse on}{cm +}{cm m}{cm +}{cm m}{cm n}{cm m}{cm +}{cm m}{cm +}{cm m}{cm n}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{cm +}{cm m}{reverse off} {reverse on}{cm +} {reverse off} {reverse on}{cm +}{cm m}{reverse off}{space*2}{reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{reverse off}"
155 PRINT"{reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{cm n}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{cm n}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm +}{cm m}{reverse off} {reverse on}{cm pound}{space*2}{cm m}{reverse off} {reverse on}{cm pound}{space*2}{cm m} {cm +}{cm m}{reverse off}{space*3}{reverse on}{cm pound}{space*2}{cm m}{reverse off}"
156 PRINTTAB(19)"{reverse on}{cm +}{cm m}{reverse off}":PRINTTAB(16)"{reverse on}{cm +}{space*2}{cm m}{reverse off}"TAB(27)"{red}Remastered{white}"
157 PRINT"{down*2}Would you like to:":PRINT"{space*3}{reverse on}{cyan}S{white}{reverse off}tart a new character"
158 PRINT"{space*3}{reverse on}{cyan}R{white}{reverse off}ead in an old one";
159 GOSUB880:GOSUB69:I=RND(-TI):POKEFZ,200:SY=1:IFC$="{cm +}"THEN159
160 IFC$<>"r"THENPRINT:PRINT:PRINT"START":GOSUB65:GOTO181
!-------------------------------------------------------------------------------
!- Load Character
!-------------------------------------------------------------------------------
161 D$="":GOSUB12:IFD$=""THEN151
162 NM$=D$:PRINT:NP$=NM$:IFLEFT$(NM$,2)="sv"THENNP$=MID$(NM$,3)
163 OPEN2,8,15:OPEN1,8,3,"0:"+NP$+",s,r":INPUT#2,ER,ER$
164 IFER=0THEN167
165 PRINT"ERR=";ER;"{reverse on}";ER$:PRINT"%Cannot read this character from disk"
166 CLOSE1:CLOSE2:GOSUB65:GOTO115
167 INPUT#1,NM$:PRINTNP$" FOUND"
168 INPUT#1,VS:IFVS<4.18THENPRINT"%Incorect version character":GOTO166
169 FORI=0TO5:INPUT#1,S(I):NEXT
170 INPUT#1,LV:INPUT#1,GD:INPUT#1,TG:INPUT#1,EX:INPUT#1,CH:INPUT#1,HP
171 INPUT#1,CX:INPUT#1,CY:INPUT#1,CZ:INPUT#1,SU:INPUT#1,CS
172 FORI=1TO10:INPUT#1,I(I):INPUT#1,SF(I):NEXT:IFVS>4.13THENINPUT#1,SF(11)
173 FORI=1TO20:INPUT#1,M%(I):INPUT#1,L%(I):INPUT#1,H%(I):NEXT
174 GOSUB65:FORQ=1TO4:INPUT#1,B(Q):NEXT:FORI=0to299:INPUT#1,Q:POKEEL+I,Q:NEXT
175 INPUT#1,Q:POKE764,Q:IFCZ=0THENCZ=1
176 IFCZ<0THENPRINT"%You're not in Telengard":GOTO166
177 PRINT NP$;" READ":CLOSE1:IFLEFT$(NM$,2)="sv"THEN180
178 PRINT#2,"s0:";NP$:INPUT#2,ER,ER$
179 IFER<>1THENPRINT"ERR=";ER;"{reverse on}";ER$:PRINT"%Can't delete character":GOTO166
180 CLOSE2:GOSUB65:PRINT"{clear}";:SYSDC:GOSUB198:GOSUB843:GOTO201
!-------------------------------------------------------------------------------
!- Create Character
!-------------------------------------------------------------------------------
181 PRINT"{clear}<RET> to use stats"
182 FORI=0TO5:Q=0:FORQ1=1TO3:Q=Q+INT(RND(1)*6+1):NEXTQ1:S(I)=Q
183 PRINTMID$(S$,I*3+1,3);STR$(S(I));"{space*2}":NEXT
184 GOSUB68:IFC$<>CHR$(13)THEN181
185 HP=S(3):CH=HP:GD=0:TG=0:CZ=1:LV=1:FORI=1TO10:I(I)=0:SF(I)=0:NEXT:SF(11)=0
186 GOSUB638:CX=25:CY=13:EX=0:SU=1:CS=1:PRINT"{clear}"TAB(9);
187 PRINT"Your name, noble sire?":PRINT:PRINT"{space*11}";
188 GOSUB609:IFD$=""THEND$="Demo":PRINTD$
189 PRINT:PRINT:PRINT"Enable Permadeath? ";
190 GOSUB68:IFC$<>"y"ANDC$<>"n"THEN190
191 NM$=D$:IFC$="n"THENNM$="sv"+D$:PRINT"No":GOTO193
192 PRINT"Yes"
193 NP$=NM$:IFLEFT$(NM$,2)="sv"THENNP$=MID$(NM$,3)
194 FORI=0TO299:POKEEL+I,0:NEXT:POKE764,0
195 PRINT"{down}You are now descending into the"
196 PRINT"depths of the Telengard dungeon...":PRINT"{down*3}{reverse on}beware....{reverse off}";
197 GOSUB65:GOSUB65:PRINT"{clear}";:SYSDC:L=1:GOSUB198:GOSUB4:GOTO206
!-------------------------------------------------------------------------------
!- Draw Entire Character Sheet
!-------------------------------------------------------------------------------
198 GOSUB77:GOSUB82:GOSUB83:GOSUB84:GOSUB85:GOSUB86:GOSUB87:GOSUB88
199 GOSUB89:GOSUB90:GOSUB91:GOSUB93:GOSUB95:GOSUB96:GOSUB97:GOSUB98
200 RETURN
!-------------------------------------------------------------------------------
!- Start Next Turn
!-------------------------------------------------------------------------------
201 FORI=1TO11:SF(I)=SF(I)-1:NEXT:L=CZ:GOSUB8:GOSUB64:IFSY=1THENGOSUB4
!- Set view to re-plot and apply ring of rengeneration
202 POKE709,CX:POKE710,CY:POKE713,CZ:SYSTL:LS=PEEK(765)
203 SY=1:IFI(6)=0ORCH=HPTHEN206
204 CH=CH+I(6):IFCH>HPTHENCH=HP
205 GOSUB89
!-------------------------------------------------------------------------------
!- 30% Chance of Random Encounter
!-------------------------------------------------------------------------------
206 IFRND(1)>.3THEN300
!-------------------------------------------------------------------------------
!- If Invisible, 80% Chance of Going Unnoticed
!-------------------------------------------------------------------------------
207 IFSF(6)>0ANDRND(1)>.2THEN300
!-------------------------------------------------------------------------------
!- Generate Monster
!-------------------------------------------------------------------------------
!- No weak monsters if you have cast fear
208 AI=0:M=INT(RND(1)*20+1):IFSF(7)>0ANDM<5THEN208
!- Generate monster level and undead flag
209 ML=INT((RND(1)^1.5)*(CZ*2+2)+1):GOSUB652:I=1:IFM>16THENI=1.5
!- Roll to see if you sneak up on monsters if you have elven cloak
210 IFAI=1THEN212:IFINT((RND(1)*20+1)+ML*I)<=I(4)THEN665
!- 80% chance monster will not be undead if "Light" is cast
211 IFSF(3)>0ANDUN=1ANDRND(1)>.8THEN208
!-------------------------------------------------------------------------------
!- Begin Encounter
!-------------------------------------------------------------------------------
212 SYSRA:POKESG,1:POKEGI,M:SYSDS:GOSUB106:GOSUB635
213 PRINT"You have encountered a lvl"ML;M$
!- Dwarves, specters, vampires, demons, and dragons are immune to "Time Stop" spell
214 IFSF(9)>0ANDM<16ANDM<>11THENGOSUB63:GOTO300
!- Preserve current line number and reposition
215 I=PEEK(SP):POKESP,18:PRINT
!- Print monster's level and reposition cursor
216 PRINTTAB(21)"{reverse on}Level"STR$(ML)" "M$:POKESP,I-1:PRINT
!- Generate monster's hit points
217 POKESP,I-1:PRINT:MH=INT((RND(1)^.5)*ML*M+1):L=ML
!- 5% chance the monster heals you, steals from you, or gives you something
218 IFRND(1)>.95THENONINT(RND(1)*3+1)GOTO 221,224,231
!- But if it's an elf . . .
219 IFM<>9THEN223
!- . . . then, there is a higher chance it heals you (based on your charisma)
220 IFRND(1)>.04*S(5)THEN223
!- Get healed by monster
221 PRINT"The "M$" likes your body.":PRINT"He heals you to full strength!":CH=HP
!- Update game status and end encounter
222 GOSUB89:GOSUB65:GOSUB110:GOTO300
!- If it's a hobbit there is a higher chance it steals from you (based on your charisma)
223 IFM<>4OR(RND(1)-.2+ML/2000)<.0555*S(5)THEN230
224 PRINT"The "M$" makes a quick move":GOSUB65
225 FORI=1TO10:IFI(I)>0THEN227
226 NEXT:PRINT"You have nothing he wants to steal!":GOTO222
227 I=INT(RND(1)*10+1):IFI(I)<1THEN227
228 PRINT"He steals ";:IFI<8THENPRINT"your "MI$(I):I(I)=0:GOTO222
!- Update game status and end encounter
229 PRINT"a "MI$(I):I(I)=I(I)-1:GOTO222
!- Only dragons give you items and very rarely at that!
230 IFM<>20ORRND(1)*30>S(5)THEN237
!- Generate item to give.  Give nothing if item bonus is already higher than monster's level
231 I=INT(RND(1)*7+1):IFI(I)>=MLTHEN237
!- Generate item bonus between monster's level and existing bonus
232 C=ML-I(I):C=INT(RND(1)*C+1):I(I)=I(I)+C
233 PRINT"The "M$" likes you!":GOSUB63
234 PRINT"He gives you a "MI$(I)" +"I(I):IFI>3THENGOSUB98:GOSUB63:GOTO236
235 ONIGOSUB 95,96,97:GOSUB380
!- Update game status and end encoutner
236 GOSUB110:GOTO300
!-------------------------------------------------------------------------------
!- Battle
!-------------------------------------------------------------------------------
!- Roll initiative
237 IFRND(1)>.5+S(4)*.02THEN253
!-------------------------------------------------------------------------------
!- - Player's Turn
!-------------------------------------------------------------------------------
238 PRINT"{reverse on}{cyan}F{white}{reverse off}ight, {reverse on}{cyan}C{white}{reverse off}ast, or {reverse on}{cyan}E{white}{reverse off}vade:";:GOSUB68
239 IFC$="{cm +}"THENPRINT"wait"
240 FORI=1TO7:IFMID$("fce{f3}{f5}{f7}{cm +}",I,1)=C$THEN242
241 NEXT:PRINT:PRINT"The "M$" is not amused":GOSUB63:GOTO238
242 ONIGOTO 243,283,284,243,283,284,253
!-------------------------------------------------------------------------------
!- - Player's Turn - Fight
!-------------------------------------------------------------------------------
243 I=INT(RND(1)*20)+LV+I(1)+S(0)/2:PRINT"Fight!"
244 IFSF(1)>0THENI=I+4
245 IFI<10THENPRINT"You missed...":GOTO253
246 I=INT(RND(1)*8+RND(1)*LV*2+I(1)+1):IFSF(1)>0THENI=I+5
247 PRINT"You do"I"points damage"
248 MH=MH-I:IFMH>0THEN253
249 PRINT"It died...":POKESE,TE
250 E=ML*M*10:EX=EX+E:GOSUB65
251 GOSUB110:PRINT"You gain"E"experience points":GOSUB91:GOSUB623
252 GOSUB63:GOTO298
!-------------------------------------------------------------------------------
!- - Monster's Turn - Initialize values
!-------------------------------------------------------------------------------
253 DB=1:PA=0:DR=0:MB=0
254 IFM=13THENDR=.1:GOTO260
255 IFM=17THENDR=.2:GOTO260
256 IFM=18THENDR=.3:PA=.3:GOTO260
257 IFM=10THENPA=.5
258 IFM=19THEN271
259 IFM=20THEN273
!-------------------------------------------------------------------------------
!- - Monster's Turn - Attack
!-------------------------------------------------------------------------------
!- Roll to-hit against player
260 I=INT(RND(1)*20)+ML-I(2)-I(3)+MB
!- Protection from Evil grants -6 on to-hit rolls by Specters, Vampires, and Demons
261 IFM>16ANDM<20ANDSF(4)>0THENI=I-6
!- Monster misses; End turn
262 IFI<10THENPRINT"It missed...":GOSUB63:GOTO238
!- Roll damage against player
263 I=INT((RND(1)*8+RND(1)*ML*2+1)*DB):PRINT"It does"I"points damage."
!- Apply damage to character
264 CH=CH-I:GOSUB89:IFCH<1THEN600
265 GOSUB65:IFRND(1)>DRORSF(4)>0THEN269
266 GOSUB64:PRINT"It drains a level!!!":EX=INT(EX/2)
267 IFLV=1THENEX=-1
268 GOSUB623:GOSUB63:GOTO238
269 IFRND(1)>PATHENGOSUB63:GOTO238
270 GOSUB64:PRINT"You're paralyzed!!!!":GOSUB63:GOTO253
!- The demon attacks
271 GOSUB63:IFRND(1)>.6THENPRINT"It uses it's sword!!!":MB=4:DB=3:GOTO260
272 PRINT"It uses it's whip!!":MB=2:DB=2:GOTO260
!- The dragon attacks!  But does he breath fire?
273 IFRND(1)>.3THENMB=5:DB=2:GOTO260
!- He does!
274 PRINT"The dragon breaths fire!!!":GOSUB108:POKEF1+1,20:POKEF2+1,30
275 POKEF+E,196:POKEF+12,196:POKEF+19,196:POKEF3+1,37:POKEF4,129:POKEF5,129
276 POKEF6,129:POKESG,5:POKEGI,3:SYSDS
277 FORQ=1TO60:POKEXE,1:POKEXE,0:NEXT:POKEC9+7,2
278 FORQ=1TO300:POKEXE,1:POKEXE,0:NEXT
279 POKESE,PEEK(SE)AND254:POKEMC,24:GOSUB107:I=INT(RND(1)*20*ML+1)
280 IFRND(1)<.05*S(3)THEN282
281 PRINT"You partially dodge it.":I=INT(I/2+.5)
282 PRINT"You burn for"I"points damage.":GOSUB65:POKEC9+7,11:GOTO264
!-------------------------------------------------------------------------------
!- - Player's Turn - Cast
!-------------------------------------------------------------------------------
283 D=1:GOTO669
!-------------------------------------------------------------------------------
!- - Player's Turn - Evade
!-------------------------------------------------------------------------------
284 Q=INT(RND(1)*18+1):PRINT"Evade"
285 IFQ<S(4)+I(5)THEN287
286 PRINT"You're rooted to the spot!":GOSUB63:GOSUB106:GOTO253
287 IFSF(8)>0THENC=FNR(4):GOTO297
!- Choose random direction to run
288 ONFNR(4)GOTO 289,290,291,292
289 C=1:IFFNUP(L%)<3THEN297
290 C=2:IFFNUP(P21)<3THEN297
291 C=3:IFFNLF(L%)<3THEN297
292 C=4:IFFNLF(P12)<3THEN297
293 C=1:IFFNUP(L%)<3THEN297
294 C=2:IFFNUP(P21)<3THEN297
295 C=3:IFFNLF(L%)<3THEN297
296 GOTO286
!-------------------------------------------------------------------------------
!- - End Encounter and Run
!-------------------------------------------------------------------------------
297 GOSUB110:GOSUB64:GOTO533
!-------------------------------------------------------------------------------
!- Treasure
!-------------------------------------------------------------------------------
!- check for treasure dropped by monster (50% chance)
298 IFRND(1)>.5THEN302
299 GOTO344
!- Clear non-player sprites and check for treasure not dropped by monster (20% chance)
300 POKESE,TE:IFPEEK(765)=1THEN344
301 IFRND(1)>.2THEN344
!- 15% chance that treasure is trapped
302 T=0:IFRND(1)>.85THENT=1
!- Reposition cursor; 30% chance of refuse,silver,gold,gems, or jewels
303 GOSUB106:C=0:IFRND(1)>.7THEN316
!- Show Treasure
304 TJ=INT(RND(1)*5):GOSUB850:PRINT"You see some ";
305 PRINTMID$(T$,TJ*6+1,6):PRINT"<RET> to pick up:";
306 IFT=1THENIFSF(2)>0ANDRND(1)>.1THENPRINT:PRINT"You detect traps!";
307 GOSUB68:AN=0:IFC$=CHR$(13)THEN309
308 PRINT"Leave it":POKESE,TE:GOSUB63:GOTO344
309 PRINT"Snarf it":IFT=0THEN313
310 Q=INT(RND(1)*3*L+1):GOSUB64
311 PRINT"It's trapped!":PRINT"You suffer"Q"points of damage."
312 CH=CH-Q:GOSUB89:IFCH<1THENGOSUB65:GOTO600
313 POKESE,TE:J=INT(RND(1)*TJ*L*200+1):PRINT"It's worth"J"gold!"
!- Update gold in character sheet; 20% chance of an item
314 GD=GD+J:IFTJ=0ANDRND(1)>.8THENGOSUB93:GOSUB64:GOTO329
!- Update character sheet and get no more treasure
315 GOSUB93:GOTO342
!- 50% chance of Treasure Chest
316 IFRND(1)>.5THEN329
!- Show Treasure Chest
317 POKESG,2:POKEGI,6:SYSDS
318 PRINT"You have found a treasure chest!!"
319 PRINT"<RET> to open it:";
320 IFT=1THENIFSF(2)>0ANDRND(1)>.1THENPRINT:PRINT"You detect traps!";
321 GOSUB68:IFC$<>CHR$(13)THENPRINT"Ignore it":POKESE,TE:GOTO344
322 PRINT"OPEN IT":IFT=0THEN325
323 GOSUB63:PRINT"The chest explodes!!!!!":I=INT(RND(1)*10*CZ+1):CH=CH-I
324 PRINT"You suffer"I"points of damage.":GOSUB89:IFCH<1THEN600
325 GOSUB63:I=INT(RND(1)*1000*L^2+1)
326 IFRND(1)>.9THENPRINT"Inside, there is only cobwebs...":GOTO342
!- Assign Gold; Update Character Sheet; 50% chance of an item
327 PRINT"Inside is"I"gold pieces!":GD=GD+I:GOSUB93:IFRND(1)>.5THEN342
328 C=1:GOSUB63
!- Calculate item found
329 I=INT(RND(1)*10+1):PRINT"You see a ";
!- Calculate item bonus
330 J=INT((RND(1)+1)^.82*(L+1)):IFI>7THENPRINTMI$(I):GOTO332
331 PRINTMI$(I)" +"J
332 PRINT"<RET> to pick it up:";:GOSUB68:IFC$=CHR$(13)THEN334
333 PRINT"Leave it":GOTO341
334 IFI<>1ORT<>1THEN338
335 PRINT:PRINT"It's a hostile sword!!":I=INT(RND(1)*I*5+1)
336 PRINT"You suffer"I"points of damage.":CH=CH-I:GOSUB89:IFCH<1THEN600
337 GOTO342
338 PRINT"It's yours!":I(I)=I(I)+1:IFI<8THENI(I)=J
339 IFI>3THENGOSUB98:GOTO341
340 ONIGOSUB 95,96,97
341 IFC=1ANDRND(1)>.5THENGOSUB63:GOTO329
!- Disable all sprites but player sprite and clear text
342 POKESE,TE:GOSUB63
!- 50% chance that monsters move one step closer
343 IFRND(1)>.5THENGOSUB839:IFM<>0THEN212
!-------------------------------------------------------------------------------
!- Room Features
!-------------------------------------------------------------------------------
!- Calculate Room Features
344 POKE711,CX:POKE712,CY:POKE713,CZ-1:SYSCR:H%=PEEK(715)*TF+PEEK(714)
345 J=FNS(H%):I=FNS(L%):IFCZ=1THENJ=0
346 IFI>9THENI=I-9:GOTO346
347 IFJ>9THENJ=J-9:GOTO347
348 IFCZ=VBANDI=4THENI=0
349 IFI=0ANDJ<>4THEN527
350 IFJ=4THEN408
!-------------------------------------------------------------------------------
!- Jump to Specific Room Feature Routines
!-------------------------------------------------------------------------------
351 ONIGOTO 352,377,389,408,421,438,464,477,508
!-------------------------------------------------------------------------------
!- Room Feature: Inn (Level 1); Elevator (All Other Levels)
!-------------------------------------------------------------------------------
!- If not level 1, then elevator
352 IFCZ<>1THEN372
!- Display stairs dialogue
353 J=4:GOTO408
!- Come back if player goes up
354 I1$=Z$(FNRD(CX*CY),0):I2$=Z$(FNRD(CX+CY),1):I3$=Z$(FNRD(CX*3+CY*7),2)
355 I1=INT(4-LEN(I1$)/2)+1:I2=INT(4-LEN(I2$)/2)+2:I3=INT(4-LEN(I3$)/2)+1
356 GOSUB64:SYSDV:SYSDC:SYSDP:SYSDI:POKESG,3:POKEGI,8:SYSDS:POKEBD,0
357 PRINT"{home}{down*11}";:FORI=1TOI1:PRINT"{right}";:NEXT:PRINT"{reverse on}{brown}"I1$
358 PRINT"{home}{down*12}";:FORI=1TOI2:PRINT"{right}";:NEXT:PRINT"{reverse on}{brown}"I2$
359 PRINT"{home}{down*13}";:FORI=1TOI3:PRINT"{right}";:NEXT:PRINT"{reverse on}{brown}"I3$"{reverse off}{white}"
360 GOSUB106:PRINT"You've found the {light blue}"I1$" "I2$" "I3$"{white}."
361 PRINT"They cash in your gold.":EX=EX+GD:TG=TG+GD:GD=0:GOSUB91:GOSUB93
362 GOSUB623:GOSUB109:GOSUB64:CH=HP:PRINT"You have{yellow}"TG"{white}in the safe"
363 FORI=0TO11:SF(I)=0:NEXT
364 CS=SU:PRINT"You spend the night.":GOSUB65
365 PRINT"You feel better.":GOSUB89:GOSUB90:GOSUB63
366 PRINT"<RET> to return to dungeon,"
367 PRINT"<F1> save character on disk:";
368 GOSUB68:IFC$="{cm +}"THEN368
369 AN=0:IFC$="{f1}"THENPRINT:SYSDV:POKESE,0:GOTO544
370 IFC$<>CHR$(13)THENPRINT"???":GOSUB63:GOTO366
371 PRINT"Reenter":POKESG,5:POKEGI,1:SYSDS:SYSDV:GOSUB63:CZ=1:GOTO201
!- Display Elevator
372 POKESG,3:POKEGI,3:SYSDS
373 GOSUB106:PRINT"You feel heavy for a moment."
!- Animate Elevator
374 GOSUB108:POKEF4,33:FORI=0TO40:POKECP+5,PEEK(CP+5)-1:POKECP+3,PEEK(CP+3)-1
375 FORJ=11TO15STEP2:POKECP+J,PEEK(CP+J)-1:NEXT:POKEF1+1,I:NEXT:GOSUB107
376 CZ=CZ-1:SYSDV:GOTO201
!-------------------------------------------------------------------------------
!- Room Feature: Pit (All but Lowest Level); Redirect to Elevator (Lowest Level)
!-------------------------------------------------------------------------------
377 IFCZ=VBTHEN372
378 POKESG,3:POKEGI,9:SYSDS
379 GOSUB106:PRINT"You see a pit."
380 IFSF(5)>0THENPRINT"You are hovering above a pit.":GOTO382
381 IFINT(RND(1)*20)>S(4)+I(5)THEN385
382 PRINT"Do you want to descend?";:GOSUB68:IFC$="y"ORC$="9"THEN384
383 PRINT"No":GOSUB63:GOTO527
384 PRINT"Yes":GOTO386
385 PRINT"You fall in!!":L=3:GOSUB639:GOSUB65
386 CZ=CZ+1:GOSUB108:POKESB,TH:POKEF4,17
387 FORI=25TO0STEP-1:FORJ=11TO15STEP2:POKECP+J,PEEK(CP+J)+1:NEXT
388 POKEF1+1,I*10:FORJ=1TO10:NEXT:NEXT:GOSUB107:SYSDV:GOTO201
!-------------------------------------------------------------------------------
!- Room Feature: Teleport
!-------------------------------------------------------------------------------
389 GOSUB106
390 PRINT"ZZAP!! You've been teleported...":GOSUB109
391 IF((CX+CY)AND1)=0THENCZ=CZ-1:IF((CX+CY)AND2)=2THENCZ=CZ+2
392 CX=CX+CZ*8+CY*13:CY=CY+CZ*6+CX*17
393 IFCX>200THENCX=CX-200:GOTO393
394 IFCY>200THENCY=CY-200:GOTO394
395 IFCZ=0THENCZ=1
396 IFCZ>VBTHENCZ=VB
397 IFRND(1)>.8THEN391
398 FORJ=8TO23:POKEWW+J,0:NEXT
399 GOSUB108:POKEF4,17:POKEF5,129:Q1=25:Q2=193:Q=F1+1
400 FORI=7TO0STEP-1:POKEFV,15-I*2:FORK=1TO3:Q1=Q1-1:POKEF2+1,Q1
401 FORJ=0TO7:POKEQ,Q2:Q2=Q2-1
402 POKEWW+J,BW(J)AND(RND(1)*PW(I))
403 POKEQ,TH-Q2:NEXT:NEXT:NEXT:POKEQ,0:GOSUB4:Q=F1+1:Q1=1:Q2=1
404 FORI=0TO7:POKEFV,15-I*2:FORK=1TO3:POKEF2+1,Q1:Q1=Q1+1:FORJ=0TO7:POKEQ,Q2
405 Q2=Q2+1:POKEWW+J,BW(J)AND(RND(1)*PW(I))
406 POKEQ,TH-Q2:NEXT:NEXT:NEXT:GOSUB107
407 FORJ=0TO23:POKEWW+J,BW(J):NEXT:SY=0:GOTO201
!-------------------------------------------------------------------------------
!- Room Feature: Stairway
!-------------------------------------------------------------------------------
408 POKESG,3:POKEGI,5:SYSDS
409 GOSUB64:PRINT"You have found a stairway."
410 IFJ=4ANDCZ=1THENPRINT"You see {yellow}light{white} above."
411 PRINT"Do you want to ";:IFJ=4THENPRINT"go {reverse on}{cyan}U{white}{reverse off}p, ";
412 IFI=4THENPRINT"go {reverse on}{cyan}D{white}{reverse off}own, ";
413 PRINT:PRINT"or {reverse on}{cyan}S{white}{reverse off}tay on the same level?";:GOSUB68
414 IFC$="{cm +}"THENC$="s"
415 IF(I<>4AND(C$="d"ORC$="1"))OR(J<>4AND(C$="u"ORC$="7"))THEN420
416 IFC$="u"ORC$="7"THENPRINT"UP":CZ=CZ-1:IFCZ>0THEN201
417 IFCZ<=0THEN354
418 IFC$="d"ORC$="1"THENPRINT"DOWN":CZ=CZ+1:GOTO201
419 IFC$="s"ORC$="5"THENGOSUB64:GOTO527
420 PRINT"???":GOTO409
!-------------------------------------------------------------------------------
!- Room Feature: Altar
!-------------------------------------------------------------------------------
421 POKESG,3:POKEGI,1:SYSDS:SYSSA:GOSUB64
422 PRINT"You have found a holy altar.":PRINT"<RET> to worship";:GOSUB68
423 IFC$=CHR$(13)THEN428
424 IFRND(1)>.7THENGOTO527
425 PRINT:PRINT"Dirty pagan trash!"
426 M=INT(RND(1)*20+1):GOSUB652:IFUN=0THEN426
427 GOSUB63:AI=1:GOTO209
428 PRINT:PRINT"<RET> to donate money";:GOSUB68
429 IFC$<>CHR$(13)THEN424
430 PRINT:PRINT"How much gold?";:GOSUB654:GOSUB64
431 IFC>GDTHENPRINT"You don't have that much!";:GOTO425
432 IFC<50*CZTHENPRINT"{up}";:GOTO425
433 GD=GD-C:GOSUB93:IFRND(1)<C/(GD+C)THEN435
434 PRINT"Thank you for your donation.":GOSUB63:GOTO527
435 I=INT(RND(1)*7+1):IFSF(I)<0THENSF(I)=0
436 SF(I)=SF(I)+INT(RND(1)*100*C/(GD+C)+1)
437 PRINT"You've been heard.":GOSUB63:GOTO527
!-------------------------------------------------------------------------------
!- Room Feature: Fountain
!-------------------------------------------------------------------------------
438 C=INT(RND(1)*5+1):POKESG,3:POKEGI,4:SYSDS:POKEM1,CL(C)
439 POKESG,5:POKEGI,2:SYSDS:POKEC9,LC(C):AN=5:AR=8:AC=0
440 GOSUB64:PRINT"You have found a fountain"
441 PRINT"with running "MID$("whitegreenclearred{space*2}black",C*5-4,5)" water."
442 PRINT"<RET> to drink some:";:GOSUB68:IFC$=CHR$(13)THEN444
443 GOSUB64:GOTO527
444 GOSUB64:IFRND(1)>.6THEN454
445 IFRND(1)>1-C*.15THEN449
446 PRINT"You feel better.":GOSUB65:I=INT(RND(1)*3*CZ+1)
447 PRINT"You heal"I"points!":CH=CH+I:IFCH>HPTHENCH=HP
448 GOSUB89:GOSUB63:GOTO527
449 IFRND(1)>.15*CTHEN453
450 PRINT"It's poison!!!":I=INT(RND(1)*3*CZ+1):PRINT"You lose"I"hit points!"
451 CH=CH-I:GOSUB89:IFCH<1THEN600
452 GOSUB63:GOTO527
453 GOSUB642:GOSUB63:GOTO527
454 IFRND(1)>.4THENPRINT"You feel refreshed!":GOSUB63:GOTO527
455 IFRND(1)>.5THEN461
456 IFRND(1)>.5THEN459
457 PRINT"Magical power surges through your body!":CS=CS+INT(RND(1)*4*CZ+1)
458 PRINT"You now have"CS" spells.":GOSUB90:GOSUB63:GOTO527
459 PRINT"You have been disposessed!!":FORI=1TO10:I(I)=0:NEXT:GOSUB65:GOSUB63
460 PRINT"{clear}":GOSUB95:GOSUB96:GOSUB97:GOSUB98:GOSUB4:GOSUB843:GOTO527
461 PRINT"You feel refreshed!":GOSUB63:PRINT"Actually, you're drunk!!"
462 IFSF(11)<0THENSF(11)=0
463 SF(11)=SF(11)+INT(RND(1)*16+1):GOSUB4:GOSUB64:GOTO527
!-------------------------------------------------------------------------------
!- Room Feature: Gray Misty Cube
!-------------------------------------------------------------------------------
464 POKESG,3:POKEGI,6:SYSDS:AN=1:AR=15
465 GOSUB64:PRINT"You see a large gray misty cube."
466 PRINT"<RET> to walk in:";:GOSUB68:AN=0:IFCHR$(13)<>C$THEN527
467 IFRND(1)>.2THEN469
468 CZ=INT(RND(1)*VB+1):GOTO472
469 PRINT:PRINT"A number from 1 to"VB":";:GOSUB654:IFC$="{cm +}"THEN468
470 IFC<1ORC>VBTHENPRINT"No, you fool!!";:GOSUB63:GOTO467
471 CZ=C
472 SYSDV:PRINT"{home}{down*2}{right}{green}You float":POKESE,0
473 PRINT"{space*5}in space....{white}";
474 GOSUB108:POKEF4,17:FORQQ=1TO4:POKEF1,29:POKEF1+1,21:GOSUB112
475 POKEF1,92:POKEF1+1,22:GOSUB112:POKEF1,29:POKEF1+1,21:GOSUB112
476 POKEF1,204:POKEF1+1,18:GOSUB112:NEXT:GOSUB107:GOTO201
!-------------------------------------------------------------------------------
!- Room Feature: Throne
!-------------------------------------------------------------------------------
477 POKESG,3:POKEGI,7:SYSDS:AN=3:AR=10:AC=1
478 GOSUB64:PRINT"You see a jewel encrusted throne."
479 PRINT"Do you want to {reverse on}{cyan}P{white}{reverse off}ry some jewels,"
480 PRINT"{reverse on}{cyan}S{white}{reverse off}it down, {reverse on}{cyan}R{white}{reverse off}ead the runes,":PRINT"or {reverse on}{cyan}I{white}{reverse off}gnore it:";
481 GOSUB903:GOSUB69:AN=0:IFC$="i"ORC$="{cm +}"THENPRINT"IGNORE":GOSUB63:GOTO527
482 IFC$<>"p"THEN487
483 PRINT"PRY":GOSUB63:IFRND(1)>.7THEN505
484 IFRND(1)>.4THEN504
485 PRINT"They pop into your greedy hands!!":I=INT(RND(1)*1000*CZ+1)
486 PRINT"They are worth"I"gold!":GD=GD+I:GOSUB93:GOSUB63:GOTO527
487 IFC$<>"s"THEN496
488 PRINT"SIT";:GOSUB63:IFRND(1)>.7THEN505
489 IFRND(1)>.6THEN504
490 IFRND(1)>.4THEN390
491 PRINT"A loud gong sounds!";:GOSUB63:IFRND(1)<.5THEN494
492 EX=INT(EX/2):IFLV=1THENEX=-1
493 GOSUB623:GOTO527
494 IFLV>CZTHENPRINT"Nothing happens...";:GOTO502
495 EX=1000*2^LV:GOSUB623:GOTO527
496 IFC$<>"r"THEN503
497 PRINT"READ";:GOSUB63
498 IFRND(1)>.7THEN505
499 IFRND(1)<S(1)*.05THEN501
500 PRINT:PRINT"You don't understand them...";:GOTO502
501 PRINT:PRINT"A mysterious magic grips you..":GOSUB646
502 GOSUB63:GOTO527
503 PRINT"???";:GOSUB63:GOTO477
504 PRINT"Nothing happens...";:GOTO502
505 M=INT(RND(1)*20+1):GOSUB635
506 PRINT"The "M$" king returns!!":GOSUB63:GOSUB652
507 PRINT"{space*3}";:ML=INT(RND(1)*CZ*5)+5:GOTO213
!-------------------------------------------------------------------------------
!- Room Feature: Small Box with Four Colored Lights
!-------------------------------------------------------------------------------
508 AN=2:AR=4:AC=0:POKESG,3:POKEGI,2:SYSDS
509 GOSUB64:GOSUB108:PRINT"You see a small box with four colored":POKEF4,17
510 PRINT"lights. {reverse on}{cyan}P{white}{reverse off}ush buttons or {reverse on}{cyan}I{white}{reverse off}gnore:";:GOSUB68:AN=0:GOSUB107
511 IFC$<>"p"THENPRINT"IGNORE":GOSUB63:GOTO527
512 PRINT"PUSH":GOSUB63:CB=1
513 PRINT"Push {reverse on}{cyan}R{white}{reverse off}ed, {reverse on}{cyan}G{white}{reverse off}reen, {reverse on}{cyan}Y{white}{reverse off}ellow, {reverse on}{cyan}B{white}{reverse off}lue":PRINT"or {reverse on}{cyan}S{white}{reverse off}top:";
514 GOSUB68:IFC$="s"ORC$="{cm +}"THENPRINT"STOP";:GOSUB63:GOTO527
515 FORC=1TO4:IFC$=MID$(B$,C*6-5,1)THENM$=MID$(B$,C*6-5,6):GOTO517
516 NEXT:PRINT"???":GOSUB63:GOTO513
517 GOSUB636:PRINTM$:IFB(CB)<>CTHEN522
518 CB=CB+1:IFCB<5THENGOSUB63:GOTO513
519 PRINT"It opens!!!{space*2}";:GOSUB63:PRINT"Inside you find jewels worth"
520 GOSUB638:I=INT(RND(1)*20000*CZ^2+1):PRINTI"in gold!!":GD=GD+I:GOSUB93
521 GOSUB63:GOTO527
522 I=INT(RND(1)*2*CZ+1):PRINT"An electric bolt shoots through you!!"
523 GOSUB108:POKEF4,129:FORQ=1TO120:POKEF1+1,Q:NEXT:GOSUB107
524 GOSUB63:PRINT"You suffer"I"points of damage!":CH=CH-I:GOSUB89
525 IFCH<1THEN600
526 GOSUB63
!-------------------------------------------------------------------------------
!- Command Prompt
!-------------------------------------------------------------------------------
527 AN=0:M=0:GOSUB106:GOSUB64:PRINT"->";:GOSUB68:IFC$="{cm +}"THENC$="s"
528 FORC=1TO22:IFMID$(CM$,C,1)=C$THEN531
529 NEXT
530 PRINT"{left*2}NO";:FORI=1TO200:NEXT:GOTO527
531 IFC>9THENC=C-9
!-------------------------------------------------------------------------------
!- Confusion Command Override
!-------------------------------------------------------------------------------
532 IFSF(11)>0ANDC<6THENPRINT"You're confused ->";:C=FNR(5)
!-------------------------------------------------------------------------------
!- User Commands
!-------------------------------------------------------------------------------
533 ONCGOTO 534,536,538,540,542,565,562,584,599,544,586,592,595
!-------------------------------------------------------------------------------
!- - Go North
!-------------------------------------------------------------------------------
534 IFFNUP(L%)>2ANDSF(8)<1ORCY=1THEN530
535 PRINT"NORTH";:CY=CY-1:GOSUB846:GOTO201
!-------------------------------------------------------------------------------
!- - Go South
!-------------------------------------------------------------------------------
536 IFFNUP(P21)>2ANDSF(8)<1ORCY=200THEN530
537 PRINT"SOUTH";:CY=CY+1:GOSUB846:GOTO201
!-------------------------------------------------------------------------------
!- - Go West
!-------------------------------------------------------------------------------
538 IFFNLF(L%)>2ANDSF(8)<1ORCX=1THEN530
539 PRINT"WEST";:CX=CX-1:GOSUB846:GOTO201
!-------------------------------------------------------------------------------
!- - Go East
!-------------------------------------------------------------------------------
540 IFFNLF(P12)>2ANDSF(8)<1ORCX=200THEN530
541 PRINT"EAST";:CX=CX+1:GOSUB846:GOTO201
!-------------------------------------------------------------------------------
!- - Stay
!-------------------------------------------------------------------------------
542 PRINT"STAY":GOSUB839:IFM<>0THEN212
543 SY=0:GOTO201
!-------------------------------------------------------------------------------
!- - Save Character
!-------------------------------------------------------------------------------
544 PRINT"Store ";NP$:IFNM$<>"Demo"THEN546
545 PRINT:PRINT"%Cannot store demonstration character!":GOTO560
546 POKESE,0:OPEN2,8,15,"i0":INPUT#2,ER,ER$,ET,ES:IFERTHEN549
547 PRINT#2,"s0:"+NP$:OPEN1,8,3,"0:"+NP$+",s,w"
548 INPUT#2,ER,ER$,ET,ES:IFER=0THEN551
549 PRINT"ERR=";ER;"{reverse on}";ER$:PRINT"%Cannot store character on drive 0"
550 CLOSE1:CLOSE2:GOSUB65:GOTO560
551 R$=CHR$(13)
552 PRINT#1,Q$;NM$;Q$;R$;:PRINT#1,4.18;R$;:FORI=0TO5:PRINT#1,S(I);R$;:NEXT
553 PRINT#1,LV;R$;:PRINT#1,GD;R$;:PRINT#1,TG;R$;:PRINT#1,EX;R$;:PRINT#1,CH;R$;
554 PRINT#1,HP;R$;:PRINT#1,CX;R$;:PRINT#1,CY;R$;:PRINT#1,CZ;R$;:PRINT#1,SU;R$;
555 PRINT#1,CS;R$;:FORI=1TO10:PRINT#1,I(I);R$;:PRINT#1,SF(I);R$;:NEXT
556 PRINT#1,SF(11);R$;:FORI=1TO20:PRINT#1,M%(I);R$;:PRINT#1,L%(I);R$;
557 PRINT#1,H%(I);R$;:NEXT:FORI=1TO4:PRINT#1,B(I);R$;:NEXT
558 FORI=0TO299:PRINT#1,PEEK(EL+I);R$;:NEXT:PRINT#1,PEEK(764);R$;
559 CLOSE1:CLOSE2:PRINTNP$" stored":GOTO140
560 GOSUB63:IFCZ=0THENGOTO366
561 GOTO527
!-------------------------------------------------------------------------------
!- - Quit Game
!-------------------------------------------------------------------------------
562 PRINT"QUIT":PRINT"Are you sure?";:GOSUB68
563 IFC$<>"y"ANDC$<>"9"THENPRINT"NO":GOSUB63:GOTO527
564 PRINT"Yes":PRINT"Good bye, cruel world!!":GOSUB65:GOTO600
!-------------------------------------------------------------------------------
!- - Print Help
!-------------------------------------------------------------------------------
565 SYSDV:POKESE,0:PRINT"{home}Commands are:{down}"
566 PRINT"{space*6}North"
567 PRINT"{blue}{space*7}{cm b}{sh asterisk}{cm asterisk}"
568 PRINT"{space*7}{cm i}{white}W{blue}{cm i}{light green}{reverse on}S{reverse off}{white}tay"
569 PRINT"{blue}{space*6}{cm b}{cm c}{cm f}{cm c}{cm f}{sh asterisk}{cm asterisk}"
570 PRINT"{white}{space*2}West{blue}{cm i}{white}A{blue}{cm i}{white}S{blue}{cm i}{white}D{blue}{cm i}{white}East"
571 PRINT"{blue}{space*6}{cm v}{sh asterisk}{cm c}{cm f}{cm c}{cm f}{cm x}"
572 PRINT"{space*9}{cm i}{white}X{blue}{cm i}"
573 PRINT"{space*9}{cm v}{sh asterisk}{cm x}"
574 PRINT"{white}{space*8}South"
575 PRINT"{brown}{space*6}{cm b}{sh asterisk*2}{cm asterisk}"
576 PRINT"{light green}{reverse on}F{reverse off}{white}ight {brown}{cm i}{light green}{reverse on}F1{reverse off}{brown}{cm i}{white}Save Char"
577 PRINT"{light green}{reverse on}C{reverse off}{white}ast{space*2}{brown}{cm i}{light green}{reverse on}F3{reverse off}{brown}{cm i}{white}Scrl/Rescue"
578 PRINT"{light green}{reverse on}E{reverse off}{white}vade {brown}{cm i}{light green}{reverse on}F5{reverse off}{brown}{cm i}{white}Pot/Healing"
579 PRINT"Re{light green}{reverse on}P{reverse off}{white}lot{brown}{cm i}{light green}{reverse on}F7{reverse off}{brown}{cm i}{white}Pot/Strength"
580 PRINT"{light green}{reverse on}Q{reverse off}{white}uit{space*2}{brown}{cm v}{sh asterisk*2}{cm x}"
581 PRINT"{light green}{reverse on}H{reverse off}{white}elp  {light green}{reverse on}R/S{reverse off}{white}=Pause"
582 GOSUB64:PRINT"Hit any key to continue...";:GOSUB68:GOSUB64:SYSDV
583 GOSUB4:GOTO527
!-------------------------------------------------------------------------------
!- - Re-Plot Screen
!-------------------------------------------------------------------------------
584 PRINT"Re-Plot":GOSUB65:PRINT"{clear}";:SYSDC:GOSUB198:GOSUB4
585 GOSUB843:GOTO527
!-------------------------------------------------------------------------------
!- - Use Scroll of Rescue
!-------------------------------------------------------------------------------
586 PRINT"Use scroll of rescue"
587 IFI(8)<1THEN590
588 I(8)=I(8)-1:CX=25:CY=13:CZ=1:PRINT"***ZAP!!***":GOSUB65:GOSUB109
589 GD=0:GOSUB93:GOTO201
590 PRINT"You don't have one!!"
591 GOSUB63:GOTO527
!-------------------------------------------------------------------------------
!- - Drink Potion of Healing
!-------------------------------------------------------------------------------
592 PRINT"Drink healing potion":IFI(9)<1THEN590
593 I(9)=I(9)-1:CH=CH+FNR(20):IFCH>HPTHENCH=HP
594 PRINT"You feel better!"::GOSUB98:GOSUB89:GOTO591
!-------------------------------------------------------------------------------
!- - Drink Potion of Strength
!-------------------------------------------------------------------------------
595 PRINT"Drink strength potion":IFI(10)<1THEN590
596 IFSF(1)<0THENSF(1)=0
597 SF(1)=SF(1)+10+INT(RND(1)*20):PRINT"Strength flows through your body!"
598 I(10)=I(10)-1:GOSUB83:GOTO591
!-------------------------------------------------------------------------------
!- - Cast Spell
!-------------------------------------------------------------------------------
599 D=0:GOTO669
!-------------------------------------------------------------------------------
!- - Character Death
!-------------------------------------------------------------------------------
600 POKESE,0:GOSUB64:PRINT"You died!!":GOSUB63:IFSF(10)>0THEN820
601 PRINT"{clear}{down*5}Another ";:IFLV<4THENPRINT"not so ";
602 PRINT"mighty adventurer":PRINT"bites the dust{down*4}"
603 I=LV:GOSUB874
604 PRINT"Do you want to try again?";
605 GOSUB68:IFC$="n"ORC$="3"THEN608
606 IFC$="{cm +}"THEN605
607 PRINT"Yes":GOTO140
608 PRINT"No":PRINT"{down*2}So long.....":GOTO849
!-------------------------------------------------------------------------------
!- Enter Character Name
!-------------------------------------------------------------------------------
609 D$="":NL=16
610 PRINT"{reverse on} {reverse off}";
611 GETC$:IFC$=""THEN611
612 PRINT"{left} {left}";:IFC$=CHR$(13)THENRETURN
613 IFC$<>CHR$(20)THEN617
614 IFLEN(D$)=0THEN610
615 PRINT"{left} {left}";:IFLEN(D$)<2THEN609
616 D$=LEFT$(D$,LEN(D$)-1):GOTO610
617 IFLEN(D$)>=NLTHEN610
618 IF(C$>"/"ANDC$<":")THEN622
619 IF(C$>"@"ANDC$<"[")THEN622
620 IF(C$>"{cm k}"ANDC$<"{sh +}")THEN622
621 IFC$<>" "THEN610
622 D$=D$+C$:PRINTC$;:GOTO610
!-------------------------------------------------------------------------------
!- Update Character Level
!-------------------------------------------------------------------------------
623 IFEX<1000*2^LVTHEN628
624 GOSUB64:PRINT"You went up a level!";:LV=LV+1:J=INT(RND(1)*S(3)+1)
625 I=1:GOSUB874:CH=CH+J:HP=HP+J:IFEX>1000*2^LVTHENEX=1000*2^LV-1
626 CS=CS+LV:SU=SU+LV:GOSUB82:GOSUB89:GOSUB90:GOSUB91
627 GOSUB63:PRINT"You gain"J"hit points!":RETURN
628 IFLV=1ANDEX>=0THENRETURN
629 IFEX>=1000*2^(LV-1)THENRETURN
630 CS=CS-LV:SU=SU-LV:IFCS<0THENCS=0
631 PRINT"You go down a level!";:LV=LV-1:J=INT(RND(1)*S(3)+1):CH=CH-J:HP=HP-J
632 GOSUB82:GOSUB89:GOSUB90:GOSUB91:GOSUB63:PRINT"you lose"J"hit points!"
633 IFCH>0ANDLV>0THENRETURN
634 GOSUB65:GOTO600
!-------------------------------------------------------------------------------
!- Generate Monster Name
!-------------------------------------------------------------------------------
635 M$=MID$(MO$,M*8-7,8)
!-------------------------------------------------------------------------------
!- Remove Trailing Space from Monster Name
!-------------------------------------------------------------------------------
636 IFRIGHT$(M$,1)=" "THENM$=LEFT$(M$,LEN(M$)-1):GOTO636
637 RETURN
!-------------------------------------------------------------------------------
!- Generate New Combination for Box
!-------------------------------------------------------------------------------
638 FORQ=1TO4:B(Q)=INT(RND(1)*4+1):NEXTQ:RETURN
!-------------------------------------------------------------------------------
!- Do Damage to Character
!-------------------------------------------------------------------------------
639 D=INT(RND(1)*L*6+1):PRINT"You suffer"D"points of damage!":CH=CH-D
640 IFCH>0THENGOSUB89:RETURN
641 PRINT"Your life has been terminated!":GOSUB89:GOSUB63:GOTO600
!-------------------------------------------------------------------------------
!- Modify Character Experience Points
!-------------------------------------------------------------------------------
642 I=INT(RND(1)*500*CZ+1):PRINT"You just ";
643 IFRND(1)>.5THENPRINT"lost";:I=-I:GOTO645
644 PRINT"gained";
645 PRINTABS(I);"experience points!":EX=EX+I:GOSUB623:RETURN
!-------------------------------------------------------------------------------
!- Modify Character Stats
!-------------------------------------------------------------------------------
646 I=INT(RND(1)*6):IFRND(1)>.5THEN649
647 IFS(I)=18THEN646
648 PRINT"Your ";MID$(S$,I*3+1,3);" goes up";:S(I)=S(I)+1:GOTO651
649 IFS(I)=3THEN646
650 PRINT"Your ";MID$(S$,I*3+1,3);" goes down";:S(I)=S(I)-1
651 PRINT" by 1!":ONIGOSUB 83,84,85,86,87,88:GOSUB390:RETURN
!-------------------------------------------------------------------------------
!- Decide if Monster is Undead
!-------------------------------------------------------------------------------
652 UN=0:IFM=3ORM=5ORM=8ORM=10ORM=13ORM=17ORM=18THENUN=1
653 RETURN
!-------------------------------------------------------------------------------
!- Get Coordinates
!-------------------------------------------------------------------------------
654 D$=""
655 GOSUB68:IFC$<>CHR$(20)THEN659
656 IFD$=""THEN655
657 PRINT"{left} {left}";:IFLEN(D$)=1THEN654
658 D$=LEFT$(D$,LEN(D$)-1):GOTO655
659 IFC$=CHR$(13)THENC=VAL(D$):PRINT:RETURN
660 IFC$="{cm +}"THENC=0:RETURN
661 IFLEN(D$)>9THEN655
662 IFC$="-"ANDD$=""THEN664
663 IFC$<"0"ORC$>"9"THEN655
664 PRINTC$;:D$=D$+C$:GOTO655
!-------------------------------------------------------------------------------
!- - Elven Cloak Encounter Handler
!-------------------------------------------------------------------------------
665 GOSUB106:POKESE,TE:PRINT"You have not been noticed...":POKESC+331,63
666 PRINT"<RET> to approach:";:GOSUB68
667 POKESC+331,32:IFC$=CHR$(13)THENGOSUB64:GOTO211
668 GOSUB64:GOTO300
!-------------------------------------------------------------------------------
!- Cast Spell
!-------------------------------------------------------------------------------
669 PRINT"CAST":PRINT"Spell level:";:GOSUB68:C=VAL(C$):PRINTC$
670 IFC>0ANDC<=INT(LV/3)+1ANDC<7THEN673
671 IFC=0THEN690
672 PRINT"You don't have that level spells!":GOSUB65:GOTO690
673 IFC>CSTHENPRINT"You don't have enough spell units!":GOTO688
674 PRINT"Spell( = to list):";:GOSUB68:IFC$=CHR$(13)ORC$="{cm +}"THEN690
675 IFC$<"1"ORC$>"6"THENC$="="
676 IFC$="="THEN678
677 CS=CS-C:GOSUB90:POKESP,21:PRINT:PRINTTAB(18);:GOTO683
678 GOSUB64:PRINT"{up}":FORI=1TO3:PRINTI;LEFT$(SP$(I+6*(C-1)),20);
679 PRINTTAB(20);I+3;LEFT$(SP$(I+3+6*(C-1)),19):NEXT
680 PRINT:PRINT"Press any key to continue...";:GOSUB68:GOSUB64
681 IFC$<"1"ORC$>"6"THEN674
682 GOTO677
683 S=VAL(C$):ONCGOTO 694,717,735,754,784,814
684 MH=MH-I:PRINT"It suffers"I"points of damage":IFMH>0THEN688
685 GOTO249
686 PRINT"Not in melee!!":GOSUB63:GOTO253
687 PRINT"You just wasted a combat spell!"
688 GOSUB63:IFD=1THEN253
689 GOTO527
690 GOSUB64:IFD=1THEN238
691 GOTO527
692 GOSUB63:GOSUB110:GOTO300
693 PRINT"Undead are already dead!!":GOTO688
!-------------------------------------------------------------------------------
!- Level 1 Spells
!-------------------------------------------------------------------------------
694 ONSGOTO 695,697,704,707,710,716
!-------------------------------------------------------------------------------
!- - Cast "Magic Missile"
!-------------------------------------------------------------------------------
695 PRINTSP$(1):GOSUB63:IFD=0THEN687
696 POKEBK,2:GOSUB112:POKEBK,0:I=INT(RND(1)*8+5):GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Sleep"
!-------------------------------------------------------------------------------
697 PRINTSP$(2):GOSUB63:IFD=0THEN687
698 IFUN=1THENPRINT"Undead don't sleep!":GOTO253
699 IFINT(RND(1)*20+1)>S(1)THENPRINT"The "M$" isn't sleepy!":GOTO253
700 PRINT"The "M$" is sleeping.":PRINT"<RET> to kill:";:GOSUB68
701 IFC$<>CHR$(13)THENGOSUB64:GOTO287
702 IFRND(1)>.2THEN249
703 PRINT"It woke up!!":GOSUB65:GOTO253
!-------------------------------------------------------------------------------
!- - Cast "Cure Light Wounds"
!-------------------------------------------------------------------------------
704 PRINTSP$(3):I=INT(RND(1)*8+1):PRINT"You feel better!":CH=CH+I
705 IFCH>HPTHENCH=HP
706 GOSUB89:GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Light"
!-------------------------------------------------------------------------------
707 S=4:T=3:U=11:POKE709,CX:POKE710,CY:POKE713,CZ:SYSCR:SYSRL
!-------------------------------------------------------------------------------
!- Exit Point for Duration-Based Spells
!-------------------------------------------------------------------------------
708 PRINTSP$(S):IFSF(T)<0THENSF(T)=0
709 SF(T)=SF(T)+INT(RND(1)*U+5):GOSUB8:GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Turn Undead"
!-------------------------------------------------------------------------------
710 PRINTSP$(5):GOSUB63:IFD=0THEN687
711 IFUN=1THEN713
712 PRINT"The "M$" is insulted":PRINT"at being called undead!":GOTO688
713 IFRND(1)<.05*S(2)+.05*LV-.05*MLTHEN715
714 PRINT"The "M$" listens with deaf ears.":GOTO688
715 ML=INT((ML/2)+.5):PRINT"It runs in fear!!":GOTO250
!-------------------------------------------------------------------------------
!- - Cast "Prot/Evil"
!-------------------------------------------------------------------------------
716 S=6:T=4:U=11:GOTO708
!-------------------------------------------------------------------------------
!- Level 2 Spells
!-------------------------------------------------------------------------------
717 ONSGOTO 718,725,726,728,729,734
!-------------------------------------------------------------------------------
!- - Cast "Web"
!-------------------------------------------------------------------------------
718 PRINTSP$(7):GOSUB64:IFD=0THEN687
719 IFINT(RND(1)^2*20+ML)>S(1)THENPRINT"The "M$" dodges aside!":GOTO253
!- Display web sprite
720 POKESG,4:POKEGI,4:SYSDS
721 PRINT"The "M$" is webbed!":PRINT"Press <RET> to kill:";:GOSUB68
722 IFC$<>CHR$(13)THENGOSUB64:GOTO287
723 IFRND(1)-ML/20>.2THEN249
724 PRINT"It broke free!!":POKESE,254:GOSUB65:GOTO253
!-------------------------------------------------------------------------------
!- - Cast "Levitate"
!-------------------------------------------------------------------------------
725 S=8:T=5:U=21:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Cause Light Wnds"
!-------------------------------------------------------------------------------
726 PRINTSP$(9):GOSUB63:IFD=0THEN687
727 I=INT(RND(1)*12+3):GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Detect Traps"
!-------------------------------------------------------------------------------
728 S=10:T=2:U=21:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Charm"
!-------------------------------------------------------------------------------
729 PRINTSP$(11):GOSUB64:IFD=0THEN687
730 IFUN=1THENPRINT"The undead ignore your wiles!":GOTO253
731 IFINT((RND(1)^2)*20+1)>S(5)THENPRINT"The "M$" resists you!":GOTO253
732 PRINT"The "M$" is charmed!":PRINT"Press <RET> to kill:";:GOSUB68
733 GOTO722
!-------------------------------------------------------------------------------
!- - Cast "Strength"
!-------------------------------------------------------------------------------
734 S=12:T=1:U=21:GOTO708
!-------------------------------------------------------------------------------
!- Level 3 Spells
!-------------------------------------------------------------------------------
735 ONSGOTO 736,739,742,743,744,750
!-------------------------------------------------------------------------------
!- - Cast "Lightning Bolt"
!-------------------------------------------------------------------------------
736 PRINTSP$(13):GOSUB64:PRINT"ZZZZAAAAPP!!!":IFD=0THEN687
737 POKEBK,1:GOSUB108:POKEF4,129:FORQ=1TO55:POKEF1+1,Q:NEXT:GOSUB107
738 POKEBK,0:GOSUB65:I=INT(RND(1)*6*LV+15):GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Cure Serious Wnds"
!-------------------------------------------------------------------------------
739 PRINTSP$(14):I=INT(RND(1)*24+1):PRINT"You feel better!":CH=CH+I
740 IFCH>HPTHENCH=HP
741 GOSUB89:GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Continual Light"
!-------------------------------------------------------------------------------
742 S=15:T=3:U=31:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Invisibility"
!-------------------------------------------------------------------------------
743 S=16:T=6:U=21:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Hold Monster"
!-------------------------------------------------------------------------------
744 PRINTSP$(17):GOSUB63:IFD=0THEN687
745 IFINT(RND(1)*20+ML)>S(1)THENPRINT"The "M$" ignores you!":GOTO253
746 PRINT"The "M$" is held!":PRINT"Press <RET> to kill:";:GOSUB68
747 IFC$<>CHR$(13)THENGOSUB64:GOTO287
748 IFRND(1)>.2+ML*.03THEN249
749 PRINT"It broke free!!":GOSUB65:GOTO253
!-------------------------------------------------------------------------------
!- - Cast "Phantasml Forces"
!-------------------------------------------------------------------------------
750 PRINTSP$(18):GOSUB63:IFD=0THEN687
751 IFINT(RND(1)*22+ML)<S(1)THEN753
752 PRINT"The "M$" doesn't believe!":GOTO253
753 PRINT"It believes!....ARRGH...":GOTO249
!-------------------------------------------------------------------------------
!- Level 4 Spells
!-------------------------------------------------------------------------------
754 ONSGOTO 755,770,773,775,779,780
!-------------------------------------------------------------------------------
!- - Cast "Pass Wall"
!-------------------------------------------------------------------------------
755 PRINTSP$(19):GOSUB63:IFD=1THEN686
756 PRINT"Direction>";:GOSUB68
757 FORI=1TO9:IFMID$("wxad8246{cm +}",I,1)=C$THEN759
758 NEXT:PRINT"???":GOSUB64:GOTO756
759 IFI>4THENI=I-4
760 IFI=5THEN688
761 IF(I=1ANDCY>1)OR(I=2ANDCY<200)OR(I=3ANDCX>1)OR(I=4ANDCX<200)THEN763
762 PRINT"Only stone there....":GOTO688
763 GOSUB109:PRINT:PRINT"****{reverse on}POOF!{reverse off}****"
764 ONIGOTO 766,768,765,767
765 FORQ=0TO25:FORJ=10TO14STEP2:POKECP+J,PEEK(CP+J)-2:NEXT:NEXT:GOTO769
766 FORQ=0TO25:FORJ=11TO15STEP2:POKECP+J,PEEK(CP+J)-2:NEXT:NEXT:GOTO769
767 FORQ=0TO25:FORJ=10TO14STEP2:POKECP+J,PEEK(CP+J)+2:NEXT:NEXT:GOTO769
768 FORQ=0TO25:FORJ=11TO15STEP2:POKECP+J,PEEK(CP+J)+2:NEXT:NEXT
769 ONIGOTO 535,537,539,541
!-------------------------------------------------------------------------------
!- - Cast "Fireball"
!-------------------------------------------------------------------------------
770 PRINTSP$(20):GOSUB64:PRINT"Whoooooshh!!!":IFD=0THEN687
771 PRINT"The "M$" is burning!":I=INT(RND(1)*12*LV+15)
772 FORQ=0TO127:POKEBK,2:POKEBK,8:NEXT:POKEBK,0:GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Cause Serious Wnd"
!-------------------------------------------------------------------------------
773 PRINTSP$(21):GOSUB63:IFD=0THEN687
774 I=INT(RND(1)*32+10):GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Flesh to Stone"
!-------------------------------------------------------------------------------
775 PRINTSP$(22):GOSUB63:IFD=0THEN687
776 IFRND(1)>.6THENPRINT"The "M$" isn't affected.":GOTO253
777 POKEC9+1,12:POKEC9+2,15:POKEC9+3,11:POKEC9+4,12
778 POKEM1,15:POKEM2,11:PRINT"One stone statue....":GOSUB65:GOTO249
!-------------------------------------------------------------------------------
!- - Cast "Fear"
!-------------------------------------------------------------------------------
779 S=23:T=7:U=30:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Finger of Death"
!-------------------------------------------------------------------------------
780 PRINTSP$(24):GOSUB63:PRINT"DIE!!!!!!":IFD=0THEN687
781 IFUN=1THEN693
782 GOSUB65:IFRND(1)>.3+ML*.04-LV*.03THEN249
783 PRINT"The "M$" laughs!":GOSUB63:GOTO253
!-------------------------------------------------------------------------------
!- Level 5 Spells
!-------------------------------------------------------------------------------
784 ONSGOTO 785,794,795,799,801,808
!-------------------------------------------------------------------------------
!- - Cast "Teleport"
!-------------------------------------------------------------------------------
785 PRINTSP$(25):GOSUB63:IFD=1THEN686
786 PRINT"+North/-South:";:GOSUB654:NY=C:PRINT"+East/-West:";:GOSUB654
787 NX=C:PRINT"+Up/-Down:";:GOSUB654:NZ=C:I=SQR(NX^2+NY^2+(NZ*5)^2)-.1
788 IFI>LV*5THENPRINT"Too far...try again":GOSUB63:GOTO786
789 NX=CX+NX:NY=CY-NY:NZ=CZ-NZ
790 IFNX>0ANDNX<201ANDNY>0ANDNY<201ANDNZ<(VB+1)THEN792
791 PRINT"Only stone there....the spell fails..":GOTO688
792 IFNZ<1THENPRINT"Only thin air...the spell fails":GOTO688
793 CX=NX:CY=NY:CZ=NZ:PRINT"{cyan}{cm +*3}POOF!{cm +*3}{white}":GOSUB109:GOTO201
!-------------------------------------------------------------------------------
!- - Cast "Astral Walk"
!-------------------------------------------------------------------------------
794 S=26:T=8:U=16:GOTO708
!-------------------------------------------------------------------------------
!- - Cast "Power Word Kill"
!-------------------------------------------------------------------------------
795 PRINTSP$(27):GOSUB63:IFD=0THEN687
796 PRINT"QWERTY!!!!":GOSUB65:IFUN=0ANDRND(1)<.8THEN249
797 IFUN=1THEN693
798 PRINT"{up}The "M$" doesn't hear...":GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Ice Storm"
!-------------------------------------------------------------------------------
799 PRINTSP$(28):GOSUB63:IFD=0THEN687
800 PRINT"BRRRR!!!!":I=60:GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Wall of Fire"
!-------------------------------------------------------------------------------
801 PRINTSP$(29):GOSUB63:POKESG,4:POKEGI,3:SYSDS:PRINT"WWhhooooosshhh!!!"
802 POKE1675,PEEK(1675)OR32
803 PRINT"A wall of fire appears about you!":GOSUB65:GOSUB63
804 IFD=0THEN687
805 POKESG,5:POKEGI,1:SYSDS:POKE1675,PEEK(1675)AND223
806 IFRND(1)>.4THENPOKESE,TE:PRINT"The "M$" is gone.":GOTO692
807 PRINT"The "M$" walks through!!!":I=INT(RND(1)*12+8):GOTO684
!-------------------------------------------------------------------------------
!- - Cast "Plague"
!-------------------------------------------------------------------------------
808 PRINTSP$(30):GOSUB63:IFD=0THEN687
809 IFUN=1THEN693
810 PRINT"Black death for the "M$'.'
811 GOSUB63:IFRND(1)>S(2)*.05THENPRINT"It is immune!":GOTO688
812 IFRND(1)*2<S(3)*.03+1THEN249
813 PRINT"The spell backfires!!":GOSUB63:GOTO600
!-------------------------------------------------------------------------------
!- Level 6 Spells
!-------------------------------------------------------------------------------
814 ONSGOTO 815,819,824,829,832,834
!-------------------------------------------------------------------------------
!- - Cast "Time Stop"
!-------------------------------------------------------------------------------
815 PRINTSP$(31):GOSUB63:PRINT"Time is frozen, monsters cannot"
816 PRINT"attack you.":IFSF(9)<0THENSF(9)=0
817 SF(9)=SF(9)+FNR(20)+4:IFD=1THEN300
818 GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Raise Dead"
!-------------------------------------------------------------------------------
819 S=32:T=10:U=40:GOTO708
820 PRINTSP$(32):GOSUB63:S(3)=S(3)-1
821 SF(10)=0:IFRND(1)>S(3)*.06THEN823
822 PRINT"It works!!":CH=HP:GOSUB89:POKESE,TE:GOSUB110:D=0:GOTO688
823 PRINT"It doesn't work!":GOTO600
!-------------------------------------------------------------------------------
!- - Cast "Holy Symbol"
!-------------------------------------------------------------------------------
824 PRINTSP$(33):GOSUB63:IFD=0THEN687
825 SYSDP:POKESG,4:POKEGI,1:SYSDS:POKE1675,PEEK(1675)OR32
826 GOSUB65:POKESG,5:POKEGI,1:SYSDS:POKE1675,PEEK(1675)AND223:SYSEP
827 IFRND(1)<.9THEN249
828 PRINT"The "M$" doesn't see...":GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Word of Recall"
!-------------------------------------------------------------------------------
829 PRINTSP$(34):GOSUB63:IFD=1THEN686
830 FORI=0TO10:I(I)=0:NEXT:GD=0:PRINT"{clear}";:GOSUB93:GOSUB109
831 CX=25:CY=13:CZ=1:PRINT"***ZAP!!***":GOSUB65:GOTO201
!-------------------------------------------------------------------------------
!- - Cast "Restoration"
!-------------------------------------------------------------------------------
832 PRINTSP$(35):GOSUB63:PRINT"You feel better!":CH=HP:GOSUB89
833 GOTO688
!-------------------------------------------------------------------------------
!- - Cast "Prismatic Wall"
!-------------------------------------------------------------------------------
834 PRINTSP$(36):GOSUB63:PRINT"A shifting multi-colored wall appears."
835 IFD=0THEN687
836 POKESG,4:POKEGI,2:SYSDS:FORI=0TO4:FORJ=0TO6:POKEC9+5,P1(J):POKEC9+6,P2(J)
837 POKEC9+7,P3(J):FORK=0TO30:NEXT:NEXT:NEXT:POKESG,5:POKEGI,1:SYSDS
838 PRINT"The "M$" is gone.":GOTO692
!-------------------------------------------------------------------------------
!- Monsters Move One Step Closer
!-------------------------------------------------------------------------------
839 M=0:IFM%(1)=0THEN841
840 M=M%(1):ML=L%(1):MH=H%(1):GOSUB652
841 FORI=1TO19:M%(I)=M%(I+1):L%(I)=L%(I+1):H%(I)=H%(I+1):NEXT
842 M%(20)=0:L%(20)=0:H%(20)=0
!-------------------------------------------------------------------------------
!- Print Evaded Monster Track
!-------------------------------------------------------------------------------
843 PRINT"{home}":PRINTTAB(22)"{up}";:FORQ=1TO20:IFM%(Q)=0THENPRINT" {down}{left}";:GOTO845
844 PRINT"{sh -}{down}{left}";
845 NEXT:RETURN
!-------------------------------------------------------------------------------
!- Monsters Move Back One Step
!-------------------------------------------------------------------------------
846 FORQ=19TO1STEP-1:M%(Q+1)=M%(Q):L%(Q+1)=L%(Q):H%(Q+1)=H%(Q):NEXT
847 IFM=0THENM%(1)=0:L%(1)=0:H%(1)=0:GOTO843
848 M%(1)=M:L%(1)=ML:H%(1)=MH:GOTO843
!-------------------------------------------------------------------------------
!- End Game and Return to BASIC
!-------------------------------------------------------------------------------
849 GOSUB65:SYS(PEEK(65532)+TF*PEEK(65533)):END
!-------------------------------------------------------------------------------
!- SETUP TREASURE
!-------------------------------------------------------------------------------
!- Setup treasure sprites and gems/jewels animation delay
850 SYSRA:POKESG,2:POKEGI,TJ+1:IFTJ+1>3THENAN=4:AR=20
!- Display sprites
851 SYSDS:RETURN
!-------------------------------------------------------------------------------
!- INPUT ANIMATION ROUTINES
!-------------------------------------------------------------------------------
852 AQ=INT(400/AR):FORQ=1TOAQ:FORQQ=1TOAR:GETC$:IFC$<>""THEN71
853 NEXT
854 GOSUB857
855 NEXT:IFNM$="Demo"THEN852
856 GOTO76
!-------------------------------------------------------------------------------
!- Select Room's Visual Effects
!-------------------------------------------------------------------------------
857 ONANGOSUB 859,860,865,867,872
858 RETURN
!-------------------------------------------------------------------------------
!- Gray Misty Cube: Cycle sprite colors
!-------------------------------------------------------------------------------
859 I=PEEK(C9+3):POKEC9+3,PEEK(C9+2):POKEC9+2,PEEK(C9+1):POKEC9+1,I:RETURN
!-------------------------------------------------------------------------------
!- Flashing Box with Lights: Cycle sprite colors
!-------------------------------------------------------------------------------
860 POKEF1+1,20+AC*2:IF(AC=0)OR(AC=4)THENPOKEC9+2,10:POKEM2,6
861 IF(AC=1)OR(AC=5)THENPOKEC9+1,8:POKEC9+2,2
862 IF(AC=2)OR(AC=6)THENPOKEM1,13:POKEC9+1,7
863 IF(AC=3)OR(AC=7)THENPOKEM2,14:POKEM1,5
864 AC=(AC+1)AND7:RETURN
!-------------------------------------------------------------------------------
!- Throne: Cycle sprite colors
!-------------------------------------------------------------------------------
865 POKEC9+3,AC:POKEM1,AC+1:POKEM2,AC+2:AC=(AC+2)AND15:IFAC=13THENAC=1
866 RETURN
!-------------------------------------------------------------------------------
!- Gems/Jewels: Cycle sprite colors
!-------------------------------------------------------------------------------
867 IFJC=0THENPOKEM2,PEEK(M2)AND7:POKEC9+1,PEEK(C9+1)OR8
868 IFJC=1THENPOKEC9+1,PEEK(C9+1)AND7:POKEM1,PEEK(M1)OR8
869 IFJC=2THENPOKEM1,PEEK(M1)AND7:POKEM2,PEEK(M2)OR8
870 JC=JC+1:IFJC=3THENJC=0
871 RETURN
!-------------------------------------------------------------------------------
!- Fountain: Cycle sprite pointers
!-------------------------------------------------------------------------------
872 POKESL,181+AC:AC=AC+1:IFAC=3THENAC=0
873 RETURN
!-------------------------------------------------------------------------------
!- CHIME I TIMES
!-------------------------------------------------------------------------------
874 IFPEEK(IB)THENRETURN
875 POKEF1+1,11:POKEF1,0:POKEF+5,43:POKEF+6,0:POKEF3+1,5:POKEF3,0:POKEFV,15
876 FORQ=1TOI:POKEF4,20:POKEF4,21:FORQQ=1TO10:POKEFZ,RND(1)*8+200:NEXT
877 FORQQ=1TO600
878 IFPEEK(IB)THENPOKEF4,0:POKEF5,0:POKEF6,0:POKEFV,0:POKEFZ,200:RETURN
879 NEXT:NEXT:POKEF4,20:GOSUB65:POKEFV,0:POKEFZ,200:RETURN
!-------------------------------------------------------------------------------
!- TITLE PAGE MUSIC
!-------------------------------------------------------------------------------
880 POKEF+5,144:POKEF+6,217:POKEF+12,251:POKEF+13,27:POKEF+19,251:POKEF+20,27
881 POKEF3,70:POKEF3+1,6:POKEF5,0
882 POKEFV,8:FORJ=1TO500:NEXT:POKEF6,129:TI$="000000"
883 IFPEEK(IB)THEN892
884 POKEFZ,RND(1)*4+200:IFTI<480THEN883
885 POKEF2,251:POKEF2+1,9:POKEF5,129:TI$="000000"
886 IFPEEK(IB)THEN892
887 POKEFZ,RND(1)*4+200:IFTI<540THEN886
888 POKEF6,0:POKEF+19,16:POKEF+20,215:F(0)=17:F(1)=129:F(2)=17:POKEFV,15
889 POKEFZ,200:POKEF+5,16:POKEF+6,215
890 FF=FT:GOSUB893:IFPEEK(IB)THEN892
891 I=5:GOSUB874
892 POKEF4,0:POKEF5,0:POKEF6,0:FORQ=0TO24:POKEF+Q,0:NEXT:RETURN
!-------------------------------------------------------------------------------
!- MUSIC SEQUENCER
!-------------------------------------------------------------------------------
893 K=F1+1
894 TI$="000000":FS=PEEK(FF)*3:IFFS=0THENRETURN
895 FF=FF+1:FORI=0TO2:Q=PEEK(FF):IFQ=0THEN898
896 IFQ=255THENPOKEF4+I*7,0:GOTO898
897 POKEF1+I*7,NT%(Q)ANDTH:POKEK+I*7,NT%(Q)/TF:POKEF4+I*7,F(I)
898 FF=FF+1:NEXTI:IFPEEK(IB)THENRETURN
899 IFAN=3THENGOSUB865
900 IFPEEK(IB)THENRETURN
901 IFTI<FSTHEN899
902 GOTO894
!-------------------------------------------------------------------------------
!- THRONE MUSIC
!-------------------------------------------------------------------------------
903 FORFQ=0TO2:POKEF+5+FQ*7,18:POKEF+6+FQ*7,244:F(FQ)=17:NEXT:FF=FC
904 POKEFV,10:GOSUB893:GOTO107
!-------------------------------------------------------------------------------
!- *TURN RUN/STOP OFF*
!-------------------------------------------------------------------------------
905 POKE56334,PEEK(56334)AND254
906 POKE788,96:POKE789,194
907 POKE792,226:POKE793,252
908 POKE56334,PEEK(56334)OR1:RETURN
!-------------------------------------------------------------------------------
!- DATA
!-------------------------------------------------------------------------------
!- Spells
909 DATA mAGIC mISSILE,sLEEP,cURE lIGHT wOUNDS,lIGHT,tURN uNDEAD,pROT/eVIL,wEB
910 DATA lEVITATE,cAUSE lIGHT wNDS,dETECT tRAPS,cHARM,sTRENGTH,lIGHTNING bOLT
911 DATA cURE sERIOUS wNDS,cONTINUAL lIGHT,iNVISIBILITY,hOLD mONSTER
912 DATA pHANTSML fORCES,pASS wALL,fIREBALL,cAUSE sERIOUS wND,fLESH TO sTONE
913 DATA fEAR,fINGER OF dEATH,tELEPORT,aSTRAL wALK,pOWER wORD kILL,iCE sTORM
914 DATA wALL OF fIRE,pLAGUE,tIME sTOP,rAISE dEAD,hOLY sYMBOL,wORD OF rECALL
915 DATA rESTORATION,pRISMATIC wALL
!- Inn Names
916 DATA sALTY,bOLD,lOUD,oLD,gOODLY,wORTHY,lOFTY,fINE,rOCKY,aGED
917 DATA rOAD,eYE,tOOTH,dRAGON,mUG,dEMON,wHARF,bRIDGE,mEADE,aLE
918 DATA tAVERN,aLEHOUSE,cELLAR,cLUB,iNN,hOUSE,iNN,lODGE,mEADHALL,rESTHOUSE
!- Character Graphics (Doors and Walls)
919 DATA,247,247,247,,127,127,127,,,,255,255,,,,24,24,24,24,24,24,24,24