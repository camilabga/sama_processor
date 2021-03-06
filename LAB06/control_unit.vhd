library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port(clock, clear: in std_logic;
         rom_out: in std_logic_vector(15 downto 0);
         rom_addr: out std_logic_vector(7 downto 0);
         D_addr: out std_logic_vector(7 downto 0);

         opcode_ex: out std_logic_vector(3 downto 0);
         pc_out_ex: out std_logic_vector(7 downto 0);
         ir_out_ex: out std_logic_vector(15 downto 0);

         D_wr, RF_s, RF_W_wr, RF_Rp_rd, RF_Rq_rd, alu_s0, I_rd: out std_logic;
         RF_W_addr, RF_Rp_addr, RF_Rq_addr: out std_logic_vector(3 downto 0));
end control_unit;

architecture cu of control_unit is

component comparador is
	port(a,b:in std_logic_vector(3 downto 0);
	aMENORb,aMAIORb,aIGUALb:out std_logic);
end component;

component instruction_register is
    port(data_in: in std_logic_vector(15 downto 0);
         ld, clock, clear: in std_logic;
         data_out: out std_logic_vector(15 downto 0));
end component;

component program_counter is
    port(PC_clr, PC_inc, PC_clk: in std_logic;
         addr: out std_logic_vector(7 downto 0));
end component;

component clk_pcir is
	port (clk_in : in std_logic;
			clk_out : out std_logic);
end component;

signal opcode: std_logic_vector(3 downto 0);
signal ir_out: std_logic_vector(15 downto 0);
signal pc_out: std_logic_vector(7 downto 0);
signal opcode0, opcode1, opcode2, clk_pc_ir: std_logic;
signal IR_ld, PC_clr, PC_clk: std_logic;

begin

opcode <= ir_out(15 downto 12);

OPCODE00: comparador port map(opcode, "0000", open, open, opcode0);
OPCODE01: comparador port map(opcode, "0001", open, open, opcode1);
OPCODE02: comparador port map(opcode, "0010", open, open, opcode2);

D_addr <= ir_out(7 downto 0);
RF_W_addr <= ir_out(11 downto 8);
RF_Rq_addr <= ir_out(3 downto 0);

RF_Rp_addr <= ir_out(11 downto 8) when opcode1='1' else
              ir_out(7 downto 4) when opcode2='1';

RF_s <= opcode0;

RF_W_wr <= opcode0 or opcode2;

D_wr <= opcode1;
RF_Rp_rd <= opcode1 or opcode2;

RF_Rq_rd <= opcode2;
alu_s0 <= opcode2;

CLOCKpcIR: clk_pcir port map(clock, clk_pc_ir);

I_rd <= clk_pc_ir;
IR_ld <= clk_pc_ir;

IR0: instruction_register port map(rom_out, IR_ld, clock, clear, ir_out);
PC0: program_counter port map(PC_clr, '1', clk_pc_ir, pc_out);

rom_addr <= pc_out;

opcode_ex <= opcode;
ir_out_ex <= ir_out;
pc_out_ex <= pc_out;

end cu;