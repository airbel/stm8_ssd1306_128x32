   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  14                     	bsct
  15  0000               _A0:
  16  0000 0000          	dc.w	0
 107                     ; 14 void main()
 107                     ; 15 {		
 109                     	switch	.text
 110  0000               _main:
 112  0000 5207          	subw	sp,#7
 113       00000007      OFST:	set	7
 116                     ; 18 	bool state = 0;
 118                     ; 20 	clock_setup();
 120  0002 cd008f        	call	_clock_setup
 122                     ; 21 	GPIO_setup();
 124  0005 cd00f3        	call	_GPIO_setup
 126                     ; 22 	ADC1_setup();  	
 128  0008 cd0121        	call	_ADC1_setup
 130                     ; 23 	OLED_init();
 132  000b cd0000        	call	_OLED_init
 134                     ; 26 	OLED_clear_screen();
 136  000e cd0000        	call	_OLED_clear_screen
 138                     ; 28 	Moisturn_Full_D1();
 140  0011 cd0000        	call	_Moisturn_Full_D1
 142                     ; 29 	delay_ms(1);
 144  0014 ae0001        	ldw	x,#1
 145  0017 cd0000        	call	_delay_ms
 147  001a               L74:
 148                     ; 32 		adcValue = ADC1_ReadChannel(ADC1_CHANNEL_4);   //Ū PA3
 150  001a a604          	ld	a,#4
 151  001c ad4d          	call	_ADC1_ReadChannel
 153  001e 1f05          	ldw	(OFST-2,sp),x
 155                     ; 33 		voltage_mV = ((uint32_t)adcValue * 3300UL) >> 10;
 157  0020 1e05          	ldw	x,(OFST-2,sp)
 158  0022 90ae0ce4      	ldw	y,#3300
 159  0026 cd0000        	call	c_umul
 161  0029 a60a          	ld	a,#10
 162  002b cd0000        	call	c_lursh
 164  002e 96            	ldw	x,sp
 165  002f 1c0001        	addw	x,#OFST-6
 166  0032 cd0000        	call	c_rtol
 169                     ; 34 		if (adcValue > 900)
 171  0035 1e05          	ldw	x,(OFST-2,sp)
 172  0037 a30385        	cpw	x,#901
 173  003a 2506          	jrult	L35
 174                     ; 36 				state = 1;
 176  003c a601          	ld	a,#1
 177  003e 6b07          	ld	(OFST+0,sp),a
 180  0040 2002          	jra	L55
 181  0042               L35:
 182                     ; 38 				state = 0;
 184  0042 0f07          	clr	(OFST+0,sp)
 186  0044               L55:
 187                     ; 40 		if(state){			
 189  0044 0d07          	tnz	(OFST+0,sp)
 190  0046 2705          	jreq	L75
 191                     ; 41 			Low_water();
 193  0048 cd0000        	call	_Low_water
 196  004b 2003          	jra	L16
 197  004d               L75:
 198                     ; 43 			Full_Water();
 200  004d cd0000        	call	_Full_Water
 202  0050               L16:
 203                     ; 46 		OLED_print_int(0,2,voltage_mV,2);
 205  0050 4b02          	push	#2
 206  0052 1e04          	ldw	x,(OFST-3,sp)
 207  0054 89            	pushw	x
 208  0055 1e04          	ldw	x,(OFST-3,sp)
 209  0057 89            	pushw	x
 210  0058 ae0002        	ldw	x,#2
 211  005b cd0000        	call	_OLED_print_int
 213  005e 5b05          	addw	sp,#5
 214                     ; 47 		OLED_clear_buffer();
 216  0060 cd0000        	call	_OLED_clear_buffer
 218                     ; 48 		delay_ms(1000);		
 220  0063 ae03e8        	ldw	x,#1000
 221  0066 cd0000        	call	_delay_ms
 224  0069 20af          	jra	L74
 264                     ; 54 uint16_t ADC1_ReadChannel(uint8_t ch)
 264                     ; 55 {
 265                     	switch	.text
 266  006b               _ADC1_ReadChannel:
 268  006b 88            	push	a
 269       00000000      OFST:	set	0
 272                     ; 56 		ADC1_ClearFlag(ADC1_FLAG_EOC);
 274  006c a680          	ld	a,#128
 275  006e cd0000        	call	_ADC1_ClearFlag
 277                     ; 57     ADC1_ConversionConfig(ADC1_CONVERSIONMODE_SINGLE, ch, ADC1_ALIGN_RIGHT);
 279  0071 4b08          	push	#8
 280  0073 7b02          	ld	a,(OFST+2,sp)
 281  0075 5f            	clrw	x
 282  0076 97            	ld	xl,a
 283  0077 cd0000        	call	_ADC1_ConversionConfig
 285  007a 84            	pop	a
 286                     ; 58     ADC1_StartConversion();
 288  007b cd0000        	call	_ADC1_StartConversion
 291  007e               L301:
 292                     ; 59     while (ADC1_GetFlagStatus(ADC1_FLAG_EOC) == RESET);
 294  007e a680          	ld	a,#128
 295  0080 cd0000        	call	_ADC1_GetFlagStatus
 297  0083 4d            	tnz	a
 298  0084 27f8          	jreq	L301
 299                     ; 60 		result = ADC1_GetConversionValue();
 301  0086 cd0000        	call	_ADC1_GetConversionValue
 303  0089 bf00          	ldw	_result,x
 304                     ; 61 		return result;
 306  008b be00          	ldw	x,_result
 309  008d 84            	pop	a
 310  008e 81            	ret
 343                     ; 64 void clock_setup(void)
 343                     ; 65 {
 344                     	switch	.text
 345  008f               _clock_setup:
 349                     ; 66 	CLK_DeInit();
 351  008f cd0000        	call	_CLK_DeInit
 353                     ; 68 	CLK_HSECmd(DISABLE);
 355  0092 4f            	clr	a
 356  0093 cd0000        	call	_CLK_HSECmd
 358                     ; 69 	CLK_LSICmd(DISABLE);
 360  0096 4f            	clr	a
 361  0097 cd0000        	call	_CLK_LSICmd
 363                     ; 70 	CLK_HSICmd(ENABLE);
 365  009a a601          	ld	a,#1
 366  009c cd0000        	call	_CLK_HSICmd
 369  009f               L121:
 370                     ; 71 	while(CLK_GetFlagStatus(CLK_FLAG_HSIRDY) == FALSE);
 372  009f ae0102        	ldw	x,#258
 373  00a2 cd0000        	call	_CLK_GetFlagStatus
 375  00a5 4d            	tnz	a
 376  00a6 27f7          	jreq	L121
 377                     ; 73 	CLK_ClockSwitchCmd(ENABLE);
 379  00a8 a601          	ld	a,#1
 380  00aa cd0000        	call	_CLK_ClockSwitchCmd
 382                     ; 74 	CLK_HSIPrescalerConfig(CLK_PRESCALER_HSIDIV8);
 384  00ad a618          	ld	a,#24
 385  00af cd0000        	call	_CLK_HSIPrescalerConfig
 387                     ; 75 	CLK_SYSCLKConfig(CLK_PRESCALER_CPUDIV1);
 389  00b2 a680          	ld	a,#128
 390  00b4 cd0000        	call	_CLK_SYSCLKConfig
 392                     ; 77 	CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSI, 
 392                     ; 78 	DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
 394  00b7 4b01          	push	#1
 395  00b9 4b00          	push	#0
 396  00bb ae01e1        	ldw	x,#481
 397  00be cd0000        	call	_CLK_ClockSwitchConfig
 399  00c1 85            	popw	x
 400                     ; 80 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_SPI, DISABLE);
 402  00c2 ae0100        	ldw	x,#256
 403  00c5 cd0000        	call	_CLK_PeripheralClockConfig
 405                     ; 81 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_I2C, ENABLE);
 407  00c8 ae0001        	ldw	x,#1
 408  00cb cd0000        	call	_CLK_PeripheralClockConfig
 410                     ; 82 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
 412  00ce ae1301        	ldw	x,#4865
 413  00d1 cd0000        	call	_CLK_PeripheralClockConfig
 415                     ; 83 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_AWU, DISABLE);
 417  00d4 ae1200        	ldw	x,#4608
 418  00d7 cd0000        	call	_CLK_PeripheralClockConfig
 420                     ; 84 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART1, DISABLE);
 422  00da ae0300        	ldw	x,#768
 423  00dd cd0000        	call	_CLK_PeripheralClockConfig
 425                     ; 85 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER1, DISABLE);
 427  00e0 ae0700        	ldw	x,#1792
 428  00e3 cd0000        	call	_CLK_PeripheralClockConfig
 430                     ; 86 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, DISABLE);
 432  00e6 ae0500        	ldw	x,#1280
 433  00e9 cd0000        	call	_CLK_PeripheralClockConfig
 435                     ; 87 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4, DISABLE);
 437  00ec ae0400        	ldw	x,#1024
 438  00ef cd0000        	call	_CLK_PeripheralClockConfig
 440                     ; 88 }
 443  00f2 81            	ret
 468                     ; 91 void GPIO_setup(void)
 468                     ; 92 {
 469                     	switch	.text
 470  00f3               _GPIO_setup:
 474                     ; 93 	GPIO_DeInit(I2C_PORT );
 476  00f3 ae5005        	ldw	x,#20485
 477  00f6 cd0000        	call	_GPIO_DeInit
 479                     ; 94 	GPIO_Init(I2C_PORT, SCL_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 481  00f9 4bb0          	push	#176
 482  00fb 4b10          	push	#16
 483  00fd ae5005        	ldw	x,#20485
 484  0100 cd0000        	call	_GPIO_Init
 486  0103 85            	popw	x
 487                     ; 95 	GPIO_Init(I2C_PORT, SDA_pin, GPIO_MODE_OUT_OD_HIZ_FAST);
 489  0104 4bb0          	push	#176
 490  0106 4b20          	push	#32
 491  0108 ae5005        	ldw	x,#20485
 492  010b cd0000        	call	_GPIO_Init
 494  010e 85            	popw	x
 495                     ; 98 	GPIO_DeInit(GPIOD);
 497  010f ae500f        	ldw	x,#20495
 498  0112 cd0000        	call	_GPIO_DeInit
 500                     ; 99 	GPIO_Init(GPIOD, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
 502  0115 4b40          	push	#64
 503  0117 4b08          	push	#8
 504  0119 ae500f        	ldw	x,#20495
 505  011c cd0000        	call	_GPIO_Init
 507  011f 85            	popw	x
 508                     ; 100 }
 511  0120 81            	ret
 537                     ; 103 void ADC1_setup(void)
 537                     ; 104 {
 538                     	switch	.text
 539  0121               _ADC1_setup:
 543                     ; 105 	ADC1_DeInit();	
 545  0121 cd0000        	call	_ADC1_DeInit
 547                     ; 107 	ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
 547                     ; 108 					  ADC1_CHANNEL_4,
 547                     ; 109 					  ADC1_PRESSEL_FCPU_D18, 
 547                     ; 110 					  ADC1_EXTTRIG_GPIO, 
 547                     ; 111 					  DISABLE, 
 547                     ; 112 					  ADC1_ALIGN_RIGHT, 
 547                     ; 113 					  ADC1_SCHMITTTRIG_ALL, 
 547                     ; 114 					  DISABLE);
 549  0124 4b00          	push	#0
 550  0126 4bff          	push	#255
 551  0128 4b08          	push	#8
 552  012a 4b00          	push	#0
 553  012c 4b10          	push	#16
 554  012e 4b70          	push	#112
 555  0130 ae0104        	ldw	x,#260
 556  0133 cd0000        	call	_ADC1_Init
 558  0136 5b06          	addw	sp,#6
 559                     ; 116 	ADC1_Cmd(ENABLE);
 561  0138 a601          	ld	a,#1
 562  013a cd0000        	call	_ADC1_Cmd
 564                     ; 117 }
 567  013d 81            	ret
 610                     	switch	.ubsct
 611  0000               _result:
 612  0000 0000          	ds.b	2
 613                     	xdef	_result
 614                     	xdef	_main
 615                     	xdef	_ADC1_ReadChannel
 616                     	xdef	_ADC1_setup
 617                     	xdef	_GPIO_setup
 618                     	xdef	_clock_setup
 619                     	xdef	_A0
 620                     	xref	_Moisturn_Full_D1
 621                     	xref	_Full_Water
 622                     	xref	_Low_water
 623                     	xref	_OLED_print_int
 624                     	xref	_OLED_clear_buffer
 625                     	xref	_OLED_clear_screen
 626                     	xref	_OLED_init
 627  0002               _buffer:
 628  0002 000000000000  	ds.b	128
 629                     	xdef	_buffer
 630                     	xref	_GPIO_Init
 631                     	xref	_GPIO_DeInit
 632                     	xref	_CLK_GetFlagStatus
 633                     	xref	_CLK_SYSCLKConfig
 634                     	xref	_CLK_HSIPrescalerConfig
 635                     	xref	_CLK_ClockSwitchConfig
 636                     	xref	_CLK_PeripheralClockConfig
 637                     	xref	_CLK_ClockSwitchCmd
 638                     	xref	_CLK_LSICmd
 639                     	xref	_CLK_HSICmd
 640                     	xref	_CLK_HSECmd
 641                     	xref	_CLK_DeInit
 642                     	xref	_ADC1_ClearFlag
 643                     	xref	_ADC1_GetFlagStatus
 644                     	xref	_ADC1_GetConversionValue
 645                     	xref	_ADC1_StartConversion
 646                     	xref	_ADC1_ConversionConfig
 647                     	xref	_ADC1_Cmd
 648                     	xref	_ADC1_Init
 649                     	xref	_ADC1_DeInit
 650                     	xref	_delay_ms
 651                     	xref.b	c_x
 652                     	xref.b	c_y
 672                     	xref	c_rtol
 673                     	xref	c_lursh
 674                     	xref	c_umul
 675                     	end
