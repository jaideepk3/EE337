#include <at89c5131.h>
#include "endsem.h"

char S_str[6]= {0,0,0,0,0,0};   //String for Balance Sita
char G_str[6] = {0,0,0,0,0,0};  //String for Balance Gita
char n500_s[3]= {0,0,0};    // STRING FOR 500RS NOTE
char n100_s[3]= {0,0,0};    // STRING FOR 100RS NOTE

char password[5] = {0,0,0,0,0} ;   //PASSWORD ARRAY
//Main function

//-------------------------------------------------
void main(void)
{
	uart_init();            // Please finish this function in endsem.h 
	transmit_string("Press A for Account display and W for withdrawing cash\r\n");
	while (1)
    {
        /* code */
        // YOUR CODE GOES HERE
				ch = recieve_char();
				
				switch(ch)
				{
					case 'A' or 'a':transmit_string("Hello, Please enter Account Number\r\n");
											case '1':	transmit_string("Account Holder: Sita\r\nAccount Balance: ");
																transmit_char("S_str");
																transmit_string("/r/n");
											case '1':	transmit_string("Account Holder: Gita\r\nAccount Balance: ");
																transmit_char("G_str");
																transmit_string("/r/n");
	
											default:transmit_string("No such account, please enter valid details\r\n);
																break;
					case 'W' or 'w':transmit_string("Withdraw state, enter account number\r\n");
											case '1':	transmit_string("Account Holder: Sita\r\n");
																transmit_string("Account Balance: S_str\r\n");
																transmit_string("Enter Amount, in hundreds\r\n");
															  
											case '2':	transmit_string("Account Holder: Gita\r\n");
																transmit_string("Account Balance: G_str\r\n");
																break;
											
											default:transmit_string("No such account, please enter valid details\r\n);
																break;
    }
}


