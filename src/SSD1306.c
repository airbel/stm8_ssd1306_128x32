#include "fonts.h"
#include "SSD1306.h"


void I2C_setup(void)
{
    I2C_DeInit();

    I2C_Init(100000, 
             SSD1306_I2C_Address, 
             I2C_DUTYCYCLE_2, 
             I2C_ACK_CURR, 
             I2C_ADDMODE_7BIT, 
             (CLK_GetClockFreq() / 1000000));

    I2C_Cmd(ENABLE);
}


void OLED_HW_setup(void)
{
	I2C_setup();
}


void OLED_init(void)
{
     OLED_HW_setup();
     delay_ms(100);
     
     OLED_write((Set_Display_ON_or_OFF_CMD | Display_OFF), SSD1306_CMD);
     OLED_write(Set_Multiplex_Ratio_CMD, SSD1306_CMD);
     OLED_write(0x1F, SSD1306_CMD);
     OLED_write(Set_Display_Offset_CMD, SSD1306_CMD);
     OLED_write(0x00, SSD1306_CMD);
     OLED_write(Set_Display_Start_Line_CMD, SSD1306_CMD);
     OLED_write((Set_Segment_Remap_CMD | Column_Address_0_Mapped_to_SEG127), SSD1306_CMD);
     OLED_write((Set_COM_Output_Scan_Direction_CMD | Scan_from_COM63_to_0), SSD1306_CMD);
     OLED_write(Set_Common_HW_Config_CMD, SSD1306_CMD);
     OLED_write(0x02, SSD1306_CMD);
     OLED_write(Set_Contrast_Control_CMD, SSD1306_CMD);
     OLED_write(0x8F, SSD1306_CMD);
     OLED_write(Set_Entire_Display_ON_CMD, SSD1306_CMD);
     OLED_write(Set_Normal_or_Inverse_Display_CMD, SSD1306_CMD);
     OLED_write(Set_Display_Clock_CMD, SSD1306_CMD);
     OLED_write(0x80, SSD1306_CMD);
     OLED_write(Set_Pre_charge_Period_CMD, SSD1306_CMD);
     OLED_write(0xF1, SSD1306_CMD);
     OLED_write(Set_VCOMH_Level_CMD, SSD1306_CMD);
     OLED_write(0x40, SSD1306_CMD);
     OLED_write(Set_Page_Address_CMD, SSD1306_CMD);
     OLED_write(0x00, SSD1306_CMD);
     OLED_write(0x03, SSD1306_CMD);
     OLED_write(Set_Page_Start_Address_CMD , SSD1306_CMD);
     OLED_write(Set_Higher_Column_Start_Address_CMD, SSD1306_CMD);
     OLED_write(Set_Lower_Column_Start_Address_CMD, SSD1306_CMD);
     OLED_write(Set_Memory_Addressing_Mode_CMD, SSD1306_CMD);
     OLED_write(0x02, SSD1306_CMD);
     OLED_write(Set_Charge_Pump_CMD, SSD1306_CMD);
     OLED_write(0x14, SSD1306_CMD);
     OLED_write((Set_Display_ON_or_OFF_CMD | Display_ON), SSD1306_CMD);
}


void OLED_write(unsigned char value, unsigned char control_byte)
{
    while(I2C_GetFlagStatus(I2C_FLAG_BUSBUSY));
	
	I2C_GenerateSTART(ENABLE);
    while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
   
    I2C_Send7bitAddress(SSD1306_I2C_Address, I2C_DIRECTION_TX); 
    while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
   
    I2C_SendData(control_byte);
    while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTING));
	
    I2C_SendData(value);
    while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));

    I2C_GenerateSTOP(ENABLE);  
}


void OLED_gotoxy(unsigned char x_pos, unsigned char y_pos)
{
		 if(y_pos > 3) y_pos = 3;
		 if(x_pos > 127) x_pos = 127;
     OLED_write((Set_Page_Start_Address_CMD + y_pos), SSD1306_CMD);
     OLED_write(((x_pos & 0x0F) | Set_Lower_Column_Start_Address_CMD), SSD1306_CMD);
     OLED_write((((x_pos & 0xF0) >> 0x04) | Set_Higher_Column_Start_Address_CMD), SSD1306_CMD);
}


void OLED_fill(unsigned char bmp_data)
{
    unsigned char x_pos = 0x00;
    unsigned char page = 0x00;

    for(page = 0; page < 4; page++)
    {
        OLED_gotoxy(x_min, page);
        
        I2C_GenerateSTART(ENABLE);
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
       
        I2C_Send7bitAddress(SSD1306_I2C_Address, I2C_DIRECTION_TX); 
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
       
        I2C_SendData(SSD1306_DAT);
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTING));    

        for(x_pos = x_min; x_pos < x_max; x_pos++)
        {
           I2C_SendData(bmp_data);
		   while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));  
        }
		
        I2C_GenerateSTOP(ENABLE);  
    }
}

