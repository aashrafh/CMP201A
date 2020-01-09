SCROLL MACRO X, Y, EX, EY
	MOV AX, 0601h    ; Scroll up function
	MOV CH, Y     ; Upper left corner CH=row, CL=column
	MOV CL, X
	MOV DH, EY   ; lower right corner DH=row, DL=column
	MOV DL, EX
	MOV BH, 07    
	INT 10H
ENDM SCROLL

CURSOR MACRO X, Y
	MOV AH,2       ;move cursor function
	MOV DH,Y	   ;DH = Y
	MOV DL,X       ;DL = X
	MOV BH,0 	   ;Display Page
	INT 10H        ;Execute
ENDM CURSOR

SENDING MACRO VALUE
LOCAL AGAIN
;PUSHA
;Check that Transmitter Holding Register is Empty
	mov dx,3FDH		; Line Status Register
AGAIN:
	In al,dx 			;Read Line Status
  	AND al,00100000b
  	JZ AGAIN

;If empty put the VALUE in Transmit data register
  	mov dx,3F8H		; Transmit data register
  	mov al,VALUE
  	out dx,al 
;POPA
ENDM SENDING

RECEIVING MACRO VALUE
	;PUSHA
  ;CHECK THAT DATA READY
  MOV DX,3FDH		; LINE STATUS REGISTER
  IN AL,DX 
  AND AL,1
  JNZ READ 
  JMP FINISH

  READ:
  ;IF READY READ THE VALUE IN RECEIVE DATA REGISTER
	MOV DX,03F8H
	IN AL,DX 
	MOV VALUE,AL

  FINISH:
	;POPA
ENDM RECEIVING