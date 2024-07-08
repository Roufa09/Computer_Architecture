Library IEEE;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY ExecuteMemory IS
GENERIC (n : integer := 1);
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	

		MemRead     : IN std_logic;
		MemReadOut     : OUT std_logic;

		MemWrite     : IN std_logic;
		MemWriteOut     : OUT std_logic;
 
		AluValueIn1 : IN std_logic_vector(31 DOWNTO 0);
		AluValueIn2 : IN std_logic_vector(31 DOWNTO 0);


		AluValueOut1 : OUT std_logic_vector(31 DOWNTO 0);
		AluValueOut2 : OUT std_logic_vector(31 DOWNTO 0);
		
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);
	

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);


		AluAddressIn : IN std_logic_vector(11 downto 0);
		AluAddressout : OUT std_logic_vector(11 downto 0);
		
		STD_DATA_IN : IN std_logic_vector(31 downto 0);
		STD_DATA_OUT : OUT std_logic_vector(31 downto 0);

		MemWrite_PF_IN : IN std_logic;
		MemWrite_PF_OUT : OUT std_logic;

		MemRead_PF_IN : IN std_logic;
		MemRead_PF_OUT : OUT std_logic;

		datain_PF_IN   : IN std_logic_vector(n-1 DOWNTO 0);
		datain_PF_OUT   : OUT std_logic_vector(n-1 DOWNTO 0);

		PF_address_IN   : IN std_logic_vector(11 DOWNTO 0);
		PF_address_OUT   : OUT std_logic_vector(11 DOWNTO 0);

		SP_Signal_IN : IN std_logic_vector(1 DOWNTO 0);
		SP_Signal_OUT : OUT std_logic_vector(1 DOWNTO 0);
		
		PUSH_DATA_IN : IN std_logic_vector(31 downto 0);
		PUSH_DATA_OUT : OUT std_logic_vector(31 downto 0);

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);
            	INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);

		OUT_Enable_INPUT : IN std_logic;
		OUT_Enable_OUTPUT : OUT std_logic

		);
END ExecuteMemory;

ARCHITECTURE RegBehaviour OF ExecuteMemory IS

component my_DFF IS
GENERIC(n : integer :=202);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END component;


--type Reg_type is  std_logic_vector(31 downto 0);	
	signal Reg_input	: std_logic_vector (201 DOWNTO 0) :=  (others => '0');
	signal Reg_output	: std_logic_vector (201 DOWNTO 0) := (others => '0');

--SIGNAL WE_output : std_logic_vector (1 DOWNTO 0);
--SIGNAL ALU_output : std_logic_vector (31 DOWNTO 0);

begin
--RegsGenerate: FOR i IN 0 TO 1 GENERATE
regs: my_DFF PORT MAP(Reg_input,Reg_output,Clk,Rst,'1');
--END GENERATE;


process(clk,rst)

begin

if Rst='1' then 
	--loop1 : for i in 0 to 1 loop
		Reg_input <= (others => '0');
		
	--end loop;

 --elsif rising_edge(Clk) then
else 

	Reg_input(31 downto 0) <= AluValueIn1;
	
	Reg_input(72 downto 41) <= AluValueIn2;

	Reg_input(33 downto 32) <= RegWrite;
	
	Reg_input(36 downto 34) <= DestAdrss1In;
	Reg_input(38 downto 37) <= WriteBackDataSrcIn;
	Reg_input(39) <= MemRead;
	Reg_input(40) <= MemWrite;

	Reg_input(75 downto 73) <= DestAdrss2In;

	Reg_input(87 downto 76) <= AluAddressIn;

	Reg_input(119 downto 88) <= STD_DATA_IN;

	Reg_input(120) <=MemWrite_PF_IN;
	Reg_input(121) <=datain_PF_IN(0); -- MOMKN TDRB FL SIM

	Reg_input(133 DOWNTO 122) <=PF_address_IN;
	Reg_input(134) <=MemRead_PF_IN;
		
	Reg_input(136 downto 135) <=SP_Signal_IN;

	Reg_input(168 downto 137) <= PUSH_DATA_IN;

	Reg_input(200 downto 169) <= INPORT_Input;

	Reg_input(201) <= OUT_Enable_INPUT;

end if; 

end process;



AluValueOut1 <= Reg_output(31 downto 0);
AluValueOut2 <= Reg_output(72 downto 41);


--WE_output <= RegWrite;
RegWriteOut <= Reg_output(33 downto 32);



DestAdrss1OuT <= Reg_output(36 downto 34);

WriteBackDataSrcOut <= Reg_output(38 downto 37);

MemReadOut <= Reg_output(39);

MemWriteOut <= Reg_output(40);

DestAdrss2OuT <= Reg_output(75 downto 73);

AluAddressOUT <= Reg_output(87 downto 76);

STD_DATA_OUT <= Reg_output(119 downto 88);

MemWrite_PF_OUT <= Reg_output(120);
datain_PF_OUT(0) <= Reg_output(121); -- MOMKN TDRB FL SIMS

PF_address_OUT <= Reg_output(133 DOWNTO 122);
MemRead_PF_OUT <= Reg_output(134);

SP_Signal_OUT <= Reg_output(136 downto 135);

PUSH_DATA_OUT <= Reg_output(168 downto 137);

INPORT_Output <= Reg_output(200 downto 169);

OUT_Enable_OUTPUT <= Reg_output(201);

End RegBehaviour;


