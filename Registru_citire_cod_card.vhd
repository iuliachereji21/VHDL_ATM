library IEEE;
use IEEE.std_logic_1164.all;

entity registru_cod_card is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(3 downto 0);
	Out_cod: out std_logic_vector(3 downto 0));
end registru_cod_card;

architecture ar1 of registru_cod_card is
begin
	process(clk,rst,enable)
	begin
		if rst = '1' then
			Out_cod<="0000";
		else 
			if clk'EVENT and clk='1' and enable= '1' then --doar daca dam enable se citeste val din switchuri, altfel, pe data out ramane ce a fost inainte
				Out_cod <= In_switchuri;
			end if;
		end if;	
	end process;
end ar1;	