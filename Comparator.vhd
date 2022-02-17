library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity comparator is
	port(A,B:in std_logic_vector(15 downto 0); --A suma din cont/atm, B suma ceruta 
	enable:in std_logic;
	result:out std_logic_vector(2 downto 0)); --r(2)=grater(A>B)=> ok, r(1)=equal => ok,  r(0)=less (A<B) => not ok
end comparator;	

architecture a1 of comparator is
begin
	process (enable, A, B)
	variable nr1: integer;
	variable nr2: integer;
	begin 
		--if clk'event and clk = '1' then
			if enable='1' then
				nr1:= conv_integer(A);
				nr2:= conv_integer(B);
				if nr1 = nr2 then
					result <= "010";
				else
					if nr1 > nr2 then
						result<= "100";
					else result <= "001";
					end if;
				end if;
			else result <= "000";	
			end if;		
		--end if;
	end process;	



end a1;