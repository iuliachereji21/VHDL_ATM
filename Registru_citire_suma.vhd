library IEEE;
use IEEE.std_logic_1164.all;

entity registru_suma is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(15 downto 0);
	Out_suma: out std_logic_vector(15 downto 0));
end registru_suma;

architecture ar1 of registru_suma is
begin
	process(clk,rst,enable)
	begin
		if rst = '1' then
			Out_suma<="0000000000000000";
		else 
			if clk'EVENT and clk='1' and enable= '1' then
				Out_suma <= In_switchuri;
			end if;
		end if;	
	end process;
end ar1;	