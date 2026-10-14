void print(const char *text)
{
   char *video = (char *)0xB8000;
   int i;

   for (i = 0; text[i] != '\0'; i++)
   {
       video[2 * i] = text[i];
       video[2 * i + 1] = 0x0F;
   }
}

void kernel_main(void)
{
   print("ChildeOS");

   for (;;)
   {
   }

}
