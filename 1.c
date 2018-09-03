/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 8/30/2018
Author  :
Company :
Comments:


Chip type               : ATmega64
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

#include <mega64.h>
#include <delay.h>
#include <alcd.h>
#include <delay.h>
#include <stdlib.h>
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCH;
}

#define S_A PORTC.0
#define S_B PORTC.1
#define S_C PORTC.2

#define IN1 PORTB.4
#define IN2 PORTB.7

#define BLACK 120

#define R_12 sen[19]
#define R_11 sen[16]
#define R_10 sen[17]
#define R_9 sen[18]
#define R_8 sen[20]
#define R_7 sen[22]
#define R_6 sen[23]
#define R_5 sen[21]
#define R_4 sen[12]
#define R_3 sen[14]
#define R_2 sen[15]
#define R_1 sen[13]
#define L_1 sen[11]
#define L_2 sen[8]
#define L_3 sen[9]
#define L_4 sen[10]
#define L_5 sen[4]
#define L_6 sen[6]
#define L_7 sen[7]
#define L_8 sen[5]
#define L_9 sen[3]
#define L_10 sen[0]
#define L_11 sen[1]
#define L_12 sen[2]

#define SEN_R_12 ir_sensor[19]
#define SEN_R_11 ir_sensor[16]
#define SEN_R_10 ir_sensor[17]
#define SEN_R_9 ir_sensor[18]
#define SEN_R_8 ir_sensor[20]
#define SEN_R_7 ir_sensor[22]
#define SEN_R_6 ir_sensor[23]
#define SEN_R_5 ir_sensor[21]
#define SEN_R_4 ir_sensor[12]
#define SEN_R_3 ir_sensor[14]
#define SEN_R_2 ir_sensor[15]
#define SEN_R_1 ir_sensor[13]
#define SEN_L_1 ir_sensor[11]
#define SEN_L_2 ir_sensor[8]
#define SEN_L_3 ir_sensor[9]
#define SEN_L_4 ir_sensor[10]
#define SEN_L_5 ir_sensor[4]
#define SEN_L_6 ir_sensor[6]
#define SEN_L_7 ir_sensor[7]
#define SEN_L_8 ir_sensor[5]
#define SEN_L_9 ir_sensor[3]
#define SEN_L_10 ir_sensor[0]
#define SEN_L_11 ir_sensor[1]
#define SEN_L_12 ir_sensor[2]





#define E_R_1 5
#define E_R_2 15
#define E_R_3 60
#define E_R_4 60
#define E_R_5 70
#define E_R_6 90
#define E_R_7 450
#define E_R_8 450
#define E_R_9 550
#define E_R_10 550
#define E_R_11 550
#define E_R_12 550

#define E_L_1 -5
#define E_L_2 -15
#define E_L_3 -60
#define E_L_4 -60
#define E_L_5 -70
#define E_L_6 -90
#define E_L_7 -450
#define E_L_8 -450
#define E_L_9 -550
#define E_L_10 -550
#define E_L_11 -550
#define E_L_12 -550


unsigned char ir_sensor[24];
unsigned char sen[24];
unsigned char black[24];
unsigned char ir_max_min_calibrate[2][24];
unsigned int counter_speed=0;
int MAX_STRAIGHT=160;
int MAX_TURN=210;


void ReadMp();
void Back(unsigned char motor_r_speed,unsigned char motor_l_speed);
void Left(unsigned char motor_r_speed,unsigned char motor_l_speed);
void Right(unsigned char motor_r_speed,unsigned char motor_l_speed);
void Go(unsigned char motor_r_speed,unsigned char motor_l_speed);
void Move(int motor_r_speed,int motor_l_speed);
void Stop();
void lcd_put_int(int Data);
void lcd_show_sensor();
void init();
void digitalize();
void my_put_int(int data);
void my_putstr( char *f);
void controller(char f);
void calibrate();
int Inverse_is_black();




void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Port E initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

// Port F initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

// Port G initialization
// Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
// State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0<<AS0;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 125.000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inverted PWM
// OC1B output: Non-Inverted PWM
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 2.048 ms
// Output Pulse(s):
// OC1A Period: 2.048 ms Width: 0 us// OC1B Period: 2.048 ms Width: 0 us
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Disconnected
// OC3B output: Disconnected
// OC3C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);

// USART0 initialization
// USART0 disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// USART1 initialization
// USART1 disabled
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 125.000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);
//mp-----
DDRC.0=1;
DDRC.1=1;
DDRC.2=1;
//------
//---motor
DDRB.4=1;
DDRB.7=1;
//-----

