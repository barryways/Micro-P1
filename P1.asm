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
    titulomenuparte1 DB 10,13, 'Bienvenido al menu de la parte el numero 1 es para la generar un UUID y el numero 2 para regresar$', 0
    titulomenuparte2 DB 10,13, 'Bienvenido al menu de la parte 2$', 0
    ; Mensaje de error
    msgError DB 10,13, 'Opcion invalida, intente de nuevo$', 0


	;Variables menu parte 1
    msgGenerarUUID DB 10,13, 'Generando UUID...$', 0
	msg DB 10,13,'Generando UUID $', 0
	guion DB '-$', 0
	byteSignificativo1 DB '1$', 0
	byteSignificativo2 DB '-$', 0
	
    aleatorio DB ?                     ; Variable para almacenar el carácter aleatorio

	;variables menu parte 2
	msgRegexMenu DB 10,13, 'Ingrese el UUID a validar o presione X para salir$', 0
    msgUUIDValido DB 10,13, 'UUID valido$', 0
    msgUUIDInvalido DB 10,13, 'UUID invalido$', 0
	

    ; Mensajes de errores específicos, ideal para depuración :)
    msgErrorGuion8 DB 10,13, 'Error: Falta guion en posicion 8$', 0
    msgErrorGuion13 DB 10,13, 'Error: Falta guion en posicion 13$', 0
    msgErrorGuion18 DB 10,13, 'Error: Falta guion en posicion 18$', 0
    msgErrorGuion23 DB 10,13, 'Error: Falta guion en posicion 23$', 0
    msgErrorHexBlock1 DB 10,13, 'Error: Bloque 1 no es hexadecimal$', 0
    msgErrorHexBlock2 DB 10,13, 'Error: Bloque 2 no es hexadecimal$', 0
    msgErrorHexBlock3 DB 10,13, 'Error: Bloque 3 no comienza con 1$', 0
    msgErrorHexBlock4 DB 10,13, 'Error: Bloque 4 no comienza con 8, 9, A o B$', 0
    msgErrorHexBlock5 DB 10,13, 'Error: Bloque 5 no es hexadecimal$', 0
	msgErrorLongitud DB 10,13, 'Error: Longitud incorrecta$', 0
	
    UUIDIngresado DB 37       ; Tamaño de la cadena a ingresar + terminador
    NumChars      DB 0        ; Número de caracteres ingresados (inicialmente 0)
    CadenaUUID    DB 36 DUP('$')  ; Aquí se almacena la cadena
	
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
	call SaltoDeLinea ;insertamos un salto de linea para que se vea bonito
    call LeerOpcion	; Leemos lo que pone el user
	

    ; Comparar la entrada
    CMP AL, '1'  ; Comparamos si el resultado del teclado es 1
    JE llamar_todos_aleatorios    ; Ir a la parte 1

    CMP AL, '2'  ; Comparamos si es 2
    JE MenuPrincipal    ; Nos saltamos a la parte de la validacion del UUID

    ; Si no es valido, mostrar mensaje de error y repetir
    call MostrarError
    JMP MenuPrincipal

; ---------------------------------------
; Procedimiento para la parte 2
; ---------------------------------------
Parte2:
    ; Mostrar el titulo del menu de la parte 2
    call SaltoDeLinea
    MOV ah, 09h
    LEA dx, titulomenuparte2
    INT 21h

    ; Mostramos el mensaje para ingresar el UUID
    MOV ah, 09h
    LEA dx, msgRegexMenu
    INT 21h

    ; Lectura del UUID ingresado por el usuario
	call SaltoDeLinea ;insertamos un salto de linea para que se vea bonito
    call LeerUUID

    ; Valida el UUID ingresado
	call SaltoDeLinea ;insertamos un salto de linea para que se vea bonito
    call ValidarUUID

    ; Regresa al menu principal después de terminar
    JMP MenuPrincipal
	

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
; Procedimiento para numeros random
; ---------------------------------------
generate_random proc

mov bx, 1        ; BX se usará para controlar el número de iteraciones
generate:
   MOV AH, 00h       ; Interrupción para obtener el tiempo del sistema        
   INT 1AH           ; CX:DX ahora contienen los ticks del reloj desde medianoche      

   mov  ax, dx       ; Copiamos el valor de DX a AX
   xor  dx, dx       ; Limpiamos DX
   mov  cx, 16       ; Queremos un número del 0 al 15 (hexadecimal)   
   div  cx           ; Aquí DX contendrá el residuo de la división (un número entre 0 y 15)

   cmp  dl, 9        ; Comparamos si el número es mayor que 9
   jbe  is_digit     ; Si es menor o igual a 9, es un dígito decimal ('0' a '9')

   ; Convertimos a 'A' a 'F' para los valores 10 a 15
   add  dl, 7        ; Ajustamos para que 10 sea 'A', 11 sea 'B', ..., 15 sea 'F'

