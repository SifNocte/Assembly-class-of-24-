org 100h

NUM1    DB 4 DUP(?)  ; Arreglo de bytes para el primer numero ingresado
NUM2    DB 4 DUP(?)  ; Arreglo de bytes para el segundo numero ingresado
RESULT  DB 5 DUP(?)  ; Arreglo de bytes para almacenar el resultado de la suma
TMP     DB 5,?,?,?,?,?,?  ; Arreglo de bytes con valores iniciales desconocidos

START:
    LEA DX, TMP       

CAPTURE:              
    MOV AH, 0AH       ; Carga la funcion 0AH (capturar cadena de caracteres) en AH
    INT 21H           ; Llama a la interrupcion 21H del sistema operativo DOS para capturar la entrada del usuario

    LEA BX, TMP       ; Carga la dirección de memoria de TMP en BX
    LEA BP, NUM1      ; Carga la dirección de memoria de NUM1 en BP
    XOR CX,CX         ; Establece CX en 0

    MOV CL,[BX+1]     

CONVERT_LOOP:         ; Etiqueta para el bucle de conversión de caracteres a números
    MOV SI,CX         ; Mueve el tamaño de la cadena ingresada a SI
    MOV DL, [BX+SI+1H]  ; Mueve el byte correspondiente de la cadena a DL
    SUB DL,30H        ; Resta 30H (valor ASCII de '0') para convertir el caracter a su valor numérico
    MOV [BP+3], DL    ; Almacena el valor numérico en NUM1
    DEC BP            ; Decrementa BP para apuntar al siguiente byte en NUM1
    LOOP CONVERT_LOOP  ; Repite el bucle hasta que CX llegue a cero

    XOR CX,CX         ; Establece CX en 0

CLEAR_TMP:            
    MOV CX , 07H      ; Establece CX en 07H (longitud de TMP)

CLEAR_LOOP:           ; Etiqueta para el bucle de limpieza
    MOV SI,CX         ; Mueve el valor de CX a SI
    MOV TMP[SI], 0H   ; Establece el byte correspondiente de TMP en 0
    LOOP CLEAR_LOOP   ; Repite el bucle hasta que CX llegue a cero

    CMP BL, 33H       ; Compara el contenido de BL con '3' (33H en hexadecimal)
    JE SUM_START      ; Salta a SUM_START si son iguales

NEXT:                 
    MOV DL,2BH        ; Mueve el valor ASCII de '+' a DL
    MOV AH, 02H       ; Carga la función 02H (imprimir caracter) en AH
    INT 21H           ; Llama a la interrupción 21H del sistema operativo DOS para imprimir el caracter en DL
    LEA DX, TMP       ; Carga la dirección de memoria de TMP en DX
    MOV AH, 0AH       ; Carga la función 0AH (capturar cadena de caracteres) en AH
    INT 21H           ; Llama a la interrupción 21H del sistema operativo DOS para capturar la entrada del usuario

    LEA BX, TMP       ; Carga la dirección de memoria de TMP en BX
    LEA BP, NUM2      ; Carga la dirección de memoria de NUM2 en BP
    XOR CX,CX         ; Establece CX en 0
    MOV CL,[BX+1]     ; Mueve el tamaño de la cadena ingresada a CL

SECOND_CONVERT_LOOP:  
    MOV SI,CX         ; Mueve el tamaño de la cadena ingresada a SI
    MOV DL, [BX+SI+1H]  ; Mueve el byte correspondiente de la cadena a DL
    SUB DL,30H        ; Resta 30H (valor ASCII de '0') para convertir el caracter a su valor numérico
    MOV [BP+3], DL    ; Almacena el valor numérico en NUM2
    DEC BP            ; Decrementa BP para apuntar al siguiente byte en NUM2
    LOOP SECOND_CONVERT_LOOP  ; Repite el bucle hasta que CX llegue a cero

FIRST_STEP_ADD:   
    MOV BL, 33H       ; Establece BL en 33H (valor ASCII de '3')
    JMP CLEAR_TMP     ; Salta a CLEAR_TMP

