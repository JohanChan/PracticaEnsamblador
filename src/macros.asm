imprimir macro buffer
    mov ax, seg @data     
    mov ds, ax   
    mov ah, 09h
    mov dx, offset buffer
    int 21h
endm
getDato macro
    mov ah, 01h
    int 21h
endm
obtenerCadena macro arreglo
    
    LOCAL Concatenar, fin
    
    xor si, si
    
    Concatenar:
        getDato
        cmp al, 0dh
        je FIN
        mov arreglo[si],al
        inc si
        jmp Concatenar
    fin:

        mov al, "$"
        mov arreglo[si],al
       
endm
limpiar macro buffer, numbytes, caracter
LOCAL Repetir
	xor si,si
	xor cx,cx
	mov	cx,numbytes

	Repetir:
		mov buffer[si], caracter
		inc si
		Loop Repetir
endm

obtenerNumero macro arreglo
    LOCAL Unidad, Decena, Salir, Negativo, UnidadNegativo
    tamaString arreglo
    xor ax, ax

    cmp bl,1
        je Unidad
    cmp bl,2
        je Decena
    cmp bl,3
        je Negativo

    Unidad:
        
        mov al,arreglo[0]
		SUB al,30h
		jmp Salir
    Decena:
        mov al, arreglo[0]
        cmp al, 2Dh
            je UnidadNegativo
        mov al,arreglo[0]
		sub al,30h
		mov bl,10
		mul bl

		xor bx,bx
		mov bl,arreglo[1]
		sub bl,30h

		add al,bl

		jmp Salir
    UnidadNegativo:
        mov al,arreglo[1]
		SUB al,30h
        neg al
		jmp Salir
    Negativo:
        mov al,arreglo[1]
		sub al,30h
		mov bl,10
		mul bl

		xor bx,bx
		mov bl,arreglo[2]
		sub bl,30h

		add al,bl
        neg al
        jmp salir
    Salir:
endm

tamaString macro string
LOCAL LeerNumero, endTexto
	xor si,si ; xor si,si =	mov si,0
	xor bx,bx

	LeerNumero:
		mov bl,string[si] ;mov destino, fuente
		cmp bl,24h ; ascii de signo dolar
		je endTexto
		inc si ; si = si + 1
		jmp LeerNumero

	endTexto:
		mov bx,si
endm

IntToString macro numero, arreglo
LOCAL Unidades,Decenas, Salir, Negativos
	xor ax,ax
	xor bx,bx

	mov al,numero
    cmp al, 99
    ja  Negativos
	cmp al, 9 
	ja Decenas

	Unidades:
		add al,30h
		mov arreglo[0],al
		jmp Salir

	Decenas:
		mov bl,10
		div bl     ;divide entre 10 las decenas
		add al,30h ;le suma 30h a al, al cociente 
		add ah,30h ; le suma 30h al residuo 
		mov arreglo[0],al ;decenas
		mov arreglo[1],ah ;unidades

		jmp Salir
    Negativos:
        neg al
        mov arreglo[0], 2Dh
        jmp NegDecenas
    NegDecenas:
		mov bl,10
		div bl     ;divide entre 10 las decenas
		add al,30h ;le suma 30h a al, al cociente 
		add ah,30h ; le suma 30h al residuo 
		mov arreglo[1],al ;decenas
		mov arreglo[2],ah ;unidades 
		jmp Salir    

	Salir:
endm
concatenarValor macro arreglo1, arreglo2, separador
    LOCAL verificarEspacio, guardarCaracteres, guardarUnCaract, guardarDosCaract,guardarTresCaract, fin, insertarInicio
    xor si, si
    verificarEspacio:
        tamaString arreglo1
        cmp bl, 0
            je insertarInicio
        mov al, arreglo1[si]
        cmp al, 24h
            je guardarCaracteres
        inc si
        jmp verificarEspacio

    insertarInicio: 
        push si ; me guarda el valor de 'si' de esta macro
        tamaString arreglo2
        pop si  ; recupero el valor de 'si' de esta macro 
        cmp bl, 2
            je guardarDosCaract
        cmp bl, 1   
            je guardarUnCaract
        cmp bl, 3
            je guardarTresCaract

    guardarCaracteres:
        push si ; me guarda el valor de 'si' de esta macro
        tamaString arreglo2
        pop si  ; recupero el valor de 'si' de esta macro 
        mov al, separador
        mov arreglo1[si], al
        inc si
        cmp bl, 2
            je guardarDosCaract
        cmp bl, 3
            je guardarTresCaract
        
    guardarUnCaract:
        ;xor si, si
        mov al, arreglo2[0]
        mov arreglo1[si], al
        jmp fin

    guardarDosCaract:
        ;xor si, si
        mov al, arreglo2[0]
        mov arreglo1[si], al
        inc si
        mov al, arreglo2[1]
        mov arreglo1[si], al
        jmp fin

    guardarTresCaract:
        mov al, arreglo2[0]
        mov arreglo1[si], al
        inc si
        mov al, arreglo2[1]
        mov arreglo1[si], al
        inc si
        mov al, arreglo2[2]
        mov arreglo1[si], al
        jmp fin        
    fin: 
