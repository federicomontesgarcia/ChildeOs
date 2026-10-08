bits 16
org 0x8000

inicio:
   mov si, mensaje

imprimir:
   lodsb
   cmp al, 0
   je detener

   mov ah, 0x0E
   int 0x10

   jmp imprimir

detener:
   cli
   hlt
   jmp detener


mensaje:
   db "Hello from ChildeOS Kernel!", 0

