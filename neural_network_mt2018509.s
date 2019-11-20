     AREA     appcode, CODE, READONLY
     EXPORT __main
		IMPORT printMsg
	 IMPORT printMsg2p
	 IMPORT printMsg4p 
     ENTRY
;Registers s20,s21 and s22 hold the input bits a,b and c respectively
;inputs a and b are used to calculate the argument to the sigmoid function incase of a not gate. c is ignored.
__main  FUNCTION
	 VLDR.F32 s20,=1;input a
	 VLDR.F32 s21,=1;input b
	 VLDR.F32 s22,=0;input c
	 VCVT.U32.F32 s23,s20
	 VCVT.U32.F32 s24,s21
	 VCVT.U32.F32 s25,s22
	 
	 VLDR.F32 s29,=0.5
	 B and1
ret	 B or
ret1 B not
ret2 B nand
ret3 B nor


stop B stop

check  VCMP.F32 s12,s29
	   vmrs    APSR_nzcv, FPSCR
	   BGT one
	   VLDR.F32 s4,=0
check1 VCVT.U32.F32 s4,s4
	   VMOV.F32 r0,s23
	   VMOV.F32 r1,s24
	   VMOV.F32 r2,s25
	   VMOV.F32 r3,s4
       BX lr

one  VLDR.F32 s4,=1
     B check1

and1 VLDR.F32 s0,=-0.1
     VLDR.F32 s1,=0.2
	 VLDR.F32 s2,=0.2
	 VLDR.F32 s3,=-0.2
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3
	 BL calc
	 MOV r0,#0
	 BL printMsg
	 BL check
	 BL printMsg4p
	 B ret
	
or   VLDR.F32 s0,=-0.1
     VLDR.F32 s1,=0.7
	 VLDR.F32 s2,=0.7
	 VLDR.F32 s3,=-0.1
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3
	 BL calc
	 MOV r0,#1
	 BL printMsg
	 BL check
	 BL printMsg4p
	 B ret1
	
not  VLDR.F32 s0,=0.5
     VLDR.F32 s1,=-0.7
	 VLDR.F32 s2,=0
	 VLDR.F32 s3,=0.1
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3
	 BL calc
	 MOV r0,#2
	 BL printMsg
	 BL check
	 BL printMsg4p
	 B ret2;BX lr
	
nand VLDR.F32 s0,=0.6
     VLDR.F32 s1,=-0.8
	 VLDR.F32 s2,=-0.8
     VLDR.F32 s3,=0.3
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3
	 BL calc
	 MOV r0,#3
	 BL printMsg
	 BL check
	 BL printMsg4p
	 B ret3
	 
nor  VLDR.F32 s0,=0.5
     VLDR.F32 s1,=-0.7
	 VLDR.F32 s2,=-0.7
	 VLDR.F32 s3,=0.1
	 VMUL.F32 s0,s0,s20
	 VMUL.F32 s1,s1,s21
	 VMUL.F32 s2,s2,s22
	 VADD.F32 s0,s0,s1
	 VADD.F32 s0,s0,s2
	 VADD.F32 s3,s0,s3
	 BL calc
	 MOV r0,#4
	 BL printMsg
	 BL check
	 BL printMsg4p
	 B stop
	 

calc VLDR.F32 s6,=30;Number of series terms required
	 VLDR.F32 s5,=1
	 VLDR.F32 s8,=0
	 VLDR.F32 s9,=0
	 VLDR.F32 s13,=-1
	 VMUL.F32 s3,s3,s13
sign VLDR.F32 s7,=1
     VMOV.F32 s10,s8
loop VCMP.F32 s8, #0
     vmrs    APSR_nzcv, FPSCR
     BEQ next
     VMUL.F32 s7,s8,s7
     VSUB.F32 s8,s8,s5
     B loop
	 
next VMOV.F32 s8,s10
     VLDR.F32 s5,=1
	 VLDR.F32 s4,=1
	 VCMP.F32 s8,#0
	 vmrs    APSR_nzcv, FPSCR
	 BEQ new
	 
term VMUL.F32 s4,s4,s3;
     VSUB.F32 s8,s8,s5
	 VCMP.F32 s8,#0
	 vmrs    APSR_nzcv, FPSCR
	 BGT term
	 
new  VDIV.F32 s4,s4,s7
     VADD.F32 s9,s4,s9
	 VMOV.F32 s8,s10
	 VADD.F32 s8,s8,s5
	 VCMP.F32 s8,s6
	 vmrs    APSR_nzcv, FPSCR
	 BLT sign
	 
     ;BX lr
	 
func VLDR.F32 s11,=1
     VADD.F32 s12,s11,s9
	 VDIV.F32 s12,s11,s12
	 BX lr
     ENDFUNC
     END 