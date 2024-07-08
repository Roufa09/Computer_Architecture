Library IEEE;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY MemoryWriteBack IS
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	

		ALUValue1In : IN std_logic_vector(31 DOWNTO 0); --R type inst
		ALUValue2In : IN std_logic_vector(31 DOWNTO 0); --SWAP
		
		ALUValue1Out : OUT std_logic_vector(31 DOWNTO 0);
		ALUValue2Out : OUT std_logic_vector(31 DOWNTO 0);

		MemoryValueIn : IN std_logic_vector(31 DOWNTO 0); --load
		MemoryValueOut : OUT std_logic_vector(31 DOWNTO 0);
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);
            	INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);

		OUT_Enable_INPUT : IN std_logic;
		OUT_Enable_OUTPUT : OUT std_logic;

		OutPortValue_IN : IN std_logic_vector(31 DOWNTO 0); 
		OutPortValue_OUT : OUT std_logic_vector(31 DOWNTO 0)

		);
END MemoryWriteBack;

ARCHITECTURE RegBehaviour OF MemoryWriteBack IS

component my_DFF IS
GENERIC(n : integer :=171);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END component;


--type Reg_type is  std_logic_vector(31 downto 0);	
	signal Reg_input	: std_logic_vector (170 DOWNTO 0) :=  (others => '0');
	signal Reg_output	: std_logic_vector (170 DOWNTO 0) := (others => '0');

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

	Reg_input(31 downto 0) <= MemoryValueIn;
	
	Reg_input(33 downto 32) <= RegWrite;
	
	Reg_input(36 downto 34) <= DestAdrss1In;
	Reg_input(38 downto 37) <= WriteBackDataSrcIn;
	Reg_input(70 downto 39) <= ALUValue1In;
	Reg_input(102 downto 71) <= ALUValue2In;
	Reg_input(105 downto 103) <= DestAdrss2In;

	Reg_input(137 downto 106) <= INPORT_Input;

	Reg_input(138) <= OUT_Enable_INPUT;

	Reg_input(170 downto 139) <= OutPortValue_IN;


end if; 

end process;



MemoryValueOut <= Reg_output(31 downto 0);



--WE_output <= RegWrite;
RegWriteOut <= Reg_output(33 downto 32);



DestAdrss1OuT <= Reg_output(36 downto 34);

WriteBackDataSrcOut <= Reg_output(38 downto 37);

ALUValue1Out <= Reg_output(70 downto 39);
ALUValue2Out <= Reg_output(102 downto 71);
DestAdrss2OuT <= Reg_output(105 downto 103);

INPORT_Output <= Reg_output(137 downto 106);

OUT_Enable_OUTPUT <= Reg_output(138);

OutPortValue_OUT <= Reg_output(170 downto 139);

End RegBehaviour;


