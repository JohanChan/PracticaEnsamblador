include macros.asm                                                                           
.model small
.stack
.data 
    encabezado BYTE "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",10,"$"
    encabezado2 BYTE "%%%%%%%%% MENU PRINCIPAL %%%%%%%%",10,"$"
    opcionCarga BYTE "%% 1. Cargar Archivo           %%",10,"$"
    opcionCalculadora BYTE "%% 2. Modo Calculadora         %%",10,"$"
    opcionFactorial BYTE "%% 3. Factorial                %%",10,"$"
    opcionReporte BYTE "%% 4. Crear Reporte            %%",10,"$"
    opcionSalir BYTE "%% 5. Salir                    %%",10,"$" 
    opcionelegida BYTE "Elija una opcion: ",10,"$" 
    prueba BYTE 10,"Opcion calculadora ",10,"$"
    menuFactorial BYTE 10,"Ingrese numero entre (00-04): ",10,"$"
    despedida BYTE 10,"Adios Vaquero!! ",10,"$"
    saltoLinea db " ",10,"$"
    numopcion db 0
    signo db ?
    numero db 0
    numeroFact db 1
    pedirNum BYTE "Ingrese numero: ",10,"$"
    pedirSigno BYTE "Ingrese un operador: ",10,"$"
    pedirMasSigno BYTE "Ingrese un operador o ';' para finalizar: ",10,"$"
    resultao db 0
    printResultado db "El resultado fue: ","$"
    u db 0
    d db 0
    
.code 

main proc
    menu:
    mov   ax, seg @data     
    mov   ds, ax  

    ; muestra el menu completo
    imprimir encabezado
    imprimir encabezado2
    imprimir opcionCarga
    imprimir opcionCalculadora
    imprimir opcionFactorial
    imprimir opcionReporte
    imprimir opcionSalir
    imprimir encabezado
    imprimir opcionelegida       
    ; termina de mostrar menu

    ; lee dato escogido
    getDato
    mov numopcion, al
    cmp numopcion, 32h
    je calculadoraMode
    ; un comentario alv
    cmp numopcion, 33h
    je factorial

    ; otro comentario alv
    cmp numopcion, 35h
    je Salir

    ; un ultimo comentario alv
    jmp menu

    ; fin de lectura
    
    cargarArchivo:
        jmp menu
    calculadoraMode:

        imprimir saltoLinea
        imprimir pedirNum

        getDato
        sub al, 30h
        mov d, al ; resultao = al 5
        getDato
        sub al, 30h
        mov u, al
        devolverDecimal u, d, resultao
        imprimir saltoLinea
        imprimir pedirSigno
        getDato
        mov signo, al ; signo = al
        imprimir saltoLinea
        imprimir pedirNum

        getDato
        sub al, 30h
        mov d, al ; resultao = al 5
        getDato
        sub al, 30h
        mov u, al
        devolverDecimal u, d, numero
        call funcionCalculadora
    factorial:
        call factorial
    Salir:
        imprimir despedida
        mov ah, 4ch
        xor al, al
        int 21h
main endp
factorial proc
        
        imprimir menuFactorial
        getDato 
        sub al, 30h
        mov d, al ; resultao = al 5
        getDato
        sub al, 30h
        mov u, al
        cmp u, 0
        je resultado        
        mov cl, u
        ciclo:
            mov al, numeroFact ; 1
            mov bl, cl         ; 2
            mul bl
            mov numeroFact, al
        loop ciclo
        resultado:
            imprimir saltoLinea
            imprimir printResultado
            mov al, numeroFact
            AAM  
            mov bx, ax
            mov ah, 02h
            mov dl, bh
            add dl, 30h
            int 21h
            mov ah,02h
            mov dl,bl
            add dl,30h
            int 21h
            imprimir saltoLinea
            mov numeroFact, 1
            call main
        jmp main
factorial endp
funcionCalculadora proc
    irSigno:
        cmp signo, 2Bh
        je suma
        cmp signo, 2Dh
        je resta
        cmp signo, 2Ah
        je multiplicacion
        cmp signo, 2Fh
        je division
    masSignos: 
        imprimir saltoLinea
        imprimir pedirMasSigno

        getDato        
        mov signo, al
        cmp signo, 3Bh
        je resultado

        imprimir saltoLinea
        imprimir pedirNum

        getDato
        sub al, 30h
        mov d, al 
        getDato
        sub al, 30h
        mov u, al
        devolverDecimal u, d, numero

        jmp irSigno
    suma:
        mov al, resultao ; al = resultao
        adc al, numero  ; al = al + numero
        mov resultao, al  ; resultao = al resultao = 8
        jmp masSignos
    resta:
        mov al, resultao ; al = resultao
        sbb al, numero  ; al = al - numero
        mov resultao, al  ; resultao = al
        jmp masSignos
    multiplicacion:
        mov al, resultao
        mov bl, numero
        imul bl
        mov resultao, al
        jmp masSignos
    division:
        xor ax, ax
        mov al, resultao
        mov bl, numero
        idiv bl
        mov resultao, al
        jmp masSignos
    resultado:
        imprimir saltoLinea
        imprimir printResultado
        mov al, resultao
        AAM  
        mov bx, ax
        mov ah, 02h
        mov dl, bh
        add dl, 30h
        int 21h

        mov ah,02h
        mov dl,bl
        add dl,30h
        int 21h
        imprimir saltoLinea
        call main
funcionCalculadora endp
end main