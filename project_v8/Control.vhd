LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Control IS 
GENERIC (n : integer := 1);
    PORT(   	
		OpCode : IN std_logic_vector(5 DOWNTO 0);

		ALUSelectors : OUT std_logic_vector(3 DOWNTO 0);
		AlUSrc : OUT std_logic;
		MWrite, MRead: out std_logic;
		
		RegWrite : OUT std_logic_vector(1 DOWNTO 0);
		WriteBackDataSrc : OUT std_logic_vector(1 downto 0);--el mux el a5rany 3shan a WB (memory value,inport,alu)

		ImmSig : OUT std_logic;

		MemWrite_PF : OUT std_logic;
		MemRead_PF : OUT std_logic;
		datain_PF   : OUT std_logic_vector(n-1 DOWNTO 0);
		SP_Signal : OUT std_logic_vector(1 DOWNTO 0);
		OUT_Enable : OUT std_logic;
		FLAGS_Enable : OUT std_logic
		
);
END Control;

ARCHITECTURE My_Control OF Control IS

BEGIN

with OpCode select 
                RegWrite <=
                    "00" when "001011", --CMP
		    "00" when "000000", --NOP
                    "01" when "110000", --NOT
		    "01" when "000001", --NEG
		    "01" when "000010", --INC
		    "01" when "000011", --DEC
		    "01" when "000100", --MOV
		    "11" when "000101", --SWAP
		    "01" when "000110", --ADD
		    "01" when "000111", --SUB
		    "01" when "001000", --AND
		    "01" when "001001", --OR
		    "01" when "001010", --XOR
		    "01" when "110101", --LDM
	       	    "01" when "010010", --LDD
		    "01" when "110011", --ADDI
		    "01" when "110100", --SUBI
		    "01" when "010011", --POP
		    "01" when "101010", --IN-PORT
                    "10" when others;

with OpCode select 
                ALUSelectors <=
		"1110" when "110000", --NOT
		"1010" when "000000", --NOP
		"1001" when "000001", --NEG
		"0001" when "000010", --INC
		"0010" when "000011", --DEC
		"0011" when "000100", --MOV
		"1100" when "000101", --SWAP
		"0100" when "000110", --ADD
		"0101" when "000111", --SUB
		"0110" when "001000", --AND
		"0111" when "001001", --OR
		"1101" when "001010", --XOR
		"1111" when "001011", --CMP
		"1011" when "110101", --LDM
		"0100" when "110011", --ADDI
		"0101" when "110100", --SUBI
		"0100" when "010010", --LDD
		"0100" when "010001", --STD (LDD and STD need to calculate effective address)
		"1000" when others;--Not used selectors

with OpCode(5 downto 4) select 
                WriteBackDataSrc <=
		"01" when "01", --LDD POP
		"10" when "00", --Included NOP-- ALU output bytl3
		"10" when "11", --> KDA INCLUDING LDM ADDI SUBI
		"00" when "10", -->Inport
		"11" when others; -----------fadl hagat el return(INT RESET??????)

  with OpCode select 
                MRead <=
		'0' when "110101", --LDM
		'1' when "010010", --LDD
		'1' when "010011", --POP
		'0' when others;
 with OpCode select 
		MWrite<=
		'1' when "010001", --STD 
		'1' when "010000", --PUSH 
		'1' when "010011", --POP 
		'0' when others;

with OpCode select 
                AlUSrc <=
		'1' when "110101", --LDM
		'1' when "110011", --ADDI
		'1' when "110100", --SUBI
		'1' when "010010", --LDD
		'1' when "010001", --STD
		'0' when others;

with OpCode select 
                ImmSig <=
		'1' when "110101", --LDM
		'1' when "110011", --ADDI
		'1' when "110100", --SUBI
		'1' when "010010", --LDD
		'1' when "010001", --STD
		'0' when others;

with OpCode select 
                MemWrite_PF <=
                    '1'when "010100", --PROTECT
		    '1' when "010101", --FREE
		    '0' WHEN OTHERS; 
with OpCode select 
                datain_PF <=
                    (OTHERS => '0') when "010100", --PROTECT
		    (OTHERS => '1') when "010101", --FREE
		    (OTHERS => '1') WHEN OTHERS; 

with OpCode select 
                MemRead_PF<=
                    '1'when "010001", --STD
		    '1'when "010000", --PUSH
		    '0' WHEN OTHERS; 

with OpCode select 
                SP_Signal<=
                    "01" when "010000", --PUSH
		    "10" when "010011", --POP
		    "00" WHEN "010001", --STD
		    "00" WHEN "010010", --LDD
		    "11" WHEN OTHERS;

  with OpCode select 
                OUT_Enable <=
		'1' when "110001", --OUT
		'0' when others;

with OpCode select 
                FLAGS_Enable <=
		'1' when "110000", --NOT
		
		'1' when "000001", --NEG
		'1' when "000010", --INC
		'1' when "000011", --DEC
		
		
		'1' when "000110", --ADD
		'1' when "000111", --SUB
		'1' when "110011", --ADDI
		'1' when "110100", --SUBI
		'1' when "001000", --AND
		'1' when "001001", --OR
		'1' when "001010", --XOR
		'1' when "001011", --CMP
		
		'0' when others;--Dont update flags



END My_Control;


