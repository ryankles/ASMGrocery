; Author: David Diaz, Bailey Kwok, Ryan Reeves, Brian Scott
; Class: CS140 Assembly Language and Computer Architecture.
; File Name: Grocery_Procedures.asm
; Creation Date: 10/05/2023
; Program Description: Describe with a short paragraph the purpose of this file. 


;Include below the name of the procedure's prototype file (inc).
INCLUDE Grocery.inc


.code
  ;------------------------------------------------------------------------------------------------------------------
  ; GroceryMenu Procedure
  ; This procedure contains a case table that creates A look up value for each user-defined procedure.
  ; Depending on what the user selects, the procedure will see if there is a match and jump to that 
  ; procedure.
  ; RECIVES: The caseTable, edx: holds the table an message prompts, ebx: holds user value, ecx: holds loop counter.
  ; RETURNS: Nothing.
  ;------------------------------------------------------------------------------------------------------------------- 

GroceryMenu PROC

.data

  invalid BYTE "Invalid Input", 0

    caseTable BYTE '1'                             ; look up value.
      DWORD Dairy_op                               ; Address of Dairy procedure.
    EntrySize = ($ - caseTable)
      BYTE '2'                                     ; lookup value.
      DWORD Produce_op                             ; Address of Produce procedure.
      BYTE '3'                                     ; look up value.
      DWORD Meats_op                               ; Address of Meats procedure.
      BYTE '4'                                     ; look up value.
      DWORD Beverages_op                           ; Address of Beverages procedure.
      BYTE '5'                                     ; look up value.
      DWORD FinalCost_op                           ; Address of the FinalCost procedure.
    NumberOfEntries = ($ - caseTable) / EntrySize


.code

  push ebx                                         ; Push ebx onto stack.
  push ecx                                         ; Push ecx onto stack.
  
  mov ebx, OFFSET caseTable                        ; Pointer to the table.
  mov ecx, NumberOfEntries                         ; loop counter.

  l1:
  cmp al, [ebx]                                    ; Checks to see if match is found.
  jne l2                                           ; If match is not found, continue. 
  call NEAR PTR [ebx + 1]                          ; If match is found, call Procedure.
  jmp l3                                           ; Jump to loop 3.

  l2:
  add ebx, EntrySize                               ; Points to the next entry.
  loop l1                                          ; Repeats until the loop is done.

  l3:
  pop ecx                                          ; Remove ebx from stack.
  pop ebx                                          ; Remove ebx from stack.

    ret
GroceryMenu ENDP








;----------------------------------------------------------------------------------------------------------------
; Dairy_op Procedure
; This procedure contains a struct that holds the foods name and value, in this procedure the user
; is able to view some dairy products and select what they want. it contains a operation for each 
; item. After selcting the user will have the chance to add another item or they can return to the menu main to 
; view another food group.
; RECIVES: eax: holds various values and variables, edx: holds message propmts
; RETURNS:Nothing
;-----------------------------------------------------------------------------------------------------------------

Dairy_op Proc

my_struct STRUCT
        food   BYTE 30 DUP (0)                     ; 30 bytes for the food name
        cost   DWORD   ?                           ; 4 bytes for the cost field
    my_struct ENDS    

.data 

field1 my_struct < "Cheese", 429>                  ; stores food and cost for field1
field2 my_struct < "Milk", 599>                    ; stores food and cost for field2
    result DWORD ?                                 ; This varaible is used to store the total of all products added

    menu1 BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0ah      ; This string is used to print the menu and the options within that menu
       BYTE "  DAIRY PRODUCTS", 0ah
       BYTE "  1. Cheese. . . . . . . . (130 Calories) $4.29  ", 0ah
       BYTE "  2. Milk  . . . . . . . . (50 Calories)  $5.99", 0ah
       BYTE "  3. Go back to main menu", 0ah
       BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0
    subMenuPrompt BYTE "Enter your choice (1-3): ", 0                    ;This string prompts the user for input

    ; Messages for displaying the selected item
    cheeseMsg BYTE "You selected Cheese. Select another item or exit back to the main menu.", 0ah, 0    ; This string is used to inform the user that they have selected Cheese, and prompts the user for input
    milkMsg   BYTE "You selected Milk. Select another item or exit back to the main menu.", 0ah, 0      ; This string is used to inform the user that they have selected Milk, and prompts the user for input

