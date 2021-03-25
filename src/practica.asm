include macros.asm                                                                           
.model small
.stack
.data 
    encabezadoPrincipal db 10,"UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,13,"FACULTAD DE INGENIERIA",10,13,"ESCUELA DE CIENCIAS Y SISTEMAS",10,13,"ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A",10,13,"SECCION B",10,13,"PRIMER SEMESTRE 2021",10,13,"Johan Leonel Chan Toledo",10,13,"201603052",10,13,"Primera Practica Assembler",10,"$"
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
    despedida BYTE 10,"         -------- Adios Vaquero!! --------          ",10,"$"
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
    digito db 0
    signoPor db " x ","$"
    operaciones db "Operaciones: ","$"
    signoIgual db "= ","$"
    singoFact db "! ","$"
    numeroCompleto db 3 dup("$")
    deseaGuardar db 10,"Desea Guardar (S/N): ",10,"$"
    resultadosGuardados db 100 dup("$")
    
    mensajeGuardado db "Valor guardado ",10,"$"
    separador db ",","$"
    operacionesGuardadas db 200 dup("$")
    pivoteOperaciones db 200 dup("$")
    mensajeReport db "       -------- Reporte creado!! --------       ",10,"$"
    errorCrear db "       -------- Error al crear archivo!! --------       ",10,"$"
    errorEscribir db "       -------- Error al crear archivo!! --------       ",10,"$"
    rutaReporte db "reporte.html"
    handlerReporte dw ?
    etiquetaHTML db "<html>"
    encabezadoHTML db "<h1>Practica 3 Arqui 1 Seccion B</h1>","<p>Estudiante: Johan Leonel Chan Toledo</p>","<p>Carnet: 201603052</p>"
    tabla db "<table border=1><thead><tr><th>Id Operacion</th><th>Operacion</th><th>Resultado</th></tr></thead>"
    columna db "<td>"
    columnaC db "</td>"
    fila db "<tr>"
    filaC db "</tr>"
    tablaC db "</table>"
    etiquetaHTMLC db "</html>"
    fecha db 15 dup(" ")
    hora db 9 dup(" ")
    separadorFecha db "/"
    separadorHora db ":"
    labelFecha db "Fecha: "
    labelHora db "Hora: "
    P db "<p>"
    pC db "</p>"
    indice db 0
    Operacion db "Operacion "
    char db "$"

.code 

main proc

    menu:
    mov   ax, seg @data     
    mov   ds, ax  

    ; muestra el menu completo
    imprimir encabezadoPrincipal
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

    cmp numopcion, 34h
    je crearReporte
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
        limpiar numeroCompleto, SIZEOF numeroCompleto, 24h
        obtenerCadena numeroCompleto
        guardarOperacion pivoteOperaciones, numeroCompleto
        obtenerNumero numeroCompleto
        mov resultao, al
        limpiar numeroCompleto, SIZEOF numeroCompleto,24h 
        imprimir saltoLinea
        imprimir pedirSigno
        getDato
        mov signo, al ; signo = al
        guardarOperacion pivoteOperaciones, signo
        imprimir saltoLinea
        imprimir pedirNum
        obtenerCadena numeroCompleto
        guardarOperacion pivoteOperaciones, numeroCompleto
        obtenerNumero numeroCompleto

        mov numero, al
        limpiar numeroCompleto, SIZEOF numeroCompleto,24h 
        call funcionCalculadora
    factorial:
        call factorial
    Salir:
        mov cx, 4
        saltos:
            imprimir saltoLinea    
        loop saltos
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
        mov u, al
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
        imprimir saltoLinea
        imprimir operaciones
        imprimirDigito:
            cmp cl, u
            ja resultado
            mov digito, cl
            mov ah, 02h
            mov dl, digito
            add dl, 30h
            int 21h
            inc cl
            imprimir singoFact
            imprimir signoPor
            jmp imprimirDigito
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
        guardarOperacion pivoteOperaciones, signo
        cmp signo, 3Bh
        je resultado

        imprimir saltoLinea
        imprimir pedirNum
        obtenerCadena numeroCompleto
        guardarOperacion pivoteOperaciones, numeroCompleto
        obtenerNumero numeroCompleto
        mov numero, al
        limpiar numeroCompleto, SIZEOF numeroCompleto,24h 
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
        IntToString resultao, numeroCompleto
        imprimir numeroCompleto
        imprimir saltoLinea
        jmp guardar
    guardar:
        imprimir saltoLinea
        imprimir deseaGuardar
        getDato
        cmp al, 53h 
            je saveData
        cmp al, 73h
            je saveData
        limpiar pivoteOperaciones, SIZEOF pivoteOperaciones, 24h
        jmp main
    saveData:
        concatenarValor resultadosGuardados, numeroCompleto, separador
        guardarOperaciones operacionesGuardadas, pivoteOperaciones
        limpiar pivoteOperaciones, SIZEOF pivoteOperaciones, 24h
        imprimir saltoLinea
        imprimir resultadosGuardados
        imprimir saltoLinea
        imprimir operacionesGuardadas
        imprimir saltoLinea
        imprimir mensajeGuardado
        jmp main
