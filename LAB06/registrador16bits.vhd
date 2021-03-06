library ieee;
use ieee.std_logic_1164.all;

entity registrador16Bits is
	port(clock,ld,Preset,Clear	: in std_logic;
			D: in std_logic_vector(15	downto 0);
			Q:out std_logic_vector(15 downto 0));
end registrador16Bits;

architecture ckt of registrador16Bits is

component FFD is
	port(clk,D,P,C	:in std_logic;
			q:out std_logic);
end component;

signal z, sQ	:std_logic_vector(15 downto 0);
begin 

	z(0) 	<= ((D(0) and ld) or(sQ(0) and not ld));
	z(1) 	<= ((D(1) and ld) or(sQ(1) and not ld));
	z(2) 	<= ((D(2) and ld) or(sQ(2) and not ld));
	z(3) 	<= ((D(3) and ld) or(sQ(3) and not ld));
	z(4) 	<= ((D(4) and ld) or(sQ(4) and not ld));
	z(5) 	<= ((D(5) and ld) or(sQ(5) and not ld));
	z(6) 	<= ((D(6) and ld) or(sQ(6) and not ld));
	z(7) 	<= ((D(7) and ld) or(sQ(7) and not ld));
	z(8) 	<= ((D(8) and ld) or(sQ(8) and not ld));
	z(9) 	<= ((D(9) and ld) or(sQ(9) and not ld));
	z(10) 	<= ((D(10) and ld) or(sQ(10) and not ld));
	z(11) 	<= ((D(11) and ld) or(sQ(11) and not ld));
	z(12) 	<= ((D(12) and ld) or(sQ(12) and not ld));
	z(13) 	<= ((D(13) and ld) or(sQ(13) and not ld));
	z(14) 	<= ((D(14) and ld) or(sQ(14) and not ld));
	z(15) 	<= ((D(15) and ld) or(sQ(15) and not ld));
	
	FFD0: FFD port map(clock,z(0),Preset,Clear,sQ(0));
	FFD1: FFD port map(clock,z(1),Preset,Clear,sQ(1));
	FFD2: FFD port map(clock,z(2),Preset,Clear,sQ(2));
	FFD3: FFD port map(clock,z(3),Preset,Clear,sQ(3));
	FFD4: FFD port map(clock,z(4),Preset,Clear,sQ(4));
	FFD5: FFD port map(clock,z(5),Preset,Clear,sQ(5));
	FFD6: FFD port map(clock,z(6),Preset,Clear,sQ(6));
	FFD7: FFD port map(clock,z(7),Preset,Clear,sQ(7));
	FFD8: FFD port map(clock,z(8),Preset,Clear,sQ(8));
	FFD9: FFD port map(clock,z(9),Preset,Clear,sQ(9));
	FFD10: FFD port map(clock,z(10),Preset,Clear,sQ(10));
	FFD11: FFD port map(clock,z(11),Preset,Clear,sQ(11));
	FFD12: FFD port map(clock,z(12),Preset,Clear,sQ(12));
	FFD13: FFD port map(clock,z(13),Preset,Clear,sQ(13));
	FFD14: FFD port map(clock,z(14),Preset,Clear,sQ(14));
	FFD15: FFD port map(clock,z(15),Preset,Clear,sQ(15));

	Q <= sQ;
	
end ckt;
