     AREA     appcode, CODE, READONLY
     EXPORT __main
		IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p 
     ENTRY
;Registers s20,s21 and s22 hold the input bits a,b and c respectively
;For a not gate, only inputs a and b are used to calculate the argument to the sigmoid function. c is ignored.
;For a given input vector, the output will be printed on the terminal
__main  FUNCTION
	 VLDR.F32 s20,=1;input a in s20
	 VLDR.F32 s21,=0;input b in s21
	 VLDR.F32 s22,=1;input c in s22
	 VCVT.U32.F32 s23,s20;conversion for printing and moving 'a' to s23
	 VCVT.U32.F32 s24,s21;conversion for printing and moving 'b' to s24
	 VCVT.U32.F32 s25,s22;conversion for printing and moving 'c' to s25
	 
	 VLDR.F32 s29,=0.5;To decide logic values depending on output from neural network. If output>0.5 considered logic 1, else a logic 0
	 B and1;Branches to and gate neural network
ret	 B or;Branches to or gate neural network
ret1 B not;Branches to not gate neural network
ret2 B nand;Branches to nand gate neural network
ret3 B nor;Branches to nor gate neural network


stop B stop;Halts

;subroutine check1 is used to assign a logic 1 or a logic 0 to the final output, depending on the output from the sigmoid function
check  VCMP.F32 s12,s29 ;checking if s12>0.5, s29 is initialised with 0.5
	   vmrs    APSR_nzcv, FPSCR
	   BGT one ;if s12>0.5 is true, branches to make final output as logic 1
	   VLDR.F32 s4,=0;if s12>0.5 is false, final output is a logic 0
check1 VCVT.U32.F32 s4,s4;conversion for printing. s4 has the final logic gate output value
	   VMOV.F32 r0,s23;moving the value of 'a' into r0 to print
	   VMOV.F32 r1,s24;moving the value of 'b' into r1 to print
	   VMOV.F32 r2,s25;moving the value of 'c' into r2 to print
	   VMOV.F32 r3,s4;moving the value of 'd' into r3 to print
       BX lr;returns to the calling function. printmsg4p will be called after returning to print the above values

one  VLDR.F32 s4,=1;if s12>0.5 is true, branches to make final output as logic 1
     B check1;branches back to check1 to perform the further required things to print
	 
	 ;In the following code, registers s0,s1 & s2 hold the weights for inputs a,b & c respectively;s3 holds the bias
;z=wa*a+wb*b+wc*c+bias is calculated and stored in s3 register
and1 VLDR.F32 s0,=-0.1;wa
     VLDR.F32 s1,=0.2;wb
	 VLDR.F32 s2,=0.2;wc
	 VLDR.F32 s3,=-0.2;bias
	 VMUL.F32 s0,s0,s20;wa*a calculated
	 VMUL.F32 s1,s1,s21;wb*b calculated
	 VMUL.F32 s2,s2,s22;wc*c calculated
	 VADD.F32 s0,s0,s1;wa*a+wb*b calculated
	 VADD.F32 s0,s0,s2;wa*a+wb*b+wc*c calculated
	 VADD.F32 s3,s0,s3;wa*a+wb*b+wc*c+bias is calculated
	 BL calc;calling the subroutine to calculate the sigmoid function value;z is stored in s3 
	 MOV r0,#0;r0 used as an identifier for the logic gate to print the logic gate name in printMsg function
	 BL printMsg;called to print the logic gate name and input output names
	 BL check;called to assign logic 1 or logic 0 to output
	 BL printMsg4p;called to print the input output values
	 B ret;returns to move to next gate
	
or   VLDR.F32 s0,=-0.1;wa
     VLDR.F32 s1,=0.7;wb
	 VLDR.F32 s2,=0.7;wc
	 VLDR.F32 s3,=-0.1;bias
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3;z value
	 BL calc;calling the subroutine to calculate the sigmoid function value;z is stored in s3
	 MOV r0,#1;r0 used as an identifier for the logic gate to print the logic gate name in printMsg function
	 BL printMsg;called to print the logic gate name and input output names
	 BL check;called to assign logic 1 or logic 0 to output
	 BL printMsg4p;called to print the input output values
	 B ret1;returns to move to next gate
	
not  VLDR.F32 s0,=0.5;wa
     VLDR.F32 s1,=-0.7;wb
	 VLDR.F32 s2,=0
	 VLDR.F32 s3,=0.1;bias
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3;z value
	 BL calc;calling the subroutine to calculate the sigmoid function value;z is stored in s3
	 MOV r0,#2;r0 used as an identifier for the logic gate to print the logic gate name in printMsg function
	 BL printMsg;called to print the logic gate name and input output names
	 BL check;called to assign logic 1 or logic 0 to output
	 BL printMsg4p;called to print the input output values
	 B ret2;returns to move to next gate
	
nand VLDR.F32 s0,=0.6;wa
     VLDR.F32 s1,=-0.8;wb
	 VLDR.F32 s2,=-0.8;wc
     VLDR.F32 s3,=0.3;bias
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3;z value
	 BL calc;calling the subroutine to calculate the sigmoid function value;z is stored in s3
	 MOV r0,#3;r0 used as an identifier for the logic gate to print the logic gate name in printMsg function
	 BL printMsg;called to print the logic gate name and input output names
	 BL check;called to assign logic 1 or logic 0 to output
	 BL printMsg4p;called to print the input output values
	 B ret3;returns to move to next gate
	 
nor  VLDR.F32 s0,=0.5;wa
     VLDR.F32 s1,=-0.7;wb
	 VLDR.F32 s2,=-0.7;wc
	 VLDR.F32 s3,=0.1;bias
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3;z value
	 BL calc;calling the subroutine to calculate the sigmoid function value;z is stored in s3
	 MOV r0,#4;r0 used as an identifier for the logic gate to print the logic gate name in printMsg function
	 BL printMsg;called to print the logic gate name and input output names
	 BL check;called to assign logic 1 or logic 0 to output
	 BL printMsg4p;called to print the input output values
	 B stop;Branches to stop as all logic gates are done
	 
	 
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
