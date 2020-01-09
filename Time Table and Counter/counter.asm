 .MODEL SMALL
 .STACK 100H

 .DATA
   PROMPT   DB  'Enter the the starting number :',' $'
   
   res DB        0FFFh DUP('*') 
   startnum DB   0FFFh DUP('$')

 .CODE
 
 
 ;---------------------------------------------------------------

 ENDL PROC NEAR
   
   PUSH AX                   ; push AX onto the STACK
   PUSH DX                   ; push DX onto the STACK

   MOV AH, 2                 ; set output function
   MOV DL, 0AH               ; enter ascii
   INT 21H                   

   MOV DL, 0DH               ; line feed ascii
   INT 21H

   POP DX                    ; pop a value from STACK to DX
   POP AX                    ; pop a value from STACK to AX

   RET                       ; return control to the calling procedure
 ENDL ENDP
 ;---------------------------------------------------------------------
 AOUT MACRO char
 
  mov ah ,02
  mov dl , char
  int 21h
  
 ENDM AOUT
 ;---------------------------------------------------------------------
DELAY MACRO
 ;one million microsecond
 mov cx ,0Fh  
 mov dx ,4240h
 mov ah ,86h
 int 15h
  
ENDM DELAY
 ;---------------------------------------------------------------------
CHECK_KEY_PRESSED MACRO
 mov ah ,1
 int 16h
ENDM CHECK_KEY_PRESSED
 
 ;---------------------------------------------------------------------
 MAIN PROC
 ;{ 
     MOV AX, @DATA                ; initialize DS  
     MOV DS, AX

     LEA DX, PROMPT               ; load and display PROMPT_1  
     MOV AH, 9
     INT 21H

    mov si ,offset startnum
	
	
	;----------------------------------------------
	
    READ_START: 
         MOV AH, 1                    ; read a character
         INT 21H
         
		 cmp al,0DH                  ;if (pressed key = enter) 
		 je End_reading
		 
		 
		 mov [si] , al    
		 inc si		 
		 jmp read_Start
	
	End_reading:
	     dec si
         mov di ,si      
	    
	
	;------------------------------------------------
   
 REB:	
 ;{  
	
	CALL ENDL  ;endl like c++ 
	;-------------------------------------------------
	INCNUM:                            ;increment the number
	;{  
	   mov bl, [si]
	   cmp bl , '9'
       je DECREMENT
       
       mov bl ,[si]
       cmp bl ,'*'
       jne not_the_first
	       mov bl ,'0'
           mov [si],bl             
       not_the_first:
        
	   
	   mov bl ,[si]
	   add bl ,1
	   mov [si],bl
	   jmp NEWNUM_OFFSET
	   
       DECREMENT:
          mov bl ,'0'
          mov [si],bl
          dec si		  
	      jmp INCNUM
	;} 
	;------------------------------------------------
    NEWNUM_OFFSET:    ;edit the offset to hold new number
    ;{       
		 dec di
		 mov bl ,[di]			 
		 cmp bl ,'*'
		 jnz NEWNUM_OFFSET
         inc di	     ;the offset of the new number
	;}	 
	;-------------------------------------------------
	Print_num:
	;{    
	   mov bl ,[di]
	   cmp bl, '$'
       je End_Print 	   
	   	
	   AOUT [di]   ; call the procedure 	   
	   
	   inc di
	   jmp Print_num 

       End_Print:
	;}
	;--------------------------------------------------
	dec di           
	mov si ,di        ;hold  the last char of the number to start new number
	;--------------------------------------------------
	DELAY  ;delay by second
    
	CHECK_KEY_PRESSED ;check if key is Pressed
	
	jnz ENDALL 
    
	jmp REB                     
    
  ;}
   ENDALL:
     MOV AH, 4CH                  ; return control to DOS
     INT 21H
;}	 
MAIN ENDP
END MAIN