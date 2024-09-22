;Proyecto de Microprogramacion 2024
;Carlos Daniel Barrientos Castillo -1040121
;Diego Andre Cordon Hernandez -1094021

;----------------------
; LOGICA DEL PROYECTO
;---------------------
;MENU Principal
;seleccion parte 1 o parte 2

;parte 1
;Menu para parte 1 (generar UUID o salir)(repetir hasta que el usuario presione una tecla)
;GENERAR NUMEROS ALEATORIOS por timespan
;generar UUID
;mostrar resultado

;parte 2
;Menu para parte 2 (ingresar regex o salir)(repetir hasta que el usuario presione una tecla X)
;ingreso de regex
;validar regex
;mostrar resultado

;----------------------------------------------------

.model small
.data
	; Mensajes
    titulomenuprincipal DB 10,13, 'Bienvenido al menu principal, el numero 1 es para la parte 1 y el numero 2 para la parte 2$', 0
    titulomenuparte1 DB 10,13, 'Bienvenido al menu de la parte 1$', 0
    titulomenuparte2 DB 10,13, 'Bienvenido al menu de la parte 2$', 0
    ; Mensaje de error
    msgError DB 10,13, 'Opcion invalida, intente de nuevo$', 0


	;Variables menu parte 1
    msgGenerarUUID DB 10,13, 'Generando UUID...$', 0
    UUIDbuffer DB 16 DUP(?) ; Buffer para guardar el UUID (16 bytes)
	msg DB 10,13,'Este-----$', 0
	
	var1 DB '653E4B57', 0
    var2 DB '0058', 0
    var3 DB '45C7', 0
    var4 DB '886F', 0
    var5 DB '76065208B0AB', 0
    resultado DB 50 dup(0) ; Buffer para el resultado, ajusta el tamaño según sea necesario
    separador DB '-', 0    ; Separador
	
	
	;variables menu parte 2
	

	;variables extras 
	newline db 0Dh, 0Ah, '$'  ; Cadena que contiene retorno de carro y nueva línea
	
	
.stack 100h
.code
.startup
;---------------------------
;	Inicio del programa
;---------------------------
    call MenuPrincipal	; Vamos al menu principal

    ; Terminamos el programa
    MOV ax, 4C00h
    INT 21h

; ---------------------------------------
; Procedimiento para mostrar el menu principal
; ---------------------------------------
MenuPrincipal:
    ; Mostrar titulo del menu principal
    MOV ah, 09h
    LEA dx, titulomenuprincipal
    INT 21h
	call SaltoDeLinea ;insertamos un salto de linea para que se vea bonito

    call LeerOpcion	; Leemos lo que pone el user

    ; Comparar la entrada
    CMP AL, '1'  ; Comparamos si el resultado del teclado es 1
    JE Parte1    ; Ir a la parte 1

    CMP AL, '2'  ; Comparamos si es 2
    JE Parte2    ; Nos saltamos a la parte de la validacion del UUID

    ; Si no es valido, mostrar mensaje de error y repetir
    call MostrarError
    JMP MenuPrincipal

    ret

; ---------------------------------------
; Procedimiento para la parte 1
; ---------------------------------------
Parte1:
    ; Mostrar el titulo del menu de la parte 1
    MOV ah, 09h
    LEA dx, titulomenuparte1
    INT 21h
	
	;mov cx, 32          ; Contador para 32 repeticiones
	;repeat_procedure:
    ;call MiProcedimiento ; Llamar al procedimiento
    ;loop repeat_procedure ; Decrementar CX y repetir si no es cero

; Concatenar var1, var2, var3, var4 y var5 en resultado
    lea si, var1           ; Cargar dirección de var1
    call Concatenar        ; Concatenar var1

    lea si, separador      ; Cargar dirección del separador
    call Concatenar        ; Concatenar el separador

    lea si, var2           ; Cargar dirección de var2
    call Concatenar        ; Concatenar var2

    lea si, separador      ; Cargar dirección del separador
    call Concatenar        ; Concatenar el separador

    lea si, var3           ; Cargar dirección de var3
    call Concatenar        ; Concatenar var3

    lea si, separador      ; Cargar dirección del separador
    call Concatenar        ; Concatenar el separador

    lea si, var4           ; Cargar dirección de var4
    call Concatenar        ; Concatenar var4

    lea si, separador      ; Cargar dirección del separador
    call Concatenar        ; Concatenar el separador

    lea si, var5           ; Cargar dirección de var5
    call Concatenar        ; Concatenar var5

    ; Imprimir el resultado
    mov dx, offset resultado
    mov ah, 09h
    int 21h

    ; Finalizar el programa
    mov ax, 4C00h
    int 21h

    jmp MenuPrincipal ; Terminamos y volvemos

