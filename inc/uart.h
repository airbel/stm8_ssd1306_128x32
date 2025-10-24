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
 void Serial_begin(uint32_t); //�q�L baug �v�ö}�l���q�H
 void Serial_print_int (int); //�ǻ���ƭȥH�N����ܦb�̹��W
 void Serial_print_char (char); //�ǻ� char �ȥH�C�L�b�ù��W 
 void Serial_print_string (char[]); //�ǻ��r��ȨӦC�L��
 void Serial_newline(void); //move to next line
 bool Serial_available(void); //check if input serial data available return 1 is yes 
 char Serial_read_char(void); //read the incoming char byte and return it 
 void Serial_SendString(char *str); //ChatGTP �ɪ�  
 void Serial_SendNumber(uint16_t);  //ChatGTP �ɪ� 