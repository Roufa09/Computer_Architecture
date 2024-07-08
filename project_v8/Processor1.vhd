Library IEEE;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE ieee.std_logic_misc.all;

ENTITY Processor1 IS
GENERIC (n : integer := 1);
PORT(
clk, reset : IN std_logic;
INPORT :IN std_logic_vector(31 downto 0);--#########
OUTPORT :OUT std_logic_vector(31 downto 0);--########
Exception_OUT : OUT std_logic --#######################
);

END ENTITY;

ARCHITECTURE struct OF Processor1 IS
Component my_DFF IS--##############################################
GENERIC(n : integer :=32);

 PORT( 	d : IN std_logic_vector (n-1 downto 0);
 	q : OUT std_logic_vector (n-1 downto 0);
	clk,rst,en : IN std_logic );
END Component;
COMPONENT pc is
    port (
        reset : in std_logic;
        clk : in std_logic;
        pc_out : out std_logic_vector(31 downto 0)
    );
end COMPONENT;

Component instruction_cache is
    port (
        --clk : in std_logic;
        address_in : in std_logic_vector(31 downto 0);
        data_out : out std_logic_vector(15 downto 0)
    );
END COMPONENT;

Component FetchDecodeReg IS
    PORT(   Clk, Rst : IN std_logic;
            FetchDecode_Input : IN std_logic_vector(15 DOWNTO 0);
            FetchDecode_Output : OUT std_logic_vector(15 DOWNTO 0);
	    INPORT_Input : IN std_logic_vector(31 DOWNTO 0);----#################
            INPORT_Output : OUT std_logic_vector(31 DOWNTO 0)--################

        );
END COMPONENT;


Component ALU IS
PORT( A,B: IN std_logic_vector (31 DOWNTO 0);
		        sel : IN std_logic_vector (3 DOWNTO 0);
                        Cout,Negout,Zeroout,Overflowout : OUT std_logic; --Carry,negative,zero,OverFlow
                        NOSETCarry,NOSETNeg,NOSETZero,NOSETOVERFLOW : In std_logic; 
			ALUout1: OUT std_logic_vector (31 DOWNTO 0);
			ALUout2: OUT std_logic_vector (31 DOWNTO 0)
			--AlU_MEM_ADDRESS : OUT std_logic_vector (11 DOWNTO 0)


);
END component ALU ;


Component ExecuteMemory IS
GENERIC (n : integer := 1);
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	

		MemRead     : IN std_logic;
		MemReadOut     : OUT std_logic;

		MemWrite     : IN std_logic;
		MemWriteOut     : OUT std_logic;
 
		AluValueIn1 : IN std_logic_vector(31 DOWNTO 0);
		AluValueIn2 : IN std_logic_vector(31 DOWNTO 0);


		AluValueOut1 : OUT std_logic_vector(31 DOWNTO 0);
		AluValueOut2 : OUT std_logic_vector(31 DOWNTO 0);
		
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);
	

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);
		
		AluAddressIn : IN std_logic_vector(11 downto 0);
		AluAddressout : OUT std_logic_vector(11 downto 0);
		
		STD_DATA_IN : IN std_logic_vector(31 downto 0);
		STD_DATA_OUT : OUT std_logic_vector(31 downto 0);

		MemWrite_PF_IN : IN std_logic;
		MemWrite_PF_OUT : OUT std_logic;

		MemRead_PF_IN : IN std_logic;
		MemRead_PF_OUT : OUT std_logic;

		datain_PF_IN   : IN std_logic_vector(n-1 DOWNTO 0);
		datain_PF_OUT   : OUT std_logic_vector(n-1 DOWNTO 0);

		PF_address_IN   : IN std_logic_vector(11 DOWNTO 0);
		PF_address_OUT   : OUT std_logic_vector(11 DOWNTO 0);
	
		SP_Signal_IN : IN std_logic_vector(1 DOWNTO 0);--#####################
		SP_Signal_OUT : OUT std_logic_vector(1 DOWNTO 0);--#####################

		PUSH_DATA_IN : IN std_logic_vector(31 downto 0);--########################
		PUSH_DATA_OUT : OUT std_logic_vector(31 downto 0);--########################

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);--########################
                INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);--########################

		OUT_Enable_INPUT : IN std_logic;--###############
		OUT_Enable_OUTPUT : OUT std_logic--###############

		);
END component;


