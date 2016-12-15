; multi-segment executable file template.

include 'emu8086.inc'

data segment
    ; add your data here!
    pkey db "press any key...$"
    filename db "temp.txt", 0
    text db 1000 dup(0)
    nums dw 1000 dup(0)
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
    
    ; open file  
    mov al, 0 
    mov dx, offset filename
    mov ah, 3dh
	int 21h
    ; read text
	mov bx, ax
	mov cx, 1000
	mov dx, offset text
	mov ah, 3fh
	int 21h
	;print text
	printn 'source text:'
	mov si,ax
	mov text[si],'$'
	mov ah, 9
	int 21h
	printn ''
	
	;parse text
	mov text[si],' '
	mov si,0
	mov ax,0
	mov di,0
	mov bx,1
parse_loop:
    mov cl,text[si]
    mov ch,0
    cmp cx,' '
    jne next1
    cmp bx,1
    je parse_next ;another space, do nothing
    mov bx,1 ;for next loop
    mov nums[di],ax
    add di,2
    mov ax,0
    jmp parse_next
next1:
    mov bx,0
    cmp cx,0
    jne next2
    jmp parse_finish
next2:
    shl ax,4
    cmp cx,'A'
    jge next3
    sub cx,'0'
    add ax,cx
    jmp parse_next     
next3:
    cmp cx,'a'
    jge next4
    sub cx,'A'
    add cx,10
    add ax,cx
    jmp parse_next
next4:
    sub cx,'a'
    add cx,10
    add ax,cx
parse_next:
    inc si
    jmp parse_loop
    
parse_finish:
    ;now di is count*2
    ;reverse print hex
    printn 'reverse:'
    mov si,di
reverse_next:
    sub si,2
    mov cx,nums[si]
    mov bx,cx
    shr bx,4
    cmp bx,0
    je no_print_leading_zero
    call print_hex
no_print_leading_zero:
    mov bx,cx
    and bx,0xf
    call print_hex
    print ' '
    cmp si,0
    jg reverse_next
    printn ''

    ;sort
    mov ax, 2
sort_loop1:
    cmp ax, di
    jge finish_sort
    mov bx, ax
sort_loop2:
    cmp bx, 0
    jle sort_next
    mov cx, nums[bx]
    mov dx, nums[bx-2]
    cmp cx, dx
    jae sort_next
    ;swap
    mov nums[bx], dx
    mov nums[bx-2], cx
    add bx, -2
    jmp sort_loop2
sort_next:    
    add ax, 2
    jmp sort_loop1 

finish_sort:
    
    ;print decimal
    printn 'sorted:'
    mov si,0
print_loop:
    mov ax,nums[si]
    call print_num_uns
    add si,2
    cmp si,di
    jge no_comma
    print ','
no_comma:
    cmp si,di
    jl print_loop
    printn ''
    
    ;count even nums
    mov si,0
    mov bx,0 ;even
    mov cx,0 ;total
count_loop:
    mov ax,nums[si]
    and ax,1
    inc bx
    sub bx,ax
    inc cx
    add si,2
    cmp si,di
    jl count_loop
    print 'total='
    mov ax,cx
    call print_num
    print ',even='
    mov ax,bx
    call print_num
    printn ''
    mov ax,cx ;save total in ax
    
    ;input num    
input_again:
    print 'please input N:'
    call scan_num
    printn ''
    cmp cx,1
    jl input_again
    cmp cx,ax
    jg input_again
    ;input ok
    dec cx
    mov si,cx
    add si,si   
    mov cx,nums[si]
    mov ax,cx
    call print_num_uns
    print '='
    ;factor cx
    cmp cx,2
    jge no_zero_one
    mov ax,cx
    call print_num_uns
    jmp factor_finish
no_zero_one:
    mov bx,2
factor_loop:
    mov ax,cx
    mov dx,0
    div bx
    cmp dx,0
    jne not_factor
    mov cx,ax ;cx=div result
    mov ax,bx
    call print_num_uns
    cmp cx,1
    je factor_finish
    print '*'
    jmp factor_loop
not_factor:
    inc bx
    jmp factor_loop    
factor_finish:    
    printn '' 
    
    jmp finish_all
    
print_hex: ;print hex char of bx(0~15)
    cmp bx,10
    jge more_than_ten1
    add bx,'0'
    mov dl,bl
    jmp print_char1
more_than_ten1:
    sub bx,10
    add bx,'A'
    mov dl,bl
print_char1:
    mov ah, 2
    int 21h
    ret      


    
finish_all:
           
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM_UNS
DEFINE_PRINT_NUM 

end start ; set entry point and stop the assembler.
