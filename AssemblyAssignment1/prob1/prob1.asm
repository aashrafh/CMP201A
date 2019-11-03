.MODEL SMALL
.STACK 64
.DATA

InputString DB 'THis iS A TEsT MESsaGE'
ResultString DB 22 DUP('?')   

.CODE

MAIN    PROC    FAR
        
        MOV AX, @DATA
        MOV DS, AX
        
        MOV CL, 22D                 ;The number of loop counter
        MOV BX, OFFSET InputString  ;Store the address of the first character byte                            
        MOV DI, OFFSET ResultString ;Output string will be stored here                                               
        
CheckLower:  MOV AL, [BX]
             CMP AL, 60H          ;compare current character with the 60H value which equals 96 the character before the frist lower character a in acii code
             JC  ConvertLower       ;jump if carry overflow or unnderflow in this case it will jump if underflow
        
SPACE:  MOV AL, [BX]                ;if the current character is a space then do nothing
        MOV [DI], AL                ;just add it to the output
        
Next:   INC DI                      ;increment the DI to store the next character
        INC BX                      ;increment the BX to get the next character that we will check
        DEC CL                      ;decrement the CL which represets the counter
        JNZ CheckLower              ;go and check the current character status
        JZ FNSH                     ;if we are done then hlt
        
ConvertLower: 
        MOV AL, [BX]
        CMP AL,20H                ;check if it a space not a capital char
        JZ SPACE                    ;if it a space thent CMP will return zero then JZ = jump if zero
        MOV AL, [BX]                ;use AL as a temp to convert from capital to small
        ADD AL, 20H                 ;add 20h which equals 32D to convert from capital to small
        MOV [DI], AL                ;put the result in the output string
        JMP Next                    ;retur to the loop

FNSH:   HLT                         ;everything is fine then finish this program
MAIN    ENDP
END     MAIN