.code

    pushad                                            ; Push all registers onto the stack.
 
    mov edx, OFFSET menu1                             ; Moves the menu1 string into the edx register
    call WriteString                                  ;Ouputs the string stored in the edx register

    ; Get user input for dairy type
    call Crlf                                    
    mov edx, OFFSET subMenuPrompt                     ;moves the subMenuPrompt string into the edx register
    call WriteString                                  ;Outputs the subMenuPrompt to the console

    ; Read the user's choice
    mov eax, 0                                        ; initializes the eax register
    call ReadInt                                      ; procedure to read user input

    ; Handle user's choice
    cmp eax, 1                                        ; compare user input to 1
    je DisplayCheese                                  ; jump to display cheese 
    cmp eax, 2                                        ; compare user input to 2
    je DisplayMilk                                    ; jump to display Milk
    cmp eax, 3                                        ; compare user input to 3
    je EndDairyMenu                                   ; Go back to main menu
    jmp InvalidChoice                                 ; jump to Invalid Choice

DisplayCheese:
    ; Display Cheese message
    call Crlf                                         ; Outputs a new line
    mov edx, OFFSET cheeseMsg                         ; Moves the cheeseMsg string into the edx register
    call WriteString                                  ; Outputs the cheeseMsg string the console

    mov eax, result                                    ; move result to eax
    add eax, field1.cost                               ; Add the cost of field1

    mov result, eax                                    ; move eax to result
    jmp ChooseAnotherItem                              ; jump Choose Another Item

DisplayMilk:
    ; Display Milk message
    call Crlf                                          ; Outputs a new line
    mov edx, OFFSET milkMsg                            ; Moves the milkMsg string into the edx register
    call WriteString                                   ; Outputs the milkMsg string to the console

    mov eax, result                                    ; move result to eax
    add eax, field2.cost                               ; Add the cost of field2

    mov result, eax                                    ; move eax to result
    jmp ChooseAnotherItem                              ; jump to Choose Another Item

InvalidChoice:
    mov edx, OFFSET invalid                            
    call WriteString
    jmp ChooseAnotherItem                              ; jump to Choose Another Item
    

ChooseAnotherItem:
    ; Prompt to choose another item or go back to the main menu
    mov edx, OFFSET menu1                              ; Display the menu again    
    call WriteString 
    call Crlf
    mov edx, OFFSET subMenuPrompt                      ; move subMenu to edx    
    call WriteString                                   ; print edx
    call ReadInt                                       ; read user input

    ; Handle the user's choice for the sub-menu
    cmp eax, 1                                         ; compare user input to 1
    je DisplayCheese                                   ; jump to Display cheese
    cmp eax, 2                                         ; compare user input to 2
    je DisplayMilk                                     ; jump to Display Milk
    cmp eax, 3                                         ; compare user input to 3
    je EndDairyMenu ; Go back to main menu             ; jump to End Dairy Menu
    jmp InvalidChoice                                  ; jump to Invalid Choice

EndDairyMenu:
    popad                                        ; Save and restore procedures.

    ret                                          ;Returns
Dairy_op ENDP








  ;--------------------------------------------------------------------------------------------------------------------
  ; Produce_op Procedure
  ; This procedure contains a struct that holds the foods name and value, in this procedure the user
  ; is able to view some produce products and select what they want. it contains a operation for each 
  ; item. After selcting the user will have the chance to add another item or they can return to the menu main to 
  ; view another food group.
  ; RECIVES: eax: holds various values and variables, edx: holds message propmts
  ; RETURNS:Nothing
  ;-------------------------------------------------------------------------------------------------------------------

  Produce_op Proc


.data 

