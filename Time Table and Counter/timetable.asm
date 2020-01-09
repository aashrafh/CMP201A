.MODEL SMALL
.STACK 64
.DATA
Days DB 'SAT', 'SUN', 'MON', 'TUS', 'WED', 'THU'
Sessions DB '1ST', '2ND', '3RD', '4TH', '5TH', '6TH', '7TH'
			;SAT, SUN, MON, TUS, WED, THU
Lectures DB 'MENN001', 0, 0, 0, 'CMPN201', 0, 0 ;1st day
		 DB	'BENN001', 0, 0, 0, 'CMPN201', 0, 0 ;2nd day
		 DB	'GENN001', 0, 0, 0, 'CMPN201', 0, 0 ;3rd day
		 DB	'GENN001', 0, 0, 0, 'CMPN201', 0, 0 ;4th day
		 DB	'GENN001', 0, 0, 0, 'CMPN201', 0, 0 ;5th day
		 DB	'GENN001', 0, 0, 0, 'CMPN201', 0, 0 ;6th day
ZERO DB '   0   '	 ;If you want to print nothing just replace 0 with space ==> '       '
X DB 0
Y DB 0
LEN DB 0
CNT DB 0

.CODE
MAIN PROC FAR
	MOV AX, @DATA
	MOV DS, AX
	MOV ES, AX
	
	; MOV AH, 00H ; Set video mode
	; MOV AL, 10H ; Mode 13h
	; INT 10H        ; We are now in 320x200x256
	
	;clear the screan
	MOV AH, 06h    ; Scroll up function
	XOR AL, AL     ; Clear entire screen
	XOR CX, CX     ; Upper left corner CH=row, CL=column
	MOV DX, 184FH  ; lower right corner DH=row, DL=column 
	MOV BH, 0      ; color 
	INT 10H
	
	MOV SI, OFFSET Days
	MOV DI, 6		;number of days to display
	
	;set the position
	MOV AH, 7
	MOV X, AH
	MOV AH, 1
	MOV Y, AH
	displayDays:
		;print the day name
		MOV BP, SI ; ES: BP POINTS TO THE TEXT
		MOV AH, 13H ; WRITE THE STRING
		MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
		XOR BH,BH ; VIDEO PAGE = 0
		MOV BL, 4 ;RED
		MOV CX, 3 ; LENGTH OF THE STRING
		MOV DH, Y ;ROW TO PLACE STRING
		MOV DL, X ; COLUMN TO PLACE STRING
		INT 10H	  ;execute
		;ready for the next
		ADD SI, 3
		MOV AH, 10
		ADD X, AH
		DEC DI
		JNZ displayDays
		
	
	;starting position for the sessions
	MOV AH, 1
	MOV X, AH
	MOV AH, 3
	MOV Y, AH
	MOV SI, OFFSET Sessions
	MOV DI, 7		;number of days to display
	
	;printing sessions column
	displaySessions:
		;print the session name
		MOV BP, SI ; ES: BP POINTS TO THE TEXT
		MOV AH, 13H ; WRITE THE STRING
		MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
		XOR BH,BH ; VIDEO PAGE = 0
		MOV BL, 2 ;GREAN
		MOV CX, 3 ; LENGTH OF THE STRING
		MOV DH, Y ;ROW TO PLACE STRING
		MOV DL, X ; COLUMN TO PLACE STRING
		INT 10H   ;execute
		;ready for the next
		ADD SI, 3
		MOV AH, 3
		ADD Y, AH
		DEC DI
	JNZ displaySessions
	
	
	MOV SI, OFFSET Lectures    ;ready for printing lecs
	;set the loop counter
	MOV Ax, 0007
	MOV DI, AX
	;set the position for the first lec
	MOV X, 7
	MOV Y, 3
	;counter for the outer loop
	MOV CNT, 6
	;print the lectures matrix
	LEC:
		displayLecs:
			;check if it a free lecture
			MOV AX, [SI]
			MOV AH, 0
			CMP AX, 0
			JE ZEROHERE
			
			MOV LEN, 7
			JMP GO
			
			;If it a free lecture handle it
			ZEROHERE:
			PUSH SI     ;keep the offset
			mov si, offset ZERO
			MOV LEN, 1
			;normal loop ro print a column of lectures
			GO:
			MOV BP, SI ; ES: BP POINTS TO THE TEXT
			MOV AH, 13H ; WRITE THE STRING
			MOV AL, 01H; ATTRIBUTE IN BL, MOVE CURSOR TO THAT POSITION
			XOR BH,BH ; VIDEO PAGE = 0
			MOV BL, 15 ;WHITE
			MOV CL, 7 ; LENGTH OF THE STRING
			MOV CH, 0
			MOV DH, Y ;ROW TO PLACE STRING
			MOV DL, X ; COLUMN TO PLACE STRING
			INT 10H   ;execute
			
			;ready for the next
			MOV AH, LEN
			CMP AH, 1 ;compare if it a free lecture
			JNE DONE  ;If not a free lecture
			POP SI    ;if not a free lecture the return to the previos offset
			DONE:	  ;normal increment if it not a free lecture
				MOV AL, LEN
				MOV AH, 0
				ADD SI, AX ;move the offset
				ADD Y, 3   ;move the column
				DEC DI     ;counter
			JNZ displayLecs
		;ready for the next				 
		MOV Ax, 0007
		MOV DI, AX		                 
		ADD X, 10
		MOV Y, 3
		DEC CNT
		JNZ LEC
	
	MOV AH, 4CH
	INT 21H
MAIN ENDP
END MAIN