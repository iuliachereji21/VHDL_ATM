library IEEE;
use IEEE.std_logic_1164.all;

entity registru_pin is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(15 downto 0);
	Out_pin: out std_logic_vector(15 downto 0));
end registru_pin;

architecture ar1 of registru_pin is
begin
	process(clk,rst,enable)
	begin
		if rst = '1' then
			Out_pin<="0000000000000000";
		else 
			if clk'EVENT and clk='1' and enable= '1' then
				Out_pin <= In_switchuri;
			end if;
		end if;	
	end process;
end ar1;	