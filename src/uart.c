#include "uart.h"
#include <stdarg.h>
#include <stdio.h>

 char Serial_read_char(void)
 {
	 while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
	 UART1_ClearFlag(UART1_FLAG_RXNE);
	 return (UART1_ReceiveData8());
 }

 void Serial_print_char (char value)
 {
	 UART1_SendData8(value);
	 while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending
 }
 
  void Serial_begin(uint32_t baud_rate)
 {
	 GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
	 GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_PU_NO_IT);
	 
	 UART1_DeInit(); //Deinitialize UART peripherals 
			
                
		UART1_Init(baud_rate, 
                UART1_WORDLENGTH_8D, 
                UART1_STOPBITS_1, 
                UART1_PARITY_NO, 
                UART1_SYNCMODE_CLOCK_DISABLE, 
                UART1_MODE_TXRX_ENABLE); //(BaudRate, Wordlegth, StopBits, Parity, SyncMode, Mode)
                
		UART1_Cmd(ENABLE);
 }
 
 void Serial_print_int (int number) //Funtion to print int value to serial monitor 
 {
	 char count = 0;
	 char digit[5] = "";
	 
	 if (number == 0)  //ChatGTP 幫忙補的
	 { 
        UART1_SendData8('0');
        while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
        return;
    }
    
	 
	 while (number != 0) //split the int to char array 
	 {
		 digit[count] = number%10;
		 count++;
		 number = number/10;
	 }
	 
	 while (count !=0) //print char array in correct direction 
	 {
		UART1_SendData8(digit[count-1] + 0x30);
		while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending 
		count--; 
	 }
 }
 
 
 void Serial_SendNumber(uint16_t num) {
    char buffer[6];
    uint8_t i = 0;
    
    if (num == 0) {
        UART1_SendData8('0');
        return;
    }
    
    // 轉換數字
    while (num > 0) {
        buffer[i++] = '0' + (num % 10);
        num /= 10;
    }
    
    // 反向發送
    while (i > 0) {
        UART1_SendData8(buffer[--i]);
        while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
    }
}
 
 void Serial_newline(void)
 {
	 UART1_SendData8(0x0a);
	while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending 
 }
 
 void Serial_print_string (char string[])
 {

	 char i=0;

	 while (string[i] != 0x00)
	 {
		UART1_SendData8(string[i]);
		while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
		i++;
	}
 }
 
 bool Serial_available()
 {
	 if(UART1_GetFlagStatus(UART1_FLAG_RXNE) == TRUE)
	 return 1;
	 else
	 return 0;
 }

void Serial_SendString(char *str)
{
    while (*str)
    {
        UART1_SendData8(*str++);
        while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
    }
}