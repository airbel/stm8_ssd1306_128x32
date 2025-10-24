   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.12.6 - 16 Dec 2021
   3                     ; Generator (Limited) V4.5.4 - 16 Dec 2021
  45                     ; 5  char Serial_read_char(void)
  45                     ; 6  {
  47                     	switch	.text
  48  0000               _Serial_read_char:
  52  0000               L32:
  53                     ; 7 	 while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
  55  0000 ae0080        	ldw	x,#128
  56  0003 cd0000        	call	_UART1_GetFlagStatus
  58  0006 4d            	tnz	a
  59  0007 27f7          	jreq	L32
  60                     ; 8 	 UART1_ClearFlag(UART1_FLAG_RXNE);
  62  0009 ae0020        	ldw	x,#32
  63  000c cd0000        	call	_UART1_ClearFlag
  65                     ; 9 	 return (UART1_ReceiveData8());
  67  000f cd0000        	call	_UART1_ReceiveData8
  71  0012 81            	ret
 107                     ; 12  void Serial_print_char (char value)
 107                     ; 13  {
 108                     	switch	.text
 109  0013               _Serial_print_char:
 113                     ; 14 	 UART1_SendData8(value);
 115  0013 cd0000        	call	_UART1_SendData8
 118  0016               L74:
 119                     ; 15 	 while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending
 121  0016 ae0080        	ldw	x,#128
 122  0019 cd0000        	call	_UART1_GetFlagStatus
 124  001c 4d            	tnz	a
 125  001d 27f7          	jreq	L74
 126                     ; 16  }
 129  001f 81            	ret
 167                     ; 18   void Serial_begin(uint32_t baud_rate)
 167                     ; 19  {
 168                     	switch	.text
 169  0020               _Serial_begin:
 171       00000000      OFST:	set	0
 174                     ; 20 	 GPIO_Init(GPIOD, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_FAST);
 176  0020 4bf0          	push	#240
 177  0022 4b20          	push	#32
 178  0024 ae500f        	ldw	x,#20495
 179  0027 cd0000        	call	_GPIO_Init
 181  002a 85            	popw	x
 182                     ; 21 	 GPIO_Init(GPIOD, GPIO_PIN_6, GPIO_MODE_IN_PU_NO_IT);
 184  002b 4b40          	push	#64
 185  002d 4b40          	push	#64
 186  002f ae500f        	ldw	x,#20495
 187  0032 cd0000        	call	_GPIO_Init
 189  0035 85            	popw	x
 190                     ; 23 	 UART1_DeInit(); //Deinitialize UART peripherals 
 192  0036 cd0000        	call	_UART1_DeInit
 194                     ; 26 		UART1_Init(baud_rate, 
 194                     ; 27                 UART1_WORDLENGTH_8D, 
 194                     ; 28                 UART1_STOPBITS_1, 
 194                     ; 29                 UART1_PARITY_NO, 
 194                     ; 30                 UART1_SYNCMODE_CLOCK_DISABLE, 
 194                     ; 31                 UART1_MODE_TXRX_ENABLE); //(BaudRate, Wordlegth, StopBits, Parity, SyncMode, Mode)
 196  0039 4b0c          	push	#12
 197  003b 4b80          	push	#128
 198  003d 4b00          	push	#0
 199  003f 4b00          	push	#0
 200  0041 4b00          	push	#0
 201  0043 1e0a          	ldw	x,(OFST+10,sp)
 202  0045 89            	pushw	x
 203  0046 1e0a          	ldw	x,(OFST+10,sp)
 204  0048 89            	pushw	x
 205  0049 cd0000        	call	_UART1_Init
 207  004c 5b09          	addw	sp,#9
 208                     ; 33 		UART1_Cmd(ENABLE);
 210  004e a601          	ld	a,#1
 211  0050 cd0000        	call	_UART1_Cmd
 213                     ; 34  }
 216  0053 81            	ret
 219                     .const:	section	.text
 220  0000               L17_digit:
 221  0000 00            	dc.b	0
 222  0001 00000000      	ds.b	4
 275                     ; 36  void Serial_print_int (int number) //Funtion to print int value to serial monitor 
 275                     ; 37  {
 276                     	switch	.text
 277  0054               _Serial_print_int:
 279  0054 89            	pushw	x
 280  0055 5208          	subw	sp,#8
 281       00000008      OFST:	set	8
 284                     ; 38 	 char count = 0;
 286  0057 0f08          	clr	(OFST+0,sp)
 288                     ; 39 	 char digit[5] = "";
 290  0059 96            	ldw	x,sp
 291  005a 1c0003        	addw	x,#OFST-5
 292  005d 90ae0000      	ldw	y,#L17_digit
 293  0061 a605          	ld	a,#5
 294  0063 cd0000        	call	c_xymov
 296                     ; 41 	 if (number == 0)  //ChatGTP À°¦£¸Éªº
 298  0066 1e09          	ldw	x,(OFST+1,sp)
 299  0068 2633          	jrne	L331
 300                     ; 43         UART1_SendData8('0');
 302  006a a630          	ld	a,#48
 303  006c cd0000        	call	_UART1_SendData8
 306  006f               L521:
 307                     ; 44         while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 309  006f ae0080        	ldw	x,#128
 310  0072 cd0000        	call	_UART1_GetFlagStatus
 312  0075 4d            	tnz	a
 313  0076 27f7          	jreq	L521
 314                     ; 45         return;
 316  0078 204c          	jra	L61
 317  007a               L131:
 318                     ; 51 		 digit[count] = number%10;
 320  007a 96            	ldw	x,sp
 321  007b 1c0003        	addw	x,#OFST-5
 322  007e 9f            	ld	a,xl
 323  007f 5e            	swapw	x
 324  0080 1b08          	add	a,(OFST+0,sp)
 325  0082 2401          	jrnc	L41
 326  0084 5c            	incw	x
 327  0085               L41:
 328  0085 02            	rlwa	x,a
 329  0086 1609          	ldw	y,(OFST+1,sp)
 330  0088 a60a          	ld	a,#10
 331  008a cd0000        	call	c_smody
 333  008d 9001          	rrwa	y,a
 334  008f f7            	ld	(x),a
 335  0090 9002          	rlwa	y,a
 336                     ; 52 		 count++;
 338  0092 0c08          	inc	(OFST+0,sp)
 340                     ; 53 		 number = number/10;
 342  0094 1e09          	ldw	x,(OFST+1,sp)
 343  0096 a60a          	ld	a,#10
 344  0098 cd0000        	call	c_sdivx
 346  009b 1f09          	ldw	(OFST+1,sp),x
 347  009d               L331:
 348                     ; 49 	 while (number != 0) //split the int to char array 
 350  009d 1e09          	ldw	x,(OFST+1,sp)
 351  009f 26d9          	jrne	L131
 353  00a1 201f          	jra	L141
 354  00a3               L731:
 355                     ; 58 		UART1_SendData8(digit[count-1] + 0x30);
 357  00a3 96            	ldw	x,sp
 358  00a4 1c0003        	addw	x,#OFST-5
 359  00a7 1f01          	ldw	(OFST-7,sp),x
 361  00a9 7b08          	ld	a,(OFST+0,sp)
 362  00ab 5f            	clrw	x
 363  00ac 97            	ld	xl,a
 364  00ad 5a            	decw	x
 365  00ae 72fb01        	addw	x,(OFST-7,sp)
 366  00b1 f6            	ld	a,(x)
 367  00b2 ab30          	add	a,#48
 368  00b4 cd0000        	call	_UART1_SendData8
 371  00b7               L741:
 372                     ; 59 		while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending 
 374  00b7 ae0080        	ldw	x,#128
 375  00ba cd0000        	call	_UART1_GetFlagStatus
 377  00bd 4d            	tnz	a
 378  00be 27f7          	jreq	L741
 379                     ; 60 		count--; 
 381  00c0 0a08          	dec	(OFST+0,sp)
 383  00c2               L141:
 384                     ; 56 	 while (count !=0) //print char array in correct direction 
 386  00c2 0d08          	tnz	(OFST+0,sp)
 387  00c4 26dd          	jrne	L731
 388                     ; 62  }
 389  00c6               L61:
 392  00c6 5b0a          	addw	sp,#10
 393  00c8 81            	ret
 448                     ; 65  void Serial_SendNumber(uint16_t num) {
 449                     	switch	.text
 450  00c9               _Serial_SendNumber:
 452  00c9 89            	pushw	x
 453  00ca 5209          	subw	sp,#9
 454       00000009      OFST:	set	9
 457                     ; 67     uint8_t i = 0;
 459  00cc 0f09          	clr	(OFST+0,sp)
 461                     ; 69     if (num == 0) {
 463  00ce a30000        	cpw	x,#0
 464  00d1 2633          	jrne	L502
 465                     ; 70         UART1_SendData8('0');
 467  00d3 a630          	ld	a,#48
 468  00d5 cd0000        	call	_UART1_SendData8
 470                     ; 71         return;
 472  00d8 2052          	jra	L22
 473  00da               L302:
 474                     ; 76         buffer[i++] = '0' + (num % 10);
 476  00da 1e0a          	ldw	x,(OFST+1,sp)
 477  00dc a60a          	ld	a,#10
 478  00de 62            	div	x,a
 479  00df 5f            	clrw	x
 480  00e0 97            	ld	xl,a
 481  00e1 1c0030        	addw	x,#48
 482  00e4 9096          	ldw	y,sp
 483  00e6 72a90003      	addw	y,#OFST-6
 484  00ea 1701          	ldw	(OFST-8,sp),y
 486  00ec 7b09          	ld	a,(OFST+0,sp)
 487  00ee 9097          	ld	yl,a
 488  00f0 0c09          	inc	(OFST+0,sp)
 490  00f2 909f          	ld	a,yl
 491  00f4 905f          	clrw	y
 492  00f6 9097          	ld	yl,a
 493  00f8 72f901        	addw	y,(OFST-8,sp)
 494  00fb 01            	rrwa	x,a
 495  00fc 90f7          	ld	(y),a
 496  00fe 02            	rlwa	x,a
 497                     ; 77         num /= 10;
 499  00ff 1e0a          	ldw	x,(OFST+1,sp)
 500  0101 a60a          	ld	a,#10
 501  0103 62            	div	x,a
 502  0104 1f0a          	ldw	(OFST+1,sp),x
 503  0106               L502:
 504                     ; 75     while (num > 0) {
 506  0106 1e0a          	ldw	x,(OFST+1,sp)
 507  0108 26d0          	jrne	L302
 509  010a 201c          	jra	L312
 510  010c               L112:
 511                     ; 82         UART1_SendData8(buffer[--i]);
 513  010c 96            	ldw	x,sp
 514  010d 1c0003        	addw	x,#OFST-6
 515  0110 1f01          	ldw	(OFST-8,sp),x
 517  0112 0a09          	dec	(OFST+0,sp)
 519  0114 7b09          	ld	a,(OFST+0,sp)
 520  0116 5f            	clrw	x
 521  0117 97            	ld	xl,a
 522  0118 72fb01        	addw	x,(OFST-8,sp)
 523  011b f6            	ld	a,(x)
 524  011c cd0000        	call	_UART1_SendData8
 527  011f               L122:
 528                     ; 83         while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 530  011f ae0080        	ldw	x,#128
 531  0122 cd0000        	call	_UART1_GetFlagStatus
 533  0125 4d            	tnz	a
 534  0126 27f7          	jreq	L122
 535  0128               L312:
 536                     ; 81     while (i > 0) {
 538  0128 0d09          	tnz	(OFST+0,sp)
 539  012a 26e0          	jrne	L112
 540                     ; 85 }
 541  012c               L22:
 544  012c 5b0b          	addw	sp,#11
 545  012e 81            	ret
 570                     ; 87  void Serial_newline(void)
 570                     ; 88  {
 571                     	switch	.text
 572  012f               _Serial_newline:
 576                     ; 89 	 UART1_SendData8(0x0a);
 578  012f a60a          	ld	a,#10
 579  0131 cd0000        	call	_UART1_SendData8
 582  0134               L732:
 583                     ; 90 	while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET); //wait for sending 
 585  0134 ae0080        	ldw	x,#128
 586  0137 cd0000        	call	_UART1_GetFlagStatus
 588  013a 4d            	tnz	a
 589  013b 27f7          	jreq	L732
 590                     ; 91  }
 593  013d 81            	ret
 640                     ; 93  void Serial_print_string (char string[])
 640                     ; 94  {
 641                     	switch	.text
 642  013e               _Serial_print_string:
 644  013e 89            	pushw	x
 645  013f 88            	push	a
 646       00000001      OFST:	set	1
 649                     ; 96 	 char i=0;
 651  0140 0f01          	clr	(OFST+0,sp)
 654  0142 2016          	jra	L172
 655  0144               L562:
 656                     ; 100 		UART1_SendData8(string[i]);
 658  0144 7b01          	ld	a,(OFST+0,sp)
 659  0146 5f            	clrw	x
 660  0147 97            	ld	xl,a
 661  0148 72fb02        	addw	x,(OFST+1,sp)
 662  014b f6            	ld	a,(x)
 663  014c cd0000        	call	_UART1_SendData8
 666  014f               L772:
 667                     ; 101 		while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 669  014f ae0080        	ldw	x,#128
 670  0152 cd0000        	call	_UART1_GetFlagStatus
 672  0155 4d            	tnz	a
 673  0156 27f7          	jreq	L772
 674                     ; 102 		i++;
 676  0158 0c01          	inc	(OFST+0,sp)
 678  015a               L172:
 679                     ; 98 	 while (string[i] != 0x00)
 681  015a 7b01          	ld	a,(OFST+0,sp)
 682  015c 5f            	clrw	x
 683  015d 97            	ld	xl,a
 684  015e 72fb02        	addw	x,(OFST+1,sp)
 685  0161 7d            	tnz	(x)
 686  0162 26e0          	jrne	L562
 687                     ; 104  }
 690  0164 5b03          	addw	sp,#3
 691  0166 81            	ret
 736                     ; 106  bool Serial_available()
 736                     ; 107  {
 737                     	switch	.text
 738  0167               _Serial_available:
 742                     ; 108 	 if(UART1_GetFlagStatus(UART1_FLAG_RXNE) == TRUE)
 744  0167 ae0020        	ldw	x,#32
 745  016a cd0000        	call	_UART1_GetFlagStatus
 747  016d a101          	cp	a,#1
 748  016f 2603          	jrne	L323
 749                     ; 109 	 return 1;
 751  0171 a601          	ld	a,#1
 754  0173 81            	ret
 755  0174               L323:
 756                     ; 111 	 return 0;
 758  0174 4f            	clr	a
 761  0175 81            	ret
 798                     ; 114 void Serial_SendString(char *str)
 798                     ; 115 {
 799                     	switch	.text
 800  0176               _Serial_SendString:
 802  0176 89            	pushw	x
 803       00000000      OFST:	set	0
 806  0177 2017          	jra	L743
 807  0179               L543:
 808                     ; 118         UART1_SendData8(*str++);
 810  0179 1e01          	ldw	x,(OFST+1,sp)
 811  017b 1c0001        	addw	x,#1
 812  017e 1f01          	ldw	(OFST+1,sp),x
 813  0180 1d0001        	subw	x,#1
 814  0183 f6            	ld	a,(x)
 815  0184 cd0000        	call	_UART1_SendData8
 818  0187               L553:
 819                     ; 119         while (UART1_GetFlagStatus(UART1_FLAG_TXE) == RESET);
 821  0187 ae0080        	ldw	x,#128
 822  018a cd0000        	call	_UART1_GetFlagStatus
 824  018d 4d            	tnz	a
 825  018e 27f7          	jreq	L553
 826  0190               L743:
 827                     ; 116     while (*str)
 829  0190 1e01          	ldw	x,(OFST+1,sp)
 830  0192 7d            	tnz	(x)
 831  0193 26e4          	jrne	L543
 832                     ; 121 }
 835  0195 85            	popw	x
 836  0196 81            	ret
 849                     	xdef	_Serial_SendNumber
 850                     	xdef	_Serial_SendString
 851                     	xdef	_Serial_read_char
 852                     	xdef	_Serial_available
 853                     	xdef	_Serial_newline
 854                     	xdef	_Serial_print_string
 855                     	xdef	_Serial_print_char
 856                     	xdef	_Serial_print_int
 857                     	xdef	_Serial_begin
 858                     	xref	_UART1_ClearFlag
 859                     	xref	_UART1_GetFlagStatus
 860                     	xref	_UART1_SendData8
 861                     	xref	_UART1_ReceiveData8
 862                     	xref	_UART1_Cmd
 863                     	xref	_UART1_Init
 864                     	xref	_UART1_DeInit
 865                     	xref	_GPIO_Init
 866                     	xref.b	c_x
 867                     	xref.b	c_y
 886                     	xref	c_sdivx
 887                     	xref	c_smody
 888                     	xref	c_smodx
 889                     	xref	c_xymov
 890                     	end
