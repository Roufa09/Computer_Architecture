LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY SignExtend IS
    PORT (
        input_data  : IN  std_logic_vector(15 DOWNTO 0);
        output_data : OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY SignExtend;

ARCHITECTURE behavior OF SignExtend IS
BEGIN
    PROCESS(input_data)
    BEGIN
        -- Replicate the sign bit to fill the upper 16 bits
        if input_data(15) = '0' then
            output_data(31 DOWNTO 16) <= (others => '0'); -- Positive number, fill with zeros
        else
            output_data(31 DOWNTO 16) <= (others => '1'); -- Negative number, fill with ones
        end if;
        
        -- Copy the lower 16 bits of input_data to the lower 16 bits of output_data
        output_data(15 DOWNTO 0) <= input_data;
    END PROCESS;
END behavior;
