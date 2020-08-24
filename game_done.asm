data segment
    welcome_msg db "Welcome to Bul/Pgiya by Denis Gambraih. Press enter to start$"
    type_number_msg db "Type 4-digits' number (0 can not be first digit)$"
    error_msg db "Number is wrong! Type 4-digits number (0 can not be first digit)$"
    win_msg db "You won!$"
    lose_msg db "You lost :($"
    exit_msg db "Press enter to exit from the game$"
    guessings_msg db " - count of guessings$"
    
    randomed_number db 4 dup(?)
    
    counter_guessings db 0h, "tries$"
    counter_guessings_to_print db '0$'
    counter_bull db ?, " -- count of bulls $"
    counter_pgiya db ?, " -- count of pgiya$"
    
    counter_loop db ?
    
    n=4
    user_input_string db n+1, ?, n+1 dup(?)    
data ends

sseg segment stack
    dw 100 dup(?)
sseg ends 

code segment
    assume cs:code, ds:data, ss:sseg
start:
    mov ax, data
    mov ds, ax
    ;
    
    count_of_bulls_inc_wrapper:
    jmp welcome_message
        count_of_bulls_inc:
            inc counter_bull
            jmp loop_check_count_of_bulls
        ;
    ;
    
    count_of_pgiya_inc:
        inc counter_pgiya
        jmp for2_check_count_of_pgiya    
    ;
    
    welcome_message:
        mov dx, offset welcome_msg
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
    ;
    
    check_if_was_pressed_enter:                                                          
        mov ah, 7h ;taking char from user
        int 21h
        cmp al, 0dh
        jnz welcome_message
    ;
    
    randoming_number:
        call randoming_proc
    ;
    
    waiting_for_user_input: 
        mov si, offset counter_guessings
        mov al, [si]
        cmp al, 0ch
        je lose_message
        
        mov dx, offset type_number_msg ;printing 'type number'
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        taking_input_by_user:
            mov dx, offset user_input_string; taking input by user
            mov ah, 0ah
            int 21h
        ;
        
        ;block of checks if user_input_string was valid
        cmp user_input_string[2], 30h
        jz user_input_error
        
        cmp user_input_string[1], 4h
        jnz user_input_error
        
        mov si, offset user_input_string
        add si, 2h
        mov counter_loop, 0h
        mov cx, 3h
        
        for1_check_valid_user_input_string:
            mov counter_loop, 0h
            mov ah, byte ptr [si]
            mov di, si
            add di, 1h
                for2_check_valid_user_input_string:
                    cmp counter_loop, 4h
                    jz for2_check_valid_user_input_string_exit
                    mov al, byte ptr [di]
                    inc di
                    inc counter_loop
                    cmp ah, al
                    jz user_input_error
                    jnz for2_check_valid_user_input_string    
                ;;
                for2_check_valid_user_input_string_exit:
                    inc si
                    loop for1_check_valid_user_input_string
                ;    
            ;;
        
        ;end of this block
    
        inc counter_guessings
        inc counter_guessings_to_print
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        mov dx, offset counter_guessings_to_print ;printing count of tries
        mov ah, 9h
        int 21h
        
        mov dx, offset guessings_msg
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        jmp check_if_equals_full_number
    ;
     
     check_if_equals_full_number:
        mov si, offset randomed_number
        mov di, offset user_input_string
        
        mov cx, 4h
        add di, 2h
        loop_check_all_digit_one_to_one:
            mov al, byte ptr [si]
            mov ah, byte ptr [di]
            inc si
            inc di
            cmp al, ah
            jnz check_count_of_bulls
            loop loop_check_all_digit_one_to_one
        ;;
        jmp win_message                     
     ;    
     
     check_count_of_bulls:
        mov counter_bull, 0h
        mov si, offset randomed_number
        mov di, offset user_input_string
        mov counter_loop, 0h
        
        mov cx, 4h
        add di, 2h
        
        loop_check_count_of_bulls:
            mov al, byte ptr [si]
            mov ah, byte ptr [di]
            inc si
            inc di
            cmp al, ah
            je count_of_bulls_inc
            loop loop_check_count_of_bulls
        ;;
        mov dx, offset counter_bull ;printing counter of bulls in console
        add counter_bull, '0'
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h 
     ;
     
     check_count_of_pgiya:
        mov counter_pgiya, 0h
        mov si, offset randomed_number
        
        mov counter_loop, 0h
        
        mov cx, 4h
        
        for1_check_count_of_pgiya:
        mov counter_loop, 0h
        mov ah, byte ptr [si]
        mov di, offset user_input_string
        add di, 2h
            for2_check_count_of_pgiya:
                cmp counter_loop, 4h
                jz for2_check_count_of_pgiya_exit
                mov al, byte ptr [di]
                inc di
                inc counter_loop
                cmp ah, al
                jz count_of_pgiya_inc
                jnz for2_check_count_of_pgiya    
            ;;
            for2_check_count_of_pgiya_exit:
                inc si
                loop for1_check_count_of_pgiya
            ;    
        ;;
        mov dx, offset counter_pgiya ;printing counter pgiya in console
        add counter_pgiya, '0'
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        jmp waiting_for_user_input 
     ;
    
     win_message: 
        mov dx, offset win_msg
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        mov dx, offset exit_msg
        mov ah, 9h
        int 21h
    
        check_if_was_pressed_enter_from_win:                                                          
            mov ah, 7h ;taking char from user
            int 21h
            
            ;printing_new_line
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
        
            cmp al, 0dh
            jnz check_if_was_pressed_enter_from_win
            jmp exit
     ;
    
     lose_message:
        mov dx, offset lose_msg
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        mov dx, offset exit_msg
        mov ah, 9h
        int 21h
    
        check_if_was_pressed_enter_from_exit:                                                          
            mov ah, 7h ;taking char from user
            int 21h
            
            ;printing_new_line
            mov dl, 10
            mov ah, 02h
            int 21h
            mov dl, 13
            mov ah, 02h
            int 21h
        
            cmp al, 0dh
            jnz check_if_was_pressed_enter_from_exit
     ;

