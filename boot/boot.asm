bits 16
org 0x7C00

start:
   ; Inicializar segmentos
   xor ax, ax
   mov ds, ax
   mov es, ax

   ; Guardar numero de unidad de arranque
   mov [boot_drive], dl

   ; Mostrar mensaje
   mov si, mensaje

imprimir:
   lodsb
   cmp al, 0
   je cargar_kernel

   mov ah, 0x0E
   int 0x10

   jmp imprimir


cargar_kernel:
   ; ES:BX = direccion donde se cargara el kernel
   mov ax, 0x0000
   mov es, ax
   mov bx, 0x8000

   ; BIOS: leer sector 2 del disco
   mov ah, 0x02
   mov al, 0x01
   mov ch, 0x00
   mov cl, 0x02
   mov dh, 0x00
   mov dl, [boot_drive]

   int 0x13

   jc error_disco

   ; Deshabilitar interrupciones
   cli

   ; Cargar la GDT
   lgdt [gdt_descriptor]

   ; Activar Protected Mode
   mov eax, cr0
   or eax, 1
   mov cr0, eax

   ; Saltar al segmento de codigo de Protected Mode
   jmp dword 0x08:protected_mode


error_disco:
   mov si, error

error_loop:
   lodsb
   cmp al, 0
   je detener

   mov ah, 0x0E
   int 0x10

   jmp error_loop


detener:
   cli
   hlt
   jmp detener


; =========================================================
; GDT - Global Descriptor Table
; =========================================================

gdt_start:

; Descriptor nulo
gdt_null:
   dq 0x0000000000000000


; Descriptor de codigo
gdt_code:
   dw 0xFFFF
   dw 0x0000
   db 0x00
   db 10011010b
   db 11001111b
   db 0x00


; Descriptor de datos
gdt_data:
   dw 0xFFFF
   dw 0x0000
   db 0x00
   db 10010010b
   db 11001111b
   db 0x00


gdt_end:


; =========================================================
; Descriptor utilizado por LGDT
; =========================================================

gdt_descriptor:
   dw gdt_end - gdt_start - 1
   dd gdt_start


; =========================================================
; Codigo ejecutado en Protected Mode
; =========================================================

bits 32

protected_mode:

   ; Selector del segmento de datos
   mov ax, 0x10

   ; Inicializar segmentos de datos
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax

   ; Inicializar la pila
   mov esp, 0x90000

   ; Marca de prueba
   mov edi, 0xB8000

   ; -----------
   mov edi, 0xB8000

   mov byte [edi], 'X'
   mov byte [edi + 1], 0x0F

   mov byte [edi + 2], 'O'
   mov byte [edi + 3], 0x0F

   mov byte [edi + 4], 'S'
   mov byte [edi + 5], 0x0F

   ; Ejecutar kernel C
   call 0x8000

detener_pm:
   cli
   hlt
   jmp detener_pm


; =========================================================
; Datos del bootloader
; =========================================================

mensaje:
   db "ChildeOS Bootloader...", 0

error:
   db "Error leyendo Kernel!", 0

boot_drive:
   db 0


; =========================================================
; Rellenar hasta 512 bytes
; =========================================================

times 510 - ($ - $$) db 0

; Firma de boot sector
dw 0xAA55
