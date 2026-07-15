
[org 0x7C00]
[bits 16]

start:
    cli                     
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00   
    sti

    mov [BOOT_DRIVE], dl      

    mov si, msg_start
    call print_string_16


    call load_kernel

    
    call enable_a20

    mov si, msg_a20_ok
    call print_string_16

    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax             

    jmp CODE_SEG32:protected_mode_start

print_string_16:
    pusha
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    popa
    ret

load_kernel:
    pusha
    mov ah, 0x02              
    mov al, KERNEL_SECTORS    
    mov ch, 0                 
    mov dh, 0                 
    mov cl, 2               
    mov bx, 0x1000
    mov es, bx
    xor bx, bx                
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc disk_error
    popa
    ret

disk_error:
    mov si, msg_disk_error
    call print_string_16
    jmp $

enable_a20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret


[bits 32]
protected_mode_start:
    mov ax, DATA_SEG32
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call setup_page_tables
    call enable_paging

    lgdt [gdt64_descriptor]
    jmp CODE_SEG64:long_mode_start

setup_page_tables:
    
    mov edi, 0x1000          
    mov cr3, edi
    xor eax, eax
    mov ecx, 4096
    rep stosd                 

    mov edi, 0x1000
    mov dword [edi], 0x2003    
    mov edi, 0x2000
    mov dword [edi], 0x3003    
    mov edi, 0x3000

    mov ebx, 0x00000083      
    mov ecx, 512                
.fill_pd:
    mov dword [edi], ebx
    add ebx, 0x200000
    add edi, 8
    loop .fill_pd

    ret

enable_paging:
    
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax


    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

[bits 64]
long_mode_start:
    mov ax, DATA_SEG64
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x90000


    cli
    hlt

gdt_start32:
    dq 0x0000000000000000     

gdt_code32:
    dw 0xFFFF, 0x0000
    db 0x00, 10011010b, 11001111b, 0x00

gdt_data32:
    dw 0xFFFF, 0x0000
    db 0x00, 10010010b, 11001111b, 0x00
gdt_end32:

gdt_descriptor:
    dw gdt_end32 - gdt_start32 - 1
    dd gdt_start32

CODE_SEG32 equ gdt_code32 - gdt_start32
DATA_SEG32 equ gdt_data32 - gdt_start32

gdt_start64:
    dq 0x0000000000000000      

gdt_code64:
    dw 0x0000, 0x0000
    db 0x00, 10011010b, 00100000b, 0x00  

gdt_data64:
    dw 0x0000, 0x0000
    db 0x00, 10010010b, 00000000b, 0x00
gdt_end64:

gdt64_descriptor:
    dw gdt_end64 - gdt_start64 - 1
    dq gdt_start64

CODE_SEG64 equ gdt_code64 - gdt_start64
DATA_SEG64 equ gdt_data64 - gdt_start64


BOOT_DRIVE:      db 0
KERNEL_SECTORS   equ 32          

msg_start:       db "Starting Tree OS Bootloader...", 13, 10, 0
msg_a20_ok:      db "A20 line started now....", 13, 10, 0
msg_disk_error:  db "Error Kernel is cannot readed from disk!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
