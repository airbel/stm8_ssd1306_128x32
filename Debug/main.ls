   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  14                     	bsct
  15  0000               _A0:
  16  0000 0000          	dc.w	0
  76                     ; 13 void main()
  76                     ; 14 {		
  78                     	switch	.text
  79  0000               _main:
  81  0000 5206          	subw	sp,#6
  82       00000006      OFST:	set	6
  85                     ; 18 	clock_setup();
  87  0002 ad65          	call	_clock_setup
  89                     ; 19 	GPIO_setup();
  91  0004 cd00cd        	call	_GPIO_setup
  93                     ; 20 	ADC1_setup();  	
  95  0007 cd00fb        	call	_ADC1_setup
  97                     ; 21 	OLED_init();
  99  000a cd0000        	call	_OLED_init
 101                     ; 23 	OLED_clear_screen();
 103  000d cd0000        	call	_OLED_clear_screen
 105                     ; 24 	OLED_print_string_2x_correct(0, 0, "Moisture");
 107  0010 ae0000        	ldw	x,#L33
 108  0013 89            	pushw	x
 109  0014 5f            	clrw	x
 110  0015 cd0000        	call	_OLED_print_string_2x_correct
 112  0018 85            	popw	x
 113  0019               L53:
 114                     ; 28 		OLED_clear_value_area(); 
 116  0019 cd0000        	call	_OLED_clear_value_area
 118                     ; 29 		adcValue = ADC1_ReadChannel(ADC1_CHANNEL_4);   //Ū PA3
 120  001c a604          	ld	a,#4
 121  001e ad25          	call	_ADC1_ReadChannel
 123  0020 1f05          	ldw	(OFST-1,sp),x
 125                     ; 30 		voltage_mV = ((uint32_t)adcValue * 3300UL) >> 10;
 127  0022 1e05          	ldw	x,(OFST-1,sp)
 128  0024 90ae0ce4      	ldw	y,#3300
 129  0028 cd0000        	call	c_umul
 131  002b a60a          	ld	a,#10
 132  002d cd0000        	call	c_lursh
 134                     ; 31 		OLED_print_uint16_2x(0,2,adcValue);
 136  0030 1e05          	ldw	x,(OFST-1,sp)
 137  0032 89            	pushw	x
 138  0033 ae0002        	ldw	x,#2
 139  0036 cd0000        	call	_OLED_print_uint16_2x
 141  0039 85            	popw	x
 142                     ; 32 		OLED_clear_buffer();
 144  003a cd0000        	call	_OLED_clear_buffer
 146                     ; 33 		delay_ms(1000);		
 148  003d ae03e8        	ldw	x,#1000
 149  0040 cd0000        	call	_delay_ms
 152  0043 20d4          	jra	L53
 192                     ; 39 uint16_t ADC1_ReadChannel(uint8_t ch)
 192                     ; 40 {
 193                     	switch	.text
 194  0045               _ADC1_ReadChannel:
 196  0045 88            	push	a
 197       00000000      OFST:	set	0
 200                     ; 41 		ADC1_ClearFlag(ADC1_FLAG_EOC);
 202  0046 a680          	ld	a,#128
 203  0048 cd0000        	call	_ADC1_ClearFlag
 205                     ; 42     ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE, ch, ADC1_ALIGN_RIGHT);
 207  004b 4b08          	push	#8
 208  004d 7b02          	ld	a,(OFST+2,sp)
 209  004f 5f            	clrw	x
 210  0050 97            	ld	xl,a
 211  0051 cd0000        	call	_ADC1_ConversionConfig
 213  0054 84            	pop	a
 214                     ; 43     ADC1_StartConversion();
 216  0055 cd0000        	call	_ADC1_StartConversion
 219  0058               L16:
 220                     ; 44     while (ADC1_GetFlagStatus(ADC1_FLAG_EOC) == RESET);
 222  0058 a680          	ld	a,#128
 223  005a cd0000        	call	_ADC1_GetFlagStatus
 225  005d 4d            	tnz	a
 226  005e 27f8          	jreq	L16
 227                     ; 45 		result = ADC1_GetConversionValue();
 229  0060 cd0000        	call	_ADC1_GetConversionValue
 231  0063 bf00          	ldw	_result,x
 232                     ; 46 		return result;
 234  0065 be00          	ldw	x,_result
 237  0067 84            	pop	a
 238  0068 81            	ret
 271                     ; 49 void clock_setup(void)
 271                     ; 50 {
 272                     	switch	.text
 273  0069               _clock_setup:
 277                     ; 51 	CLK_DeInit();
 279  0069 cd0000        	call	_CLK_DeInit
 281                     ; 53 	CLK_HSECmd(DISABLE);
 283  006c 4f            	clr	a
 284  006d cd0000        	call	_CLK_HSECmd
 286                     ; 54 	CLK_LSICmd(DISABLE);
 288  0070 4f            	clr	a
 289  0071 cd0000        	call	_CLK_LSICmd
 291                     ; 55 	CLK_HSICmd(ENABLE);
 293  0074 a601          	ld	a,#1
 294  0076 cd0000        	call	_CLK_HSICmd
 297  0079               L77:
 298                     ; 56 	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
 300  0079 ae0102        	ldw	x,#258
 301  007c cd0000        	call	_CLK_GetFlagStatus
 303  007f 4d            	tnz	a
 304  0080 27f7          	jreq	L77
 305                     ; 58 	CLK_ClockSwitchCmd(ENABLE);
 307  0082 a601          	ld	a,#1
 308  0084 cd0000        	call	_CLK_ClockSwitchCmd
 310                     ; 59 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
 312  0087 a618          	ld	a,#24
 313  0089 cd0000        	call	_CLK_HSIPrescalerConfig
 315                     ; 60 	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
 317  008c a680          	ld	a,#128
 318  008e cd0000        	call	_CLK_SYSCLKConfig
 320                     ; 62 	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, 
 320                     ; 63 	DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
 322  0091 4b01          	push	#1
 323  0093 4b00          	push	#0
 324  0095 ae01e1        	ldw	x,#481
 325  0098 cd0000        	call	_CLK_ClockSwitchConfig
 327  009b 85            	popw	x
 328                     ; 65 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
 330  009c ae0100        	ldw	x,#256
 331  009f cd0000        	call	_CLK_PeripheralClockConfig
 333                     ; 66 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
 335  00a2 ae0001        	ldw	x,#1
 336  00a5 cd0000        	call	_CLK_PeripheralClockConfig
 338                     ; 67 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
 340  00a8 ae1301        	ldw	x,#4865
 341  00ab cd0000        	call	_CLK_PeripheralClockConfig
 343                     ; 68 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
 345  00ae ae1200        	ldw	x,#4608
 346  00b1 cd0000        	call	_CLK_PeripheralClockConfig
 348                     ; 69 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
 350  00b4 ae0300        	ldw	x,#768
 351  00b7 cd0000        	call	_CLK_PeripheralClockConfig
 353                     ; 70 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 355  00ba ae0700        	ldw	x,#1792
 356  00bd cd0000        	call	_CLK_PeripheralClockConfig
 358                     ; 71 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 360  00c0 ae0500        	ldw	x,#1280
 361  00c3 cd0000        	call	_CLK_PeripheralClockConfig
 363                     ; 72 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
 365  00c6 ae0400        	ldw	x,#1024
 366  00c9 cd0000        	call	_CLK_PeripheralClockConfig
 368                     ; 73 }
 371  00cc 81            	ret
 396                     ; 76 void GPIO_setup(void)
 396                     ; 77 {
 397                     	switch	.text
 398  00cd               _GPIO_setup:
 402                     ; 78 	GPIO_DeInit(I2C_PORT );
 404  00cd ae5005        	ldw	x,#20485
 405  00d0 cd0000        	call	_GPIO_DeInit
 407                     ; 79 	GPIO_Init(I2C_PORT, SCL_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 409  00d3 4bb0          	push	#176
 410  00d5 4b10          	push	#16
 411  00d7 ae5005        	ldw	x,#20485
 412  00da cd0000        	call	_GPIO_Init
 414  00dd 85            	popw	x
 415                     ; 80 	GPIO_Init(I2C_PORT, SDA_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 417  00de 4bb0          	push	#176
 418  00e0 4b20          	push	#32
 419  00e2 ae5005        	ldw	x,#20485
 420  00e5 cd0000        	call	_GPIO_Init
 422  00e8 85            	popw	x
 423                     ; 83 	GPIO_DeInit(GPIOD);
 425  00e9 ae500f        	ldw	x,#20495
 426  00ec cd0000        	call	_GPIO_DeInit
 428                     ; 84 	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
 430  00ef 4b40          	push	#64
 431  00f1 4b08          	push	#8
 432  00f3 ae500f        	ldw	x,#20495
 433  00f6 cd0000        	call	_GPIO_Init
 435  00f9 85            	popw	x
 436                     ; 85 }
 439  00fa 81            	ret
 465                     ; 88 void ADC1_setup(void)
 465                     ; 89 {
 466                     	switch	.text
 467  00fb               _ADC1_setup:
 471                     ; 90 	ADC1_DeInit();	
 473  00fb cd0000        	call	_ADC1_DeInit
 475                     ; 92 	ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
 475                     ; 93 					  ADC1_CHANNEL_4,
 475                     ; 94 					  ADC1_PRESSEL_FCPU_D18, 
 475                     ; 95 					  ADC1_EXTTRIG_GPIO, 
 475                     ; 96 					  DISABLE, 
 475                     ; 97 					  ADC1_ALIGN_RIGHT, 
 475                     ; 98 					  ADC1_SCHMITTTRIG_ALL, 
 475                     ; 99 					  DISABLE);
 477  00fe 4b00          	push	#0
 478  0100 4bff          	push	#255
 479  0102 4b08          	push	#8
 480  0104 4b00          	push	#0
 481  0106 4b10          	push	#16
 482  0108 4b70          	push	#112
 483  010a ae0104        	ldw	x,#260
 484  010d cd0000        	call	_ADC1_Init
 486  0110 5b06          	addw	sp,#6
 487                     ; 101 	ADC1_Cmd(ENABLE);
 489  0112 a601          	ld	a,#1
 490  0114 cd0000        	call	_ADC1_Cmd
 492                     ; 102 }
 495  0117 81            	ret
 538                     	switch	.ubsct
 539  0000               _result:
 540  0000 0000          	ds.b	2
 541                     	xdef	_result
 542                     	xdef	_main
 543                     	xdef	_ADC1_ReadChannel
 544                     	xdef	_ADC1_setup
 545                     	xdef	_GPIO_setup
 546                     	xdef	_clock_setup
 547                     	xdef	_A0
 548                     	xref	_OLED_clear_value_area
 549                     	xref	_OLED_print_uint16_2x
 550                     	xref	_OLED_print_string_2x_correct
 551                     	xref	_OLED_clear_buffer
 552                     	xref	_OLED_clear_screen
 553                     	xref	_OLED_init
 554  0002               _buffer:
 555  0002 000000000000  	ds.b	32
 556                     	xdef	_buffer
 557                     	xref	_GPIO_Init
 558                     	xref	_GPIO_DeInit
 559                     	xref	_CLK_GetFlagStatus
 560                     	xref	_CLK_SYSCLKConfig
 561                     	xref	_CLK_HSIPrescalerConfig
 562                     	xref	_CLK_ClockSwitchConfig
 563                     	xref	_CLK_PeripheralClockConfig
 564                     	xref	_CLK_ClockSwitchCmd
 565                     	xref	_CLK_LSICmd
 566                     	xref	_CLK_HSICmd
 567                     	xref	_CLK_HSECmd
 568                     	xref	_CLK_DeInit
 569                     	xref	_ADC1_ClearFlag
 570                     	xref	_ADC1_GetFlagStatus
 571                     	xref	_ADC1_GetConversionValue
 572                     	xref	_ADC1_StartConversion
 573                     	xref	_ADC1_ConversionConfig
 574                     	xref	_ADC1_Cmd
 575                     	xref	_ADC1_Init
 576                     	xref	_ADC1_DeInit
 577                     	xref	_delay_ms
 578                     .const:	section	.text
 579  0000               L33:
 580  0000 4d6f69737475  	dc.b	"Moisture",0
 581                     	xref.b	c_x
 582                     	xref.b	c_y
 602                     	xref	c_lursh
 603                     	xref	c_umul
 604                     	end
