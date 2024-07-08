library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

ENTITY RegisterFile IS
    PORT(   Clk : IN std_logic;
            Rst : IN std_logic ;

	    WriteEnable : IN std_logic_vector(1 DOWNTO 0);
            ReadAddress0, ReadAddress1 : IN std_logic_vector(2 DOWNTO 0)  ;
            WriteAddress0, WriteAddress1 : IN std_logic_vector(2 DOWNTO 0) ;

            ReadPort0, ReadPort1 : OUT std_logic_vector(31 downto 0);
            WritePort0, WritePort1 : IN std_logic_vector(31 downto 0)
        );
        
END RegisterFile;


architecture ArchRegisterFile of RegisterFile is 
    component my_DFF IS
      GENERIC(n : integer :=31);   
 	PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
    END component;
    








    type ndff_type is array(0 to 7) of std_logic_vector(31 downto 0);
    signal DFF_input : ndff_type := (others=>(others=>'0'));
    signal DFF_output : ndff_type := (others=>(others=>'0'));    Signal NotClk :	std_logic;
	
begin

NotClk <= not clk;

    loop1: for i in 0 to 7 generate
        fx: my_DFF generic map (32) port map(DFF_input(i), DFF_output(i), notclk, Rst, '1');
    end generate;
	

    PROCESS (WriteEnable, WriteAddress0, WriteAddress1, Rst, Clk)
    begin 
        if Rst = '1' then 
            loop1 : for i in 0 to 7 loop
                DFF_input(i) <= (others => '0');
            end loop;

        --end if;

   elsif falling_edge(Clk) then

        if WriteEnable = "01" then        
            	DFF_input(to_integer(unsigned(WriteAddress0))) <= WritePort0;
        end if;
	
        
        if WriteEnable = "11" then  
		DFF_input(to_integer(unsigned(WriteAddress0))) <= WritePort0;
            	DFF_input(to_integer(unsigned(WriteAddress1))) <= WritePort1;
        end if; 
	end if; 
  

	
    end PROCESS;


	ReadPort0 <= DFF_output(to_integer(unsigned(ReadAddress0)));
	ReadPort1 <= DFF_output(to_integer(unsigned(ReadAddress1)));
    

end ArchRegisterFile;

