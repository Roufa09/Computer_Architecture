LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY PF_Memory IS
    GENERIC (n : integer := 1);
    PORT(
        clk      : IN std_logic;
	rst      : IN std_logic;
        MemWrite_PF : IN std_logic;
	MemRead_PF : IN std_logic;
        PF_address  : IN std_logic_vector(11 DOWNTO 0); 
        datain_PF   : IN std_logic_vector(n-1 DOWNTO 0); --selka gaya mn elctrl '1' --> Free , '0' --> protect
        dataout_PF  : OUT std_logic_vector(n-1 DOWNTO 0)
    );
END ENTITY PF_Memory;

ARCHITECTURE sync_ram_b OF PF_Memory IS
    TYPE PFMem_type IS ARRAY(0 TO 4095) OF std_logic_vector(n-1 DOWNTO 0);
    SIGNAL DataMem : PFMem_type;
BEGIN
    PROCESS(clk)
    BEGIN
	IF rst = '1' THEN
            -- Reset: Set all memory locations to zero
            for i in DataMem'range loop
                DataMem(i) <=  (OTHERS => '1');
            end loop;
        ELSIF falling_edge(clk) THEN  
            IF MemWrite_PF = '1' THEN
                -- Write first 16 bits to the address
                DataMem(to_integer(unsigned(PF_address))) <= datain_PF;
                -- Write next 16 bits to the address below
                DataMem(to_integer(unsigned(PF_address)) + 1) <= datain_PF;
            END IF;
	END IF;
    END PROCESS;


	 --dataout_PF <= DataMem(to_integer(unsigned(PF_address))) AND DataMem(to_integer(unsigned(PF_address)) + 1); -- law ha check 3la address noso protected we noso free

PROCESS(PF_address,MemRead_PF,MemWrite_PF)
	begin
	IF MemRead_PF = '1' THEN
         	dataout_PF <= DataMem(to_integer(unsigned(PF_address))) AND DataMem(to_integer(unsigned(PF_address)) + 1); -- law ha check 3la address noso protected we noso free
       	END IF;
	

	end process;


END sync_ram_b;