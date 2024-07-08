library ieee ; 
use ieee.std_logic_1164.all ; 
use ieee.numeric_std.all;

ENTITY WriteBackStage IS

PORT ( 

INportvalue,MEMvalue,ALUvalue1,ALUvalue2:  IN std_logic_vector(31 DOWNTO 0) ;
writebacksrc : in std_logic_vector(1 DOWNTO 0);
writebackdata1 : OUT std_logic_vector(31 DOWNTO 0);
writebackdata2 : OUT std_logic_vector(31 DOWNTO 0)
);

END WriteBackStage;


architecture myarch of WriteBackStage is


begin
writebackdata1<= aluvalue1 when writebacksrc="10"
           else memvalue when writebacksrc="01"
           else INportvalue when writebacksrc="00"
	   else (OTHERS => '0') ;

writebackdata2<=ALUvalue2;
end myarch;