init();
//calibrate();
    while (1)
    {
        ReadMp();
        if(Inverse_is_black())//if bc was black
        {
            controller(1);
        }
        else
        {
            controller(0);
        }
   //       lcd_show_sensor();
 //       ReadMp();



    }
}
void init()
{
    lcd_clear();
//    Back(200,200);
//    delay_ms(1000);
//    Right(100,100);
//    delay_ms(1000);
//    Left(100,100);
//    delay_ms(1000);
//    Stop();
//    lcd_putsf("salam");
//    delay_ms(1000);
//    lcd_clear();
}
int Inverse_is_black()
{
    int black_counter=0;
    int i=0;
    for(i=0;i<24;i++)
    {
        if(sen[i])
            black_counter++;
    }
    if(black_counter>=12)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
void ReadMp()
{
    static unsigned int ir_sensor_back[24];
    unsigned char i=0;
    for(;i<8;i++)
    {
        S_A=i%2;
        S_B=(i%4)/2;
        S_C=(i%8)/4;
        i++;
        i--;
        i++;
        i--;

        ir_sensor[i]=read_adc(0);
    }
    i=0;
    for(;i<8;i++)
    {
        S_A=i%2;
        S_B=(i%4)/2;
        S_C=(i%8)/4;
        i++;
        i--;
        i++;
        i--;

        ir_sensor[i+8]=read_adc(1);
    }
    i=0;
    for(;i<8;i++)
    {
        S_A=i%2;
        S_B=(i%4)/2;
        S_C=(i%8)/4;
        i++;
        i--;
        i++;
        i--;
        ir_sensor[i+16]=read_adc(2);
    }
    digitalize();

}
void Back(unsigned char motor_r_speed,unsigned char motor_l_speed)
{
    IN1=1;
    IN2=0;

    OCR1AH=0x00;
    OCR1AL=255-motor_l_speed;

    OCR1BH=0x00;
    OCR1BL=motor_r_speed;
}
void Right(unsigned char motor_r_speed,unsigned char motor_l_speed)
{
    IN1=0;
    IN2=0;

    OCR1AH=0x00;
    OCR1AL=motor_l_speed;

    OCR1BH=0x00;
    OCR1BL=motor_r_speed;
}
void Left(unsigned char motor_r_speed,unsigned char motor_l_speed)
{
    IN1=1;
    IN2=1;

    OCR1AH=0x00;
    OCR1AL=255-motor_l_speed;

    OCR1BH=0x00;
    OCR1BL=255-motor_r_speed;
}
void Go(unsigned char motor_r_speed,unsigned char motor_l_speed)
{
    IN1=0;
    IN2=1;

    OCR1AH=0x00;
    OCR1AL=motor_l_speed;

    OCR1BH=0x00;
    OCR1BL=255-motor_r_speed;
}
void Stop()
{
    IN1=0;
    IN2=0;

    OCR1AH=0x00;
    OCR1AL=0;

    OCR1BH=0x00;
    OCR1BL=0;
}
void Move(int motor_r_speed,int motor_l_speed)
{
    if(motor_r_speed<0)
    {
        if(motor_r_speed<(-1*(MAX_TURN)))
            motor_r_speed=-1*(MAX_TURN);
        if(motor_l_speed>MAX_TURN)
            motor_l_speed=MAX_TURN;
    }
    else if(motor_l_speed<0)
    {
        if(motor_l_speed<(-1*(MAX_TURN)))
            motor_l_speed=-1*(MAX_TURN);
        if(motor_r_speed>MAX_TURN)
            motor_r_speed=MAX_TURN;
   }
   else
   {
        if(motor_r_speed>MAX_STRAIGHT)
            motor_r_speed=MAX_STRAIGHT;
        if(motor_l_speed>MAX_STRAIGHT)
            motor_l_speed=MAX_STRAIGHT;
   }



    if(motor_r_speed>=0&&motor_l_speed>=0)
       Go(motor_r_speed,motor_l_speed);
    else if(motor_r_speed<=0&&motor_l_speed>=0)
        Right(motor_r_speed*-1,motor_l_speed);
    else if(motor_r_speed>=0&&motor_l_speed<=0)
        Left(motor_r_speed,motor_l_speed*-1);
    else
        Back(motor_r_speed*-1,motor_r_speed*-1);
}
void lcd_put_int(int Data)
{
    unsigned char f[50];
    itoa(Data,f);
    lcd_puts(f);
}
void lcd_show_sensor()
{
    lcd_clear();
    ReadMp();

    lcd_put_int(R_1);
    lcd_put_int(L_1);
    lcd_put_int(R_2);
    lcd_put_int(L_2);
    lcd_put_int(R_3);
    lcd_put_int(L_3);
    lcd_put_int(R_4);
    lcd_put_int(L_4);
    lcd_put_int(R_5);
    lcd_put_int(L_5);
    lcd_put_int(R_6);
    lcd_put_int(L_6);
    lcd_put_int(R_7);
    lcd_put_int(L_7);
    lcd_put_int(R_8);
    lcd_put_int(L_8);
    lcd_put_int(R_9);
    lcd_put_int(L_9);
    lcd_put_int(R_10);
    lcd_put_int(L_10);
    lcd_put_int(R_11);
    lcd_put_int(L_11);
    lcd_put_int(R_12);
    lcd_put_int(L_12);



    delay_ms(200);


}
void controller(char f)
{
    static int last_error=0;
    float kp=.6;
    int motor_speed=0;
    int sum_r=0;
    int sum_l=0;
    int error=0;
    int m_r=0;
    int m_l=0;
    if(f)//if bg was black
    {
        int i=0;
        for(;i<24;i++)
        {
            if(ir_sensor[i]<BLACK)//ir_max_min_calibrate[0][i]-60)
                sen[i]=1;
            else
                sen[i]=0;
        }

    }
    else//bg is white
    {
    }
    if(R_1||R_2||L_2||R_2||L_3||R_3)
    {
        last_error=0;
        sum_l=(L_1*E_L_1)+(L_2*E_L_2)+(L_3*E_L_3);
        sum_r=(R_1*E_R_1)+(R_2*E_R_2)+(R_3*E_R_3);
        counter_speed+=1;
    }
    else
    {
        sum_l=(L_1*E_L_1)+(L_2*E_L_2)+(L_3*E_L_3)+(L_4*E_L_4)+(L_5*E_L_5)+(L_6*E_L_6)+(L_7*E_L_7)+(L_8*E_L_8)+(L_9*E_L_9)+(L_10*E_L_10)+(L_11*E_L_11)+(L_12*E_L_12);
        sum_r=(R_1*E_R_1)+(R_2*E_R_2)+(R_3*E_R_3)+(R_4*E_R_4)+(R_5*E_R_5)+(R_6*E_R_6)+(R_7*E_R_7)+(R_8*E_R_8)+(R_9*E_R_9)+(R_10*E_R_10)+(R_11*E_R_11)+(R_12*E_R_12);
        counter_speed=0;
    }

    error=sum_r+sum_l;
    if(L_1||R_1||L_2||R_2||L_3||R_3||L_4||R_4||L_5||R_5||L_6||R_6||L_7||R_7||L_8||R_8||L_9||R_9||L_10||R_10||L_11||R_11||L_12||R_12)
        last_error=error;
    else
    {
        error=last_error;
        if((last_error<299&&last_error>0)||(last_error>-299&&last_error<0))
            error=0;

    }
    motor_speed=error*kp;

//    lcd_clear();
//    lcd_put_int(motor_speed);
//    lcd_gotoxy(0,1);
//    lcd_put_int(error);
//    if(error==0&&(!(R_1||R_2||L_2||R_2||L_3||R_3||L_4||R_4||L_5||R_5||L_6||R_6)))
//        Stop();
//    else

    Move((MAX_STRAIGHT-motor_speed),(MAX_STRAIGHT+motor_speed));
   if(counter_speed>20)
   {
    counter_speed=20;
   }

}
void digitalize()
{
    int i=0;
    for(;i<24;i++)
    {
        if(ir_sensor[i]>BLACK)//ir_max_min_calibrate[0][i]-60)
            sen[i]=1;
        else
            sen[i]=0;
    }
}
void calibrate()
{
    int count=0;
    unsigned char i=0;
    for(i=0;i<24;i++)
    {
         ir_max_min_calibrate[0][i]=40;
         ir_max_min_calibrate[1][i]=40;
    }
    Go(50,50);
    while(count<5)
    {
        for(i=0;i<24;i++)
        {   int temp=0;
            ReadMp();
            if(ir_sensor[i]>ir_max_min_calibrate[0][i])
            {
              ir_max_min_calibrate[0][i]=ir_sensor[i];
            }
            if(ir_sensor[i]<ir_max_min_calibrate[1][i])
            {
              ir_max_min_calibrate[1][i]=ir_sensor[i];
            }

        }
        count++;
    }
    Stop();
    delay_ms(100);
    Back(50,50);
    count=0;
    while(count<5)
    {
        for(i=0;i<24;i++)
        {   int temp=0;
            ReadMp();
            if(ir_sensor[i]>ir_max_min_calibrate[0][i])
            {
              ir_max_min_calibrate[0][i]=ir_sensor[i];
            }
            if(ir_sensor[i]<ir_max_min_calibrate[1][i])
            {
              ir_max_min_calibrate[1][i]=ir_sensor[i];
            }

        }
        count++;
    }

//    for(i=0;i<24;i++)
//    {
//        my_put_int(i);
//        my_putstr(":max:");
//        my_put_int(ir_max_min_calibrate[0][i]);
//        my_putstr("\t");
//        my_putstr("min:");
//        my_put_int(ir_max_min_calibrate[1][i]);
//        putchar('\n');
//    }


    Stop();

}
//void my_put_int(int data)
//{
//    unsigned char f[50];
//    sprintf(f,�%d�,data);
//    my_putstr(f);
//}
//void my_putstr( char *f)
//{
//     int i=0;
//      while(f[i]!=�\0�)
//      {
//           putchar(f[i]);
//           i++;
//       }
//}