produce1 my_struct < "Mango", 99>          ; creates a my_struct called produce1 with the stored values of "Mango" and 99
produce2 my_struct < "Apple", 129>         ; creates a my_struct called produce2 with the stored values of "Apple" and 129


    menu2 BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0ah      ; This string is used to output the produce menu
       BYTE "  PRODUCE PRODUCT", 0ah
       BYTE "  1. Mango. . . . . . . . (130 Calories) $0.99  ", 0ah
       BYTE "  2. Apple  . . . . . . . . (50 Calories)  $1.29", 0ah
       BYTE "  3. Go back to main menu", 0ah
       BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0
    subMenuPrompt2 BYTE "Enter your choice (1-3): ", 0                       ; This prompts the user for input

    ; Messages for displaying the selected item
    mangoMsg BYTE "You selected Mango. Select another item or exit back to the main menu.", 0ah, 0    ;This string is used to inform the user that they have selected Mango, and prompts the user for additional input
    appleMsg   BYTE "You selected Apple. Select another item or exit back to the main menu.", 0ah, 0  ;This string is used to inform the user that they have selected Apple, and prompts the user for additional input

.code

    pushad                                          ; Push all registers onto the stack.

    mov edx, OFFSET menu2                           ; moves the menu2 string into the edx register
    call WriteString                                ; Outputs the menu2 string to the console

    ; Get user input for produce type
    call Crlf                                       ; Outputs a new line
    mov edx, OFFSET subMenuPrompt2                  ; Moves the subMenuPrompt2 string into the edx register
    call WriteString                                ; Outputs the subMenuPrompt2 string to the console

    ; Read the user's choice
    mov eax, 0                                      ; initializes the eax register
    call ReadInt                                    ; Takes user input

    ; Handle user's choice
    cmp eax, 1                                      ; compare user input to 1
    je DisplayMango                                 ; jump to display for menu
    cmp eax, 2                                      ; compares the user input to 2
    je DisplayApple                                 ; If equal jump to DisplayApple operation.
    cmp eax, 3                                      ; compares the user input to 3
    je EndProduceMenu                               ; If the user input is equal to 3 the program jumps to the EndProduceMenu jump point
    jmp InvalidChoice                               ; Jumps to the InvalidChoice jump point

DisplayMango:
    ; Display Mango message                         
    call Crlf                                       ; Makes new line.
    mov edx, OFFSET mangoMsg                        ; Moves the mangoMsg string into the edx register
    call WriteString                                ; Puts message on the console.

    mov eax, result                                 ; mov result into edx
    add eax, produce1.cost                          ; Add the cost of produce1 to result which is eax

    mov result, eax                                 ; mov eax into result to store result and clear eax
    jmp ChooseAnotherItem                           ; jumps to the ChooseAntherItem jump point

DisplayApple:
    ; Display Apple message
    call Crlf                                       ; Makes new line.
    mov edx, OFFSET appleMsg                        ; print apple message
    call WriteString

    mov eax, result                                 ; mov result into edx
    add eax, produce2.cost                          ; Add the cost of produce2 to result which is eax

    mov result, eax                                 ; mov eax into result to store result and clear eax
    jmp ChooseAnotherItem                           ; jump to Choose Another item

InvalidChoice:
    mov edx, OFFSET invalid                        ; Puts invalid message in the edx register.
    call WriteString                               ; Puts message on console.
    jmp ChooseAnotherItem                          ; jump CHoose another Item

ChooseAnotherItem:
    ; Prompt to choose another item or go back to the main menu
    mov edx, OFFSET menu2                          ; Display the menu again
    call WriteString
    call Crlf
    mov edx, OFFSET subMenuPrompt2                 ; Display the Sub Menu 
    call WriteString
    call ReadInt                                   ; Read user input

    ; Handle the user's choice for the sub-menu
    cmp eax, 1                                     ; compare user input to 1
    je DisplayMango                                ; print out the display for mango 
    cmp eax, 2                                     ; compare user input to 2
    je DisplayApple                                ; print out the display for apple
    cmp eax, 3                                     ; compare user input to 3
    je EndProduceMenu                              ; Go back to main menu
    jmp InvalidChoice                              ; jump to invalid choise is user inputs anything other then 1-3