is_digit:
   add  dl, '0'      ; Convertimos a su valor ASCII ('0' a '9' o 'A' a 'F')
   mov  ah, 2h       ; Llamamos a la interrupción para mostrar el valor en DL
   int 21h   

   dec bx            ; Decrementamos BX (controla el loop)
   cmp bx, 0         ; Comprobamos si BX es 0
   jne generate      ; Si no es 0, volvemos al inicio del loop

generate_random endp




;-----------------------------------------
;Procedimiento para generar un retraso en el programa
;-----------------------------------------

long_delay proc
    mov cx, 0FFFFh    ; Un retardo más largo
    mov dx, 0FFFFh    ; Segundo registro para mayor retardo
delay_loop:
    loop delay_loop   ; Bucle de retardo
    dec dx            ; Decrementamos DX
    jnz delay_loop    ; Continuamos hasta que DX llegue a 0
    ret
long_delay endp


;--------------------------------------
;Procedimiento para generar y unir aleatorios
;--------------------------------------
llamar_todos_aleatorios proc
	call SaltoDeLinea
	call generar_8

	call generar_4
	
	MOV ah, 09h
	LEA dx, byteSignificativo1
	INT 21h
	call generar_3
	
	
	call generate_random_1_to_4       ; Generar un número aleatorio entre 1 y 4
    call asignar_caracter              ; Asignar el carácter correspondiente

    ; Imprimir el carácter aleatorio
    mov ah, 02h                       ; Función para imprimir un carácter
    mov dl, aleatorio                  ; Cargar el carácter aleatorio en DL
    int 21h                           ; Llamar a la interrupción DOS para imprimir
	call generar_3
	
	call generar_12
	
	
	
	jmp Parte1 

llamar_todos_aleatorios endp

;--------------------------------------
;Generar 1
;--------------------------------------
generar_1 proc
;1
call generate_random
call long_delay
MOV ah, 09h
LEA dx, guion
INT 21h
ret
generar_1 endp
;--------------------------------------
;Generar 3
;--------------------------------------
generar_3 proc
;1
call generate_random
call long_delay
;2
call generate_random
call long_delay
;3
call generate_random
call long_delay

MOV ah, 09h
LEA dx, guion
INT 21h

ret
generar_3 endp

;--------------------------------------
;Generar 4
;--------------------------------------
generar_4 proc
;1
call generate_random
call long_delay
;2
call generate_random
call long_delay
;3
call generate_random
call long_delay
;4
call generate_random
call long_delay

MOV ah, 09h
LEA dx, guion
INT 21h
ret
generar_4 endp
;--------------------------------------
;Generar 8
;--------------------------------------
generar_8 proc
;1
call generate_random
call long_delay
;2
call generate_random
call long_delay
;3
call generate_random
call long_delay
;4
call generate_random
call long_delay
;5
call generate_random
call long_delay
;6
call generate_random
call long_delay
;7
call generate_random
call long_delay
;8
call generate_random
call long_delay
MOV ah, 09h
LEA dx, guion
INT 21h

ret
generar_8 endp
;--------------------------------------
;Generar 12
;--------------------------------------
generar_12 proc
;1
call generate_random
call long_delay
;2
call generate_random
call long_delay
;3
call generate_random
call long_delay
;4
call generate_random
call long_delay
;5
call generate_random
call long_delay
;6
call generate_random
call long_delay
;7
call generate_random
call long_delay
;8
call generate_random
call long_delay
;9
call generate_random
call long_delay
;10
call generate_random
call long_delay
;11
call generate_random
call long_delay
;12
call generate_random

ret
generar_12 endp

; Procedimiento que genera un número aleatorio del 1 al 4
generate_random_1_to_4 proc
    MOV AH, 00h                       ; Interrupción para obtener el tiempo del sistema        
    INT 1AH                           ; CX:DX ahora contienen los ticks del reloj desde medianoche      

    mov ax, dx                        ; Copiar el valor de DX a AX
    xor dx, dx                        ; Limpiar DX
    mov cx, 4                         ; Queremos un número del 0 al 3
    div cx                            ; Aquí DX contendrá el residuo de la división (0-3)

    inc dl                            ; Incrementamos DL para que sea de 1 a 4
    mov al, dl                        ; Mover el número aleatorio a AL
    ret                               ; Regresar al procedimiento

generate_random_1_to_4 endp

asignar_caracter proc
    cmp al, 1                         ; Si el número aleatorio es 1
    je es_ocho
    cmp al, 2                         ; Si el número aleatorio es 2
    je es_nueve
    cmp al, 3                         ; Si el número aleatorio es 3
    je es_a
    cmp al, 4                         ; Si el número aleatorio es 4
    je es_b
    jmp fin                           ; Salta al final si no es válido

es_ocho:
    mov aleatorio, '8'                ; Asignar '8'
    jmp fin

es_nueve:
    mov aleatorio, '9'                ; Asignar '9'
    jmp fin

es_a:
    mov aleatorio, 'A'                ; Asignar 'A'
    jmp fin

es_b:
    mov aleatorio, 'B'                ; Asignar 'B'

fin:
    ret                               ; Regresar al procedimiento
asignar_caracter endp

; ---------------------------------------
;PARTE 2
; ---------------------------------------


