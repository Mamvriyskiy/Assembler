EXTRN NUMBER: NEAR

PUBLIC TO_UNSIGNED_BIN
PUBLIC UBIN
PUBLIC SHEX

DATASEG SEGMENT PARA PUBLIC 'DATA'
    MASK16 DW 15
    MASK2 DW 1
    SHEX DB 4 DUP(0), '$'
    UBIN DB 16 DUP(0), '$'
    SIGN DB ' '
DATASEG ENDS

CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG

TO_UNSIGNED_BIN PROC NEAR
    MOV AX, NUMBER
    MOV BX, 15

    GETBIN:
        MOV DX, AX 
        AND DX, MASK2 ;получение последних 2 бит
        ADD DL, '0' ;преобразование последнего символа в ASCII
        MOV UBIN[BX], DL
        MOV CL, 1 ;для операции сдвига в право
        SAR AX, CL ;сдвиг исходного значения на 1 бит вправо
        DEC BX 
        CMP BX, -1 ;если bx равен -1, то все цифры преобразованы
        JNE GETBIN

    ret
TO_UNSIGNED_BIN ENDP


TO_SIGNED_HEX PROC NEAR
    MOV CL, ' '
    MOV SIGN, CL
    MOV AX, NUMBER
    CMP AX, 0 ;32767

    JGE NOTOVERFLOW
    NEG AX
    MOV CL, '-'
    MOV SIGN, CL

    NOTOVERFLOW:
    MOV BX, 3

    GETHEX:
        MOV DX, AX
        AND DX, MASK16
        CMP DL, 10
        JB ISDIGIT
        ADD DL, 7
        ISDIGIT:
            ADD DL, '0'
            MOV SHEX[BX], DL
            MOV CL, 4
            SAR AX, CL
            DEC BX
            CMP BX, -1
        JNE GETHEX
    RET
    Напиши комментарии к коду
TO_SIGNED_HEX ENDP

CODESEG ENDS
END 
