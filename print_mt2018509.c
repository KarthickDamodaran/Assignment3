
#include "stm32f4xx.h"
#include <string.h>
void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	if(a==0)
	{
	 sprintf(Msg, "\nAnd Gate");
	 ptr = Msg ;
	}
	if(a==1)
	{
	 sprintf(Msg, "\nOr Gate");
	 ptr = Msg ;
	}
	if(a==2)
	{
	 sprintf(Msg, "\nNot Gate");
	 ptr = Msg ;
	}
	if(a==3)
	{
	 sprintf(Msg, "\nNand Gate");
	 ptr = Msg ;
	}
	if(a==4)
	{
	 sprintf(Msg, "\nNor Gate");
	 ptr = Msg ;
	}
	
	if(a==5)
	{
	 sprintf(Msg, "\nXnor Gate");
	 ptr = Msg ;
	}
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
void printMsg2p(const int a, const int b)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "\n%d", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 sprintf(Msg, " %d", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void printMsg4p(const int a, const int b, const int c, const int d, const int e)
{
	 char Msg[100];
	 char *ptr;
	 // Printing the message
	sprintf(Msg,"\na   b   c   y\n");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 //Printing the first parameter
	 sprintf(Msg, "%d   ", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 // Printing the message
	 //sprintf(Msg,"x1: ");
	 //ptr = Msg ;
   //while(*ptr != '\0')
	 //{
     // ITM_SendChar(*ptr);
      //++ptr;
   //}
	 sprintf(Msg, "%d   ", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 // Printing the message
	 /*sprintf(Msg,"x2: ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 if(c!=2)
	 {
	 sprintf(Msg, "%d   ", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
 }
	 // Printing the message
	 /*sprintf(Msg,"output: ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
	 sprintf(Msg, "%d", d);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
	 }

	 // Printing the message
	 /*sprintf(Msg,"\nPrinting Fifth parameter e (check this value is correct or not): ");
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }

	  sprintf(Msg, "%x", e);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }*/
}

