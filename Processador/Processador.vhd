library ieee;
use ieee.std_logic_1164.all;

entity Processador is
	port(	clk27, sw17		: in  std_logic;
			sw: in std_LOGIC_VECTOR(7 downto 0);
			out0, out1, out2: out std_LOGIC_VECTOR(6 downto 0)
			--;Ld_PC		: in  std_logic
			; A,B,C,D,pc, ram_out :out std_logic_vector(7 downto 0)--teste
			;Ld_PC, Ld_IR,Wr_ABCD,Ld_mar_ABCD		:out std_logic
			;opcode, write_data	: out std_logic_vector(7 downto 0)	--teste
			;entrada2			:out std_logic_vector(7 downto 0)--teste
			);
end Processador;


architecture ckt of Processador is
	component bcd3_conversor is
		port(bin3ary: in std_logic_vector(9 downto 0);
        b3cd: out std_logic_vector(11 downto 0));
	end component;

	component clk_div is
		port (clk_in : in std_logic;
			clk_out : out std_logic);
	end component;
	
	component display is
		port(inn: in std_logic_vector (3 downto 0);
			outt: out std_logic_vector (6 downto 0));
	end component;	
	
	component datapath is
	port(	read_data, pc, sp		:in  std_logic_vector(7 downto 0);
	     	op_ula 					:in  std_logic_vector(3 downto 0);
			Sel_addr_mem			:in	std_logic_vector(1 downto 0);
			clk, Sel_mar_mem, Ld_mar_mem, Sel_se_mult, Wr_ABCD, Ld_mar_ABCD, 
			Sel_addr_ABCD, Sel_mem_in, Sel_ABCD_in, Sel_ULA_in, 
			Ld_ULA, Clr_ULA, Sel_case_SP: in  std_logic;
	     	write_data, addr_mem		: out std_logic_vector(7 downto 0);
	     	carry,zero 					:out std_logic
			;A,B,C,D,reg2	: out std_logic_vector(7 downto 0)--teste
			);
	end component;
	
	component ram is
		port(	address_a	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				address_b	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				clock			: IN STD_LOGIC  := '1';
				data_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				data_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren_a		: IN STD_LOGIC  := '0';
				wren_b		: IN STD_LOGIC  := '0';
				q_a			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				q_b			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
	end component;
	component controller is
		port(	read_data					:in 	std_logic_vector(7 downto 0);
				carry, z,clk						: in  std_logic;
				op_ula 						:out  std_logic_vector(3 downto 0);
				Sel_addr_mem				:out	std_logic_vector(1 downto 0);
				Sel_mar_mem, Ld_mar_mem, Sel_se_mult, Wr_ABCD, Ld_mar_ABCD, 
				Sel_addr_ABCD, Sel_mem_in, Sel_ABCD_in, Sel_ULA_in, 
				Ld_ULA, Clr_ULA, Sel_case_SP,wr_mem 	: out  std_logic;
				pc,sp		: out std_logic_vector(7 downto 0)
				;Ld_PC, Ld_IR :out std_logic		--teste
				;opcode	: out std_logic_vector(7 downto 0)	--teste
				);
	end component;
	
	signal saddr_mem, swrite_data, sread_data,spc,ssp : std_logic_vector(7 downto 0);
	signal sop_ula 					: std_logic_vector(3 downto 0);
	signal sSel_addr_mem 			: std_logic_vector(1 downto 0);
	signal swr_mem,scarry, szero 	: std_logic;
	signal sA,sB, sC, sD, sopcode,sentrada2 	: std_logic_vector(7 downto 0);--teste
	signal sSel_mar_mem, sLd_mar_mem, sSel_se_mult, sWr_ABCD, sLd_mar_ABCD, 
				sSel_addr_ABCD, sSel_mem_in, sSel_ABCD_in, sSel_ULA_in, 
				sLd_ULA, sClr_ULA, sSel_case_SP : std_logic;
				
	signal	sLd_PC, sLd_IR : std_logic;
	
	signal clk, clock: std_logic;
	signal out_mem_visu: std_logic_vector(7 downto 0);
	signal in_display: std_logic_vector(11 downto 0);
	signal d0, d1, d2: std_LOGIC_VECTOR(6 downto 0);
	
	
begin

	--clockzao: clk_div port map(clk27, clock);
	clock <= clk27;
	clk <= clock or sw17;

	ram_pm		: ram port map(saddr_mem, sw, clock, swrite_data, "00000000", swr_mem,'0',sread_data, out_mem_visu);
	datapath_pm 	: datapath 	port map
			  (sread_data, spc, ssp,		
				sop_ula,	sSel_addr_mem,	
				clk, sSel_mar_mem, sLd_mar_mem, sSel_se_mult, sWr_ABCD, sLd_mar_ABCD, 
				sSel_addr_ABCD, sSel_mem_in, sSel_ABCD_in, sSel_ULA_in, 
				sLd_ULA, sClr_ULA, sSel_case_SP,
				swrite_data, saddr_mem,scarry, szero
				,sA,sB, sC, sD --TESTE
				,sentrada2
				);
				
	bcdvdc: bcd3_conversor port map("00"&out_mem_visu, in_display);
	
	display0: display port map(in_display(3 downto 0), d0);
	display1: display port map(in_display(7 downto 4), d1);
	display2: display port map(in_display(11 downto 8), d2);
	
	out0 <= d0;
	out1 <= d1;
	out2 <= d2;
				
	controller_pm	: controller port map(	sread_data,scarry, szero, clk, 
				sop_ula, sSel_addr_mem,
				sSel_mar_mem, sLd_mar_mem, sSel_se_mult, sWr_ABCD, sLd_mar_ABCD, 
				sSel_addr_ABCD, sSel_mem_in, sSel_ABCD_in, sSel_ULA_in, 
				sLd_ULA, sClr_ULA, sSel_case_SP,swr_mem,
				spc,ssp
				,sLd_PC, sLd_IR, sopcode	--teste
				);
	------------------------
	A <= sA;
	B <= sB;
	C <= sC;
	D <= sD;
	pc<=spc;
	Ld_PC <= sLd_PC;
	Ld_IR	<=sLd_IR;
	ram_out 	<=sread_data;
	Ld_mar_ABCD	<= sLd_mar_ABCD;
	Wr_ABCD	<= sWr_ABCD;
	opcode	<= sopcode;
	write_data	<= swrite_data;
	entrada2<=sentrada2;
	-----------
end ckt;