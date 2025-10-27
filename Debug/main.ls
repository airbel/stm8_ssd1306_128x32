   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  14                     	bsct
  15  0000               _A0:
  16  0000 0000          	dc.w	0
 108                     ; 14 void main()
 108                     ; 15 {		
 110                     	switch	.text
 111  0000               _main:
 113  0000 5207          	subw	sp,#7
 114       00000007      OFST:	set	7
 117                     ; 18 	bool state = 0;
 119                     ; 20 	clock_setup();
 121  0002 cd0092        	call	_clock_setup
 123                     ; 21 	GPIO_setup();
 125  0005 cd00f6        	call	_GPIO_setup
 127                     ; 22 	ADC1_setup();  	
 129  0008 cd0124        	call	_ADC1_setup
 131                     ; 23 	OLED_init();
 133  000b cd0000        	call	_OLED_init
 135                     ; 26 	OLED_clear_screen();
 137  000e cd0000        	call	_OLED_clear_screen
 139                     ; 27 	OLED_print_string_2x(20, 0, "Moisture");	
 141  0011 ae0000        	ldw	x,#L74
 142  0014 89            	pushw	x
 143  0015 ae1400        	ldw	x,#5120
 144  0018 cd0000        	call	_OLED_print_string_2x
 146  001b 85            	popw	x
 147  001c               L15:
 148                     ; 31 		adcValue = ADC1_ReadChannel(ADC1_CHANNEL_4);   //Ū PA3
 150  001c a604          	ld	a,#4
 151  001e ad4e          	call	_ADC1_ReadChannel
 153  0020 1f05          	ldw	(OFST-2,sp),x
 155                     ; 32 		voltage_mV = ((uint32_t)adcValue * 3300UL) >> 10;
 157  0022 1e05          	ldw	x,(OFST-2,sp)
 158  0024 90ae0ce4      	ldw	y,#3300
 159  0028 cd0000        	call	c_umul
 161  002b a60a          	ld	a,#10
 162  002d cd0000        	call	c_lursh
 164  0030 96            	ldw	x,sp
 165  0031 1c0001        	addw	x,#OFST-6
 166  0034 cd0000        	call	c_rtol
 169                     ; 33 		if (adcValue > 900)
 171  0037 1e05          	ldw	x,(OFST-2,sp)
 172  0039 a30385        	cpw	x,#901
 173  003c 2506          	jrult	L55
 174                     ; 35 				state = 1;
 176  003e a601          	ld	a,#1
 177  0040 6b07          	ld	(OFST+0,sp),a
 180  0042 2002          	jra	L75
 181  0044               L55:
 182                     ; 37 				state = 0;
 184  0044 0f07          	clr	(OFST+0,sp)
 186  0046               L75:
 187                     ; 39 		OLED_clear_value_area();
 189  0046 cd0000        	call	_OLED_clear_value_area
 191                     ; 40 		if(state){			
 193  0049 0d07          	tnz	(OFST+0,sp)
 194  004b 2705          	jreq	L16
 195                     ; 41 			Low_water();
 197  004d cd0000        	call	_Low_water
 200  0050 2003          	jra	L36
 201  0052               L16:
 202                     ; 43 			Full_Water();
 204  0052 cd0000        	call	_Full_Water
 206  0055               L36:
 207                     ; 46 		OLED_print_int(0,2,voltage_mV);
 209  0055 1e03          	ldw	x,(OFST-4,sp)
 210  0057 89            	pushw	x
 211  0058 1e03          	ldw	x,(OFST-4,sp)
 212  005a 89            	pushw	x
 213  005b ae0002        	ldw	x,#2
 214  005e cd0000        	call	_OLED_print_int
 216  0061 5b04          	addw	sp,#4
 217                     ; 49 		OLED_clear_buffer();
 219  0063 cd0000        	call	_OLED_clear_buffer
 221                     ; 50 		delay_ms(1000);		
 223  0066 ae03e8        	ldw	x,#1000
 224  0069 cd0000        	call	_delay_ms
 227  006c 20ae          	jra	L15
 267                     ; 56 uint16_t ADC1_ReadChannel(uint8_t ch)
 267                     ; 57 {
 268                     	switch	.text
 269  006e               _ADC1_ReadChannel:
 271  006e 88            	push	a
 272       00000000      OFST:	set	0
 275                     ; 58 		ADC1_ClearFlag(ADC1_FLAG_EOC);
 277  006f a680          	ld	a,#128
 278  0071 cd0000        	call	_ADC1_ClearFlag
 280                     ; 59     ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE, ch, ADC1_ALIGN_RIGHT);
 282  0074 4b08          	push	#8
 283  0076 7b02          	ld	a,(OFST+2,sp)
 284  0078 5f            	clrw	x
 285  0079 97            	ld	xl,a
 286  007a cd0000        	call	_ADC1_ConversionConfig
 288  007d 84            	pop	a
 289                     ; 60     ADC1_StartConversion();
 291  007e cd0000        	call	_ADC1_StartConversion
 294  0081               L501:
 295                     ; 61     while (ADC1_GetFlagStatus(ADC1_FLAG_EOC) == RESET);
 297  0081 a680          	ld	a,#128
 298  0083 cd0000        	call	_ADC1_GetFlagStatus
 300  0086 4d            	tnz	a
 301  0087 27f8          	jreq	L501
 302                     ; 62 		result = ADC1_GetConversionValue();
 304  0089 cd0000        	call	_ADC1_GetConversionValue
 306  008c bf00          	ldw	_result,x
 307                     ; 63 		return result;
 309  008e be00          	ldw	x,_result
 312  0090 84            	pop	a
 313  0091 81            	ret
 346                     ; 66 void clock_setup(void)
 346                     ; 67 {
 347                     	switch	.text
 348  0092               _clock_setup:
 352                     ; 68 	CLK_DeInit();
 354  0092 cd0000        	call	_CLK_DeInit
 356                     ; 70 	CLK_HSECmd(DISABLE);
 358  0095 4f            	clr	a
 359  0096 cd0000        	call	_CLK_HSECmd
 361                     ; 71 	CLK_LSICmd(DISABLE);
 363  0099 4f            	clr	a
 364  009a cd0000        	call	_CLK_LSICmd
 366                     ; 72 	CLK_HSICmd(ENABLE);
 368  009d a601          	ld	a,#1
 369  009f cd0000        	call	_CLK_HSICmd
 372  00a2               L321:
 373                     ; 73 	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
 375  00a2 ae0102        	ldw	x,#258
 376  00a5 cd0000        	call	_CLK_GetFlagStatus
 378  00a8 4d            	tnz	a
 379  00a9 27f7          	jreq	L321
 380                     ; 75 	CLK_ClockSwitchCmd(ENABLE);
 382  00ab a601          	ld	a,#1
 383  00ad cd0000        	call	_CLK_ClockSwitchCmd
 385                     ; 76 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
 387  00b0 a618          	ld	a,#24
 388  00b2 cd0000        	call	_CLK_HSIPrescalerConfig
 390                     ; 77 	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
 392  00b5 a680          	ld	a,#128
 393  00b7 cd0000        	call	_CLK_SYSCLKConfig
 395                     ; 79 	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, 
 395                     ; 80 	DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
 397  00ba 4b01          	push	#1
 398  00bc 4b00          	push	#0
 399  00be ae01e1        	ldw	x,#481
 400  00c1 cd0000        	call	_CLK_ClockSwitchConfig
 402  00c4 85            	popw	x
 403                     ; 82 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
 405  00c5 ae0100        	ldw	x,#256
 406  00c8 cd0000        	call	_CLK_PeripheralClockConfig
 408                     ; 83 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
 410  00cb ae0001        	ldw	x,#1
 411  00ce cd0000        	call	_CLK_PeripheralClockConfig
 413                     ; 84 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
 415  00d1 ae1301        	ldw	x,#4865
 416  00d4 cd0000        	call	_CLK_PeripheralClockConfig
 418                     ; 85 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
 420  00d7 ae1200        	ldw	x,#4608
 421  00da cd0000        	call	_CLK_PeripheralClockConfig
 423                     ; 86 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
 425  00dd ae0300        	ldw	x,#768
 426  00e0 cd0000        	call	_CLK_PeripheralClockConfig
 428                     ; 87 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 430  00e3 ae0700        	ldw	x,#1792
 431  00e6 cd0000        	call	_CLK_PeripheralClockConfig
 433                     ; 88 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 435  00e9 ae0500        	ldw	x,#1280
 436  00ec cd0000        	call	_CLK_PeripheralClockConfig
 438                     ; 89 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
 440  00ef ae0400        	ldw	x,#1024
 441  00f2 cd0000        	call	_CLK_PeripheralClockConfig
 443                     ; 90 }
 446  00f5 81            	ret
 471                     ; 93 void GPIO_setup(void)
 471                     ; 94 {
 472                     	switch	.text
 473  00f6               _GPIO_setup:
 477                     ; 95 	GPIO_DeInit(I2C_PORT );
 479  00f6 ae5005        	ldw	x,#20485
 480  00f9 cd0000        	call	_GPIO_DeInit
 482                     ; 96 	GPIO_Init(I2C_PORT, SCL_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 484  00fc 4bb0          	push	#176
 485  00fe 4b10          	push	#16
 486  0100 ae5005        	ldw	x,#20485
 487  0103 cd0000        	call	_GPIO_Init
 489  0106 85            	popw	x
 490                     ; 97 	GPIO_Init(I2C_PORT, SDA_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 492  0107 4bb0          	push	#176
 493  0109 4b20          	push	#32
 494  010b ae5005        	ldw	x,#20485
 495  010e cd0000        	call	_GPIO_Init
 497  0111 85            	popw	x
 498                     ; 100 	GPIO_DeInit(GPIOD);
 500  0112 ae500f        	ldw	x,#20495
 501  0115 cd0000        	call	_GPIO_DeInit
 503                     ; 101 	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
 505  0118 4b40          	push	#64
 506  011a 4b08          	push	#8
 507  011c ae500f        	ldw	x,#20495
 508  011f cd0000        	call	_GPIO_Init
 510  0122 85            	popw	x
 511                     ; 102 }
 514  0123 81            	ret
 540                     ; 105 void ADC1_setup(void)
 540                     ; 106 {
 541                     	switch	.text
 542  0124               _ADC1_setup:
 546                     ; 107 	ADC1_DeInit();	
 548  0124 cd0000        	call	_ADC1_DeInit
 550                     ; 109 	ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
 550                     ; 110 					  ADC1_CHANNEL_4,
 550                     ; 111 					  ADC1_PRESSEL_FCPU_D18, 
 550                     ; 112 					  ADC1_EXTTRIG_GPIO, 
 550                     ; 113 					  DISABLE, 
 550                     ; 114 					  ADC1_ALIGN_RIGHT, 
 550                     ; 115 					  ADC1_SCHMITTTRIG_ALL, 
 550                     ; 116 					  DISABLE);
 552  0127 4b00          	push	#0
 553  0129 4bff          	push	#255
 554  012b 4b08          	push	#8
 555  012d 4b00          	push	#0
 556  012f 4b10          	push	#16
 557  0131 4b70          	push	#112
 558  0133 ae0104        	ldw	x,#260
 559  0136 cd0000        	call	_ADC1_Init
 561  0139 5b06          	addw	sp,#6
 562                     ; 118 	ADC1_Cmd(ENABLE);
 564  013b a601          	ld	a,#1
 565  013d cd0000        	call	_ADC1_Cmd
 567                     ; 119 }
 570  0140 81            	ret
 613                     	switch	.ubsct
 614  0000               _result:
 615  0000 0000          	ds.b	2
 616                     	xdef	_result
 617                     	xdef	_main
 618                     	xdef	_ADC1_ReadChannel
 619                     	xdef	_ADC1_setup
 620                     	xdef	_GPIO_setup
 621                     	xdef	_clock_setup
 622                     	xdef	_A0
 623                     	xref	_Full_Water
 624                     	xref	_Low_water
 625                     	xref	_OLED_clear_value_area
 626                     	xref	_OLED_print_string_2x
 627                     	xref	_OLED_print_int
 628                     	xref	_OLED_clear_buffer
 629                     	xref	_OLED_clear_screen
 630                     	xref	_OLED_init
 631  0002               _buffer:
 632  0002 000000000000  	ds.b	128
 633                     	xdef	_buffer
 634                     	xref	_GPIO_Init
 635                     	xref	_GPIO_DeInit
 636                     	xref	_CLK_GetFlagStatus
 637                     	xref	_CLK_SYSCLKConfig
 638                     	xref	_CLK_HSIPrescalerConfig
 639                     	xref	_CLK_ClockSwitchConfig
 640                     	xref	_CLK_PeripheralClockConfig
 641                     	xref	_CLK_ClockSwitchCmd
 642                     	xref	_CLK_LSICmd
 643                     	xref	_CLK_HSICmd
 644                     	xref	_CLK_HSECmd
 645                     	xref	_CLK_DeInit
 646                     	xref	_ADC1_ClearFlag
 647                     	xref	_ADC1_GetFlagStatus
 648                     	xref	_ADC1_GetConversionValue
 649                     	xref	_ADC1_StartConversion
 650                     	xref	_ADC1_ConversionConfig
 651                     	xref	_ADC1_Cmd
 652                     	xref	_ADC1_Init
 653                     	xref	_ADC1_DeInit
 654                     	xref	_delay_ms
 655                     .const:	section	.text
 656  0000               L74:
 657  0000 4d6f69737475  	dc.b	"Moisture",0
 658                     	xref.b	c_x
 659                     	xref.b	c_y
 679                     	xref	c_rtol
 680                     	xref	c_lursh
 681                     	xref	c_umul
 682                     	end
