Library IEEE;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY DecodeExecute IS
GENERIC (n : integer := 1);
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		ALUSelectors : IN std_logic_vector(3 DOWNTO 0);

		AluSrc      : IN std_logic;
		AluSrcOut      : OUT std_logic;

		MemRead     : IN std_logic;
		MemReadOut     : OUT std_logic;

		MemWrite     : IN std_logic;
		MemWriteOut     : OUT std_logic;

		ImmValueIN    : IN std_logic_vector(31 DOWNTO 0);
		ImmValueOut    : OUT std_logic_vector(31 DOWNTO 0);


		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	
		ALUSelectorsOut : OUT std_logic_vector(3 DOWNTO 0);
 
		AdrssValu0 : IN std_logic_vector(31 DOWNTO 0);
		AdrssValu1 : IN std_logic_vector(31 DOWNTO 0);

		ReadPort0 : OUT std_logic_vector(31 DOWNTO 0);
		ReadPort1 : OUT std_logic_vector(31 DOWNTO 0);
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);
		
		
       		source1add_Decode : in std_logic_vector ( 2 downto 0);
       		source2add_Decode: in std_logic_vector ( 2 downto 0);

       		source1add : out std_logic_vector ( 2 downto 0);
       		source2add : out std_logic_vector ( 2 downto 0);

		Immediate_Sig_in     : IN std_logic;
		Immediate_Sig_out     : OUT std_logic;

		MemWrite_PF_IN : IN std_logic;
		MemWrite_PF_OUT : OUT std_logic;

		MemRead_PF_IN : IN std_logic;
		MemRead_PF_OUT : OUT std_logic;

		datain_PF_IN   : IN std_logic_vector(n-1 DOWNTO 0);
		datain_PF_OUT   : OUT std_logic_vector(n-1 DOWNTO 0);

		SP_Signal_IN : IN std_logic_vector(1 DOWNTO 0);
		SP_Signal_OUT : OUT std_logic_vector(1 DOWNTO 0);

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);
            	INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);

		OUT_Enable_INPUT : IN std_logic;
		OUT_Enable_OUTPUT : OUT std_logic;

		FLAGS_Enable_INPUT : IN std_logic;
		FLAGS_Enable_OUTPUT : OUT std_logic

		);
END DecodeExecute;

ARCHITECTURE RegBehaviour OF DecodeExecute IS

component my_DFF IS
GENERIC(n : integer :=159); --75+35+3(dest2)+6+1 imm +2 FOR pf +1 PF MEM READ +2 for SP_sig +32 INPort

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END component;





--type Reg_type is array(0 to 1) of std_logic_vector(31 downto 0);	
	signal Reg_input	: std_logic_vector (158 DOWNTO 0) :=  (others => '0');
	signal Reg_output	: std_logic_vector (158 DOWNTO 0) :=  (others => '0');

--SIGNAL DecodeExecute_output : std_logic_vector (1 DOWNTO 0);
--SIGNAL ALU_Sel_output : std_logic_vector (3 DOWNTO 0);

begin
--RegsGenerate: FOR i IN 0 TO 1 GENERATE
regs: my_DFF PORT MAP(Reg_input,Reg_output,Clk,Rst,'1');
--END GENERATE;


process(clk,rst)

begin

if Rst='1' then 
	
		Reg_input <= (others => '0');
		
	

 --elsif rising_edge(Clk) then
else 

	Reg_input(31 downto 0) <= AdrssValu0;
	Reg_input(63 downto 32) <= AdrssValu1;
	
	Reg_input(65 downto 64) <= RegWrite;
	Reg_input(69 downto 66) <= ALUSelectors;
	Reg_input(72 downto 70) <= DestAdrss1In;
	Reg_input(74 downto 73) <= WriteBackDataSrcIn;

	Reg_input(75) <= AluSrc;
	Reg_input(76) <= MemRead;
	Reg_input(77) <= MemWrite;
	Reg_input(109 downto 78) <= ImmValueIN;

	Reg_input(112 downto 110) <= DestAdrss2In;

	Reg_input(115 downto 113) <= source1add_Decode;
	Reg_input(118 downto 116) <= source2add_Decode;

	Reg_input(119) <=Immediate_Sig_in;
	
	Reg_input(120) <=MemWrite_PF_IN;
	Reg_input(121) <=datain_PF_IN(0); -- MOMKN TDRB FL SIM $$$EL7 MADAREBETSH$$$$

	Reg_input(122) <=MemRead_PF_IN;
	Reg_input(124 downto 123) <=SP_Signal_IN;
	
	Reg_input(156 downto 125) <=INPORT_Input;

	Reg_input(157) <=OUT_Enable_INPUT;
	
	Reg_input(158) <=FLAGS_Enable_INPUT;
	

end if; 

end process;

ReadPort0 <= Reg_output(31 downto 0);
ReadPort1 <= Reg_output(63 downto 32);


--WE_output <= RegWrite;
RegWriteOut <= Reg_output(65 downto 64);


--ALU_Sel_output <= ALUSelectors;
ALUSelectorsOut <= Reg_output(69 downto 66);

DestAdrss1OuT <= Reg_output(72 downto 70);

WriteBackDataSrcOut <= Reg_output(74 downto 73);

AluSrcOut <= Reg_output(75);

MemReadOut <= Reg_output(76);

MemWriteOut <= Reg_output(77);

ImmValueOut <= Reg_output(109 downto 78);

DestAdrss2OuT <= Reg_output(112 downto 110);

source1add <= Reg_output(115 downto 113);
source2add <= Reg_output(118 downto 116);

Immediate_Sig_out <= Reg_output(119);

MemWrite_PF_OUT <= Reg_output(120);
datain_PF_OUT(0) <= Reg_output(121); -- MOMKN TDRB FL SIMS

MemRead_PF_OUT <= Reg_output(122);

SP_Signal_OUT <= Reg_output(124 downto 123);

INPORT_Output <= Reg_output(156 downto 125);

OUT_Enable_OUTPUT <= Reg_output(157);
Flags_Enable_OUTPUT <= Reg_output(158);

End RegBehaviour;


