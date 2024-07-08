Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ALU IS
PORT( A,B: IN std_logic_vector (31 DOWNTO 0);
		        sel : IN std_logic_vector (3 DOWNTO 0);
                        Cout,Negout,Zeroout,Overflowout : OUT std_logic; --Carry,negative,zero,OverFlow
                        NOSETCarry,NOSETNeg,NOSETZero,NOSETOVERFLOW : In std_logic; 
			ALUout1: OUT std_logic_vector (31 DOWNTO 0);
			ALUout2: OUT std_logic_vector (31 DOWNTO 0);
			AlU_MEM_ADDRESS : OUT std_logic_vector (31 DOWNTO 0)
			
);
END ENTITY ALU ;
ARCHITECTURE MyALU OF ALU IS

Signal Outwthcarry : std_logic_vector(32 downto 0);
signal extendedA,extendedb:std_logic_vector(32 downto 0);
--signal tempb:std_logic_vector(32 downto 0);

Begin

extendedA<='0' & A(31 DOWNTO 0);
extendedb<='0' & b(31 DOWNTO 0);
--tempa<=extendeda;

Outwthcarry <= NOT extendedA when sel="1110" --NOT

else std_logic_vector(unsigned(extendedA) + "000000000000000000000000000000001") when sel="0001" --INC
else std_logic_vector(unsigned(extendedA) - "000000000000000000000000000000001") when sel="0010" --DEC
else extendedA     when sel="0011"  --MOV
else extendedb	   when sel="1100" --SWAP
else std_logic_vector(unsigned(extendedA) + unsigned(extendedb))  when sel="0100" --ADD
else std_logic_vector(unsigned(extendedA) - unsigned(extendedb))  when sel="0101" --SUB
else extendedA AND extendedb when sel="0110" --AND
else extendedA OR extendedb  when sel="0111" --OR
else extendedA XOR extendedb  when sel="1101" --XOR
else std_logic_vector(unsigned(extendedA) - unsigned(extendedb))  when sel="1111" --CMP
else extendedb when sel="1011" --LDM

else std_logic_vector("000000000000000000000000000000000"-unsigned(extendedA) ) when sel="1001" --NEG
else "000000000000000000000000000000010"; --Otherwise


aluout1<=Outwthcarry(31 downto 0);

aluout2<=A when sel = "1100"

else"00000000000000000000000000000000";


AlU_MEM_ADDRESS <=Outwthcarry(31 DOWNTO 0);  --3aizen n3ml exception el wrong address



-------------------------------------------------------------------------------------------
Cout <= Outwthcarry(32) when sel="0001" or sel="0010" or sel="0100" or sel="0101" or sel="1001"   --INC DEC ADD/ADDI SUB/SUBI NEG CMP
else NOSETCarry; --No change to flags

Negout <= '1' when (sel="1110" or sel="0001" or sel="0010" or sel="0100" or sel="0101" or sel="0110" or sel="0111" or sel="1101" or sel="1111")AND (to_integer(signed(Outwthcarry(31 downto 0))) < 0) -- its out is neg
else '0'      when (sel="1110" or sel="0001" or sel="0010" or sel="0100" or sel="0101" or sel="0110" or sel="0111" or sel="1101" or sel="1111" ) AND (to_integer(signed(Outwthcarry(31 downto 0))) >= 0)   -- its out is pos 
else NOSETNEG;

Zeroout <= '1'  when (sel="1110" or sel="0001" or sel="0010" or sel="0100" or sel="0101" or sel="0110" or sel="0111"  or sel="1101" or sel="1111") AND Outwthcarry(31 downto 0) ="00000000000000000000000000000000" -- its out = 0
else '0'  when (sel="1110" or sel="0001" or sel="0010" or sel="0100" or sel="0101" or sel="0110" or sel="0111" or sel="1101" or sel="1111")  AND Outwthcarry(31 downto 0) /= "00000000000000000000000000000000" --its out != 0
else '0'  when sel="1100"  --JZ to reset zero flag
else NOSETZero;

Overflowout<='1' when (sel="0001" or sel="0100") and to_integer(signed(Outwthcarry(31 downto 0))) < 0 and to_integer(signed(extendeda(31 downto 0)))>0 and to_integer(signed(extendedb(31 downto 0)))>0
else '1' when (sel="0001" or sel="0100") and to_integer(signed(Outwthcarry(31 downto 0))) > 0 and to_integer(signed(extendeda(31 downto 0)))<0 and to_integer(signed(extendedb(31 downto 0)))<0
else '1' when (sel="0010" or sel="0101" or sel="1001" ) and to_integer(signed(extendeda(31 downto 0)))>0 and to_integer(signed(extendedb(31 downto 0)))<0
else '1' when (sel="0010" or sel="0101" or sel="1001" ) and to_integer(signed(extendeda(31 downto 0)))<0 and to_integer(signed(extendedb(31 downto 0)))>0
else '0' when (sel="0001" or sel="0100" or  sel="0010" or sel="0101" or sel="1001" or sel="1111")
else NOSETOverflow;

end MyALU;