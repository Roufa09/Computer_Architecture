Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY MemoryStage IS
        GENERIC (n : integer := 1);
	PORT(
		clk      : IN std_logic;
		rst      : IN std_logic;
		address  : IN std_logic_vector(11 DOWNTO 0); 

		PF_address  : IN std_logic_vector(11 DOWNTO 0); 

		MemWrite_PF : IN std_logic;
		MemRead_PF : IN std_logic;
        	datain_PF   : IN std_logic_vector(n-1 DOWNTO 0); --selka gaya mn elctrl '1' --> Free , '0' --> protect
        	dataout_PF  : INOUT std_logic_vector(n-1 DOWNTO 0);
----------------------------------------------------------------------------------------------------------------------------
		MemWrite : IN std_logic;
        	MemRead  : IN std_logic;
       	 	datain   : IN std_logic_vector(31 DOWNTO 0); --Reg
       		dataout  : OUT std_logic_vector(31 DOWNTO 0);


		SP_Signal: In std_logic_vector(1 downto 0);
		Exception_OUT : OUT std_logic
	);

END ENTITY MemoryStage;


ARCHITECTURE mem_stage OF MemoryStage IS

Component PF_Memory IS
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
END Component;

Component DataMemory IS
    PORT(
        clk      : IN std_logic;
	rst      : IN std_logic;
        MemWrite : IN std_logic;
        MemRead  : IN std_logic;
        address  : IN std_logic_vector(11 DOWNTO 0); 
        datain   : IN std_logic_vector(31 DOWNTO 0); --Reg
        dataout  : OUT std_logic_vector(31 DOWNTO 0)



    );
END Component;
------------------------------------------------
component stackReg IS
GENERIC(n : integer :=12);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END component;
-------------------------------------------------
SIGNAL address_sig: std_logic_vector(11 DOWNTO 0);------PF OR DATA MAEMORY
SIGNAL address_MEM_SP: std_logic_vector(11 DOWNTO 0);
SIGNAL NewMemWrite: std_logic;
SIGNAL SP_Address_OUT :std_logic_vector(11 DOWNTO 0):="111111111111";--FFF
SIGNAL SP_Address_IN :std_logic_vector(11 DOWNTO 0):="111111111111";
SIGNAL Exeption1 : std_logic;
SIGNAL Exeption2 : std_logic;
SIGNAL Exeption3 : std_logic;
SIGNAL Exeption4 : std_logic;
signal exception12 :std_logic;
signal rightpushpop :std_logic_vector(2 downto 0);
signal memwritenewmemwrite:std_logic;
begin
exception12<=(Exeption1 AND Exeption2);
rightpushpop<= SP_Signal &  exception12;
memwritenewmemwrite<= MemWrite and not(NewMemWrite);
with MemWrite_PF select 
                address_sig <=
		     address when '0', --STD
		     PF_address when '1', --PROTECT|FREE
                     address when others;
	

--with SP_Signal select 
           --     address_MEM_SP <=
		    	
			--address_sig when "00",
			--std_logic_vector(unsigned(SP_Address_OUT) - 1) when "01",--PUSH
			--std_logic_vector(unsigned(SP_Address_OUT) + 1) when "10",--POP
			--address_sig when others;

with rightpushpop select 
                address_MEM_SP <=
		    	
			address_sig when "000",
			std_logic_vector(unsigned(SP_Address_OUT) - 1) when "010",--PUSH
			std_logic_vector(unsigned(SP_Address_OUT) + 1) when "100",--POP
			address_sig when others;








with rightpushpop select 
                SP_Address_IN <=
		    	
			SP_Address_OUT when "000",
			std_logic_vector(unsigned(SP_Address_OUT) - 2) when "010", --PUSH
			std_logic_vector(unsigned(SP_Address_OUT) + 2) when "100", --POP
			"111111111111" when others;

with SP_Signal select  
                Exeption1 <=
			'1' when  "10", -- ba check eza kan el inst pop wla la2 (for Exeption)
			'0' when others;




with SP_Address_out select 
                Exeption2 <=
			'1' when  "111111111111", -- ba check eza kan SP = FFF wla la2 (for Exeption)
			'0' when others;

with SP_Signal select  
                Exeption3 <=
			'1' when  "00", -- ba check eza kan el inst STD wla la2 (for Exeption)
			'1' when  "01", -- ba check eza kan el inst PUSH wla la2 (for Exeption)
			'0' when others;

with memwritenewmemwrite select  --******************
                Exeption4 <=
			'1' when  '1', -- ba check eno lazm ywrite fl memory (PUSH aw STD)
			'0' when others;

-----------------------Exeption3 AND Exeption4--------------------------
-----------------------Access Protected Location------------------------

Exception_OUT <= (Exeption1 AND Exeption2) OR (Exeption3 AND Exeption4);

-----------------------Exeption1 AND Exeption2--------------------------
-----------------------when  POP when SP=FFF  --------------------------


PFMem_inst: PF_Memory 
	PORT MAP (
        	clk,
        	rst,
		MemWrite_PF,
		MemRead_PF,
		address_MEM_SP,
		datain_PF,
		dataout_PF
    	);
                      -- [1]
	NewMemWrite <= MemWrite AND dataout_PF(0);
		

DataMem_inst: DataMemory 
	PORT MAP (
        	clk,
        	rst,
		NewMemWrite,
		MemRead,
		address_MEM_SP,
		datain,
		dataout
    	);




Stack_pointer_inst : stackReg

	PORT MAP (
			
			SP_Address_IN,
			SP_Address_OUT,
			clk,rst,'1'
	);







END mem_stage;
