SD SEGMENT PARA STACK 'STACK'
    db 256 dup(0)
SD ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
    matrix db 81 dup(0)

    input_n     DB  'Input columns: '
                DB '$'
    n db 0

    input_m     DB  'Input rows: '
                DB '$'
    m db 0

    sum db 0
    minsum db 1
    minindex db 0

DATA ENDS

SC1 SEGMENT PARA PUBLIC 'CODE'
    assume CS:SC1, DS:DATA

input_num:
    mov ah, 01h
    int 21h
    sub AL, '0'
    ret

create_matrix:
    mov si, 0 //по строкам
    mov cl, [m]
    label1:
        mov di, 0
        add di, si //по строке
        mov dh, cl
        mov cl, [n]

        label2:
            mov ah, 01h
            int 21h
            mov matrix[di], al
            int 21h
            inc di
        loop label2

        add si, 9
        mov cl, dh
    loop label1

    ret

print:
    mov ah, 02h
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
    ret

output_matrix:
    call print

    xor si, si
    mov cl, [m]

    lab1:
        xor di, di
        add di, si
        mov dh, cl
        mov cl, [n]
        mov ah, 2

        lab2:
            mov dl, matrix[di]
            int 21h
            mov dl, ' '
            int 21h
            inc di
        loop lab2

        call print

        mov cl, dh
        add si, 9
    loop lab1

    ret


delete_min_sum_column:
    call search_min_sum
    
    call delete_column

    ret

search_min_sum:
    mov si, 0
    mov cl, [n]
    lable1:
        mov ah, 0
        mov di, si
        mov dh, cl
        mov cl, [m]
        lable2:
            mov bl, matrix[di]
            sub bl, 30h
            add ah, bl
            
            add di, 9
        loop lable2

        cmp dh, [n]
		jne furher ;не равны
		jmp set_min_sum
		furher:
		cmp ah, [minsum]
		jb set_min_sum ;если меньше
		jae endofif
		set_min_sum:
			xchg ah, [minsum]
			xor ax, ax
			add ax, si
			xchg [minindex], al
		endofif:

        inc si
        mov cl, dh
    loop lable1

    ret

delete_column:
	mov cx, 0 
	mov di, 0 
	mov si, 0 
	mov cl, [m] ;иниц количестом строк

run_lines:
	mov dh, cl
	mov cl, [n] ;иниц количеством столбцов
	mov ax, 0
    mov al, [minindex]
	sub cl, al
	mov di, ax
	add di, si
	
	shift:
		mov ah, 0
		xchg ah, matrix[di + 1]
		mov byte ptr matrix[di], ah
		inc di
	loop shift

	add si, 9
	mov cl, dh
	loop run_lines
	
	;mov ah, n
	dec n
	;xchg ah, n
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

    call create_matrix ;создание матрицы

    call output_matrix ;вывод матрицы

    call delete_min_sum_column

    call output_matrix

    mov dl, n

    mov ax, 4c00h
    int 21h
SC1 ENDS
END main