funcionCalculadora endp

crearReporte proc 
    mov cx, 4
    xor si, si
    xor di, di
    saltos:
        imprimir saltoLinea
        loop saltos
    encabezadoReporte:
        crearArchivo rutaReporte, handlerReporte
        escribirArchivo handlerReporte, etiquetaHTML, SIZEOF etiquetaHTML
        escribirArchivo handlerReporte, encabezadoHTML, SIZEOF encabezadoHTML

        escribirArchivo handlerReporte, p, SIZEOF p
        escribirArchivo handlerReporte, labelFecha, SIZEOF labelFecha
        escribirFecha handlerReporte, fecha, separadorFecha
        escribirArchivo handlerReporte, pC, SIZEOF pC

        escribirArchivo handlerReporte, p, SIZEOF p
        escribirArchivo handlerReporte, labelHora, SIZEOF labelHora
        escribirHora handlerReporte, hora, separadorHora
        escribirArchivo handlerReporte, pC, SIZEOF pC
        escribirArchivo handlerReporte, tabla, SIZEOF tabla

        escribirArchivo handlerReporte, fila, SIZEOF fila
        escribirArchivo handlerReporte, columna, SIZEOF columna
        escribirArchivo handlerReporte, Operacion, SIZEOF Operacion
        escribirArchivo handlerReporte, columnaC, SIZEOF columnaC
        escribirArchivo handlerReporte, columna, SIZEOF columna
        inc indice
        jmp crearFila
    nuevaFila:       
        escribirArchivo handlerReporte, columnaC, SIZEOF columnaC
        escribirArchivo handlerReporte, filaC, SIZEOF filaC
        escribirArchivo handlerReporte, fila, SIZEOF fila
        escribirArchivo handlerReporte, columna, SIZEOF columna
        escribirArchivo handlerReporte, Operacion, SIZEOF Operacion
        escribirArchivo handlerReporte, columnaC, SIZEOF columnaC
        escribirArchivo handlerReporte, columna, SIZEOF columna
        inc indice
        jmp crearFila
    nuevaColumna:
        escribirArchivo handlerReporte, columnaC, SIZEOF columnaC
        escribirArchivo handlerReporte, columna, SIZEOF columna
        jmp crearColumna
    crearColumna:   
        mov al, resultadosGuardados[si]
        mov char, al
        inc si
        cmp al, ','
        je nuevaFila
        cmp al, '$'
        je pieReporte
        escribirArchivo handlerReporte, char, SIZEOF char
        jmp crearColumna
    crearFila:
        mov al, operacionesGuardadas[di]
        mov char, al
        inc di
        cmp al, ';'
        je nuevaColumna
        cmp al, '$'
        je pieReporte
        escribirArchivo handlerReporte, char, SIZEOF char
        jmp crearFila
    pieReporte:
        escribirArchivo handlerReporte, columnaC, SIZEOF columnaC
        escribirArchivo handlerReporte, filaC, SIZEOF filaC
        escribirArchivo handlerReporte, tablaC, SIZEOF tablaC
        escribirArchivo handlerReporte, etiquetaHTMLC, SIZEOF etiquetaHTMLC
        cerrarArchivo handlerReporte
        imprimir mensajeReport
    fin:
        jmp main
crearReporte endp

DISP PROC
    MOV DL,BH      ; Since the values are in BX, BH Part
    ADD DL,30H     ; ASCII Adjustment

    MOV al,BL      ; BL Part 
    ADD al,30H     ; ASCII Adjustment
    RET
DISP ENDP      ; End Disp Procedure

end main