EndProduceMenu:
    popad                                           ; Save and restore procedures.

    ret
    Produce_op ENDP









  ;--------------------------------------------------------------------------------------------------------------------
  ; Produce_op Procedure
  ; This procedure contains a struct that holds the foods name and value, in this procedure the user
  ; is able to view some produce products and select what they want. it contains a operation for each 
  ; item. After selcting the user will have the chance to add another item or they can return to the menu main to 
  ; view another food group.
  ; RECIVES: eax: holds various values and variables, edx: holds message propmts
  ; RETURNS:Nothing
  ;-------------------------------------------------------------------------------------------------------------------

  Meats_op Proc

  .data 
  meat1 my_struct < "Ham", 899>        ;Creates a my_struct called meat1 with the stored values of "Ham" and 899
  meat2 my_struct < "Steak", 2899>     ;Creates a my_struct called meat2 with the stored values of "Steak" and 2899


    menu3 BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0ah
       BYTE "  MEATS PRODUCT", 0ah
       BYTE "  1. Ham. . . . . . . . (300 Calories) $8.99  ", 0ah
       BYTE "  2. Steak  . . . . . . . . (1000 Calories)  $28.99", 0ah
       BYTE "  3. Go back to main menu", 0ah
       BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0
    subMenuPrompt3 BYTE "Enter your choice (1-3): ", 0

    ; Messages for displaying the selected item
    hamMsg BYTE "You selected Ham. Select another item or exit back to the main menu.", 0ah, 0        ;This string is used to prompt the user that they selected Ham, and prompts them to select another option
    steakMsg   BYTE "You selected Steak. Select another item or exit back to the main menu.", 0ah, 0  ;This string is used to prompt the user that they selected Steak, and prompts them to select another option

.code

    pushad                                        ; Push all registers onto the stack.

    mov edx, OFFSET menu3                         ; moves the menu3 string into the edx register
    call WriteString                              ; outputs the menu3 string into the edx register

    ; Get user input for produce type
    call Crlf                                     ; outputs a new line
    mov edx, OFFSET subMenuPrompt3                ; moves the subMenuPrompt3 string into the edx register
    call WriteString                              ; outputs the subMenuPrompt3 string to the console

    ; Read the user's choice
    mov eax, 0                                    ; initializes the eax register
    call ReadInt                                  ; takes an integer as input

    ; Handle user's choice
    cmp eax, 1                                    ; compares the input to 1
    je DisplayHam                                 ; if the input is equal to 1 the program jumps to the DisplayHam jump point
    cmp eax, 2                                    ; compares the input to 2
    je DisplaySteak                               ; if the input is equal to 2 the program jumps to the DisplaySteak jump point
    cmp eax, 3                                    ; compares the input to 3
    je EndMeatsMenu                               ; if the input is equal to 3 the program jumps to the EndMeatsMenu jump point
    jmp InvalidChoice                             ; the program jumps to the InvalidChoice jump point

DisplayHam:
    ; Display Ham message
    call Crlf                                     ; outputs a new line
    mov edx, OFFSET hamMsg                        ; moves the hamMsg string into the edx register
    call WriteString                              ; outputs the hamMsg string to the console

    mov eax, result                               ; moves the value stored in the result variable into the eax register
    add eax, meat1.cost                           ; adds the value stored in meat1 cost to the eax register

    mov result, eax                               ; moves the value stored in the eax register into the result variable
    jmp ChooseAnotherItem                         ; jumps to the ChooseAnotherItem jump point

DisplaySteak:
    ; Display Steak message
    call Crlf                                     ; outputs a new line
    mov edx, OFFSET steakMsg                      ; moves the steakMsg string into the edx register
    call WriteString                              ; outputs the steakMsg string to the console

    mov eax, result                               ; moves the value stored in the result variable to the eax register
    add eax, meat2.cost                           ; adds the value stored in meat2 cost to the eax register

    mov result, eax                               ; moves the value stored in the eax register into the result variable
    jmp ChooseAnotherItem                         ; jumps to the ChooseAnotherItem jump point

