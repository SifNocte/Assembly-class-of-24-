.model small
.stack 100h

.data
    nombreArchivo db 'Path\TuNombre.txt', 0
    mensaje db 'Parangaricutirimicuaro', 0
    manejadorArchivo dw 0
    contadorU db 0
    inputBuffer db 3 dup(?)
    promptMsg db 'Presiona Enter para continuar...$', 0
    msgContador db 13, 10, 'Se encontraron $'
    contadorStr db '0', '$'
    accion1Msg db 'Accion 1: Crear archivo', 13, 10, '$'
    accion2Msg db 'Accion 2: Escribir en el archivo', 13, 10, '$'
    accion3Msg db 'Accion 3: Cerrar el archivo', 13, 10, '$'
    accion4Msg db 'Accion 4: Abrir el archivo para lectura', 13, 10, '$'
    accion5Msg db 'Accion 5: Contar U en el contenido', 13, 10, '$'
    accion6Msg db 'Accion 6: Cerrar el archivo (lectura)', 13, 10, '$'
    accion7Msg db 'Accion 7: Eliminar el archivo', 13, 10, '$'
    accion8Msg db 'Accion 8: Mostrar contador', 13, 10, '$'

.code
inicio:
    mov ax, @data
    mov ds, ax

    lea dx, accion1Msg 
    call Pausa
    mov ah, 3Ch
    mov cx, 0
    lea dx, nombreArchivo
    int 21h
    mov [manejadorArchivo], ax

    lea dx, accion2Msg
    call Pausa
    mov ah, 40h
    mov bx, [manejadorArchivo]
    lea dx, mensaje
    mov cx, 22
    int 21h 

    lea dx, accion3Msg
    call Pausa
    mov ah, 3Eh
    mov bx, [manejadorArchivo]
    int 21h 

    lea dx, accion4Msg
    call Pausa
    mov ah, 3Dh
    mov al, 0
    lea dx, nombreArchivo
    int 21h
    mov [manejadorArchivo], ax 

    lea dx, accion5Msg
    call Pausa
    xor cx, cx
    xor dx, dx

leerCaracter:
    mov ah, 3Fh
    mov bx, [manejadorArchivo]
    lea dx, inputBuffer
    mov cx, 1
    int 21h
    cmp ax, 0
    je mostrarContadorU

    cmp [inputBuffer], 'U'
    je incrementarContador
    cmp [inputBuffer], 'u'
    je incrementarContador

    jmp leerCaracter

incrementarContador:
    inc byte ptr [contadorU]
    jmp leerCaracter
    
mostrarContadorU:
    mov ah, 3Eh
    mov bx, [manejadorArchivo]
    int 21h 
    lea dx, accion6Msg
    call Pausa

    lea dx, accion7Msg
    call Pausa
    mov ah, 41h
    lea dx, nombreArchivo
    int 21h

    lea dx, accion8Msg
    call MostrarAccion
    mov ah, 09h
    lea dx, msgContador
    int 21h
    mov al, [contadorU]
    call MostrarNumero

    lea dx, promptMsg

    mov ax, 4C00h
    int 21h

Pausa proc
    push ax  
    mov ah, 09h
    int 21h  
    pop ax   

    lea dx, promptMsg
    mov ah, 09h
    int 21h
    mov ah, 01h
    int 21h
    ret
Pausa endp     

MostrarAccion proc
    mov ah, 09h
    int 21h  
    ret
MostrarAccion endp

MostrarNumero proc
    mov ah, 0
    mov cl, 10
    div cl 
    add ah, '0' 
    mov [contadorStr], ah 
    lea dx, contadorStr 
    mov ah, 09h 
    int 21h 
    ret
MostrarNumero endp

end inicio