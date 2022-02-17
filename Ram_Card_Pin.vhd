library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity ram_card_pin is
	port(cod_card: in std_logic_vector(3 downto 0); --adresele(16 adrese capacitate)
	--reset: in std_logic;
	write_en: in std_logic;
	clock: in std_logic;
	data_in_pin: in std_logic_vector(15 downto 0);	--pinul pe 16 biti (4 cifre BCD)
	out_pin: out std_logic_vector(15 downto 0));
end ram_card_pin; 

architecture arh_ram_card_pin of ram_card_pin is	
type MEM_RAM_TYPE is array(0 to 15) of std_logic_vector(15 downto 0);
signal m_ram: MEM_RAM_TYPE:=(
							  "0010011101010100", --2754 0
							  "0000000100110000", --0130 1
							  "0000100100100111", --0927 2
							  "0110100110010000", --6990 3
							  "0001000100010000", --1110 4
							  "0001001000110000", --1230 5
							  "0000000001010000", --0050 6
							  "0000000000010000", --0010 7
							  "0001001000110100", --1234 8
							  "0010000100000011", --2103 9
							  "0010011100000011", --2703 10
							  "0010011100000110", --2706 11
							  "0000000000000000", --0000 12
							  "0101011001111000", --5678 13
							  "0010000000000000", --2000 14
							  "0001100110011001"); --1999 15
							  --others => "0000000000000000");--daca mai vrem sa mai adaugam carduri (pinuri)
begin	
	ram_process: process(clock)
	begin
		if (clock = '1') and (clock'EVENT) then	
			--if reset='1' then
				--m_ram <= (others => (others => '0'));
			--els
			if write_en = '1' then
				m_ram(conv_integer(cod_card)) <= data_in_pin;		
			end if;
			out_pin <=m_ram(conv_integer(cod_card));	
		end if;
	end process;
end arh_ram_card_pin;	