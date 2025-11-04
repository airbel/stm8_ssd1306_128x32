## stm8_ssd1306_128x32 
Stm8_ST_Lib have the lib for ssd1306_128x64,But not word on 128x32 ,
Have a program that its' memory not enough memory!
Because the Stm8s103  Memery Only 8k, so Change 
buffer_size -> 128 
And Spile 4 pages
y_size  -> 32 | y_max -> 4 

I changed 'OLED_print_Image' to make it display 16*16!

10:19 2025年11月4日
分離出來OLED_print_Image_4page()，可以滿版顯示字形