library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.std_logic_unsigned.all;

entity x7seg is
	port(BCD: in std_logic_vector(3 downto 0);
	enable: in std_logic;
	Afisor: out std_logic_vector(6 downto 0));
end x7seg;

architecture A of x7seg is
type MM is array (9 downto 0) of std_logic_vector(6 downto 0);
signal harta: MM:=(
					"0000100", --9
					"0000000", --8
					"0001111", --7
					"0100000", --6
					"0100100", --5
					"1001100", --4
					"0000110", --3
					"0010010", --2
					"1001111", --1
					"0000001"); --0

begin
	process(enable)
	begin
		if enable = '1' then
			Afisor<=harta(conv_integer(BCD));
		else 			
			Afisor<= "1111111";
		end if;
	end process;
end A;
					
					
					