InvalidChoice:
    mov edx, OFFSET invalid                       ; moves the invalid string into the edx register
    call WriteString                              ; outputs the invalid string into the edx register
    jmp ChooseAnotherItem                         ; jumps to the ChooseAnotherItem jump point

ChooseAnotherItem:
    ; Prompt to choose another item or go back to the main menu
    mov edx, OFFSET menu3                         ; moves the menu3 string into the edx register
    call WriteString                              ; outputs the menu3 string to the console
    call Crlf                                     ; outputs a new line
    mov edx, OFFSET subMenuPrompt3                ; moves the subMenuPrompt3 string into the edx register
    call WriteString                              ; outputs the subMenuPrompt3 to the console
    call ReadInt                                  ; takes an integer as input

    ; Handle the user's choice for the sub-menu
    cmp eax, 1                                    ; compares the input to 1
    je DisplayHam                                 ; if the input is equal to 1 the program jumps to the DisplayHam jump point
    cmp eax, 2                                    ; compares the input to 2
    je DisplaySteak                               ; if the input is equal to 2 the program jumps to the DisplaySteak jump point
    cmp eax, 3                                    ; compares the input to 3
    je EndMeatsMenu                               ; if the input is equal to 3 the program jumps to the EndMeatsMenu jump point
    jmp InvalidChoice                             ; jumps to the InvalidChoice jump point

EndMeatsMenu:
       popad                                       ; Save and restore procedures.          
      
      ret                                          ; returns
  Meats_op ENDP






 ;--------------------------------------------------------------------------------------------------------------------
  ; Produce_op Procedure
  ; This procedure contains a struct that holds the foods name and value, in this procedure the user
  ; is able to view some produce products and select what they want. it contains a operation for each 
  ; item. After selcting the user will have the chance to add another item or they can return to the menu main to 
  ; view another food group.
  ; RECIVES: eax: holds various values and variables, edx: holds message propmts
  ; RETURNS:Nothing
  ;-------------------------------------------------------------------------------------------------------------------

  Beverages_op Proc

  .data 
  beverage1 my_struct < "Lemonade", 199>            ;Creates a my_struct called beverage1, with the stored values of "Lemonade" and 199
  beverage2 my_struct < "Soda", 149>                ;Creates a my_struct called beverage2, witht the stored values of "Soda", and 149

    menu4 BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0ah      ;This string contains the
       BYTE "  BEVERAGE PRODUCT", 0ah                                        ;entire menu used to display
       BYTE "  1. Lemonade. . . . . . . . (150 Calories) $1.99  ", 0ah       ;the beverage products with 
       BYTE "  2. Soda  . . . . . . . . (200 Calories)  $1.49", 0ah          ;the options for input shown
       BYTE "  3. Go back to main menu", 0ah
       BYTE " - - - - - - - - - - - - - - - - - - - - - - - - ", 0
    subMenuPrompt4 BYTE "Enter your choice (1-3): ", 0                ;This string is used to prompt the user for input for selecting which option they wish to select

    ; Messages for displaying the selected item
    lemonadeMsg BYTE "You selected Lemonade. Select another item or exit back to the main menu.", 0ah, 0  ;This string is used to prompt the user that they have chosen Lemonade, and prompts them for additional input if they have decided to add and additional product
    sodaMsg   BYTE "You selected Soda. Select another item or exit back to the main menu.", 0ah, 0  ;This string 

.code

    pushad                                           ; Push all registers onto the stack.

    mov edx, OFFSET menu4                            ; moves the menu4 string into the edx register
    call WriteString                                 ; outputs the menu4 string to the console

    ; Get user input for produce type
    call Crlf                                        ; outputs a new line
    mov edx, OFFSET subMenuPrompt4                   ; moves the subMenuPrompt4 string into the edx register
    call WriteString                                 ; outputs the subMenuPrompt4 string to the console

    ; Read the user's choice
    mov eax, 0                                       ; clears the eax register
    call ReadInt                                     ; takes an integer as input

    ; Handle user's choice
    cmp eax, 1                                       ; compares the input to 1
    je DisplayLemonade                               ; if the input is equal to 1, the program jumps to the DisplayLemonade jump point
    cmp eax, 2                                       ; compares the input to 2
    je DisplaySoda                                   ; if the input is equal to 2, the program jumps to the DisplaySoda jump point
    cmp eax, 3                                       ; compares the input to 3
    je EndBeveragesMenu                              ; if the input is equal to 3, the program jumps to the EndBeveragesMenu jump point
    jmp InvalidChoice                                ; if the input is none of the above, the program jumps to the InvalidChoice jump point

