include macros.asm
.MODEL  SMALL                      ;code and data each fit in 64K
.STACK  100h                       ;512-byte stack
.DATA
    filehandle dw 0
    
    mess_ok db 10, 13, 'Program is finished and file is succesufully closed$'
    mess_error db 10, 13, 'Can`t open the file$'
    mess_enter_filename db 'Enter a file name: $'
    mess_enter_wtr db 'Enter a word you want to replace: $'
    mess_enter_repl db 'Enter a replacement: $'
    
    file_name db 12 dup('$')
    buffer db 100 dup('$')
    word_to_replace db 100 dup('$')
    replacement db 100 dup('$')
    
    mess_help db 'Program loads a file with given name character by character and replaces', 10, 13
    mh2 db 'each occurrence of one word with another (words are specified by the user).', 10, 13
    mh3 db 'Word will be replaced even if its a substring of another word.', 10, 13
    mh4 db 'The maximum length of both words (strings) is 100 characters.', 10, 13
    mh5 db 'The maximum length of the filename is 12 characters (including extension).', 10, 13
    mh6 db 'Possible arguments:', 10, 13, '-h   -   prints this manual', 10, 13, '$'
    
.CODE 
;prints the buffer on the screen and adds $ at the start of the buffer
print_buffer proc
    mov ah, 9           
    mov dx, offset buffer
    int 21h
    lea di, buffer
    mov [di], byte ptr '$'
  ret  
print_buffer endp 
;reads user input till user press enter
read_input proc
    char_read:
        int 21h
        
        cmp al, 0dh     ;check if enter was found
        jz enter_found 
        
        ;save character to offset+1
        mov [di], al
        inc di
        
        jmp char_read
        
     enter_found:
       ret
read_input endp

main:
    ;check if there is -h srgument
    read_argument
    
    ;ask user for filename and save it in file_name
    mov ah, 9
    mov dx, offset mess_enter_filename
    int 21h
    mov di, offset file_name
    mov ah, 01h
    call read_input
    ;append \0 and $ to filename
    mov [di], byte ptr 0
    inc di
    mov [di], byte ptr '$'
    ;ask user for a word to replace and save it in word_to_replace
    mov ah, 9
    mov dx, offset mess_enter_wtr
    int 21h
    mov di, offset word_to_replace
    mov ah, 01h
    call read_input
    ;ask user for a word program will be replacing with
    mov ah, 9
    mov dx, offset mess_enter_repl
    int 21h
    mov di, offset replacement
    mov ah, 01h
    call read_input
    
    ;try to open the file
    mov ax,3D00h
    mov dx, offset file_name
    int 21h
    ;save file handle
    mov filehandle, ax
    jnc no_error ;file is succsessfully opened
    print_err    ;failed to open a file
    
 no_error:
    xor si, si
    compare_char:
        ;read char from file
        read_char
        
        ;not all symbols in word_to_replace are matched yet
        
        cmp ax, 0
        jz finish   ; end of the file - next symbol will not be matched
        
        ;try to compare next symbol in the buffer and in the word_to_replace
        mov al, [word_to_replace + si]
        cmp [buffer + si], al
        pushf ; save comparation flags
        inc si   ; move to the next index
        popf ; look at the comparation flags
        jz control_end ; symbols are the same - need to control the end of word_to_replace
        jmp not_matched ; symbols are not the same
     
    control_end:
        mov al, [word_to_replace + si] ;load character into al
        cmp al, '$' ; control if its end of the word_to_replace (i.e. all symbols match)
        jz replace_word ; whole word is matched - no need to compare other symbols
        jmp compare_char ; there are more symbols in word_to_replace to compare
        
    not_matched:
        ;not matched - clear counter and buffer
        lea di, [buffer + si]
        mov [di], byte ptr '$' ; add $ at the end off word in buffer for correct output
        xor si, si ; set counter on 0
        call print_buffer
        jmp compare_char ; start the cycle again
        
    replace_word:
        ;print the word we are replacing with
        mov ah, 9
        mov dx, offset replacement
        int 21h
        xor si, si ; set counter on 0
        lea di, buffer
        mov [di], byte ptr '$' ; add $ at the start of buffer for `cleaning` it (nothing will be printed if we try print buffer)
        jmp compare_char ; start the cycle again
        
 finish:
    call print_buffer ; print last characters if there are any
    ; close the file
    mov ah,3Eh
    mov bx,filehandle
    int 21h
    ; inform user about correct finish
    mov dx,offset mess_ok
    mov ah,9
    int 21h
    ; finish the program
    mov ax, 4c00h
    int 21h
end main