SUM_START:      
    LEA BP, RESULT    ; Carga la dirección de memoria de RESULT en BP
    MOV BX, OFFSET NUM1  ; Mueve la dirección de memoria de NUM1 a BX
    MOV SI, OFFSET NUM2  ; Mueve la dirección de memoria de NUM2 a SI
    MOV DI, OFFSET TMP  ; Mueve la dirección de memoria de TMP a DI
    MOV CX, 04H       ; Establece CX en 04H (tamaño de los arreglos)
    XOR AX,AX         ; Establece AX en 0

SUM_LOOP:       
    MOV AL,[BX+3]     ; Mueve el byte correspondiente de NUM1 a AL
    ADD AL,[SI+3]     ; Suma el byte correspondiente de NUM2 a AL
    ADD AL,[DI+1]     ; Suma el byte correspondiente de TMP a AL
    MOV [DI+1],0H     ; Establece el byte correspondiente de TMP en 0

    CMP AL, 0AH       ; Compara AL con 0AH (10 en decimal)
    JAE SUB_CARRY     ; Salta a SUB_CARRY si es mayor o igual

    SAVE_NOW:         ; Guardar el resultado
    ADD AL, 30H       ; Anade 30H (valor ASCII de '0') para convertir el resultado de vuelta a un caracter ASCII
    MOV [BP+4H],AL    ; Almacena el caracter en RESULT
    DEC BP            ; Decrementa BP para apuntar al siguiente byte en RESULT
    DEC BX            ; Decrementa BX para apuntar al siguiente byte en NUM1
    DEC SI            ; Decrementa SI para apuntar al siguiente byte en NUM2
    LOOP SUM_LOOP     ; Repite el bucle hasta que CX llegue a cero

    JMP ADD_CARRY     ; Salta a ADD_CARRY

SUB_CARRY:            ; Manejar el acarreo
    SUB AL, 0AH       ; Resta 0AH (10 en decimal) a AL
    MOV [DI+1], 01H   ; Establece el acarreo en 1
    JMP SAVE_NOW      ; Salta a SAVE_NOW

ADD_CARRY:            ; Manejar el acarreo final
    XOR AL, AL        ; Establece AL en 0
    MOV AL, [DI+1]    ; Mueve el valor de acarreo a AL
    ADD AL, 30H       ; Añade 30H (valor ASCII de '0') para convertir el acarreo a un caracter ASCII
    MOV [BP+4H],AL    ; Almacena el caracter en RESULT

PRINT_ME:             ; Imprimir el resultado
    MOV DL,3DH        ; Mueve el valor ASCII de '=' a DL
    MOV AH, 02H       ; Carga la función 02H (imprimir caracter) en AH
    INT 21H           ; Llama a la interrupción 21H del sistema operativo DOS para imprimir el caracter en DL

    LEA BX,RESULT     ; Carga la dirección de memoria de RESULT en BX
    MOV CL,05H        ; Establece CL en 05H (longitud de RESULT)
    MOV DH,0H         ; Establece DH en 0

PRINTING:             ; Imprimir el resultado almacenado en RESULT
    MOV AH, 02H       ; Carga la funcion 02H (imprimir caracter) en AH
    MOV DL, [BX]      ; Mueve el byte correspondiente de RESULT a DL

    CMP DH,0H         ; Compara DH con 0
    JE PRINT_EXT      ; Salta a PRINT_EXT si son iguales
    JNE IS_VALID      ; Salta a IS_VALID si no son iguales

ZERO_NEXT:            ; Pasar al siguiente byte
    INC BX            ; Incrementa BX para apuntar al siguiente byte en RESULT
    LOOP PRINTING     ; Repite el bucle hasta que CX llegue a cero
    JMP EXIT          ; Salta a EXIT

PRINT_EXT:            ; Etiqueta para manejar caracteres 0 al inicio del resultado
    CMP DL, 30H       ; Compara DL con 30H (valor ASCII de '0')
    JNE IS_VALID      ; Salta a IS_VALID si no son iguales
    JE ZERO_NEXT      ; Salta a ZERO_NEXT si son iguales

IS_VALID:             
    MOV DH,01H        ; Establece DH en 01H
    INT 21H           ; Llama a la interrupción 21H del sistema operativo DOS para imprimir el caracter en DL
    JMP ZERO_NEXT     ; Salta a ZERO_NEXT

EXIT:  
    HLT  
    RET