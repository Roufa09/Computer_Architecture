LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY CCR IS

 PORT( 	d : IN std_logic_vector (3 downto 0);
 	q : OUT std_logic_vector (3 downto 0);
	clk,rst,en : IN std_logic );
END CCR;

ARCHITECTURE c_my_DFF OF CCR IS
BEGIN
PROCESS(clk,rst)
BEGIN
	IF(rst = '1') THEN
 	q <= (others=>'0');
ELSIF rising_edge(clk) and en='1' THEN
	--if en = '1' then 
 	q <= d;
END IF;
--END IF;
END PROCESS;
END c_my_DFF;

