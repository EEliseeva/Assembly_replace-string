;prints error if one occured while opening file
print_err macro
    mov dx,offset mess_error
    mov ah,9
    int 21h
    mov ax, 4c00h
    int 21h
endm

;reads one character from a file into the buffer
read_char macro
    mov bx,filehandle
    mov ah,3Fh
    mov cx,1
    lea dx, [buffer + si]
    int 21h
endm

;reads arguments when program starts
read_argument macro
    ;only -h argument is supported, 
    ;any `h` at 83h will trigger help option
    
    mov di, offset 83h
    mov al, [di]
    
    mov bx, @data
    mov ds, bx
 
    cmp al, byte ptr 'h'
    jnz not_help

    mov ah, 9
    lea dx, mess_help
    int 21h
    jmp not_help
    
    not_help:
endm