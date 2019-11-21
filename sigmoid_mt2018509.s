     AREA     appcode, CODE, READONLY
     EXPORT __main
		IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p 
     ENTRY
	 ;output result of the sigmoid function is available in s12 register
__main  FUNCTION
	 VLDR.F32 s3,=-5;input to sigmoid function i.e z value
	 BL calc;calling the subroutine to calculate sigmoid 
	 ;exp(-z) is available in s9 register
	 ;output result of the sigmoid function is available in s12 register

stop B stop;Halts

	 
;This is the subroutine to calculate the sigmoid function value
calc VLDR.F32 s6,=30;Number of series terms required in e^x series
	 VLDR.F32 s5,=1
	 VLDR.F32 s8,=0
	 VLDR.F32 s9,=0
	 VLDR.F32 s13,=-1;Used to multiply z by -1 and hence to calculate exp(-z)
	 VMUL.F32 s3,s3,s13;(-z is stored in the s3 register)
sign VLDR.F32 s7,=1; s7 holds the factorial result;initialised with a 1 as 0!=1
     VMOV.F32 s10,s8; storing the 'n' value in s10 to retrieve it later. n denotes the iteration count and n>=0
loop VCMP.F32 s8, #0   ; This loop computes the factorial and stores in s7 the factorial result
     vmrs    APSR_nzcv, FPSCR
     BEQ next; if the number 'n' to be computed factorial is a 0, s7 is undisturbed and the control jumps to calculate x^n
     VMUL.F32 s7,s8,s7;if non zero 'n' s7=s8*s7
     VSUB.F32 s8,s8,s5;s8=s8-1, decrementing s8 to repeat the loop
     B loop; repeats the process till factorial is computed
	 
	 ;In the following discussion x=-z;
	 
next VMOV.F32 s8,s10;retreiving the current iteration count 'n' for x^n calculation
     VLDR.F32 s5,=1;used for decrementing purposes
	 VLDR.F32 s4,=1;holds x^n and is initialised to 1 as x^0=1
	 VCMP.F32 s8,#0;if n=0,x^n=1 and hence s4 register which holds x^n initialised to 1 is undisturbed
	 vmrs    APSR_nzcv, FPSCR
	 BEQ new
	 
term VMUL.F32 s4,s4,s3;s4=s4*s3 is repeated n times, with s4=1 as initial value, we get s4=x^n  
     VSUB.F32 s8,s8,s5;decrementing s8 to keep track of the count
	 VCMP.F32 s8,#0
	 vmrs    APSR_nzcv, FPSCR
	 BGT term
	 
new  VDIV.F32 s4,s4,s7;Here,s4={(x^n)/n!} is performed i.e series terms are computed
     VADD.F32 s9,s4,s9;s9 is initialised with a 0 and the series terms are accumulated in s9
	 VMOV.F32 s8,s10;retreiving iteration count
	 VADD.F32 s8,s8,s5;incrementing iteration count
	 VCMP.F32 s8,s6;comparing it against the required series terms
	 vmrs    APSR_nzcv, FPSCR
	 BLT sign;if the required number of series terms not computed and accumulated, the computation of the next series term happens
	 
     ;BX lr
	 ;the following routine uses the e^x i.e exp(-z) calculated above(which is available in s9) and computes the sigmoid function value
func VLDR.F32 s11,=1
     VADD.F32 s12,s11,s9;denominator = 1+exp(-z)
	 VDIV.F32 s12,s11,s12;function value calculated 1/(1+exp(-z))
	 BX lr;returns to the main function
     ENDFUNC
     END 
