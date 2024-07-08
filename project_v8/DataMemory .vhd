LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DataMemory IS
    PORT(
        clk      : IN std_logic;
	rst      : IN std_logic;
        MemWrite : IN std_logic;
        MemRead  : IN std_logic;
        address  : IN std_logic_vector(11 DOWNTO 0); --ALU --ERRORRRRR
        datain   : IN std_logic_vector(31 DOWNTO 0); --Reg
        dataout  : OUT std_logic_vector(31 DOWNTO 0)
    );
END ENTITY DataMemory;

ARCHITECTURE sync_ram_a OF DataMemory IS
    TYPE Mem_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
    SIGNAL DataMem : Mem_type;
BEGIN
    PROCESS(clk)
    BEGIN
	IF rst = '1' THEN
            -- Reset: Set all memory locations to zero
            for i in DataMem'range loop
                DataMem(i) <= (OTHERS => '0');
            end loop;
	
	--IF MemRead = '1' THEN
         	-- dataout <= DataMem(to_integer(unsigned(address))) ;--& DataMem(to_integer(unsigned(address)) + 1);
    --   	END IF;  -- BY2RA FL FALLING BRDO MSH 3ARFIN LEH?
	
	

        ELSIF falling_edge(clk) THEN  
            IF MemWrite = '1' THEN
                -- Write first 16 bits to the address
                DataMem(to_integer(unsigned(address))) <= datain(31 DOWNTO 16);
                -- Write next 16 bits to the address below
                DataMem(to_integer(unsigned(address)) + 1) <= datain(15 DOWNTO 0);
            END IF;
	end if;
	--IF MemRead = '1' THEN
         	-- dataout <= DataMem(to_integer(unsigned(address)));-- & DataMem(to_integer(unsigned(address)) + 1);
       --	END IF;  -- BY2RA FL FALLING BRDO MSH 3ARFIN LEH?
	
    END PROCESS;

	PROCESS(address,MemRead,MemWrite)
	begin
	IF MemRead = '1' THEN
         	 dataout <= DataMem(to_integer(unsigned(address))) & DataMem(to_integer(unsigned(address)) + 1);
       	END IF;  -- BY2RA FL FALLING BRDO MSH 3ARFIN LEH?
	

	end process;




  -- dataout <= DataMem(to_integer(unsigned(address))) & DataMem(to_integer(unsigned(address)) + 1)  when  MemRead = '1';

                 --Read first 16 bits from the address
               -- dataout(15 DOWNTO 0) <= DataMem(to_integer(unsigned(address)));
                -- Read next 16 bits from the address below
               -- dataout(31 DOWNTO 16) <= DataMem(to_integer(unsigned(address)) + 1);


		-- Read 32 bits from the address and the next address
END sync_ram_a;