component DecodeExecute IS
GENERIC (n : integer := 1);
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		ALUSelectors : IN std_logic_vector(3 DOWNTO 0);

		AluSrc      : IN std_logic;
		AluSrcOut      : OUT std_logic;

		MemRead     : IN std_logic;
		MemReadOut     : OUT std_logic;

		MemWrite     : IN std_logic;
		MemWriteOut     : OUT std_logic;

		ImmValueIN    : IN std_logic_vector(31 DOWNTO 0);
		ImmValueOut    : OUT std_logic_vector(31 DOWNTO 0);


		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	
		ALUSelectorsOut : OUT std_logic_vector(3 DOWNTO 0);
 
		AdrssValu0 : IN std_logic_vector(31 DOWNTO 0);
		AdrssValu1 : IN std_logic_vector(31 DOWNTO 0);

		ReadPort0 : OUT std_logic_vector(31 DOWNTO 0);
		ReadPort1 : OUT std_logic_vector(31 DOWNTO 0);
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);

		
       		source1add_Decode : in std_logic_vector ( 2 downto 0);
       		source2add_Decode: in std_logic_vector ( 2 downto 0);

       		source1add : out std_logic_vector ( 2 downto 0);
       		source2add : out std_logic_vector ( 2 downto 0);

		Immediate_Sig_in     : IN std_logic;
		Immediate_Sig_out     : OUT std_logic;

		
		MemWrite_PF_IN : IN std_logic;
		MemWrite_PF_OUT : OUT std_logic;

		MemRead_PF_IN : IN std_logic;
		MemRead_PF_OUT : OUT std_logic;


		datain_PF_IN   : IN std_logic_vector(n-1 DOWNTO 0);
		datain_PF_OUT   : OUT std_logic_vector(n-1 DOWNTO 0);
		
		
		SP_Signal_IN : IN std_logic_vector(1 DOWNTO 0);--#####################
		SP_Signal_OUT : OUT std_logic_vector(1 DOWNTO 0);--#####################

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);--########################
                INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);--########################

		OUT_Enable_INPUT : IN std_logic;--###############
		OUT_Enable_OUTPUT : OUT std_logic;--###############

		FLAGS_Enable_INPUT : IN std_logic;--##############
		FLAGS_Enable_OUTPUT : OUT std_logic--#########

		);
END component;

component MemoryWriteBack IS
	PORT(	Clk,Rst : IN std_logic;
		
		RegWrite    : IN std_logic_vector(1 DOWNTO 0);
		RegWriteOut   : OUT std_logic_vector(1 DOWNTO 0);	

		ALUValue1In : IN std_logic_vector(31 DOWNTO 0); --R type inst
		ALUValue2In : IN std_logic_vector(31 DOWNTO 0); --SWAP
		
		ALUValue1Out : OUT std_logic_vector(31 DOWNTO 0);
		ALUValue2Out : OUT std_logic_vector(31 DOWNTO 0);

		MemoryValueIn : IN std_logic_vector(31 DOWNTO 0); --load
		MemoryValueOut : OUT std_logic_vector(31 DOWNTO 0);
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);

		WriteBackDataSrcOut : OUT std_logic_vector(1 downto 0);
		WriteBackDataSrcIn : IN std_logic_vector(1 downto 0);

		INPORT_Input : IN std_logic_vector(31 DOWNTO 0);--########################
                INPORT_Output : OUT std_logic_vector(31 DOWNTO 0);--########################

		OUT_Enable_INPUT : IN std_logic;
		OUT_Enable_OUTPUT : OUT std_logic;

		OutPortValue_IN : IN std_logic_vector(31 DOWNTO 0); 
		OutPortValue_OUT : OUT std_logic_vector(31 DOWNTO 0)
		);
END component;

component Decode IS
GENERIC (n : integer := 1);
PORT(  
      
       instructionCode : in std_logic_vector(15 downto 0);
	---Control Signals
       AluSelector: out std_logic_vector (3  DOWNTO 0); --3 bits sub code and extra bit
       alusource : Out std_logic;
       MWrite, MRead: out std_logic;
       WBdatasrc: out std_logic_vector (1 downto 0);
	---------------------
	 RegWrite: out std_logic_vector (1 downto 0);
       --MemWRsrc:  out std_logic;
	clk,rst:in std_logic;
	wrten : in std_logic_vector(1 downto 0);
	writeport0:in std_logic_vector(31 downto 0);
	writeport1:in std_logic_vector(31 downto 0);
	
	readport0:out std_logic_vector(31 downto 0);
	readport1:out std_logic_vector(31 downto 0);
	
	WriteAdd0: in  std_logic_vector (2 downto 0);
	WriteAdd1: in  std_logic_vector (2 downto 0);

	ImmSignal : OUT std_logic;
	dest1: out std_logic_vector ( 2 downto 0);
	dest2: out std_logic_vector ( 2 downto 0);

	source1add : out std_logic_vector ( 2 downto 0);
       	source2add : out std_logic_vector ( 2 downto 0);

	MemWrite_PF : OUT std_logic;
	MemRead_PF : OUT std_logic;
	datain_PF   : OUT std_logic_vector(n-1 DOWNTO 0);
	SP_Signal : OUT std_logic_vector(1 DOWNTO 0);--################################
	OUT_Enable : OUT std_logic;--#######################
	FLAGS_Enable : OUT std_logic--#################
	
);
END component Decode ;