; ---------------------------------------
; Procedimiento para la parte 2
; ---------------------------------------
Parte2:
    ; Mostrar el titulo del menu de la parte 2
	call SaltoDeLinea
    MOV ah, 09h
    LEA dx, titulomenuparte2
    INT 21h

    ; Aquí pones tu lógica para la parte 2 (validar UUID con regex)


    ; Volver al menu principal después de terminar
    jmp MenuPrincipal

; ---------------------------------------
; Leer la opción del usuario
; ---------------------------------------
LeerOpcion:
    ; Esperar entrada del teclado
    MOV ah, 01h
    INT 21h
    ret

; ---------------------------------------
; Mostrar error
; ---------------------------------------
MostrarError:
    MOV ah, 09h
    LEA dx, msgError
    INT 21h
    ret
; ---------------------------------------
; Hacer salto de linea
; ---------------------------------------
SaltoDeLinea:
    LEA DX, newline  ; Cargar la dirección de la cadena newline en DX
    MOV AH, 09h      ; Función DOS para imprimir una cadena
    INT 21h          ; Ejecutar la interrupción para imprimir
	ret
; ---------------------------------------
;PARTE 1
; ---------------------------------------
; ---------------------------------------
; Procedimiento para generar UUID
; ---------------------------------------
GenerarUUID:
    ; Mostrar mensaje de inicio
    mov ah, 09h
    lea dx, msgGenerarUUID
    int 21h

    ; Generar 16 bytes aleatorios para el UUID
    mov cx, 16       ; Vamos a generar 16 bytes para el UUID
    lea si, UUIDbuffer   ; Cargar la dirección base del buffer en SI

; Procedimiento que se llama 32 veces
MiProcedimiento proc
    ; Aquí va la lógica del procedimiento
    mov dx, offset msg  ; Cargar la dirección del mensaje
    mov ah, 09h         ; Función de impresión de cadena
    int 21h             ; Llamar a la interrupción de DOS
    ret
MiProcedimiento endp

; ---------------------------------------
; Generar un número aleatorio usando timestamp
; ---------------------------------------
GenerarNumeroAleatorio:
    ; Usamos la interrupción 1Ah para obtener el reloj del sistema (timestamp)
    mov ah, 00h
    int 1Ah            ; Retorna el valor en CX:DX (timestamp)
    
    ; XOR de DX y CX para mayor aleatoriedad
    xor dx, cx
    mov al, dl         ; Devolver el byte menos significativo de DX como número aleatorio
    ret

; Procedimiento para concatenar cadenas
Concatenar proc
    mov di, offset resultado ; Direccion donde se almacenara el resultado
    mov cx, 0               ; Contador de longitud

find_end:
    cmp byte ptr [di], 0    ; Buscar el final de la cadena de resultado
    je  copy_string          ; Si es 0, saltar a la copia
    inc di                   ; Incrementar DI
    inc cx                   ; Contar longitud
    jmp find_end             ; Repetir

copy_string:
    ; Copiar la cadena desde SI a DI
copy_loop:
    mov al, [si]            ; Cargar el carácter de SI
    cmp al, 0               ; Verificar si es el final de la cadena
    je  done_copy           ; Si es 0, terminar la copia
    mov [di], al            ; Copiar carácter a resultado
    inc si                  ; Mover al siguiente carácter en SI
    inc di                  ; Mover al siguiente en el resultado
    jmp copy_loop           ; Repetir

done_copy:
    mov byte ptr [di], 0    ; Terminar la cadena de resultado con 0 (indicando que es un byte)
    ret
Concatenar endp
	
end


; ---------------------------------------
;PARTE 2
; ---------------------------------------



