library ieee;
use ieee.std_logic_1164.all;

entity operations is
    port(moeda_value, moeda_value_a2, value: in std_logic_vector(9 downto 0);
		 nao_tem_moeda_atual: in std_logic;
         trocar_moeda, manter_moeda, ultima_moeda: out std_logic;
         next_value: out std_logic_vector(9 downto 0));
end operations;

architecture ckt of operations is

component comparador is
	port(a,b:in std_logic_vector(9 downto 0);
	aMENORb,aMAIORb,aIGUALb:out std_logic);
end component;

component somador10bits is
	port(a,b:in  std_logic_vector(9 downto 0);
	     c:out std_logic_vector(9 downto 0);
	     cin: in std_logic;
	     cout:out std_logic);
end component;

signal trocar_moeda_aux, manter_moeda_aux, ultima_moeda_aux: std_logic;
signal moeda_value_a2_aux, next_value_aux: std_logic_vector(9 downto 0);

begin

COMPARADOR0: comparador port map(value, moeda_value, trocar_moeda_aux, manter_moeda_aux, ultima_moeda_aux);

moeda_value_a2_aux(0) <= (moeda_value_a2(0) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(1) <= (moeda_value_a2(1) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(2) <= (moeda_value_a2(2) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(3) <= (moeda_value_a2(3) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(4) <= (moeda_value_a2(4) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(5) <= (moeda_value_a2(5) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(6) <= (moeda_value_a2(6) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(7) <= (moeda_value_a2(7) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(8) <= (moeda_value_a2(8) and not trocar_moeda_aux) and not nao_tem_moeda_atual;
moeda_value_a2_aux(9) <= (moeda_value_a2(9) and not trocar_moeda_aux) and not nao_tem_moeda_atual;

SOMADOR10: somador10bits port map(value, moeda_value_a2_aux, next_value_aux, '0', open);

trocar_moeda <= trocar_moeda_aux;
manter_moeda <= manter_moeda_aux;
ultima_moeda <= ultima_moeda_aux and not nao_tem_moeda_atual;

next_value <= next_value_aux;

end ckt;