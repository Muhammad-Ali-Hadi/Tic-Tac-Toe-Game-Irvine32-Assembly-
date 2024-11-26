include irvine32.inc

.data

WelcomeMsg BYTE "                  Welcome to TIC-TAC-TOE",0dh,0ah,0dh,0ah,0
Rules0 BYTE "The rules of the game are as follows:",0dh,0ah,0
Rules1 BYTE "1. PLAYERS: 2 players can play this game",0dh,0ah,0
Rules2 BYTE "2. TURNS: Begins with player 1 and then alternates between the 2 players",0dh,0ah,0
Rules3 BYTE "3. INPUTS: Player 1 will enter coordinates for placing X whereas Player 2 will enter coordinates for placing O along with the coordinates for position on XO grid",0dh,0ah,0
Rules4 BYTE "4. GAME OVER: Game will end when any player successfully manages to connect three consecutive blocks either row-wise, column-wise, or diagonally",0dh,0ah,0
TurnMsg1 BYTE "Player 1 turn: ",0dh,0ah,0
TurnMsg2 BYTE "Player 2 turn: ",0dh,0ah,0
WinMsg1 BYTE "Player 1 wins !",0dh,0ah,0
WinMsg2 BYTE "Player 2 wins !",0dh,0ah,0
TieMsg BYTE "Game is tied !",0dh,0ah,0
Space BYTE " ",0
player1 BYTE 'X'
player2 BYTE 'O'
RowMsg BYTE "Enter row number (1-3)",0dh,0ah,0
ColMsg BYTE "Enter coloumn number (1-3)",0dh,0ah,0
ErrMsg BYTE "Incorrect coordiantes. Enter Again",0
playAgain BYTE "Do you want to play again? Press (1) to play and (any other key) to exit",0
Row DWORD ?
Col DWORD ?
Grid BYTE 9 DUP('*')
val1 BYTE ?
val2 BYTE ?
val3 BYTE ?
flag_enter_again BYTE ?
again DWORD ?

.code

main PROC

start:

; Initialize the grid
call reset_grid

mov edx , offset WelcomeMsg
call writestring

call Rules

mov ecx,9
mov ebx,0

turns:
push ecx
push ebx
call Input
call Print
call Row1Check
cmp eax,1
pop ebx
push ebx
je Winner
call Row2Check
cmp eax,1
pop ebx
push ebx
je Winner
call Row3Check
cmp eax,1
pop ebx
push ebx
je Winner
call Col1Check
cmp eax,1
pop ebx
push ebx
je Winner
call Col2Check
cmp eax,1
pop ebx
push ebx
je Winner
call Col3Check
cmp eax,1
pop ebx
push ebx
je Winner
call Dig1Check
cmp eax,1
pop ebx
push ebx
je Winner
call Dig2Check
cmp eax,1
pop ebx
push ebx
je Winner
pop ebx
pop ecx
cmp flag_enter_again,1
je same_turn
xor ebx,1
same_turn:
loop turns

mov edx,offset TieMsg
call writestring
exit

Winner:
cmp ebx,0
jne player2_winner
mov edx,offset WinMsg1
call writestring
call writestring
call crlf
call crlf

mov edx, offset playAgain
call writestring
call crlf

call readint
cmp eax, 1
je start

jmp done

player2_winner:
mov edx,offset WinMsg2
call writestring
call crlf
call crlf

mov edx, offset playAgain
call writestring

call readint
cmp eax, 1
je start

done:
exit

main ENDP

Rules PROC

mov edx , offset Rules0
call writestring

mov edx , offset Rules1
call writestring

mov edx , offset Rules2
call writestring

mov edx , offset Rules3
call writestring

mov edx , offset Rules4
call writestring
call crlf

ret
Rules ENDP

Print PROC
call clrscr
mov esi, offset Grid
mov ecx, 9

label1:
    cmp ecx, 9
    je skip
    cmp ecx, 6
    je line_leave
    cmp ecx, 3
    jne skip
    line_leave:
    call crlf
    skip:
	mov  al, [esi]
	call writechar
    mov edx, offset Space
	call writestring
	inc esi
