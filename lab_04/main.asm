SD SEGMENT PARA STACK 'STACK'
    db 100 dup(0)
SD ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
    matrix db 81 dup(0)

    input_n     DB  'Input n: '
                DB '$'
    n db 1

    input_m     DB  'Input m: '
                DB '$'
    m db 1

    size db 1


DATA ENDS

SC1 SEGMENT PARA PUBLIC 'CODE'
    assume CS:SC1, DS:DATA

input_num:
    mov ah, 01h
    int 21h
    sub al, '0'
    ret

size_matrix:
    mov ax, 0h
    mov cx, 0h
    mov al, m
    mul n
    mov cx, ax
    ret

create_matrix:
    call size_matrix
	MOV BX, 0h

input_matrix:
    mov ah, 01h
    int 21h
    mov matrix[bx], al
    int 21h
    loop input_matrix
    ret

main:
    mov ax, DATA
    mov DS, ax

    ;Ввод количества столбцов
    mov dx, OFFSET input_n
    mov ah, 9
    int 21h

    call input_num
    mov n, al
    int 21h

    ;Ввод количества строк
    mov dx, OFFSET input_m
    mov ah, 9
    int 21h

    call input_num
    mov m, al
    int 21h

    call create_matrix

    mov ax, 4c00h
    int 21h
SC1 ENDS
END main