--component DataMemory IS
  --  PORT(
   --     clk      : IN std_logic;
	--rst      : IN std_logic;
 --       MemWrite : IN std_logic;
  --      MemRead  : IN std_logic;
 --       address  : IN std_logic_vector(11 DOWNTO 0); 
 --       datain   : IN std_logic_vector(31 DOWNTO 0); --Reg
 --       dataout  : OUT std_logic_vector(31 DOWNTO 0)
  --  );
--END component DataMemory;


component MemoryStage IS
        GENERIC (n : integer := 1);
	PORT(
		clk      : IN std_logic;
		rst      : IN std_logic;
		address  : IN std_logic_vector(11 DOWNTO 0); 

		PF_address  : IN std_logic_vector(11 DOWNTO 0); 

		MemWrite_PF : IN std_logic;
		MemRead_PF  : IN std_logic;
        	datain_PF   : IN std_logic_vector(n-1 DOWNTO 0); --selka gaya mn elctrl '1' --> Free , '0' --> protect
        	dataout_PF  : INOUT std_logic_vector(n-1 DOWNTO 0);
----------------------------------------------------------------------------------------------------------------------------
		MemWrite : IN std_logic;
        	MemRead  : IN std_logic;
       	 	datain   : IN std_logic_vector(31 DOWNTO 0); --Reg
       		dataout  : OUT std_logic_vector(31 DOWNTO 0);
		SP_Signal: In std_logic_vector(1 downto 0); --############################
		Exception_OUT : OUT std_logic --############################
	);
END component MemoryStage;



component SignExtend IS
    PORT (
        input_data  : IN  std_logic_vector(15 DOWNTO 0);
        output_data : OUT std_logic_vector(31 DOWNTO 0)
    );
END component;

---------------------------------------------------------

component WriteBackStage IS

PORT ( 

INportvalue,MEMvalue,ALUvalue1,ALUvalue2:  IN std_logic_vector(31 DOWNTO 0) ;
writebacksrc : in std_logic_vector(1 DOWNTO 0);
writebackdata1 : OUT std_logic_vector(31 DOWNTO 0);
writebackdata2 : OUT std_logic_vector(31 DOWNTO 0)
);

END component;


Component CCR IS

 PORT( 	d : IN std_logic_vector (3 downto 0);
 	q : OUT std_logic_vector (3 downto 0);
	clk,rst,en : IN std_logic );
END Component;

---------------FU--------------
Component forwardingUnit IS 
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
--stall : OUT std_logic

);
END Component;

Component Latch IS
	PORT(	Clk,Rst : IN std_logic;
		
		DestAdrss1In : IN std_logic_vector(2 DOWNTO 0);
		--DestAdrss2In : IN std_logic_vector(2 DOWNTO 0);
		RegWriteIn : IN std_logic_vector(1 DOWNTO 0);

		DestAdrss1OuT : OUT std_logic_vector(2 DOWNTO 0);
		--DestAdrss2OuT : OUT std_logic_vector(2 DOWNTO 0);
		RegWriteOuT : OUT std_logic_vector(1 DOWNTO 0);

		ALU_Valu1_fromMem_WB : IN std_logic_vector(31 DOWNTO 0);
		ALU_Valu1_fromWB_Latch : OUT std_logic_vector(31 DOWNTO 0)

		);
END Component;


------------------------------

--------------------------------------------------------------
	

	signal InstructionAddress_PCOut : std_logic_vector(31 downto 0 ); --el Signal ely tal3a men el PC
	signal Instruction : std_logic_vector(15 downto 0); --ely dakhel 3ala el fetch decode reg
	
	--signal IN_Value : std_logic_vector(31 downto 0 ); ---#####################################################
	signal IN_Value_FD_OUT : std_logic_vector(31 downto 0 ); ---#####################################################
	

	signal Mux1Out_Instruction : std_logic_vector(15 downto 0); --NOP or Inst
	signal Mux1Sel : std_logic_vector(1 downto 0);

	signal Mux2Out_ImmediateValue : std_logic_vector(15 downto 0);

	signal SignExtendOut : std_logic_vector(31 downto 0); --el ouytput ely tale3 men el sign extend

	signal Mux3Out_Src2orImm : std_logic_vector(31 downto 0); -- ely tale3 men el mux ya src2 ya imm