DisplayLemonade:
    ; Display Lemonade message
    call Crlf                                        ; outputs a new line
    mov edx, OFFSET lemonadeMsg                      ; moves the lemonadeMsg string into the edx register
    call WriteString                                 ; outputs the lemonadeMsg string to the console

    mov eax, result                                  ; moves the value stored in the result variable into the eax register
    add eax, beverage1.cost                          ; adds the value stored inbeverage1 cost to the eax register

    mov result, eax                                  ; moves the value stored in the eax register into the result variable
    jmp ChooseAnotherItem                            ; jumps to the ChooseAnotherItem jump point

DisplaySoda:
    ; Display Steak message
    call Crlf                                        ; outputs a new line
    mov edx, OFFSET sodaMsg                          ; moves the sodaMsg string into the edx register
    call WriteString                                 ; outputs the sodaMsg string to the console

    mov eax, result                                  ; moves the value stored in the result variable into the eax register
    add eax, beverage2.cost                          ; adds the value stored in beverage2 cost to the eax register

    mov result, eax                                  ; moves the value stored in the eax register into the result variable
    jmp ChooseAnotherItem                            ; jumps to the ChooseAnotherItem jump point

InvalidChoice:
    mov edx, OFFSET invalid                          ; moves the invalid string into the edx register
    call WriteString                                 ; outputs the invalid string
    jmp ChooseAnotherItem                            ; jumps to the ChooseAntherItem jump point

ChooseAnotherItem:
    ; Prompt to choose another item or go back to the main menu
    mov edx, OFFSET menu4                           ; moves the menu4 string into the edx register
    call WriteString                                ; outputs the menu4 string to the console
    call Crlf                                       ; outputs a new line
    mov edx, OFFSET subMenuPrompt4                  ; moves the subMenuPrompt4 string into the edx register
    call WriteString                                ; outputs the subMenuPrompt4 string to the console 
    call ReadInt                                    ; takes an integer as input

    ; Handle the user's choice for the sub-menu
    cmp eax, 1                                      ; compares the input to 1
    je DisplayLemonade                              ; if the input is equal to 1, the program jumps to the DisplayLemonade jump point
    cmp eax, 2                                      ; compares the input to 2
    je DisplaySoda                                  ; if the input is equal to 2, the program jumps to the DisplaySoda jump point
    cmp eax, 3                                      ; compares the input to 3
    je EndBeveragesMenu                             ; if the input is equal to 3, the program jumps to the EndBeveragesMenu jump point
    jmp InvalidChoice                               ; jumps to the InvalidChoice jump point

