; Author: David Diaz(lead), Bailey Kwok, Ryan Reeves, Harvey Freeman, Brian Scott
; Class: CS140 Assembly Language and Computer Architecture
; File Name: GroupProjectMain.asm
; Creation Date: 10/24/2023
; Program Description: This program represents a user shoping throught an online grocerey store. 
;                      

;INCLUDE Irvine32.inc			;Use Irvine32 library.
INClUDE Grocery.inc

.data
  color = black + (yellow * 16)
  msg0 BYTE " _____                                                                               _____", 0ah               
 BYTE "( ___ )                                                                             ( ___ )", 0dh,0ah                       
 BYTE " |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | ", 0dh,0ah                          
 BYTE " |   |  ______     ______     ______     ______     ______     ______     __  __     |   |", 0dh,0ah                          
 BYTE " |   | /\  ___\   /\  == \   /\  __ \   /\  ___\   /\  ___\   /\  == \   /\ \_\ \    |   | ", 0dh,0ah                        
 BYTE " |   | \ \ \__ \  \ \  __<   \ \ \/\ \  \ \ \____  \ \  __\   \ \  __<   \ \____ \   |   | ", 0dh,0ah
 BYTE " |   |  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_____\  \ \_\ \_\  \/\_____\  |   |", 0dh,0ah
 BYTE " |   |   \/_____/   \/_/ /_/   \/_____/   \/_____/   \/_____/   \/_/ /_/   \/_____/  |   | ", 0dh,0ah
 BYTE " |   |             ______     ______   ______     ______     ______                  |   | ", 0dh,0ah
 BYTE " |   |            /\  ___\   /\__  _\ /\  __ \   /\  == \   /\  ___\                 |   |", 0dh,0ah
 BYTE " |   |            \ \___  \  \/_/\ \/ \ \ \/\ \  \ \  __<   \ \  __\                 |   |", 0dh,0ah
 BYTE " |   |             \/\_____\    \ \_\  \ \_____\  \ \_\ \_\  \ \_____\               |   | ", 0dh,0ah
 BYTE " |   |              \/_____/     \/_/   \/_____/   \/_/ /_/   \/_____/               |   |", 0dh,0ah
 BYTE " |   |                   __    __     ______     __   __     __  __                  |   | ", 0dh,0ah
 BYTE " |   |                  /\ \-./  \   /\  ___\   /\ \-.\ \   /\ \/\ \                 |   | ", 0dh,0ah
 BYTE " |   |                  \ \ \-./\ \  \ \  __\   \ \ \-.\ \  \ \ \_\ \                |   | ", 0dh,0ah
 BYTE " |   |                   \ \_\ \ \_\  \ \_____\  \ \_\\ \_\  \ \_____\               |   |", 0dh,0ah
 BYTE " |   |                    \/_/  \/_/   \/_____/   \/_/ \/_/   \/_____/               |   |", 0dh,0ah
 BYTE " |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| ", 0dh,0ah
 BYTE "(_____)                                                                             (_____)", 0 


  msg1 BYTE "Please browse our menu selections and choose what kind of product your looking for", 0

  msg2 BYTE "---- Grocery store menu -----", 0ah              ; String used to prompt message.
      BYTE "    1.Dairy Products", 0dh,0ah                    ; String used to prompt message.
      BYTE "    2.Produce ", 0dh,0ah                          ; String used to prompt message.
      BYTE "    3.Meats", 0dh,0ah                             ; String used to prompt message.
      BYTE "    4.Beverages", 0dh,0ah                         ; String used to prompt message.
      BYTE "    5.Exit to check out", 0                         ; String used to prompt message.
      ;BYTE "    6.Exit Program", 0                            ; String used to prompt message.

  msg3 BYTE "Enter a choice from the menu: ", 0               ; String used to prompt message.
  msg4 BYTE " - Please  Input a valid menu number -", 0       ; String used to prompt message.

.code
main PROC
  ;Write your code here.

  mov eax, color
  call SetTextColor
  call Clrscr

  OperationScreen:

  mov edx, OFFSET msg0  ; Puts message 1 in the edx register.
    call WriteString      ; Puts the menu on the console.
  call Crlf
  call Crlf

  mov edx, OFFSET msg1  ; Puts message 1 in the edx register.
    call WriteString      ; Puts the menu on the console.
  call Crlf             ; New line.
    call Crlf             ; New line.
  mov edx, OFFSET msg2  ; Puts message 2 in the edx register.
  call WriteString      ; Puts message 2 on the console. 
  call Crlf
  call Crlf
  mov edx, OFFSET msg3  ; Puts message 2 in the edx register.
  call WriteString      ; Puts message 2 on the console. 


  l1:
  call readChar         ; Allows a user to enter the menu choice.
    call WriteChar        ; Puts there choice on the console.
  cmp al, '5'           ; Checks to see if user entered a valid menu value.
  ja l2                 ; Jumps to loop 2 if the inputed menu value is above 6.
    cmp al, '1'           ; Checks to see if the user entered a valid menu value.
  jb l2                 ; Jumps to loop 2 if the inputed menu value is below 1.

    call Crlf             ; New line.
  INVOKE GroceryMenu       ; Calls the  procedure.
  jc quit               ; Jumps is carry equals 1 and exits.

  l2:
    call Crlf
  mov edx, OFFSET msg4  ; Puts message 4 in the edx register.
  call WriteString      ; Puts message 4 on the console.
    call Crlf             ; New line.
    call Crlf             ; New line.
    jmp OperationScreen

  quit: exit

  exit						;Exit program.
main ENDP

  ;Procedures go here.



END main