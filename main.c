#include "STM8S.h"
#include "stdio.h"
#include "SSD1306.h"

unsigned int A0 = 0x0000;
unsigned char buffer[buffer_size];

void clock_setup(void);
void GPIO_setup(void);
void ADC1_setup(void);
uint16_t ADC1_ReadChannel(uint8_t ch);


void main()
{		
	uint16_t adcValue;
  uint32_t voltage_mV;	
	bool state = 0;
	
	clock_setup();
	GPIO_setup();
	ADC1_setup();  	
	OLED_init();
		

	OLED_clear_screen();
	OLED_print_string_2x(20, 0, "Moisture");	
	Moisturn_Full_D1();
	delay_ms(1); //太快會當機，要延遲一下
	while(TRUE)
	{					
		adcValue = ADC1_ReadChannel(ADC1_CHANNEL_4);   //讀 PA3
		voltage_mV = ((uint32_t)adcValue * 3300UL) >> 10;
		if (adcValue > 900)
			{
				state = 1;
			}	else	{
				state = 0;
			}		
		if(state){			
			Low_water();
		}	else {
			Full_Water();
		}
		
		OLED_print_int(0,2,voltage_mV,2);
		OLED_clear_buffer();
		delay_ms(1000);		
	};
		
}

uint16_t result;
uint16_t ADC1_ReadChannel(uint8_t ch)
{
		ADC1_ClearFlag(ADC1_FLAG_EOC);
    ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE, ch, ADC1_ALIGN_RIGHT);
    ADC1_StartConversion();
    while (ADC1_GetFlagStatus(ADC1_FLAG_EOC) == RESET);
		result = ADC1_GetConversionValue();
		return result;
}

void clock_setup(void)
{
	CLK_DeInit();
	
	CLK_HSECmd(DISABLE);
	CLK_LSICmd(DISABLE);
	CLK_HSICmd(ENABLE);
	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
	
	CLK_ClockSwitchCmd(ENABLE);
	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
	
	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, 
	DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
	
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
}

         
void GPIO_setup(void)
{
	GPIO_DeInit(I2C_PORT );
	GPIO_Init(I2C_PORT, SCL_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
	GPIO_Init(I2C_PORT, SDA_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
	
	
	GPIO_DeInit(GPIOD);
	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
}


void ADC1_setup(void)
{
	ADC1_DeInit();	
	
	ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
					  ADC1_CHANNEL_4,
					  ADC1_PRESSEL_FCPU_D18, 
					  ADC1_EXTTRIG_GPIO, 
					  DISABLE, 
					  ADC1_ALIGN_RIGHT, 
					  ADC1_SCHMITTTRIG_ALL, 
					  DISABLE);
					  
	ADC1_Cmd(ENABLE);
}