endm
guardarOperacion macro arreglo, caracter
    LOCAL inicio, fin, guardarCaracter, guardardosDatos, guardartresDatos, guardarDatos
    xor di,di 
    xor si,si
    inicio:
        mov al, arreglo[di]
        cmp al, 24h
            je guardarDatos
        inc di
        jmp inicio
    guardarDatos:
        tamaString caracter
        cmp bl, 1
           je guardarCaracter
        cmp bl, 2
            je guardardosDatos
        cmp bl, 3
            je guardartresDatos

    guardarCaracter:
        mov al, caracter[0]
        mov arreglo[di], al
        jmp fin
    guardardosDatos:
        mov al, caracter[0]
        mov arreglo[di], al
        inc di
        mov al, caracter[1]
        mov arreglo[di], al
        jmp fin
    guardartresDatos:
        mov al, caracter[0]
        mov arreglo[di], al
        inc di
        mov al, caracter[1]
        mov arreglo[di], al
        inc di
        mov al, caracter[2]
        mov arreglo[di], al
        jmp fin

    fin:
endm


guardarOperaciones macro arreglo1, arreglo2
    LOCAL inicio, fin, verificarEspacio, guardar
    xor di, di
    xor si, si
    verificarEspacio:
        mov al, arreglo1[di]
        cmp al, 24h
            je guardar
        inc di
        jmp verificarEspacio
    guardar:
        mov al, arreglo2[si]
        cmp al, 24h
            je fin
        mov arreglo1[di], al
        inc di
        inc si
        jmp guardar
    fin:
endm

crearArchivo macro ruta, handler
    xor ax,ax
    mov ah, 3ch
    mov cx, 00h
    lea dx, ruta
    int 21h
    mov handler, ax
endm

escribirArchivo macro handler, data, numeroBytes
    mov ah, 40h
    mov bx, handler
    mov cx, numeroBytes
    lea dx, data
    int 21h
endm

cerrarArchivo macro handler
    mov ah, 3Eh
    mov bx, handler
    int 21h
endm

escribirFecha macro handler, fecha, separador
    ; Obtengo la fecha del sistema
    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DL     ; Day is in DL
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[0],dl
    mov fecha[1],al

    mov al, separador
    mov fecha[2], al

    MOV AH,2AH    ; To get System Date
    INT 21H
    MOV AL,DH     ; Month is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[3],dl
    mov fecha[4],al

    mov al, separador
    mov fecha[5], al


    MOV AH,2AH    ; To get System Date
    INT 21H
    ADD CX,0F830H ; To negate the effects of 16bit value,
    MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
    AAM
    MOV BX,AX
    CALL DISP
    mov fecha[6],dl
    mov fecha[7],al

    escribirArchivo handler, fecha ,SIZEOF fecha 

endm
escribirHora macro handler, hora, separadorHora
    ; Obtengo la hora del sistema
    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CH     ; Hour is in CH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[0],dl
    mov hora[1],al

    mov al, separadorHora
    mov hora[2], al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,CL     ; Minutes is in CL
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[3],dl
    mov hora[4],al

    mov al, separadorHora
    mov hora[5], al

    MOV AH,2CH    ; To get System Time
    INT 21H
    MOV AL,DH     ; Seconds is in DH
    AAM
    MOV BX,AX
    CALL DISP
    mov hora[6],dl
    mov hora[7],al

    escribirArchivo handler, hora ,SIZEOF hora
endm