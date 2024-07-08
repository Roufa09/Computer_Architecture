LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity instruction_cache is
    port (
        --clk : in std_logic;
        address_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
end entity instruction_cache;

architecture ic_behavioral OF instruction_cache IS

    type instruction_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
    signal instruction : instruction_type := (OTHERS => (OTHERS => '0'));

begin
--process(clk)
--begin
	--if rising_edge(clk) then
    		data_out <= instruction(to_integer(unsigned(address_in))) ;
	--end if;
--end process;
end architecture ic_behavioral;