exit: mov ah, 4ch
      int 21h
         
    user_input_error:
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        mov dx, offset error_msg
        mov ah, 9h
        int 21h
        
        ;printing_new_line
        mov dl, 10
        mov ah, 02h
        int 21h
        mov dl, 13
        mov ah, 02h
        int 21h
        
        jmp taking_input_by_user
    ;      
      
;Procedures:
randoming_proc_label:
randoming_proc proc
    mov si, offset randomed_number    
    mov counter_loop, 0h
    
    looping:
        mov ah, 00h
        int 1ah ;get time
        
        mov ax, dx
        xor dx, dx
        mov bx, 10
        div bx
        
        add dl, '0'
        mov [si], dl
        inc si
        inc counter_loop
        
        cmp counter_loop, 4h
        jnz looping
        
        check_random_valid:
            cmp randomed_number[0], 0h
            jz randoming_proc_label
            
            mov si, offset randomed_number
        
            mov counter_loop, 0h
        
            mov cx, 3h
        
            for1_check_valid_randomed_number:
            mov counter_loop, 0h
            mov ah, byte ptr [si]
            mov di, si
            add di, 1h
                for2_check_valid_randomed_number:
                    cmp counter_loop, 4h
                    jz for2_check_valid_randomed_number_exit
                    mov al, byte ptr [di]
                    inc di
                    inc counter_loop
                    cmp ah, al
                    jz randoming_proc_label
                    jnz for2_check_valid_randomed_number    
                ;;
                for2_check_valid_randomed_number_exit:
                    inc si
                    loop for1_check_valid_randomed_number
                ;    
            ;;
        ;
    ;
    ret
randoming_proc endp
;

code ends
end start