-----------------------------------DecodeStage----------------------------
	signal FetchDecodeOut : std_logic_vector(15 downto 0);
	signal AluSelectorOut_sig : std_logic_vector(3 downto 0);
	signal alusourceOut_sig : std_logic;
	signal MWriteOut_sig : std_logic;
	signal MReadOut_sig : std_logic;
	signal WBdatasrcOut_sig : std_logic_vector(1 downto 0);
	signal RegWriteOut_sig : std_logic_vector(1 downto 0);
--	signal wrtenIn_sig : std_logic_vector(1 downto 0);
--	signal writeport0In : std_logic_vector(31 downto 0);
	signal writeport1In : std_logic_vector(31 downto 0);
	signal Readport0Out : std_logic_vector(31 downto 0);
	signal Readport1Out : std_logic_vector(31 downto 0);
--	signal WriteAdd0In : std_logic_vector(2 downto 0);
	signal WriteAdd1In : std_logic_vector(2 downto 0);
	signal ImmSignalOut_sig : std_logic;
	signal destOut1 : std_logic_vector(2 downto 0);
	signal destOut2 : std_logic_vector(2 downto 0);
	signal source1addOut : std_logic_vector(2 downto 0);
	signal source2addOut : std_logic_vector(2 downto 0);
	signal MemWrite_PF : std_logic;
	signal MemRead_PF : std_logic;
	signal datain_PF : std_logic_vector(n-1 downto 0);
	signal SP_signal : std_logic_vector(1 downto 0);--########################
	signal OUT_Enable : std_logic;--########################
	signal FLAGS_Enable : std_logic;--########################
---------------------------------------------------------------------------

----------------------------------DecodeExecuteReg-------------------------
	signal alusourceOut_sig_DE : std_logic;
	signal MReadOut_sig_DE : std_logic;
	signal MWriteOut_sig_DE : std_logic;
	signal ImmediateValueorEA_ED : std_logic_vector(31 DOWNTO 0);
	signal RegWriteOut_ED : std_logic_vector(1 DOWNTO 0);
	signal ALUSelectorsOut_ED : std_logic_vector(3 DOWNTO 0);
	signal ValueOfReg1_ED : std_logic_vector(31 DOWNTO 0);
	signal ValueOfReg2_ED : std_logic_vector(31 DOWNTO 0);
	signal WriteBackDataSrcOut_ED : std_logic_vector(1 downto 0);
	signal DestAdrssOut1_ED : std_logic_vector(2 DOWNTO 0);
	signal DestAdrssOut2_ED : std_logic_vector(2 DOWNTO 0);
	signal source1addOut_DE_OUT : std_logic_vector(2 downto 0);
	signal source2addOut_DE_OUT : std_logic_vector(2 downto 0);
	signal ImmediateSig_sig_DE_OUT : std_logic;
	signal MemWrite_PF_DE_OUT : std_logic;
	signal MemRead_PF_DE_OUT : std_logic;
	signal datain_PF_DE_OUT : std_logic_vector(n-1 downto 0);
	signal SP_signal_DE_OUT : std_logic_vector(1 downto 0);--########################
	signal IN_Value_DE_OUT : std_logic_vector(31 downto 0);--########################
	signal OUT_Enable_DE_OUT : std_logic;--########################
	signal FLags_Enable_DE_OUT: std_logic;--########################
---------------------------------------------------------------------------

----------------------------------ALU--------------------------------------
	 signal Carry_FlagOut,Negative_FlagOut,Zero_FlagOut,Overflow_FlagOut : std_logic; --Carry,negative,zero,OverFlow
	 signal ALUResult1 : std_logic_vector(31 DOWNTO 0);
	 signal ALUResult2 : std_logic_vector(31 DOWNTO 0);
	 signal ALU_ADDRESS :  std_logic_vector(11 DOWNTO 0);
---------------------------------------------------------------------------

