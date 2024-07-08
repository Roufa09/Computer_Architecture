LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY forwardingUnit IS 
PORT( 
	clk: in std_logic;

	WBDataSrc_EM : IN  std_logic_vector (1 DOWNTO 0);
	WBDataSrc_MWB : IN  std_logic_vector (1 DOWNTO 0);
	
	Reg_Write_EM : IN std_logic_vector (1 DOWNTO 0);
	Reg_Write_MWB : IN std_logic_vector (1 DOWNTO 0);
	Reg_Write_WB_Latch : IN std_logic_vector (1 DOWNTO 0);

	dest1_EM : IN  std_logic_vector (2 DOWNTO 0);
	dest1_MWB : IN std_logic_vector (2  DOWNTO 0);
	dest1_WB_Latch : IN std_logic_vector (2  DOWNTO 0);

	source1 : IN std_logic_vector (2  DOWNTO 0);
	source2 : IN std_logic_vector (2  DOWNTO 0);

	FU_Mux1_Selector1 : OUT std_logic_vector (1  DOWNTO 0);
	FU_Mux2_Selector2 : OUT std_logic_vector (1  DOWNTO 0);

	Immidiate_sig : IN std_logic

);
END forwardingUnit;

ARCHITECTURE archc OF forwardingUnit IS

BEGIN 

FU_Mux1_Selector1 <="01" when (source1=dest1_EM and Reg_Write_EM ="01" and WBDataSrc_EM="10" and Immidiate_sig='0' ) --from EM Reg
else "10" when (source1=dest1_MWB and Reg_Write_MWB ="01" and WBDataSrc_MWB="10" and Immidiate_sig='0' ) --from MemWB Reg
else "11" when (source1=dest1_WB_Latch and Reg_Write_WB_Latch ="01" and Immidiate_sig='0' ) --from WB_Latch Reg
else "00";

FU_Mux2_Selector2 <="01" when  (source2=dest1_EM and Reg_Write_EM ="01" and WBDataSrc_EM="10" and Immidiate_sig='0' ) --from EM Reg
else "10" when (source2=dest1_MWB and Reg_Write_MWB ="01" and WBDataSrc_MWB="10" and Immidiate_sig='0' ) --from MemWB Reg
else "11" when (source2=dest1_WB_Latch and Reg_Write_WB_Latch ="01" and Immidiate_sig='0' ) --from WB_Latch Reg
else "00";


END archc;
