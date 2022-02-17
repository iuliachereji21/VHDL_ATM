library IEEE;
use IEEE.std_logic_1164.all;

entity registru_operatie is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(1 downto 0);
	Out_operatie: out std_logic_vector(1 downto 0));
end registru_operatie;

architecture ar1 of registru_operatie is
begin
	process(clk,rst,enable)
	begin
		if rst = '1' then
			Out_operatie<="00";
		else 
			if clk'EVENT and clk='1' then 
				if enable= '1' then
					Out_operatie <= In_switchuri;
				end if; 
			end if;
		end if;	
	end process;
end ar1;	