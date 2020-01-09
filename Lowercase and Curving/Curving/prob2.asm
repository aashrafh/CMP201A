.MODEL SMALL
.STACK 64
.DATA

GRADES  DB   81, 65, 77, 82, 73,55, 88, 78, 51, 91, 86, 76
SZ	EQU  12D

.CODE

MAIN    PROC    FAR
        MOV AX, @DATA
        MOV DS, AX

        MOV BX, OFFSET GRADES  ;a pointer on the array elements
        MOV DL, [BX]           ;store the maximum element and assume it is the first element of the array
        MOV CL, SZ             ;set the counter
        
GETMAX: CMP DL, [BX]           ;compare each element with the maximum
        JNC  PLAY              ;if less than then ignore it
        MOV DL, [BX]           ;if larger then replace the max

PLAY:   INC BX                 ;increment the pointer
        DEC CL                 ;decrement the counter
        JNZ GETMAX             ;loop
         
        MOV DH, 99D            ;store the largest possible grade  
        SUB DH, DL             ;get the difference between it and the max grade
        MOV BX, OFFSET Grades  ;pointer on the first element on the array             
        MOV CL, SZ             ;loop counter
                
CURVING:  MOV CH, [BX]         ;temp reg to store the value of the current element
        ADD CH, DH             ;add the difference
        MOV [BX], CH           ;return it to its position
        INC BX                 ;increment the pointer
        DEC CL                 ;decrement the loop counter
        JNZ CURVING            ;loop
        
        HLT
        MAIN    ENDP
END     MAIN