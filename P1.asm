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

	;variables menu parte 2S


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


end
