
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x53:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x9A,0x99
	.DB  0x19,0x3F
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 8/30/2018
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <alcd.h>
;#include <delay.h>
;#include <stdlib.h>
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0020 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0021 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0022 // Delay needed for the stabilization of the ADC input voltage
; 0000 0023 delay_us(10);
	__DELAY_USB 27
; 0000 0024 // Start the AD conversion
; 0000 0025 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0026 // Wait for the AD conversion to complete
; 0000 0027 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0028 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0029 return ADCH;
	IN   R30,0x5
	JMP  _0x20A0001
; 0000 002A }
; .FEND
;
;#define S_A PORTC.0
;#define S_B PORTC.1
;#define S_C PORTC.2
;
;#define IN1 PORTB.4
;#define IN2 PORTB.7
;
;#define BLACK 120
;
;#define R_12 sen[19]
;#define R_11 sen[16]
;#define R_10 sen[17]
;#define R_9 sen[18]
;#define R_8 sen[20]
;#define R_7 sen[22]
;#define R_6 sen[23]
;#define R_5 sen[21]
;#define R_4 sen[12]
;#define R_3 sen[14]
;#define R_2 sen[15]
;#define R_1 sen[13]
;#define L_1 sen[11]
;#define L_2 sen[8]
;#define L_3 sen[9]
;#define L_4 sen[10]
;#define L_5 sen[4]
;#define L_6 sen[6]
;#define L_7 sen[7]
;#define L_8 sen[5]
;#define L_9 sen[3]
;#define L_10 sen[0]
;#define L_11 sen[1]
;#define L_12 sen[2]
;
;#define SEN_R_12 ir_sensor[19]
;#define SEN_R_11 ir_sensor[16]
;#define SEN_R_10 ir_sensor[17]
;#define SEN_R_9 ir_sensor[18]
;#define SEN_R_8 ir_sensor[20]
;#define SEN_R_7 ir_sensor[22]
;#define SEN_R_6 ir_sensor[23]
;#define SEN_R_5 ir_sensor[21]
;#define SEN_R_4 ir_sensor[12]
;#define SEN_R_3 ir_sensor[14]
;#define SEN_R_2 ir_sensor[15]
;#define SEN_R_1 ir_sensor[13]
;#define SEN_L_1 ir_sensor[11]
;#define SEN_L_2 ir_sensor[8]
;#define SEN_L_3 ir_sensor[9]
;#define SEN_L_4 ir_sensor[10]
;#define SEN_L_5 ir_sensor[4]
;#define SEN_L_6 ir_sensor[6]
;#define SEN_L_7 ir_sensor[7]
;#define SEN_L_8 ir_sensor[5]
;#define SEN_L_9 ir_sensor[3]
;#define SEN_L_10 ir_sensor[0]
;#define SEN_L_11 ir_sensor[1]
;#define SEN_L_12 ir_sensor[2]
;
;
;
;
;
;#define E_R_1 5
;#define E_R_2 15
;#define E_R_3 60
;#define E_R_4 60
;#define E_R_5 70
;#define E_R_6 90
;#define E_R_7 300
;#define E_R_8 300
;#define E_R_9 450
;#define E_R_10 500
;#define E_R_11 600
;#define E_R_12 700
;
;#define E_L_1 -5
;#define E_L_2 -15
;#define E_L_3 -60
;#define E_L_4 -60
;#define E_L_5 -70
;#define E_L_6 -90
;#define E_L_7 -300
;#define E_L_8 -300
;#define E_L_9 -450
;#define E_L_10 -500
;#define E_L_11 -600
;#define E_L_12 -700
;
;
;unsigned char ir_sensor[24];
;unsigned char sen[24];
;unsigned char black[24];
;unsigned char ir_max_min_calibrate[2][24];
;
;void ReadMp();
;void Back(unsigned char motor_r_speed,unsigned char motor_l_speed);
;void Left(unsigned char motor_r_speed,unsigned char motor_l_speed);
;void Right(unsigned char motor_r_speed,unsigned char motor_l_speed);
;void Go(unsigned char motor_r_speed,unsigned char motor_l_speed);
;void Move(int motor_r_speed,int motor_l_speed);
;void Stop();
;void lcd_put_int(int Data);
;void lcd_show_sensor();
;void init();
;void digitalize();
;void my_put_int(int data);
;void my_putstr( char *f);
;void controller();
;void calibrate();
;
;
;
;
;void main(void)
; 0000 009F {
_main:
; .FSTART _main
; 0000 00A0 // Declare your local variables here
; 0000 00A1 
; 0000 00A2 // Input/Output Ports initialization
; 0000 00A3 // Port A initialization
; 0000 00A4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A5 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00A6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A7 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00A8 
; 0000 00A9 // Port B initialization
; 0000 00AA // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00AB DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(96)
	OUT  0x17,R30
; 0000 00AC // State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00AD PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00AE 
; 0000 00AF // Port C initialization
; 0000 00B0 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B1 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00B2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B3 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00B4 
; 0000 00B5 // Port D initialization
; 0000 00B6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00B7 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00B8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00B9 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00BA 
; 0000 00BB // Port E initialization
; 0000 00BC // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00BD DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 00BE // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00BF PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 00C0 
; 0000 00C1 // Port F initialization
; 0000 00C2 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C3 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 00C4 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C5 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 00C6 
; 0000 00C7 // Port G initialization
; 0000 00C8 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C9 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 00CA // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CB PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 00CC 
; 0000 00CD // Timer/Counter 0 initialization
; 0000 00CE // Clock source: System Clock
; 0000 00CF // Clock value: Timer 0 Stopped
; 0000 00D0 // Mode: Normal top=0xFF
; 0000 00D1 // OC0 output: Disconnected
; 0000 00D2 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 00D3 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00D4 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00D5 OCR0=0x00;
	OUT  0x31,R30
; 0000 00D6 
; 0000 00D7 // Timer/Counter 1 initialization
; 0000 00D8 // Clock source: System Clock
; 0000 00D9 // Clock value: 125.000 kHz
; 0000 00DA // Mode: Fast PWM top=0x00FF
; 0000 00DB // OC1A output: Non-Inverted PWM
; 0000 00DC // OC1B output: Non-Inverted PWM
; 0000 00DD // OC1C output: Disconnected
; 0000 00DE // Noise Canceler: Off
; 0000 00DF // Input Capture on Falling Edge
; 0000 00E0 // Timer Period: 2.048 ms
; 0000 00E1 // Output Pulse(s):
; 0000 00E2 // OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
; 0000 00E3 // Timer1 Overflow Interrupt: Off
; 0000 00E4 // Input Capture Interrupt: Off
; 0000 00E5 // Compare A Match Interrupt: Off
; 0000 00E6 // Compare B Match Interrupt: Off
; 0000 00E7 // Compare C Match Interrupt: Off
; 0000 00E8 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 00E9 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 00EA TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00EB TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EC ICR1H=0x00;
	OUT  0x27,R30
; 0000 00ED ICR1L=0x00;
	OUT  0x26,R30
; 0000 00EE OCR1AH=0x00;
	CALL SUBOPT_0x0
; 0000 00EF OCR1AL=0x00;
; 0000 00F0 OCR1BH=0x00;
; 0000 00F1 OCR1BL=0x00;
; 0000 00F2 OCR1CH=0x00;
	LDI  R30,LOW(0)
	STS  121,R30
; 0000 00F3 OCR1CL=0x00;
	STS  120,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 2 initialization
; 0000 00F6 // Clock source: System Clock
; 0000 00F7 // Clock value: Timer2 Stopped
; 0000 00F8 // Mode: Normal top=0xFF
; 0000 00F9 // OC2 output: Disconnected
; 0000 00FA TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00FB TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FC OCR2=0x00;
	OUT  0x23,R30
; 0000 00FD 
; 0000 00FE // Timer/Counter 3 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: Timer3 Stopped
; 0000 0101 // Mode: Normal top=0xFFFF
; 0000 0102 // OC3A output: Disconnected
; 0000 0103 // OC3B output: Disconnected
; 0000 0104 // OC3C output: Disconnected
; 0000 0105 // Noise Canceler: Off
; 0000 0106 // Input Capture on Falling Edge
; 0000 0107 // Timer3 Overflow Interrupt: Off
; 0000 0108 // Input Capture Interrupt: Off
; 0000 0109 // Compare A Match Interrupt: Off
; 0000 010A // Compare B Match Interrupt: Off
; 0000 010B // Compare C Match Interrupt: Off
; 0000 010C TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 010D TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 010E TCNT3H=0x00;
	STS  137,R30
; 0000 010F TCNT3L=0x00;
	STS  136,R30
; 0000 0110 ICR3H=0x00;
	STS  129,R30
; 0000 0111 ICR3L=0x00;
	STS  128,R30
; 0000 0112 OCR3AH=0x00;
	STS  135,R30
; 0000 0113 OCR3AL=0x00;
	STS  134,R30
; 0000 0114 OCR3BH=0x00;
	STS  133,R30
; 0000 0115 OCR3BL=0x00;
	STS  132,R30
; 0000 0116 OCR3CH=0x00;
	STS  131,R30
; 0000 0117 OCR3CL=0x00;
	STS  130,R30
; 0000 0118 
; 0000 0119 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 011A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 011B ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 011C 
; 0000 011D // External Interrupt(s) initialization
; 0000 011E // INT0: Off
; 0000 011F // INT1: Off
; 0000 0120 // INT2: Off
; 0000 0121 // INT3: Off
; 0000 0122 // INT4: Off
; 0000 0123 // INT5: Off
; 0000 0124 // INT6: Off
; 0000 0125 // INT7: Off
; 0000 0126 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 0127 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 0128 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0129 
; 0000 012A // USART0 initialization
; 0000 012B // USART0 disabled
; 0000 012C UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 012D 
; 0000 012E // USART1 initialization
; 0000 012F // USART1 disabled
; 0000 0130 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 0131 
; 0000 0132 // Analog Comparator initialization
; 0000 0133 // Analog Comparator: Off
; 0000 0134 // The Analog Comparator's positive input is
; 0000 0135 // connected to the AIN0 pin
; 0000 0136 // The Analog Comparator's negative input is
; 0000 0137 // connected to the AIN1 pin
; 0000 0138 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0139 
; 0000 013A // ADC initialization
; 0000 013B // ADC Clock frequency: 125.000 kHz
; 0000 013C // ADC Voltage Reference: AREF pin
; 0000 013D // Only the 8 most significant bits of
; 0000 013E // the AD conversion result are used
; 0000 013F ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0140 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0141 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0142 
; 0000 0143 // SPI initialization
; 0000 0144 // SPI disabled
; 0000 0145 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0146 
; 0000 0147 // TWI initialization
; 0000 0148 // TWI disabled
; 0000 0149 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 014A 
; 0000 014B // Alphanumeric LCD initialization
; 0000 014C // Connections are specified in the
; 0000 014D // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 014E // RS - PORTA Bit 0
; 0000 014F // RD - PORTA Bit 1
; 0000 0150 // EN - PORTA Bit 2
; 0000 0151 // D4 - PORTA Bit 4
; 0000 0152 // D5 - PORTA Bit 5
; 0000 0153 // D6 - PORTA Bit 6
; 0000 0154 // D7 - PORTA Bit 7
; 0000 0155 // Characters/line: 16
; 0000 0156 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0157 //mp-----
; 0000 0158 DDRC.0=1;
	SBI  0x14,0
; 0000 0159 DDRC.1=1;
	SBI  0x14,1
; 0000 015A DDRC.2=1;
	SBI  0x14,2
; 0000 015B //------
; 0000 015C //---motor
; 0000 015D DDRB.4=1;
	SBI  0x17,4
; 0000 015E DDRB.7=1;
	SBI  0x17,7
; 0000 015F //-----
; 0000 0160 
; 0000 0161 init();
	RCALL _init
; 0000 0162 //calibrate();
; 0000 0163     while (1)
_0x10:
; 0000 0164     {
; 0000 0165         controller();
	RCALL _controller
; 0000 0166    //       lcd_show_sensor();
; 0000 0167  //       ReadMp();
; 0000 0168 
; 0000 0169 
; 0000 016A 
; 0000 016B     }
	RJMP _0x10
; 0000 016C }
_0x13:
	RJMP _0x13
