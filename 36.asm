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

;ѭ������ʼ��arr����Ϊ1~36  
    mov ax, 0
loop1:
    inc ax  
    mov di, ax
    mov arr[di-1], al
    cmp ax, 36
    je done
    jmp loop1
    
done:

;���������ѭ��    
    mov cx, 0
 
loop2:
;�ж��Ƿ�����������
    mov ax, cx
    mov bl, 6
    div bl
    inc cx
    cmp al, ah

    jl noprint ;����������������

;����10��ֱ������λ�͵�λ
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
;�ж��Ƿ���6�ı������ǵĻ�����    
    mov bl, 6
    mov ax, cx
    div bl
    cmp ah, 0
    jne nonewline ;������������
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
