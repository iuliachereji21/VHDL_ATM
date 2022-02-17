library IEEE;
use IEEE.std_logic_1164.all;

entity ram_atm is
	port(write_en,clk:in std_logic;
	suma_in: in std_logic_vector(15 downto 0);
	suma_out: out std_logic_vector(15 downto 0));
end ram_atm;

architecture arh_ram_atm of ram_atm is	
signal m_ram: std_logic_vector(15 downto 0):="0011111010000000"; --16000
begin		
	process(clk) 
	variable mem:std_logic_vector(15 downto 0);
	begin
		mem:=m_ram;
		if (clk = '1') and (clk'EVENT) then	
			if write_en = '1' then
				m_ram<=suma_in;
				mem:=suma_in;
			end if;
			suma_out<=mem;	
		end if;
	end process;
end arh_ram_atm;