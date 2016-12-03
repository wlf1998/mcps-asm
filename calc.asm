; multi-segment executable file template.

include 'emu8086.inc'

data segment
    ; add your data here!
    pkey db "press any key...$"
    s db 1025 dup(0)
ends

stack segment
    dw   2048  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    lea di, s
    mov dx, 1025
    call get_string ; read expression from input
    
    lea si, s
calc: ; calc is a function, which read expression from si, and return value in ax
    ; ax = current number, bx = result, cx = last op
    mov ax, 0
    mov bx, 0
    mov cx, '+'
loop1:
    cmp [si], '+'
    je oper
    cmp [si], '-'
    je oper
    cmp [si], ')'
    je oper
    cmp [si], 0
    jne next1
oper: ; process '+' '-' ')' and EOL, add current number to result 
    cmp cx, '+'
    jne minus
    add bx, ax ; process last oper '+'
    jmp finish_eval
minus:
    sub bx, ax ; process last oper '-'
finish_eval:   
    cmp [si], ')'
    jne not_rb
    ;right bracket
    mov ax, bx ; save result to ax and return
    ret
not_rb:
    cmp [si], 0
    je finish    
    mov ax, 0 ; clear current number
    mov cl, [si] ; save this oper to cx
    mov ch, 0
    jmp finish_char
          
next1:
    cmp [si], '(' ; process '('
    jne next2
    push bx ; push local variable onto stack
    push cx
    inc si
    call calc ; call calc to process expression between brackets
    pop cx ; pop local variable from stack
    pop bx
    jmp finish_char
     
next2: ; number
    mov dx, 10 ; ax = ax * 10 + new_digit
    mul dx
    mov dl, [si]
    mov dh, 0
    sub dx, '0'
    add ax, dx
    
finish_char:
    inc si
    jmp loop1
    
finish:
    ; print new line
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ; print result
    mov ax, bx
    call print_num    
    
    ; print new line
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

DEFINE_GET_STRING
DEFINE_PRINT_NUM 
DEFINE_PRINT_NUM_UNS

end start ; set entry point and stop the assembler.
