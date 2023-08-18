#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code 

sbit LED=P1^7;
sbit s1=P1^0;
sbit s2=P1^1;
sbit s3=P1^2;
sbit s4=P1^3;

/*
Port P0.7 is used for the audio signal output
*/	
//Main function

void main()
{ 
	P1 = 0x0F ;
	while(1) {
	if (s1==1) {	
		//Call initialization functions
		lcd_init();
		msdelay(1);
		lcd_cmd(0x86);
		msdelay(1);
		lcd_write_string("A");
		msdelay(1);
		morse_a();
	}
	else if (s2==1){
		lcd_init();
		msdelay(1);
		lcd_cmd(0x86);
		msdelay(1);
		lcd_write_string("B");
		msdelay(1);
		morse_b();
	}
	else if (s3==1){
		lcd_init();
		msdelay(1);
		lcd_cmd(0x86);
		msdelay(1);
		lcd_write_string("C");
		msdelay(1);
		morse_c();
	}
	else if (s4==1){
		lcd_init();
		msdelay(1);
		lcd_cmd(0x86);
		msdelay(1);
		lcd_write_string("D");
		msdelay(1);
		morse_d();
	}
	else{
		lcd_init();
		msdelay(1);
		lcd_cmd(0x86);
		msdelay(1);
		lcd_write_string("E");
		msdelay(1);
		morse_e();
	}
	
	// For stopping the input
	PCON |=1;
	
}
  }
	// Read input nibble here
	
	
	
	// Insert Priority Logic
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h
	// Write to LCD using function lcd_write_string() in side the condition as well
	
	
	// 
	
	

