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
    numopcion db ?
    num db ?
    resultadoFactorial db 1
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
    cmp numopcion,33h
    je factorial
    cmp numopcion,35h
    je Salir
    jmp menu
    ; fin de lectura
    
    cargarArchivo:
        jmp menu
    calculadoraMode:
        imprimir prueba
        jmp menu 
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
        mov num, al
        cmp al, 30h
        mov cx,0

        mov cx,3

        ciclo:
            mov al, resultadoFactorial
            mov bl, cl
            mul bl
            mov resultadoFactorial, al
        loop ciclo
        imprimir resultadoFactorial
        
        jmp main
factorial endp
end main