EndBeveragesMenu:
       popad                                        ; Save and restore procedures.          

      ret                                           ; returns
  Beverages_op ENDP







  ;--------------------------------------------------------------------------------------------------------------------
  ; Produce_op Procedure
  ; This procedure contains a struct that holds the foods name and value, in this procedure the user
  ; is able to view some produce products and select what they want. it contains a operation for each 
  ; item. After selcting the user will have the chance to add another item or they can return to the menu main to 
  ; view another food group.
  ; RECIVES: eax: holds various values and variables, edx: holds message propmts
  ; RETURNS:Nothing
  ;-------------------------------------------------------------------------------------------------------------------

  FinalCost_op Proc

    .data 

        ; Strings for display
        menu5 BYTE   " -------RECEIPT-------", 0
        prompt1 BYTE "    Sub-total: ", 0
        prompt2 BYTE "    Tax (10%): ", 0
        prompt4 BYTE " ---------------------", 0
        prompt3 BYTE "        Total: ", 0

    .code

        ; Push all registers onto the stack
        pushad

        ; Print header
        call Crlf
        mov edx, OFFSET menu5
        call WriteString
        call Crlf

        ; Print Sub-total prompt
        mov edx, OFFSET prompt1
        call WriteString

        ; Print '$' sign
        mov eax, '$'
        call WriteChar

        ; Calculate and print Sub-total result
        ; Use Result which is a whole number, no decimals and print it out in money form
        mov eax, result                            ; move result to eax
        mov ebx, 100                               ; move 100 into ebx
        xor edx, edx                               ; perserves the remainder bits to edx
        div ebx                                    ; divides result, now eax to ebx
        call WriteDec                              ; print first number of input $3.--
        mov eax, '.'        
        call WriteChar                             ; prints decimal point for money
        mov eax, edx                               ; move the remainder which is stored in edx to eax 
        cmp eax, 10                                ; compare if the eax to 10
        jl  PrintLeadingZero                       ; jump less if eax is less then 10 to PrintLeadingZero
        call WriteDec                              ; if user number is bigger then prints the total cents for money
        jmp taxCost                                ; jump to taxCost

    taxCost:      
        call Crlf                                  ; outputs a new line

        ; Print Tax prompt
        mov edx, OFFSET prompt2                    ; moves the prompt2 string into the edx register
        call WriteString                           ; outputs the prompt2 string to the console
        xor edx, edx

        ; Print '$' sign
        mov eax, '$'                               ; moves the '$' character into the eax register
        call WriteChar                             ; outputs the '$' character to the console

        ; Calculate and print Tax result
        mov eax, result                             ; moves the result into the eax register
        mov ebx, 1000                               ; moves 1000 into the ebx register
        xor edx, edx                                ; what sever the remander 
        div ebx                                     ; divide eax from ebx
        call WriteDec                               ; print number from eax
        mov eax, '.'                                ; move . to eax
        call WriteChar                              ; print character
        mov eax, edx                                ; move the remainder from edx to eax
        mov ebx, 10                                 ; move 10 to ebx
        xor edx, edx                                ; have edx store the remainder
        div ebx                                     ; divide eax from ebx
        cmp eax, 10                                 ; compare eax to 10
        jl  PrintLeadingZero                        ; jump less to Print Leading Zero if the number is less than 10
        call WriteDec                               ; print remainder if higher than 10

        ; Print newline
        call Crlf

        ; Calculate Total
        mov eax, result                             ; move result to eax
        mov ebx, 10                                 ; move 10 to ebx
        xor edx, edx                                ; the remainder are edx
        div ebx                                     ; divide eax from ebx
        add eax, result                             ; add result to eax
        mov ecx, eax                                ; move eax to ecx

        ; Print divider line  
        mov edx, OFFSET prompt4                     
        call WriteString
        call Crlf
      
        ; Print Total prompt
        mov edx, OFFSET prompt3                     
        call WriteString
        mov eax, '$' 
        call WriteChar
        mov eax, ecx                                 ; move ecx to eax
        mov ebx, 100                                 ; move 100 to ebx
        xor edx, edx                                 ; store the remaider to edx
        div ebx                                      ; divide eax to ebx
        call WriteDec                                ; print eax
        mov eax, '.'                                 ; store . to eax
        call WriteChar                               ; print eax character
        mov eax, edx                                 ; move edx to eax
        cmp eax, 10                                  ; compare eax to 10
        jl  PrintLeadingZero                         ; jump if less than 10 to print leading zero
        call WriteDec                                ; if number is higher than 10 print the number
        call Crlf
        mov edx, OFFSET prompt4                      
        call WriteString
        exit                                         ; exit program

    PrintLeadingZero:
        ; Print a leading zero for a single-digit remainder
        mov eax, '0'                                 ; move 0 to eax
        call WriteChar                               ; print 0
        mov eax, edx                                 ; mov edx to eax
        call WriteDec                                ; print decimal from eax
      

    DonePrintingDecimal:
        ; Exit the program
        call Crlf
        exit                                         ; exit program

    popad                                            ; Save and restore procedures.          

    ret
  FinalCost_op ENDP



  END

