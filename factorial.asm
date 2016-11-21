; multi-segment executable file template.

include emu8086.inc

data segment
    ; add your data here!
    num db 18 dup(0)
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
    call scan_num
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h
    
    mov num,1

loop1:
    mov bx,0
loop2:
    mov al,num[bx]
    mul cl
    mov num[bx],al
    inc bx
    cmp bx,18
    jl loop2
    
    mov bx,0
loop3:
    mov al,num[bx]
    mov ah,0
    mov dl,10
    div dl
    mov num[bx],ah
    add num[bx+1],al
    inc bx
    cmp bx,18
    jl loop3
    
    loop loop1
    
    mov bx,17
loop4:
    mov dl,num[bx]
    dec bx
    cmp dl,0
    je loop4
    inc bx
loop5:
    mov dl,num[bx]
    mov ah,2
    add dl,'0'
    int 21h
    dec bx
    cmp bx,0
    jge loop5
    mov dl,13
    int 21h
    mov dl,10
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

DEFINE_SCAN_NUM

end start ; set entry point and stop the assembler.
