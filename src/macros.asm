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
LOCAL Unidades,Decenas, Salir
	xor ax,ax
	xor bx,bx

	mov al,numero
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

	Salir:
endm
devolverDecimal macro u, d, numero
        mov al, d
        mov bl, 10
        mul bl
        add al, u
        mov numero, al
endm