/*
void OLED_print_Image(const unsigned char *bmp, unsigned char pixel)
{
    unsigned char x_pos = 0;
    unsigned char page = 0;
   
    if(pixel != OFF)
    {
        pixel = 0xFF;
    }
    else
    {
        pixel = 0x00;
    }
   
    for(page = 0; page < y_max; page++)
    {
         OLED_gotoxy(x_min, page);

         I2C_GenerateSTART(ENABLE);
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
       
         I2C_Send7bitAddress(SSD1306_I2C_Address, I2C_DIRECTION_TX); 
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
       
         I2C_SendData(SSD1306_DAT);
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTING));    

         for(x_pos = x_min; x_pos < x_max; x_pos++)
         {
            I2C_SendData((*bmp++ ^ pixel));
            while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
         }

		 I2C_GenerateSTOP(ENABLE); 
     }
}


void OLED_clear_screen(void)
{
    OLED_fill(0x00);
}
*/


void OLED_print_Image(const unsigned char *bmp, unsigned char pixel)
{
    unsigned char x_pos = 0;
    unsigned char page = 0;
   
    if(pixel != OFF)
    {
        pixel = 0xFF;
    }
    else
    {
        pixel = 0x00;
    }
   
    for(page = 0; page < 2; page++)
    {
         OLED_gotoxy(x_min, page);

         I2C_GenerateSTART(ENABLE);
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
       
         I2C_Send7bitAddress(SSD1306_I2C_Address, I2C_DIRECTION_TX); 
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
       
         I2C_SendData(SSD1306_DAT);
         while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTING));    

         for(x_pos = x_min; x_pos < 16; x_pos++)
         {
            I2C_SendData((*bmp++ ^ pixel));
            while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));
         }

		 I2C_GenerateSTOP(ENABLE); 
     }
}


void OLED_clear_screen(void)
{
    OLED_fill(0x00);
}

void OLED_clear_buffer(void)
{
     unsigned int s = 0x0000;

     for(s = 0; s < buffer_size; s++)
     {
          buffer[s] = 0x00;
     }
}

void OLED_print_char(unsigned char x_pos, unsigned char y_pos, unsigned char ch)
{
  unsigned char s = 0x00;
  unsigned char chr = 0x00;
    
  chr = (ch - 0x20);
  
  if(x_pos > (x_max - 0x06))
  {
    x_pos = 0x00;
    y_pos++;
		if(y_pos > 3) y_pos = 0;
  }
  OLED_gotoxy(x_pos, y_pos);
  
  for(s = 0x00; s < 0x06; s++)
  {
    OLED_write(font_regular[chr][s], SSD1306_DAT);
  }
}


void OLED_print_string(unsigned char x_pos, unsigned char y_pos, char *ch)
{
  do
  {
    OLED_print_char(x_pos, y_pos, *ch++);
    x_pos += 0x06;
		if(x_pos > (x_max - 6) && (*ch != '\0'))
    {
      x_pos = 0;
      y_pos++;
      if(y_pos > 3) y_pos = 0;  // 循環顯示
    }
  }while((*ch >= 0x20) && (*ch <= 0x7F) && (*ch != '\n'));
}


void OLED_print_int(unsigned char x_pos, unsigned char y_pos, signed long value)
{
   
    char ch[7] = {0x20, 0x20, 0x20, 0x20, 0x20, 0x20, '\0'}; // 移除 \n
    char *p = &ch[5];
    unsigned long uval;
    
    if(value < 0) {
        ch[0] = 0x2D;
        uval = -value;
    } else {
        ch[0] = 0x20;
        uval = value;
    }
    
    // 統一的數字轉換邏輯
    do {
        *p-- = (uval % 10) + 0x30;
        uval /= 10;
    } while(uval > 0 && p >= &ch[1]);
    
    //OLED_print_string(x_pos, y_pos, ch); //使用一頁
		OLED_print_string_2x(x_pos, y_pos, ch);//使用二頁
}

