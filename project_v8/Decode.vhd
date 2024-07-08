Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;



ENTITY Decode IS
GENERIC (n : integer := 1);
PORT(  
      
       instructionCode : in std_logic_vector(15 downto 0);
	---Control Signals
       AluSelector: out std_logic_vector (3  DOWNTO 0); --3 bits sub code and extra bit
       alusource : Out std_logic;
       MWrite, MRead: out std_logic;
       WBdatasrc: out std_logic_vector (1 downto 0);
	---------------------
	 RegWrite: out std_logic_vector (1 downto 0);
       --MemWRsrc:  out std_logic;
	clk,rst:in std_logic;
	wrten : in std_logic_vector(1 downto 0);
	writeport0:in std_logic_vector(31 downto 0);
	writeport1:in std_logic_vector(31 downto 0);
	
	readport0:out std_logic_vector(31 downto 0);
	readport1:out std_logic_vector(31 downto 0);
	
	WriteAdd0: in  std_logic_vector (2 downto 0);
	WriteAdd1: in  std_logic_vector (2 downto 0);

	ImmSignal : OUT std_logic;
	dest1: out std_logic_vector ( 2 downto 0);
	dest2: out std_logic_vector ( 2 downto 0);

       	source1add : out std_logic_vector ( 2 downto 0);
       	source2add : out std_logic_vector ( 2 downto 0);

	MemWrite_PF : OUT std_logic;
	MemRead_PF : OUT std_logic;
	datain_PF   : OUT std_logic_vector(n-1 DOWNTO 0);
	SP_Signal  : OUT std_logic_vector(1 DOWNTO 0);
	OUT_Enable : OUT std_logic;
	FLAGS_Enable : OUT std_logic
       
);
END ENTITY Decode ;
ARCHITECTURE dec_stage OF Decode IS

Component RegisterFile IS
    PORT(   Clk : IN std_logic;
            Rst : IN std_logic ;

	    WriteEnable : IN std_logic_vector(1 DOWNTO 0);
            ReadAddress0, ReadAddress1 : IN std_logic_vector(2 DOWNTO 0)  ;
            WriteAddress0, WriteAddress1 : IN std_logic_vector(2 DOWNTO 0) ;

            ReadPort0, ReadPort1 : OUT std_logic_vector(31 downto 0);
            WritePort0, WritePort1 : IN std_logic_vector(31 downto 0)
        );
        
END Component;


Component Control IS
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
END Component;
--------------------------------

signal Reg1 : std_logic_vector(2 downto 0);
signal Reg2 : std_logic_vector(2 downto 0);
signal opcode: std_logic_vector( 5 downto 0);
begin

with OpCode select 
                Reg1 <=
		     instructionCode(9 downto 7) when "000000", --NOP
                     instructionCode(9 downto 7) when "110000", --NOT
		     instructionCode(9 downto 7) when "000001", --NEG
		     instructionCode(9 downto 7) when "000010", --INC
		     instructionCode(9 downto 7) when "000011", --DEC
		     instructionCode(9 downto 7) when "000101", --SWAP
		     instructionCode(3 downto 1) when "010001", --STD
		     instructionCode(9 downto 7) when "010000", --PUSH
		     instructionCode(9 downto 7) when "110001", --OUT
                     instructionCode(6 downto 4) when others;

with OpCode select 
                Reg2 <=
		     instructionCode(6 downto 4) when "000101", --SWAP
		     instructionCode(6 downto 4) when "010001", --STD
                     instructionCode(3 downto 1) when others;
	


opcode <= instructionCode(15 downto 10);
dest1 <= instructionCode(9 downto 7);
dest2 <= instructionCode(6 downto 4);
--Reg1 <= instructionCode(6 downto 4);
--Reg2 <= instructionCode(3 downto 1);

 	--for forwarding unit
	source1add<=Reg1; 
	source2add<=Reg2;

regF1: registerfile port map (clk,rst,wrten(1 downto 0),Reg1,Reg2,WriteAdd0,WriteAdd1,ReadPort0,ReadPort1,WritePort0,WritePort1);--wrten and writeport will come from writeback
controller: Control port map ( Opcode,AluSelector,alusource,MWrite,MRead,RegWrite,WBdatasrc,ImmSignal,MemWrite_PF,MemRead_PF,datain_PF,SP_Signal,OUT_Enable,FLAGS_Enable);

end dec_stage;
