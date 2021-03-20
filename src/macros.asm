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
devolverDecimal macro u, d, numero
        mov al, d
        mov bl, 10
        mul bl
        add al, u
        mov numero, al
endm