void Draw_Pixel(unsigned char x_pos, unsigned char y_pos, unsigned char colour)
{
    unsigned char value = 0x00;
    unsigned char page = 0x00;
    unsigned char bit_pos = 0x00;

    // 修正：每頁有8行，所以 page = y_pos / 8
    page = (y_pos >> 3);  // 等同於 y_pos / 8
    bit_pos = (y_pos & 0x07);  // 等同於 y_pos % 8
    
    // 檢查座標範圍
    if(x_pos >= x_max || y_pos >= 32) {  // 32 是總高度
        return;
    }
    
    value = buffer[(page * x_max) + x_pos];
		
    if(colour != 0)  // 直接判斷 colour
    {
        value |= (1 << bit_pos);
    }
    else
    {
        value &= (~(1 << bit_pos));
    }

    buffer[(page * x_max) + x_pos] = value;
    OLED_gotoxy(x_pos, page);
    OLED_write(value, SSD1306_DAT);
}

void OLED_print_2xChar(unsigned char x_pos, unsigned char y_pos, unsigned char ch)
{
		
    unsigned char s = 0x00;
    unsigned char chr = 0x00;
    unsigned char temp = 0x00;
    unsigned char expanded1 = 0x00, expanded2 = 0x00;
    unsigned char expanded3 = 0x00, expanded4 = 0x00;
    unsigned char i = 0x00;
    
    chr = (ch - 0x20);
    
    // 邊界檢查 - 16像素高字體佔 12x16 像素（跨兩頁）
    if(x_pos > (x_max - 12))
    {
        x_pos = 0;
        y_pos += 2;  // 移動兩頁
        if(y_pos > 1) y_pos = 0;  // 最多顯示2行高字體
    }
    
    for(s = 0; s < 6; s++)
    {
        temp = font_regular[chr][s];
        expanded1 = 0x00;
        expanded2 = 0x00;
        expanded3 = 0x00;
        expanded4 = 0x00;
        
        // 創建不同的上下兩部分（不重複）
        for(i = 0; i < 4; i++)  // 只處理前4位用於上半部分
        {
            if(temp & (1 << i))
            {
                expanded1 |= (0x03 << (i * 2));
                expanded2 |= (0x03 << (i * 2));
            }
        }
        
        for(i = 4; i < 8; i++)  // 處理後4位用於下半部分
        {
            if(temp & (1 << i))
            {
                expanded3 |= (0x03 << ((i - 4) * 2));
                expanded4 |= (0x03 << ((i - 4) * 2));
            }
        }
        
        // 上半部分（第一頁）
        OLED_gotoxy(x_pos + (s * 2), y_pos);
        OLED_write(expanded1, SSD1306_DAT);
        OLED_write(expanded2, SSD1306_DAT);
        
        // 下半部分（第二頁）- 不同的數據！
        OLED_gotoxy(x_pos + (s * 2), y_pos + 1);
        OLED_write(expanded3, SSD1306_DAT);
        OLED_write(expanded4, SSD1306_DAT);
    }
}

void OLED_print_string_2x(unsigned char x_pos, unsigned char y_pos, char *ch)
{
    do
    {
        OLED_print_2xChar(x_pos, y_pos, *ch++);
        x_pos += 12;  // 2倍字體寬度
        
        // 換行處理
        if(x_pos > (x_max - 12) && (*ch != '\0'))
        {
            x_pos = 0;
            y_pos++;  // 只移動到下一頁
            if(y_pos > 3) 
            {
                y_pos = 0;
                OLED_clear_screen();
            }
        }
    }while((*ch >= 0x20) && (*ch <= 0x7F));
}

void OLED_clear_value_area(void)
{
    unsigned char x, page;
    
    // 清除第2行和第3行（2倍字體佔用2頁）
    for(page = 2; page < 4; page++)
    {
        OLED_gotoxy(0, page);
        
        I2C_GenerateSTART(ENABLE);
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_MODE_SELECT));
       
        I2C_Send7bitAddress(SSD1306_I2C_Address, I2C_DIRECTION_TX); 
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED));
       
        I2C_SendData(SSD1306_DAT);
        while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTING));    

        for(x = 0; x < x_max; x++)
        {
           I2C_SendData(0x00);
           while(!I2C_CheckEvent(I2C_EVENT_MASTER_BYTE_TRANSMITTED));  
        }
		
        I2C_GenerateSTOP(ENABLE);  
    }
}

//清除矩形區塊
void clear_rect_area(unsigned char x_start, unsigned char y_start, 
                     unsigned char width, unsigned char height)
{
    unsigned char i, j;
    
    for(i = 0; i < width; i++) {
        for(j = 0; j < height; j++) {
            Draw_Pixel(x_start + i, y_start + j, 0);
        }
    }
}

void Low_water(void){
	//clear_rect_area(0, 0, 16, 16);
	OLED_print_Image(water_Full,Display_OFF);	
	delay_ms(100);
}

void Full_Water(void){
	//clear_rect_area(0, 0, 16, 16);
	OLED_print_Image(water_Low,Display_OFF);	
	delay_ms(100);
}