-------------------------------ExecuteMemoryReg--------------------------------------------
	signal RegWriteOut_ExeMem :  std_logic_vector(1 downto 0); 
	signal MemReadOut_ExeMem : std_logic;
	signal MemWriteOut_ExeMem : std_logic;
	signal AluValueOut1_ExeMem :  std_logic_vector(31 DOWNTO 0);
	signal AluValueOut2_ExeMem :  std_logic_vector(31 DOWNTO 0);
	signal ALU_ADDRESS_ExeMem :  std_logic_vector(11 DOWNTO 0);
	
	signal DestAdrssOuT1_ExeMem :  std_logic_vector(2 DOWNTO 0);
	signal DestAdrssOuT2_ExeMem :  std_logic_vector(2 DOWNTO 0);
	signal WriteBackDataSrcOut_ExeMem :  std_logic_vector(1 downto 0);
	signal MemWrite_PF_ExeMem_OUT : std_logic;
	signal MemRead_PF_ExeMem_OUT : std_logic;
	signal datain_PF_ExeMem_OUT : std_logic_vector(n-1 downto 0);
	signal PF_address_ExeMem_OUT: std_logic_vector(11 DOWNTO 0);
	signal SP_signal_ExeMem_OUT : std_logic_vector(1 downto 0);--########################
	signal IN_Value_ExeMem_OUT : std_logic_vector(31 downto 0);--########################
	signal OUT_Enable_ExeMem_OUT : std_logic;--########################
------------------------------------------------------------------------------------
	signal DatMemValueOut_DataMem :  std_logic_vector(31 DOWNTO 0);

	signal RegWriteOut_MemWriteBack :  std_logic_vector(1 downto 0);
	signal DataMemoryValueOut_MemWB :  std_logic_vector(31 DOWNTO 0);
	signal AluValueOut1_MemWB :  std_logic_vector(31 DOWNTO 0);
	signal AluValueOut2_MemWB :  std_logic_vector(31 DOWNTO 0);
	signal DestAdrssOuT1_MemWB :  std_logic_vector(2 DOWNTO 0);
	signal DestAdrssOuT2_MemWB :  std_logic_vector(2 DOWNTO 0);
	signal WriteBackDataSrcOut_MemWB :  std_logic_vector(1 downto 0);

	signal IN_Value_MemWB_OUT : std_logic_vector(31 downto 0);--########################
	signal OUT_Enable_MemWB_OUT : std_logic;--########################
	signal OUT_Value_MemWB_OUT : std_logic_vector(31 downto 0);--########################

	signal Value1FromWriteBackStage :  std_logic_vector(31 DOWNTO 0);
	signal Value2FromWriteBackStage :  std_logic_vector(31 DOWNTO 0);
	
--------------------------------Memory Address-------------------------------------------

	--signal ALU_Address :  std_logic_vector(11 DOWNTO 0);
	signal STD_DATA_ExeMem : std_logic_vector(31 DOWNTO 0);
	signal PUSH_DATA_ExeMem : std_logic_vector(31 DOWNTO 0); --###############################
	signal STD_PUSH_DATA : std_logic_vector(31 DOWNTO 0); --###############################
	signal notclk :std_logic;

	signal dataOUT_PF : std_logic_vector(n-1 downto 0);

	signal Exception_OUT_Mem : std_logic; --#########################

-------------------------------CCR------------------------------------------
	signal FlagsOuT_CCR_in :  std_logic_vector(3 DOWNTO 0);
	signal FlagsOuT_CCR_Out :  std_logic_vector(3 DOWNTO 0);
	signal enable_CCR : std_logic;
----------------------------------------------------------------------------
-------------------------------FW_unit---------------------------------------
	signal FU_Mux1_Selector1_OUT : std_logic_vector(1 DOWNTO 0) ;
	signal FU_Mux1_OUTPUT : std_logic_vector(31 DOWNTO 0);

	signal FU_Mux2_Selector2_OUT : std_logic_vector(1 DOWNTO 0) ;
	signal FU_Mux2_OUTPUT : std_logic_vector(31 DOWNTO 0);
-------------------------------FW_unit---------------------------------------
------------------------------Latch------------------
	signal DestAdrssOuT1_LatchWB :  std_logic_vector(2 DOWNTO 0);
	signal RegWriteOuT_LatchWB :  std_logic_vector(1 DOWNTO 0);
	signal AlU_Valu1_OuT_LatchWB :  std_logic_vector(31 DOWNTO 0);
----------------------------------------------------------------------------
--------------------------Exception---------------------------
signal Exception_orring : std_logic;
 ---------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------

--type ndff_type is array(0 to n-1) of std_logic_vector(31 downto 0);---###################
--signal DFF_input_INport : ndff_type := (others=>(others=>'0'));---###################
--signal IN_Value : ndff_type := (others=>(others=>'0'));---###################


--signal DFF_input_OUTport : ndff_type := (others=>(others=>'0'));---###################


