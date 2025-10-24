 /*Header file for Arduino like Serial commands on STM8S
 * Website: https://circuitdigest.com/search/node/STM8S
 * Code by: Aswinth Raj
 * Github: https://github.com/CircuitDigest/STM8S103F3_SPL
 */
 
 /*Control on-board LED through USART
 * PD5 - UART1-Tx
 * PD6 - UART1-Rx
 */
 
 #include "stm8s.h"

//Funtion Declarations 
 void Serial_begin(uint32_t); //通過 baug 率並開始串行通信
 void Serial_print_int (int); //傳遞整數值以將其顯示在屏幕上
 void Serial_print_char (char); //傳遞 char 值以列印在螢幕上 
 void Serial_print_string (char[]); //傳遞字串值來列印它
 void Serial_newline(void); //move to next line
 bool Serial_available(void); //check if input serial data available return 1 is yes 
 char Serial_read_char(void); //read the incoming char byte and return it 
 void Serial_SendString(char *str); //ChatGTP 補的  
 void Serial_SendNumber(uint16_t);  //ChatGTP 補的 