loop label1
call crlf
ret
Print ENDP

Input PROC
    cmp ebx, 0
    jne Msgplayer2
    mov edx, offset TurnMsg1
    call writestring
    jmp next
    Msgplayer2:
    mov edx, offset TurnMsg2
    call writestring
    next:
    ; Display prompts and get inputs
    mov edx, offset RowMsg
    call writestring
    call readdec
    mov Row, eax

    mov edx, offset ColMsg
    call writestring
    call readdec
    mov Col, eax

    ; Validate inputs (Row, Col in range 1-3)
    cmp Row, 1
    jl invalid_input
    cmp Row, 3
    jg invalid_input
    cmp Col, 1
    jl invalid_input
    cmp Col, 3
    jg invalid_input

    ; Determine player (Player 1 or Player 2)
    cmp ebx, 0
    je update_player1
    jmp update_player2

update_player1:
    mov cl, player1
    jmp update_grid

update_player2:
    mov cl, player2

update_grid:
    mov eax, Row              ; Load Row
    dec eax                   ; Convert to zero-based index
    mov ebx, 3
    mul ebx                   ; Multiply Row by 3 (row offset)
    add eax, Col              ; Add Col
    dec eax                   ; Convert to zero-based index
    cmp Grid[eax], '*'        ; Check if the cell is empty
    jne invalid_input         ; If not empty, input is invalid
    mov Grid[eax], cl         ; Update the grid
    call crlf
    ret

invalid_input:
    mov flag_enter_again,1
    inc ecx                   ; Input Again         
    mov edx, offset ErrMsg
    call writestring
    call crlf
    call crlf
    ret

Input ENDP

Row1Check PROC
    mov al,Grid[0]
    mov val1,al
    mov al,Grid[1]
    mov val2,al
    mov al,Grid[2]
    mov val3,al
    call WinCheck
    ret
Row1Check ENDP

Row2Check PROC
    mov al,Grid[3]
    mov val1,al
    mov al,Grid[4]
    mov val2,al
    mov al,Grid[5]
    mov val3,al
    call WinCheck
    ret
Row2Check ENDP

Row3Check PROC
    mov al,Grid[6]
    mov val1,al
    mov al,Grid[7]
    mov val2,al
    mov al,Grid[8]
    mov val3,al
    call WinCheck
    ret
Row3Check ENDP

Col1Check PROC
    mov al,Grid[0]
    mov val1,al
    mov al,Grid[3]
    mov val2,al
    mov al,Grid[6]
    mov val3,al
    call WinCheck
    ret
Col1Check ENDP

Col2Check PROC
    mov al,Grid[1]
    mov val1,al
    mov al,Grid[4]
    mov val2,al
    mov al,Grid[7]
    mov val3,al
    call WinCheck
    ret
Col2Check ENDP

Col3Check PROC
    mov al,Grid[2]
    mov val1,al
    mov al,Grid[5]
    mov val2,al
    mov al,Grid[8]
    mov val3,al
    call WinCheck
    ret
Col3Check ENDP

Dig1Check PROC
    mov al,Grid[0]
    mov val1,al
    mov al,Grid[4]
    mov val2,al
    mov al,Grid[8]
    mov val3,al
    call WinCheck
    ret
Dig1Check ENDP

Dig2Check PROC
    mov al,Grid[2]
    mov val1,al
    mov al,Grid[4]
    mov val2,al
    mov al,Grid[6]
    mov val3,al
    call WinCheck
    ret
Dig2Check ENDP

WinCheck PROC
    mov al,val1
    cmp al,val2
    jne no_winner
    cmp al,val3
    jne no_winner
    cmp al,'*'           ; Ensure the winning cells are not empty
    je no_winner
    mov eax,1            ; Set eax to 1 if there is a winner
    ret                  ; Return immediately if a winner is found
no_winner:
    mov eax,0            ; Set eax to 0 if no winner
    ret
WinCheck ENDP

reset_grid PROC
    lea edi, Grid       
    mov ecx, 9          
    mov al, '*'          
reset_loop:
    mov [edi], al        
    inc edi             
    loop reset_loop     
    ret
reset_grid ENDP

end main