begin
 notclk <= not clk;
    ProgramCounterInst: pc 
	PORT MAP (
        	reset,
        	clk,
        	InstructionAddress_PCOut
    	);

    InstructionMemoryInst: instruction_cache 
	PORT MAP (
       		address_in => InstructionAddress_PCOut, 
        	data_out => Instruction
    	);

    --IN_PORT: my_DFF ---######################################################
	--PORT MAP (
		--DFF_input_INport(0),
		--IN_Value(0),clk,reset,'1'
	--);

	--OUT_PORT: my_DFF ---######################################################
	--PORT MAP (
		--OUT_Value_MemWB_OUT,---Value of reg1
		--DFF_input_OUTport(0),clk,reset,OUT_Enable_MemWB_OUT
	--);
----------------MUX1-------------
Mux1Sel<=('0'& ImmSignalOut_sig);
with Mux1Sel select
	Mux1Out_Instruction<=
		Instruction when "00", --Pass the 16bit instruction
		"0000000000000000" when others; --NOP
----------------------------------

----------------MUX2-------------
with ImmSignalOut_sig select
	Mux2Out_ImmediateValue<=
		Instruction when '1', --Pass the 16bit immediateValue
		"0000000000000000" when others; --hahot ay value lel immediate keda keda msh hay3ady fe el ex stage
----------------------------------

----------------MUX3-------------
with alusourceOut_sig_DE select
	Mux3Out_Src2orImm <=
		ImmediateValueorEA_ED when '1', --Pass the 32bit immediateValue or Effective address
		ValueOfReg2_ED when others; --Pass the value of reg2
----------------------------------
------------------MUX4-------------------3aiz a select el data ele gyale mn PUSH(Rdst) wla STD(Rsrc)--###########################
with SP_signal_ExeMem_OUT select
	STD_PUSH_DATA <=
		PUSH_DATA_ExeMem when "01",--PUSH
		(others=>'0') when "10",--POP 3aiz afdy el mkan ele 3mlt mno pop
		STD_DATA_ExeMem when others;


-----------MUX5----------------------FOR IN and OUT--################
with OUT_Enable_MemWB_OUT select
	OUTPORT <=
		OUT_Value_MemWB_OUT when '1',
		(others=>'0') when others;


--OUT_PORT: my_DFF ---######################################################
	--PORT MAP (
		--OUT_Value_MemWB_OUT,---Value of reg1
		--DFF_input_OUTport(0),clk,reset,OUT_Enable_MemWB_OUT
	--);












-------------------------------------------FU--------------------------------------------------------
ForwardUnitInst: forwardingUnit 
        PORT MAP (
		clk,
        	WriteBackDataSrcOut_ExeMem, --ely dakhel 3ala el EM
		WriteBackDataSrcOut_MemWB,

        	RegWriteOut_ExeMem,
        	RegWriteOut_MemWriteBack,
		RegWriteOuT_LatchWB,
		

        	DestAdrssOut1_ExeMem,
		DestAdrssOuT1_MemWB,
		DestAdrssOuT1_LatchWB, --3ayez dest ely dakhel 3ala el WB reg

        	source1addOut_DE_OUT,
        	source2addOut_DE_OUT,

		FU_Mux1_Selector1_OUT,
        	FU_Mux2_Selector2_OUT,

		ImmediateSig_sig_DE_OUT

       	 );


----------------MUX FU1-------------
with FU_Mux1_Selector1_OUT select --ely tale3 men hena dakhel 3ala ALU 1
	FU_Mux1_OUTPUT<=
		AluValueOut1_ExeMem when "01", --Pass from EM Reg
		AluValueOut1_MemWB when "10", --Pass from MWB Reg
		AlU_Valu1_OuT_LatchWB when "11", -- from Latch buffer
		ValueOfReg1_ED when others; --Pass the regfile src1
------------------------------------
----------------MUX FU2-------------
with FU_Mux2_Selector2_OUT select --ely tale3 men hena dakhel 3ala ALU 2
	FU_Mux2_OUTPUT <=
		AluValueOut1_ExeMem when "01", --Pass from EM Reg
		AluValueOut1_MemWB when "10", --Pass from MWB Reg
		AlU_Valu1_OuT_LatchWB when "11",
		Mux3Out_Src2orImm when others; --Pass the regfile src2 or immediate value
------------------------------------

----------------Latch---------------
LatchInst: Latch
	PORT MAP (clk,
		reset,
		DestAdrssOuT1_MemWB,
		RegWriteOut_MemWriteBack,
		DestAdrssOuT1_LatchWB,
		RegWriteOuT_LatchWB,
		AluValueOut1_MemWB,
		AlU_Valu1_OuT_LatchWB
);
		
