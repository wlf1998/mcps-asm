data segment
    arr DB 36 DUP(0) 
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

; add your code here    

;循环，初始化arr数组为1~36  
    mov ax, 0
loop1:
    inc ax  
    mov di, ax
    mov arr[di-1], al
    cmp ax, 36
    je done
    jmp loop1
    
done:

;对数组进行循环    
    mov cx, 0
 
loop2:
;判断是否是左下三角
    mov ax, cx
    mov bl, 6
    div bl
    inc cx
    cmp al, ah

    jl noprint ;如果不是则跳过输出

;除以10后分别输出高位和低位
    mov ax, cx    
    mov bl, 10
    div bl
    mov bx, ax
    mov dl, bl
    add dl, '0'
    mov ah, 2
    int 21h
    mov dl, bh 
    add dl, '0'
    int 21h
    mov dl, ' '
    int 21h

noprint:
;判断是否是6的倍数，是的话则换行    
    mov bl, 6
    mov ax, cx
    div bl
    cmp ah, 0
    jne nonewline ;不换行则跳过
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h
nonewline:    
    cmp cx, 36
    je done2
    jmp loop2

done2:      
      
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
