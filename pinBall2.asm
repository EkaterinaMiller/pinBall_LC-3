.ORIG x3000
        LD R6, STACK
LOOP    JSR Draw
        JSR Wait
        JSR Move
        LEA R0, NEWLINE
        PUTS
        BR LOOP
        HALT

STACK   .FILL xFDFF
NEWLINE .STRINGZ    "\n\n\n\n\n\n\n\n\n"

;**************Draw*************
;
;R0 holds character to display
;R1 is number of rows
;R2 is number of colums
;R3 is counter
;R4 is x coordinate of the ball
;R5 is y coordinate of the ball

Draw:
    STR R7, R6, #0
    ADD R6, R6, #-1
    STR R5, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0
    ADD R6, R6, #-1
    ; STR R1, R6
    ; ADD R6, R6, #-1
    ;display 14 '_'
    JSR DisplayLine
 
 ;display row before the balll 
        LD R5, y
        NOT R5, R5
        ADD R5, R5, #1 ;R5 = -y
        ADD R3, R5, #8 ;number of rows before the ball
LOOP2       BRz DI_BALL
            JSR DisplayRaw
            ADD R3, R3, #-1
            BR LOOP2
;       ;dispaly the raw with the ball     
DI_BALL  JSR DispalyBall
        
;  ;display row after the balll 
        LD R5, Y
        ADD R3, R5, #-1 ;number of rows after the ball
LOOP3       BRz DI_END
            JSR DisplayRaw
            ADD R3, R3, #-1
            BRp LOOP3  
    
DI_END  JSR DisplayLine
            
    ADD R6, R6, #1
    LDR R3, R6, #0
    ADD R6, R6, #1
    LDR R5, R6, #0
    ADD R6, R6, #1
    LDR R7, R6, #0
    RET

x       .FILL #2
y       .FILL #7 

;***************Move*******************************
;
;**************************************************
Move: 
    STR R1, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    STR R3, R6, #0
    ADD R6, R6, #-1
    STR R4, R6, #0
    ADD R6, R6, #-1
    
    LD R1, x
    LD R2, moveX
    LD R3, WIDTH
    AND R4, R4, #0
    
    ADD R1, R1, R2  ;new x
    BRz BounceR
    ADD R3, R1, R3
    BRzp  BounceL  
    BR STOREx 
 

BounceR ADD R4, R4, #1
        ADD R1, R1, #2  ; R1 = 2
        BR STORemx
        
BounceL ADD R4, R4, #-1
        ADD R1, R1, #-2  ; R1 = 2
        BR STORemx
        
STORemx     ST R4, moveX
STOREx      ST R1, x 

;change y coordinate
    LD R1, y
    LD R2, moveY
    LD R3, HIGHT
    AND R4, R4, #0
    
    ADD R1, R1, R2  ;new y
    BRz BounceU
    ADD R3, R1, R3
    BRzp  BounceD  
    BR STOREy 
 

BounceU ADD R4, R4, #1
        ADD R1, R1, #2  ; R1 = 2
        BR STORemy
        
BounceD ADD R4, R4, #-1
        ADD R1, R1, #-2  ; R1 = 2
        BR STORemy
        
STORemy     ST R4, moveY
STOREy      ST R1, y 
    
    ADD R6, R6, #1
    LDR R4, R6, #0
    ADD R6, R6, #1
    LDR R3, R6, #0
    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R1, R6, #0
    RET
 
WIDTH   .FILL #-13 ; 14-1=13 =>-13
HIGHT  .FILL  #-9   ;
moveX   .FILL #1
moveY   .FILL #1  
;***************DispalyBall************************
;
;R0 holds character
;R1 is x coordinate of the ball/value of the ball
;R2 is adrees of the ball in the line
;**************************************************
DispalyBall:
    STR R0, R6, #0
    ADD R6, R6, #-1
    STR R1, R6, #0
    ADD R6, R6, #-1
    STR R2, R6, #0
    ADD R6, R6, #-1
    
    LEA R0 ballLine
    LD R1, x
    ADD R1, R1, R1;multiply R1 by 2 for output
    ADD R2, R0, R1
    LD R1, BALL
    STR R1, R2, #0
    PUTS
    ;remove ball
    LD R1, SPACE
    STR R1, R2, #0
    
    

    ADD R6, R6, #1
    LDR R2, R6, #0
    ADD R6, R6, #1
    LDR R1, R6, #0
    ADD R6, R6, #1
    LDR R0, R6, #0
    RET


;ballLine    .STRINGZ    "|            |\n";
ballLine    .STRINGZ    "|                         |\n";
BALL    .FILL   #111    ;'o'
SPACE    .FILL   #32    ;' '

;***************displayLine************************
;R0 holds character
;R1 is counter
DisplayLine:
    STR R0, R6, #0
    ADD R6, R6, #-1
    
    LEA R0 LINE
    PUTS

    ADD R6, R6, #1
    LDR R0, R6, #0
    RET   
;LINE    .STRINGZ "______________\n"
LINE    .STRINGZ "_ _ _ _ _ _ _ _ _ _ _ _ _ _\n"


;********************* displayRaw**********************
;
;R0 holds character
;R1 is counter
;******************************************************
DisplayRaw:
    STR R0, R6, #0
    ADD R6, R6, #-1
    
    LEA R0 ROW
    PUTS

    ADD R6, R6, #1
    LDR R0, R6, #0
    RET
    
;ROW .STRINGZ    "|            |\n";    
ROW .STRINGZ    "|                         |\n"; 


;*****************wait************
; Sleep subrouting
;R1 counter
;*********************************
Wait
    ST R1, SAVER1_w
    LD R1 TIME
AGAIN   ADD R1, R1, #-1
        BRnz DONE
        BR AGAIN
        
DONE    LD R1, SAVER1_W
        RET
    
    
SAVER1_w    .BLKW #1
TIME        .FILL #5000





.END