; ---------------------------------------
; Leer el UUID ingresado por el usuario 
; ---------------------------------------
LeerUUID proc
    LEA dx, UUIDIngresado
    MOV ah, 0Ah    ; Función para leer una cadena con tamaño máximo (DOS)
    INT 21h
    RET
LeerUUID endp

; ---------------------------------------
; Procedimiento para validar el UUID
; ---------------------------------------

ValidarUUID proc
    ; Carga la dirección de UUIDIngresado
    LEA bx, UUIDIngresado

    ; Verificamos que la longitud ingresada sea 36 caracteres
    MOV al, [bx+1]      ; Usamos el segundo byte de UUIDIngresado para almacenar el número de caracteres ingresados
    CMP al, 36          ; Comparar
    JNE corto_error_longitud ; Si no es 36, hace salto al manejo de error de longitud

    ; Verifica la posición 8, 13, 18, 23 de los guiones
    MOV al, [bx+10]      ; Aquí se determina la posición del guión, 2 bytes después para almacenar la cadena después del tamaño
    CMP al, '-'
    JNE error_guion_8
    JMP continuar_1

error_guion_8:
    MOV ah, 09h
    LEA dx, msgErrorGuion8
    INT 21h
    JMP uuid_invalido

continuar_1:
    MOV al, [bx+15]      ; Posición 13 en bytes
    CMP al, '-'
    JNE error_guion_13
    JMP continuar_2

error_guion_13:
    MOV ah, 09h
    LEA dx, msgErrorGuion13
    INT 21h
    JMP uuid_invalido

continuar_2:
    MOV al, [bx+20]      ; Posición 18 en bytes
    CMP al, '-'
    JNE error_guion_18
    JMP continuar_3

error_guion_18:
    MOV ah, 09h
    LEA dx, msgErrorGuion18
    INT 21h
    JMP uuid_invalido

continuar_3:
    MOV al, [bx+25]      ;Posición 23 en bytes
    CMP al, '-'
    JNE error_guion_23
    JMP continuar_4

error_guion_23:
    MOV ah, 09h
    LEA dx, msgErrorGuion23
    INT 21h
    JMP uuid_invalido

continuar_4:
    ; Validación de los bloques hexadecimales
    MOV cx, 8
    MOV di, 2           ; Comienza en el tercer byte por los primeros dos bytes de control en DOS
valida_bloque1:
    MOV al, [bx+di]
    CALL validar_hexadecimal
    INC di
    LOOP valida_bloque1

    INC di    ; Skip al guion

    MOV cx, 4
valida_bloque2:
    MOV al, [bx+di]
    CALL validar_hexadecimal
    INC di
    LOOP valida_bloque2

    INC di    ; Skip al guion

    MOV al, [bx+di]
    CMP al, '1'
    JNE error_bloque3
    JMP continuar_5

error_bloque3:
    MOV ah, 09h
    LEA dx, msgErrorHexBlock3
    INT 21h
    JMP uuid_invalido

; Punto de salto corto por el error de longitud
corto_error_longitud:
    JMP largo_error_longitud

continuar_5:
    INC di
    MOV cx, 3
valida_bloque3_rest:
    MOV al, [bx+di]
    CALL validar_hexadecimal
    INC di
    LOOP valida_bloque3_rest

    INC di    ; Skip al guion

    MOV al, [bx+di]			;Evalúa la entrada del 4to bloque, que sea 8, 9, A o B
    CMP al, '8'
    JE valida_bloque4_rest
    CMP al, '9'
    JE valida_bloque4_rest
    CMP al, 'A'
    JE valida_bloque4_rest
    CMP al, 'B'
    JE valida_bloque4_rest
    JMP error_bloque4

error_bloque4:
    MOV ah, 09h
    LEA dx, msgErrorHexBlock4
    INT 21h
    JMP uuid_invalido

valida_bloque4_rest:
    INC di
    MOV cx, 3
valida_bloque4:
    MOV al, [bx+di]
    CALL validar_hexadecimal
    INC di
    LOOP valida_bloque4

    INC di    ; Saltar guion

    MOV cx, 12
valida_bloque5:
    MOV al, [bx+di]			;Validación del bloque 5
    CALL validar_hexadecimal
    INC di
    LOOP valida_bloque5

    ; Si todo es correcto, muestra el UUID válido
    MOV ah, 09h
    LEA dx, msgUUIDValido
    INT 21h
    JMP uuid_fin


largo_error_longitud:		;Error de longitud de la cadena
    MOV ah, 09h
    LEA dx, msgErrorLongitud
    INT 21h
    JMP uuid_invalido

uuid_invalido:
    MOV ah, 09h
    LEA dx, msgUUIDInvalido
    INT 21h

uuid_fin:
    RET
ValidarUUID endp

; Validación si un carácter es hexadecimal, (0-9, A-F) en la regex
validar_hexadecimal proc
    CMP al, '0'
    JL uuid_invalido
    CMP al, '9'
    JLE valido
    CMP al, 'A'
    JL uuid_invalido
    CMP al, 'F'
    JG uuid_invalido
valido:
    RET
validar_hexadecimal endp

end
