void kernel_main()
{
   char *video = (char *)0xB8000;
   

   video[0] = 'C';
   video[1] = 0x0F;
   
   video[2] = 'h';
   video[3] = 0x0F;

   video[4] = 'i';
   video[5] = 0x0F;

   video[6] = 'l';
   video[7] = 0x0F;

   video[8] = 'd';
   video[9] = 0x0F;

   video[10] = 'e';
   video[11] = 0x0F;

   video[12] = 'O';
   video[13] = 0x0F;

   video[14] = 'S';
   video[15] = 0x0F;

   for (;;)
   {
   }

}