-------------------------------------------------------------------------------------------------------

    FetchDecodeInst: FetchDecodeReg 
        PORT MAP (
        	clk,
        	reset,
        	Mux1Out_Instruction,
        	FetchDecodeOut,
		INPORT,------######################################
		IN_Value_FD_OUT----#################################
       	 );

	DecodeInst: Decode 
	PORT MAP (
        	FetchDecodeOut,
        	AluSelectorOut_sig,
        	alusourceOut_sig,
        	MWriteOut_sig,
		MReadOut_sig,
		WBdatasrcOut_sig,
		RegWriteOut_sig,
		clk,
		reset,
		--wrtenIn_sig,
		RegWriteOut_MemWriteBack,
		--writeport0In,
		Value1FromWriteBackStage,
		Value2FromWriteBackStage,
		Readport0Out,
		Readport1Out,
		--WriteAdd0In,
		DestAdrssOuT1_MemWB,
		DestAdrssOuT2_MemWB,
		ImmSignalOut_sig,
		destOut1,
		destout2,
		source1addOut,
		source2addOut,
		MemWrite_PF,
		MemRead_PF,
		datain_PF,
		SP_signal,--############
		OUT_Enable,--###############
		FLAGS_Enable
    	);

-------------SignExtend-----------
 SignExtendInst: SignExtend 
	 PORT MAP (
         	Mux2Out_ImmediateValue,
         	SignExtendOut
        );
-----------------------------------

    DecodeExecuteInst: DecodeExecute 
        PORT MAP (
            clk,
            reset,
            RegWriteOut_sig,
            AluSelectorOut_sig,
	    alusourceOut_sig,
	    alusourceOut_sig_DE,
	    MReadOut_sig,
	    MReadOut_sig_DE,
	    MWriteOut_sig,
	    MWriteOut_sig_DE,
	    SignExtendOut, --ImmediateValue
	    ImmediateValueorEA_ED,  --ImmediateValue or EA Output
	    RegWriteOut_ED,
	    ALUSelectorsOut_ED,
	    Readport0Out,
	    Readport1Out,
	    ValueOfReg1_ED,
	    ValueOfReg2_ED,
	    destOut1,
	    destOut2,
	    DestAdrssOut1_ED,
	    DestAdrssOut2_ED,
	    WriteBackDataSrcOut_ED,
	    WBdatasrcOut_sig,
	    source1addOut,
	    source2addOut,

	    source1addOut_DE_OUT,
	    source2addOut_DE_OUT,

		ImmSignalOut_sig,
	        ImmediateSig_sig_DE_OUT,
		MemWrite_PF,
		MemWrite_PF_DE_OUT,
		MemRead_PF,
		MemRead_PF_DE_OUT,
		datain_PF,
		datain_PF_DE_OUT,
		SP_signal,--#######	
		SP_signal_DE_OUT,--############	
		IN_Value_FD_OUT,--###############
		IN_Value_DE_OUT,--#################
		OUT_Enable,--###############
		OUT_Enable_DE_OUT,--###############
		FLAGS_Enable,--################
		FLags_Enable_DE_OUT--###################
		
        );


    ALUInst: ALU
	PORT MAP (
      		 FU_Mux1_OUTPUT, --FU1
       		 FU_Mux2_OUTPUT, --FU2
        	 ALUSelectorsOut_ED,
		 Carry_FlagOut,
		 Negative_FlagOut,
		 Zero_FlagOut,
		 Overflow_FlagOut,
		 '0','0','0','0',   --nonset
		 ALUResult1,----ORring for exception
		 ALUResult2
    );


-----------------------------------------------

ALU_Address <= ALUResult1(11 downto 0);--Memory Address ele tal3 mn el ALU

Exception_orring <= or_reduce(ALUResult1(31 downto 12));--##############################

--y <= or_reduce(a);


--------------------Flag Reg---------------------------
	--FlagsOuT_CCR_in <= Zero_FlagOut & Negative_FlagOut & Carry_FlagOut & Overflow_FlagOut;
	FlagsOuT_CCR_in <= Overflow_FlagOut & Carry_FlagOut & Negative_FlagOut & Zero_FlagOut;

	--enable_CCR<=(Carry_FlagOut or Negative_FlagOut or Zero_FlagOut or Overflow_FlagOut);
CCRInst: CCR 
        PORT MAP (
	FlagsOuT_CCR_in,
	FlagsOuT_CCR_Out  , 
  	clk,
	reset,
	--'1'
	FLags_Enable_DE_OUT
	
);

