library IEEE;
use IEEE.std_logic_1164.all;

entity verificator_pin is
	port (A, B: in std_logic_vector(15 downto 0);
	clk, enable: in std_logic;
	pin_bun, done: out std_logic);
end verificator_pin;

architecture ar1 of verificator_pin is
begin
	process(A, B, clk, enable)
	variable inter:std_logic;
	begin 
		inter:= '0';
		if clk'EVENT and clk='1' then
			if enable='1' then 
				inter:='1';
				for i in 0 to 15 loop
					if A(i)/=B(i) then
						inter:='0';
					end if;
				end loop;
				done <= '1'; --adica rezultatul care iese pe pin bun e ok, nu e cel ramas de dinainte
			else done <= '0';	
			end if;	
			pin_bun<=inter;
		end if;	
	end process;
end ar1;