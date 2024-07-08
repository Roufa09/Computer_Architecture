library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY FetchDecodeReg IS
    PORT(   Clk, Rst : IN std_logic;
            FetchDecode_Input : IN std_logic_vector(15 DOWNTO 0);
            FetchDecode_Output : OUT std_logic_vector(15 DOWNTO 0);

	    INPORT_Input : IN std_logic_vector(31 DOWNTO 0);
            INPORT_Output : OUT std_logic_vector(31 DOWNTO 0)
		
        );
END FetchDecodeReg;

ARCHITECTURE RegBehaviour OF FetchDecodeReg IS

    component my_DFF IS
       GENERIC(n : integer :=48);
 	PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic 
	);
    END component;
	Signal NotClk :	std_logic;
	signal Reg_input	: std_logic_vector (47 DOWNTO 0) :=  (others => '0');
	signal Reg_output	: std_logic_vector (47 DOWNTO 0) :=  (others => '0');

begin
--regs: my_DFF PORT MAP (FetchDecode_Input, FetchDecode_Output, Clk, Rst, '1');
regs: my_DFF PORT MAP(Reg_input,Reg_output,Clk,Rst,'1');
process(clk,rst)
begin

	
	if Rst='1' then 
	
		Reg_input <= (others => '0');
		
	
 --elsif rising_edge(Clk) then
else 
		Reg_input(15 downto 0) <= FetchDecode_Input;
		
		Reg_input(47 downto 16) <= INPORT_Input;
		

end if; 

end process;

	FetchDecode_Output <= Reg_output(15 downto 0);
	INPORT_Output <= Reg_output(47 downto 16);
  
END RegBehaviour;