; .FEND
;void init()
; 0000 016E {
_init:
; .FSTART _init
; 0000 016F     lcd_clear();
	CALL _lcd_clear
; 0000 0170 //    Back(200,200);
; 0000 0171 //    delay_ms(1000);
; 0000 0172 //    Right(100,100);
; 0000 0173 //    delay_ms(1000);
; 0000 0174 //    Left(100,100);
; 0000 0175 //    delay_ms(1000);
; 0000 0176 //    Stop();
; 0000 0177 //    lcd_putsf("salam");
; 0000 0178 //    delay_ms(1000);
; 0000 0179 //    lcd_clear();
; 0000 017A }
	RET
; .FEND
;void ReadMp()
; 0000 017C {
_ReadMp:
; .FSTART _ReadMp
; 0000 017D     static unsigned int ir_sensor_back[24];
; 0000 017E     unsigned char i=0;
; 0000 017F     for(;i<8;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
_0x15:
	CPI  R17,8
	BRSH _0x16
; 0000 0180     {
; 0000 0181         S_A=i%2;
	CALL SUBOPT_0x1
	BRNE _0x17
	CBI  0x15,0
	RJMP _0x18
_0x17:
	SBI  0x15,0
_0x18:
; 0000 0182         S_B=(i%4)/2;
	CALL SUBOPT_0x2
	BRNE _0x19
	CBI  0x15,1
	RJMP _0x1A
_0x19:
	SBI  0x15,1
_0x1A:
; 0000 0183         S_C=(i%8)/4;
	CALL SUBOPT_0x3
	BRNE _0x1B
	CBI  0x15,2
	RJMP _0x1C
_0x1B:
	SBI  0x15,2
_0x1C:
; 0000 0184         i++;
	CALL SUBOPT_0x4
; 0000 0185         i--;
; 0000 0186         i++;
; 0000 0187         i--;
; 0000 0188 
; 0000 0189         ir_sensor[i]=read_adc(0);
	SUBI R30,LOW(-_ir_sensor)
	SBCI R31,HIGH(-_ir_sensor)
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 018A     }
	SUBI R17,-1
	RJMP _0x15
_0x16:
; 0000 018B     i=0;
	LDI  R17,LOW(0)
; 0000 018C     for(;i<8;i++)
_0x1E:
	CPI  R17,8
	BRSH _0x1F
; 0000 018D     {
; 0000 018E         S_A=i%2;
	CALL SUBOPT_0x1
	BRNE _0x20
	CBI  0x15,0
	RJMP _0x21
_0x20:
	SBI  0x15,0
_0x21:
; 0000 018F         S_B=(i%4)/2;
	CALL SUBOPT_0x2
	BRNE _0x22
	CBI  0x15,1
	RJMP _0x23
_0x22:
	SBI  0x15,1
_0x23:
; 0000 0190         S_C=(i%8)/4;
	CALL SUBOPT_0x3
	BRNE _0x24
	CBI  0x15,2
	RJMP _0x25
_0x24:
	SBI  0x15,2
_0x25:
; 0000 0191         i++;
	CALL SUBOPT_0x4
; 0000 0192         i--;
; 0000 0193         i++;
; 0000 0194         i--;
; 0000 0195 
; 0000 0196         ir_sensor[i+8]=read_adc(1);
	__ADDW1MN _ir_sensor,8
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0197     }
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 0198     i=0;
	LDI  R17,LOW(0)
; 0000 0199     for(;i<8;i++)
_0x27:
	CPI  R17,8
	BRSH _0x28
; 0000 019A     {
; 0000 019B         S_A=i%2;
	CALL SUBOPT_0x1
	BRNE _0x29
	CBI  0x15,0
	RJMP _0x2A
_0x29:
	SBI  0x15,0
_0x2A:
; 0000 019C         S_B=(i%4)/2;
	CALL SUBOPT_0x2
	BRNE _0x2B
	CBI  0x15,1
	RJMP _0x2C
_0x2B:
	SBI  0x15,1
_0x2C:
; 0000 019D         S_C=(i%8)/4;
	CALL SUBOPT_0x3
	BRNE _0x2D
	CBI  0x15,2
	RJMP _0x2E
_0x2D:
	SBI  0x15,2
_0x2E:
; 0000 019E         i++;
	CALL SUBOPT_0x4
; 0000 019F         i--;
; 0000 01A0         i++;
; 0000 01A1         i--;
; 0000 01A2         ir_sensor[i+16]=read_adc(2);
	__ADDW1MN _ir_sensor,16
	PUSH R31
	PUSH R30
	LDI  R26,LOW(2)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01A3     }
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 01A4     digitalize();
	RCALL _digitalize
; 0000 01A5 
; 0000 01A6 }
	LD   R17,Y+
	RET
; .FEND
;void Back(unsigned char motor_r_speed,unsigned char motor_l_speed)
; 0000 01A8 {
_Back:
; .FSTART _Back
; 0000 01A9     IN1=1;
	ST   -Y,R26
;	motor_r_speed -> Y+1
;	motor_l_speed -> Y+0
	SBI  0x18,4
; 0000 01AA     IN2=0;
	CBI  0x18,7
; 0000 01AB 
; 0000 01AC     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01AD     OCR1AL=255-motor_l_speed;
	LD   R26,Y
	LDI  R30,LOW(255)
	SUB  R30,R26
	OUT  0x2A,R30
; 0000 01AE 
; 0000 01AF     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01B0     OCR1BL=motor_r_speed;
	LDD  R30,Y+1
	RJMP _0x20A0003
; 0000 01B1 }
; .FEND
;void Right(unsigned char motor_r_speed,unsigned char motor_l_speed)
; 0000 01B3 {
_Right:
; .FSTART _Right
; 0000 01B4     IN1=0;
	ST   -Y,R26
;	motor_r_speed -> Y+1
;	motor_l_speed -> Y+0
	CBI  0x18,4
; 0000 01B5     IN2=0;
	CBI  0x18,7
; 0000 01B6 
; 0000 01B7     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01B8     OCR1AL=motor_l_speed;
	LD   R30,Y
	OUT  0x2A,R30
; 0000 01B9 
; 0000 01BA     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01BB     OCR1BL=motor_r_speed;
	LDD  R30,Y+1
	RJMP _0x20A0003
; 0000 01BC }
; .FEND
;void Left(unsigned char motor_r_speed,unsigned char motor_l_speed)
; 0000 01BE {
_Left:
; .FSTART _Left
; 0000 01BF     IN1=1;
	ST   -Y,R26
;	motor_r_speed -> Y+1
;	motor_l_speed -> Y+0
	SBI  0x18,4
; 0000 01C0     IN2=1;
	SBI  0x18,7
; 0000 01C1 
; 0000 01C2     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01C3     OCR1AL=255-motor_l_speed;
	LD   R26,Y
	LDI  R30,LOW(255)
	SUB  R30,R26
	RJMP _0x20A0002
; 0000 01C4 
; 0000 01C5     OCR1BH=0x00;
; 0000 01C6     OCR1BL=255-motor_r_speed;
; 0000 01C7 }
; .FEND
;void Go(unsigned char motor_r_speed,unsigned char motor_l_speed)
; 0000 01C9 {
_Go:
; .FSTART _Go
; 0000 01CA     IN1=0;
	ST   -Y,R26
;	motor_r_speed -> Y+1
;	motor_l_speed -> Y+0
	CBI  0x18,4
; 0000 01CB     IN2=1;
	SBI  0x18,7
; 0000 01CC 
; 0000 01CD     OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01CE     OCR1AL=motor_l_speed;
	LD   R30,Y
_0x20A0002:
	OUT  0x2A,R30
; 0000 01CF 
; 0000 01D0     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01D1     OCR1BL=255-motor_r_speed;
	LDD  R26,Y+1
	LDI  R30,LOW(255)
	SUB  R30,R26
_0x20A0003:
	OUT  0x28,R30
; 0000 01D2 }
	ADIW R28,2
	RET
; .FEND
;void Stop()
; 0000 01D4 {
_Stop:
; .FSTART _Stop
; 0000 01D5     IN1=0;
	CBI  0x18,4
; 0000 01D6     IN2=0;
	CBI  0x18,7
; 0000 01D7 
; 0000 01D8     OCR1AH=0x00;
	CALL SUBOPT_0x0
; 0000 01D9     OCR1AL=0;
; 0000 01DA 
; 0000 01DB     OCR1BH=0x00;
; 0000 01DC     OCR1BL=0;
; 0000 01DD }
	RET
; .FEND
;void Move(int motor_r_speed,int motor_l_speed)
; 0000 01DF {
_Move:
; .FSTART _Move
; 0000 01E0     if(motor_r_speed>255)
	ST   -Y,R27
	ST   -Y,R26
;	motor_r_speed -> Y+2
;	motor_l_speed -> Y+0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x43
; 0000 01E1         motor_r_speed=250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 01E2     if(motor_l_speed>255)
_0x43:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x44
; 0000 01E3         motor_l_speed=250;
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   Y,R30
	STD  Y+1,R31
; 0000 01E4     if(motor_r_speed<-255)
_0x44:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x45
; 0000 01E5         motor_r_speed=-250;
	LDI  R30,LOW(65286)
	LDI  R31,HIGH(65286)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 01E6     if(motor_l_speed<-255)
_0x45:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x46
; 0000 01E7         motor_l_speed=-250;
	LDI  R30,LOW(65286)
	LDI  R31,HIGH(65286)
	ST   Y,R30
	STD  Y+1,R31
; 0000 01E8 
; 0000 01E9 
; 0000 01EA     if(motor_r_speed>=0&&motor_l_speed>=0)
_0x46:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x48
	LDD  R26,Y+1
	TST  R26
	BRPL _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 01EB        Go(motor_r_speed,motor_l_speed);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _Go
; 0000 01EC     else if(motor_r_speed<=0&&motor_l_speed>=0)
	RJMP _0x4A
_0x47:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRLT _0x4C
	LDD  R26,Y+1
	TST  R26
	BRPL _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 01ED         Right(motor_r_speed*-1,motor_l_speed);
	LDD  R30,Y+2
	LDI  R26,LOW(255)
	MULS R30,R26
	ST   -Y,R0
	LDD  R26,Y+1
	RCALL _Right
; 0000 01EE     else if(motor_r_speed>=0&&motor_l_speed<=0)
	RJMP _0x4E
_0x4B:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x50
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRGE _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 01EF         Left(motor_r_speed,motor_l_speed*-1);
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R30,Y+1
	LDI  R26,LOW(255)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RCALL _Left
; 0000 01F0     else
	RJMP _0x52
_0x4F:
; 0000 01F1         Back(motor_r_speed*-1,motor_r_speed*-1);
	LDD  R30,Y+2
	LDI  R26,LOW(255)
	MULS R30,R26
	ST   -Y,R0
	LDD  R30,Y+3
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RCALL _Back
; 0000 01F2 }
_0x52:
_0x4E:
_0x4A:
	ADIW R28,4
	RET
; .FEND
;void omeg(int omega)
; 0000 01F4 {
; 0000 01F5 
; 0000 01F6 }
;void lcd_put_int(int Data)
; 0000 01F8 {
; 0000 01F9     unsigned char f[50];
; 0000 01FA     itoa(Data,f);
;	Data -> Y+50
;	f -> Y+0
; 0000 01FB     lcd_puts(f);
; 0000 01FC }
;void lcd_show_sensor()
; 0000 01FE {
; 0000 01FF     lcd_clear();
; 0000 0200     ReadMp();
; 0000 0201 
; 0000 0202     lcd_put_int(R_1);
; 0000 0203     lcd_put_int(L_1);
; 0000 0204     lcd_put_int(R_2);
; 0000 0205     lcd_put_int(L_2);
; 0000 0206     lcd_put_int(R_3);
; 0000 0207     lcd_put_int(L_3);
; 0000 0208     lcd_put_int(R_4);
; 0000 0209     lcd_put_int(L_4);
; 0000 020A     lcd_put_int(R_5);
; 0000 020B     lcd_put_int(L_5);
; 0000 020C     lcd_put_int(R_6);
; 0000 020D     lcd_put_int(L_6);
; 0000 020E     lcd_put_int(R_7);
; 0000 020F     lcd_put_int(L_7);
; 0000 0210     lcd_put_int(R_8);
; 0000 0211     lcd_put_int(L_8);
; 0000 0212     lcd_put_int(R_9);
; 0000 0213     lcd_put_int(L_9);
; 0000 0214     lcd_put_int(R_10);
; 0000 0215     lcd_put_int(L_10);
; 0000 0216     lcd_put_int(R_11);
; 0000 0217     lcd_put_int(L_11);
; 0000 0218     lcd_put_int(R_12);
; 0000 0219     lcd_put_int(L_12);
; 0000 021A 
; 0000 021B 
; 0000 021C 
; 0000 021D     delay_ms(200);
; 0000 021E 
; 0000 021F 
; 0000 0220 }
;void controller()
; 0000 0222 {
_controller:
; .FSTART _controller
; 0000 0223     static int last_error=0;
; 0000 0224     float kp=.6;
; 0000 0225     int motor_speed=0;
; 0000 0226     int sum_r=0;
; 0000 0227     int sum_l=0;
; 0000 0228     int error=0;
; 0000 0229     int m_r=0;
; 0000 022A     int m_l=0;
; 0000 022B     ReadMp();
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x53*2)
	LDI  R31,HIGH(_0x53*2)
	CALL __INITLOCB
	CALL __SAVELOCR6
;	kp -> Y+12
;	motor_speed -> R16,R17
;	sum_r -> R18,R19
;	sum_l -> R20,R21
;	error -> Y+10
;	m_r -> Y+8
;	m_l -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL _ReadMp
; 0000 022C 
; 0000 022D     if(R_1||R_2||L_2||R_2||L_3||R_3)
	__GETB1MN _sen,13
	CPI  R30,0
	BRNE _0x55
	__GETB1MN _sen,15
	CPI  R30,0
	BRNE _0x55
	__GETB1MN _sen,8
	CPI  R30,0
	BRNE _0x55
	__GETB1MN _sen,15
	CPI  R30,0
	BRNE _0x55
	__GETB1MN _sen,9
	CPI  R30,0
	BRNE _0x55
	__GETB1MN _sen,14
	CPI  R30,0
	BREQ _0x54
_0x55:
; 0000 022E     {
; 0000 022F         last_error=0;
	LDI  R30,LOW(0)
	STS  _last_error_S000000D000,R30
	STS  _last_error_S000000D000+1,R30
; 0000 0230         sum_l=(L_1*E_L_1)+(L_2*E_L_2)+(L_3*E_L_3);
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 0231         sum_r=(R_1*E_R_1)+(R_2*E_R_2)+(R_3*E_R_3);
	RJMP _0x76
; 0000 0232     }
; 0000 0233     else
_0x54:
; 0000 0234     {
; 0000 0235         sum_l=(L_1*E_L_1)+(L_2*E_L_2)+(L_3*E_L_3)+(L_4*E_L_4)+(L_5*E_L_5)+(L_6*E_L_6)+(L_7*E_L_7)+(L_8*E_L_8)+(L_9*E_L_9 ...
	CALL SUBOPT_0x5
	__ADDWRR 22,23,30,31
	__GETB2MN _sen,10
	LDI  R27,0
	LDI  R30,LOW(65476)
	LDI  R31,HIGH(65476)
	CALL SUBOPT_0x7
	__GETB2MN _sen,4
	LDI  R27,0
	LDI  R30,LOW(65466)
	LDI  R31,HIGH(65466)
	CALL SUBOPT_0x7
	__GETB2MN _sen,6
	LDI  R27,0
	LDI  R30,LOW(65446)
	LDI  R31,HIGH(65446)
	CALL SUBOPT_0x7
	__GETB2MN _sen,7
	LDI  R27,0
	LDI  R30,LOW(65236)
	LDI  R31,HIGH(65236)
	CALL SUBOPT_0x7
	__GETB2MN _sen,5
	LDI  R27,0
	LDI  R30,LOW(65236)
	LDI  R31,HIGH(65236)
	CALL SUBOPT_0x7
	__GETB2MN _sen,3
	LDI  R27,0
	LDI  R30,LOW(65086)
	LDI  R31,HIGH(65086)
	CALL SUBOPT_0x7
	LDS  R26,_sen
	LDI  R27,0
	LDI  R30,LOW(65036)
	LDI  R31,HIGH(65036)
	CALL SUBOPT_0x7
	__GETB2MN _sen,1
	LDI  R27,0
	LDI  R30,LOW(64936)
	LDI  R31,HIGH(64936)
	CALL SUBOPT_0x7
	__GETB2MN _sen,2
	LDI  R27,0
	LDI  R30,LOW(64836)
	LDI  R31,HIGH(64836)
	CALL __MULW12
	CALL SUBOPT_0x6
; 0000 0236         sum_r=(R_1*E_R_1)+(R_2*E_R_2)+(R_3*E_R_3)+(R_4*E_R_4)+(R_5*E_R_5)+(R_6*E_R_6)+(R_7*E_R_7)+(R_8*E_R_8)+(R_9*E_R_9 ...
	__ADDWRR 22,23,30,31
	__GETB2MN _sen,12
	LDI  R30,LOW(60)
	CALL SUBOPT_0x8
	__GETB2MN _sen,21
	LDI  R30,LOW(70)
	CALL SUBOPT_0x8
	__GETB2MN _sen,23
	LDI  R30,LOW(90)
	CALL SUBOPT_0x8
	__GETB2MN _sen,22
	LDI  R27,0
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x7
	__GETB2MN _sen,20
	LDI  R27,0
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x7
	__GETB2MN _sen,18
	LDI  R27,0
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	CALL SUBOPT_0x7
	__GETB2MN _sen,17
	LDI  R27,0
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x7
	__GETB2MN _sen,16
	LDI  R27,0
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CALL SUBOPT_0x7
	__GETB2MN _sen,19
	LDI  R27,0
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CALL __MULW12
_0x76:
	ADD  R30,R22
	ADC  R31,R23
	MOVW R18,R30
; 0000 0237 
; 0000 0238     }
; 0000 0239 
; 0000 023A     error=sum_r+sum_l;
	MOVW R30,R20
	ADD  R30,R18
	ADC  R31,R19
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 023B     if(L_1||R_1||L_2||R_2||L_3||R_3||L_4||R_4||L_5||R_5||L_6||R_6||L_7||R_7||L_8||R_8||L_9||R_9||L_10||R_10||L_11||R_11| ...
	__GETB1MN _sen,11
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,13
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,8
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,15
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,9
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,14
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,10
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,12
	CPI  R30,0
	BREQ PC+2
	RJMP _0x59
	__GETB1MN _sen,4
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,21
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,6
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,23
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,7
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,22
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,5
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,20
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,3
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,18
	CPI  R30,0
	BRNE _0x59
	LDS  R30,_sen
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,17
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,1
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,16
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,2
	CPI  R30,0
	BRNE _0x59
	__GETB1MN _sen,19
	CPI  R30,0
	BREQ _0x58
_0x59:
; 0000 023C         last_error=error;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STS  _last_error_S000000D000,R30
	STS  _last_error_S000000D000+1,R31
; 0000 023D     else
	RJMP _0x5B
_0x58:
; 0000 023E     {
; 0000 023F         error=last_error;
	LDS  R30,_last_error_S000000D000
	LDS  R31,_last_error_S000000D000+1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0240     }
_0x5B:
; 0000 0241     motor_speed=error*kp;
	__GETD1S 12
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	CALL __CFD1
	MOVW R16,R30
; 0000 0242 
; 0000 0243 //    lcd_clear();
; 0000 0244 //    lcd_put_int(motor_speed);
; 0000 0245 //    lcd_gotoxy(0,1);
; 0000 0246 //    lcd_put_int(error);
; 0000 0247     if(error==0)
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,0
	BRNE _0x5C
; 0000 0248         Stop();
	RCALL _Stop
; 0000 0249     else
	RJMP _0x5D
_0x5C:
; 0000 024A         Move(140-motor_speed,140+motor_speed);
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	SUB  R30,R16
	SBC  R31,R17
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	SUBI R26,LOW(-140)
	SBCI R27,HIGH(-140)
	RCALL _Move
; 0000 024B 
; 0000 024C 
; 0000 024D }
_0x5D:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
; .FEND
;void digitalize()
; 0000 024F {
_digitalize:
; .FSTART _digitalize
; 0000 0250     int i=0;
; 0000 0251     for(;i<24;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x5F:
	__CPWRN 16,17,24
	BRGE _0x60
; 0000 0252     {
; 0000 0253         if(ir_sensor[i]>BLACK)//ir_max_min_calibrate[0][i]-60)
	LDI  R26,LOW(_ir_sensor)
	LDI  R27,HIGH(_ir_sensor)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x79)
	BRLO _0x61
; 0000 0254             sen[i]=1;
	LDI  R26,LOW(_sen)
	LDI  R27,HIGH(_sen)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(1)
	RJMP _0x77
; 0000 0255         else
_0x61:
; 0000 0256             sen[i]=0;
	LDI  R26,LOW(_sen)
	LDI  R27,HIGH(_sen)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
_0x77:
	ST   X,R30
; 0000 0257     }
	__ADDWRN 16,17,1
	RJMP _0x5F
_0x60:
; 0000 0258 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void calibrate()
; 0000 025A {
; 0000 025B     int count=0;
; 0000 025C     unsigned char i=0;
; 0000 025D     for(i=0;i<24;i++)
;	count -> R16,R17
;	i -> R19
; 0000 025E     {
; 0000 025F          ir_max_min_calibrate[0][i]=40;
; 0000 0260          ir_max_min_calibrate[1][i]=40;
; 0000 0261     }
; 0000 0262     Go(50,50);
; 0000 0263     while(count<5)
; 0000 0264     {
; 0000 0265         for(i=0;i<24;i++)
; 0000 0266         {   int temp=0;
; 0000 0267             ReadMp();
;	temp -> Y+0
; 0000 0268             if(ir_sensor[i]>ir_max_min_calibrate[0][i])
; 0000 0269             {
; 0000 026A               ir_max_min_calibrate[0][i]=ir_sensor[i];
; 0000 026B             }
; 0000 026C             if(ir_sensor[i]<ir_max_min_calibrate[1][i])
; 0000 026D             {
; 0000 026E               ir_max_min_calibrate[1][i]=ir_sensor[i];
; 0000 026F             }
; 0000 0270 
; 0000 0271         }
; 0000 0272         count++;
; 0000 0273     }
; 0000 0274     Stop();
; 0000 0275     delay_ms(100);
; 0000 0276     Back(50,50);
; 0000 0277     count=0;
; 0000 0278     while(count<5)
; 0000 0279     {
; 0000 027A         for(i=0;i<24;i++)
; 0000 027B         {   int temp=0;
; 0000 027C             ReadMp();
;	temp -> Y+0
; 0000 027D             if(ir_sensor[i]>ir_max_min_calibrate[0][i])
; 0000 027E             {
; 0000 027F               ir_max_min_calibrate[0][i]=ir_sensor[i];
; 0000 0280             }
; 0000 0281             if(ir_sensor[i]<ir_max_min_calibrate[1][i])
; 0000 0282             {
; 0000 0283               ir_max_min_calibrate[1][i]=ir_sensor[i];
; 0000 0284             }
; 0000 0285 
; 0000 0286         }
; 0000 0287         count++;
; 0000 0288     }
; 0000 0289 
; 0000 028A //    for(i=0;i<24;i++)
; 0000 028B //    {
; 0000 028C //        my_put_int(i);
; 0000 028D //        my_putstr(":max:");
; 0000 028E //        my_put_int(ir_max_min_calibrate[0][i]);
; 0000 028F //        my_putstr("\t");
; 0000 0290 //        my_putstr("min:");
; 0000 0291 //        my_put_int(ir_max_min_calibrate[1][i]);
; 0000 0292 //        putchar('\n');
; 0000 0293 //    }
; 0000 0294 
; 0000 0295 
; 0000 0296     Stop();
; 0000 0297 
; 0000 0298 }
;//void my_put_int(int data)
;//{
;//    unsigned char f[50];
;//    sprintf(f,”%d”,data);
;//    my_putstr(f);
;//}
;//void my_putstr( char *f)
;//{
;//     int i=0;
;//      while(f[i]!=‘\0’)
;//      {
;//           putchar(f[i]);
;//           i++;
;//       }
;//}
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20A0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20A0001
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x9
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_ir_sensor:
	.BYTE 0x18
_sen:
	.BYTE 0x18
_ir_max_min_calibrate:
	.BYTE 0x30
_last_error_S000000D000:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3:
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	SUBI R17,-1
	SUBI R17,1
	SUBI R17,-1
	SUBI R17,1
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
	__GETB2MN _sen,11
	LDI  R27,0
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL __MULW12
	MOVW R22,R30
	__GETB2MN _sen,8
	LDI  R27,0
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	__GETB2MN _sen,9
	LDI  R27,0
	LDI  R30,LOW(65476)
	LDI  R31,HIGH(65476)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
	ADD  R30,R22
	ADC  R31,R23
	MOVW R20,R30
	__GETB2MN _sen,13
	LDI  R30,LOW(5)
	MUL  R30,R26
	MOVW R22,R0
	__GETB2MN _sen,15
	LDI  R30,LOW(15)
	MUL  R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	__GETB2MN _sen,14
	LDI  R30,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MUL  R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
