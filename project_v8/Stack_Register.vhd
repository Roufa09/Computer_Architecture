LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY stackReg IS
GENERIC(n : integer :=12);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END stackReg;


Architecture my_stack_reg of stackReg is

BEGIN
PROCESS(clk,rst)
BEGIN
	IF(rst = '1') THEN
 	q <= (others=>'1');
ELSIF rising_edge(clk) THEN
	if en = '1' then 
 	q <= d;
END IF;
END IF;
END PROCESS;





end my_stack_reg;