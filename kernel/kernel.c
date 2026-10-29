int cursor = 0;

/*Prototipos de las funciones*/
void clear_screen(void);
void print(const char *text);

/*Debe quedar al principio del kernel*/
void kernel_main(void)
{
   clear_screen();

   print("ChildeOS");
   print(" funciona!");

   for (;;)
   {
   }

}

void clear_screen(void)
{
   char *video = (char *)0xB8000;
   int i;
   for (i = 0; i < 80 * 25; i++)
   {
       video[2 * i] = ' ';
       video[2 * i + 1] = 0x0F;
   }
   cursor = 0;
} 

void print(const char *text)
{
   char *video = (char *)0xB8000;
   int i;

   for (i = 0; text[i] != '\0'; i++)
   {
       video[2 * cursor] = text[i];
       video[2 * cursor + 1] = 0x0F;
       
       cursor++;  
   }
}


