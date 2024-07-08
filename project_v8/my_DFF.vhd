LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY my_DFF IS
GENERIC(n : integer :=16);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END my_DFF;

ARCHITECTURE c_my_DFF OF my_DFF IS
BEGIN
PROCESS(clk,rst)
BEGIN
	IF(rst = '1') THEN
 	q <= (others=>'0');
ELSIF rising_edge(clk) THEN
	if en = '1' then 
 	q <= d;
END IF;
END IF;
END PROCESS;
END c_my_DFF;