-------------------------------------------------------
ExecuteMemoryInst: ExecuteMemory 
        PORT MAP (
            clk,
            reset,
            RegWriteOut_ED,
	    RegWriteOut_ExeMem,
	    MReadOut_sig_DE,
	    MemReadOut_ExeMem,
	    MWriteOut_sig_DE,
	    MemWriteOut_ExeMem,
	    ALUResult1,
	    ALUResult2,
	    AluValueOut1_ExeMem,
	    AluValueOut2_ExeMem,
	    DestAdrssOut1_ED,
	    DestAdrssOut2_ED,
	    DestAdrssOuT1_ExeMem,
	    DestAdrssOuT2_ExeMem,
	    WriteBackDataSrcOut_ExeMem,
	    WriteBackDataSrcOut_ED,
	    ALU_ADDRESS,
	    ALU_ADDRESS_ExeMem,
	    ValueOfReg2_ED,--3shan el STD
	    STD_DATA_ExeMem,
		MemWrite_PF_DE_OUT,
		MemWrite_PF_ExeMem_OUT,
		MemRead_PF_DE_OUT,
		MemRead_PF_ExeMem_OUT,
		datain_PF_DE_OUT,
		datain_PF_ExeMem_OUT,
		ValueOfReg1_ED(11 DOWNTO 0),
		PF_address_ExeMem_OUT,
		SP_signal_DE_OUT,--##################
		SP_signal_ExeMem_OUT,--########################
		ValueOfReg1_ED,--3shan el push
		PUSH_DATA_ExeMem,--###########################
		IN_Value_DE_OUT,--##########################
		IN_Value_ExeMem_OUT,--######################
		OUT_Enable_DE_OUT,--###############
		OUT_Enable_ExeMem_OUT--###############
        );
 

--DataMemoryInst: DataMemory 
  --      PORT MAP (
    --        clk,
      --     reset,
--MemWriteOut_ExeMem,
--MemReadOut_ExeMem,
--ALU_ADDRESS_ExeMem,
--STD_DATA_ExeMem,
--DatMemValueOut_DataMem
  
--);

MemoryStageInst: MemoryStage
--GENERIC (n : integer := 1);
	PORT MAP(
		clk,
		reset,
		ALU_ADDRESS_ExeMem,
		PF_address_ExeMem_OUT,
		MemWrite_PF_ExeMem_OUT,
		MemRead_PF_ExeMem_OUT,
		datain_PF_ExeMem_OUT,
		dataOUT_PF,
		MemWriteOut_ExeMem,
		MemReadOut_ExeMem,
		--STD_DATA_ExeMem,
		STD_PUSH_DATA,--################
		DatMemValueOut_DataMem,
		SP_signal_ExeMem_OUT,--##################
		Exception_OUT_Mem--#####################
		);


	Exception_OUT <= Exception_OUT_Mem OR Overflow_FlagOut ;--OR (NOT(SP_signal_ExeMem_OUT(1) AND SP_signal_ExeMem_OUT(0)) AND Exception_orring);--########################

MemWriteBackInst: MemoryWriteBack 
        PORT MAP (
            clk,
  	    reset,
	   RegWriteOut_ExeMem,
	   RegWriteOut_MemWriteBack,

-----R typr inst---
AluValueOut1_ExeMem,
AluValueOut2_ExeMem,
AluValueOut1_MemWB,
AluValueOut2_MemWB,
-------------------

-----load----------
DatMemValueOut_DataMem,
DataMemoryValueOut_MemWB,
--
DestAdrssOuT1_ExeMem,
DestAdrssOuT2_ExeMem,
DestAdrssOuT1_MemWB,
DestAdrssOuT2_MemWB,

--
WriteBackDataSrcOut_MemWB,
WriteBackDataSrcOut_ExeMem,

IN_Value_ExeMem_OUT,--########################
IN_Value_MemWB_OUT,--###################   
OUT_Enable_ExeMem_OUT,--###################   
OUT_Enable_MemWB_OUT,--###################   
PUSH_DATA_ExeMem,--################### 
OUT_Value_MemWB_OUT--################### 
);


WriteBackStageInst: WriteBackStage 
        PORT MAP (
            --clk,
  	IN_Value_MemWB_OUT, ---in port haga######################################
	DataMemoryValueOut_MemWB,
	AluValueOut1_MemWB,
	AluValueOut2_MemWB,
	WriteBackDataSrcOut_MemWB,
	Value1FromWriteBackStage,	
	Value2FromWriteBackStage
         
);

  
end architecture struct;


