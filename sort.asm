; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"      
    filename db "2.txt", 0
    text db 10000 dup(0)
    nums dw 1024 dup(0)
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
    
    ; open 2.txt  
    mov al, 0 
    mov dx, offset filename
    mov ah, 3dh
	int 21h
	; read text
	mov bx, ax
	mov cx, 10000
	mov dx, offset text
	mov ah, 3fh
	int 21h
	; close file
	mov ah, 3eh
	int 21h
	
	; convert to int
	mov si, 0 ;text pointer
	mov di, 0 ;num pointer
	mov ax, 0 ;number
loop1:
	mov cl, text[si]
	mov ch, 0
	cmp cx, 48
    jl not_num
	add cx, -48
	mov dx, 10
	mul dx
	add ax, cx
	inc si
	jmp loop1
not_num:
    cmp cx, 10
    je no_new_num
    mov nums[di], ax
    add di,2
    cmp cx, 0
    je finish_conv
no_new_num:	
	inc si
	mov ax, 0
	jmp loop1
	
finish_conv:

    ; di = count * 2
    
    ; sort!
    mov ax, 2
loop5:
    cmp ax, di
    jge finish_sort
    mov bx, ax
loop6:
    cmp bx, 0
    jle next
    mov cx, nums[bx]
    mov dx, nums[bx-2]
    cmp cx, dx
    jae next
    ;swap
    mov nums[bx], dx
    mov nums[bx-2], cx
    add bx, -2
    jmp loop6
next:    
    add ax, 2
    jmp loop5 

finish_sort:
    
    mov si, 0
loop4:
    cmp si, di
    jge finish_print
    mov ax, nums[si]
    mov cx, 10
    mov bx, 0
loop2:
    mov dx, 0
    div cx
    push dx
    inc bx
    cmp ax, 0
    jg loop2
loop3:
    pop dx
    dec bx
    add dx, 48
    mov ah, 2
    int 21h
    cmp bx, 0
    jg loop3
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    add si,2
    jmp loop4
    
finish_print:

            
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
