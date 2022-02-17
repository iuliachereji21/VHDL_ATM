library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
	port(sub,add:in std_logic_vector(15 downto 0);
	sel:in std_logic; --0=>sub, 1=>add
	out_mux: out std_logic_vector(15 downto 0));
end mux;

architecture a1 of mux is
begin
	process(sel,sub,add)
	begin
		if sel='0' then
			out_mux<=sub;
		else out_mux<=add;
		end if;	
	end process;	
end a1;
	