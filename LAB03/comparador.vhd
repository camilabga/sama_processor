library ieee;
use ieee.std_logic_1164.all;

entity comparador is
	port(a,b:in std_logic_vector(7 downto 0);
	aMENORb,aMAIORb,aIGUALb:out std_logic);
end comparador;

architecture compare of comparador is
begin
	aIGUALb <= '1' when a = b else '0';
	aMENORb <= '1' when a < b else '0';
	aMAIORb <= '1' when a > b else '0';
end compare;
