Library IEEE;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;


ENTITY Latch IS
	PORT(	Clk,Rst : IN std_logic;
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		--DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		RegWriteIn : IN std_logic_vector(1 DOWNTO 0);

		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		--DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);
		RegWriteOuT : OUT std_logic_vector(1 DOWNTO 0);

		ALU_Valu1_fromMem_WB : IN std_logic_vector(31 DOWNTO 0);
		ALU_Valu1_fromWB_Latch : OUT std_logic_vector(31 DOWNTO 0)

		);
END Latch;

ARCHITECTURE RegBehaviour OF Latch IS

component my_DFF IS
GENERIC(n : integer :=37); 
 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END component;


--type Reg_type is array(0 to 1) of std_logic_vector(31 downto 0);	
	signal Reg_input	: std_logic_vector (36 DOWNTO 0) :=  (others => '0');
	signal Reg_output	: std_logic_vector (36 DOWNTO 0) :=  (others => '0');

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

	Reg_input(2 downto 0) <=  DestAdrss1In;
	Reg_input(4 downto 3) <=  RegWriteIn;
	Reg_input(36 downto 5) <=  ALU_Valu1_fromMem_WB;
	
end if; 

end process;

DestAdrss1OuT <= Reg_output(2 downto 0);
RegWriteOuT <= Reg_output(4 downto 3);
ALU_Valu1_fromWB_Latch <= Reg_output(36 downto 5);


End RegBehaviour;


