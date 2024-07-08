LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY my_DFF_Reg IS
GENERIC(n : integer :=16);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END my_DFF_Reg;

ARCHITECTURE d_my_DFF OF my_DFF_Reg IS
BEGIN
PROCESS(clk,rst)
BEGIN
	IF(rst = '1') THEN
 	q <= (others=>'0');
ELSIF falling_edge(clk) THEN
	if en = '1' then 
 	q <= d;
END IF;
END IF;
END PROCESS;
END d_my_DFF;

