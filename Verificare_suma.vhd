library IEEE;
use IEEE.std_logic_1164.all;  

entity verificator_suma is
	port(suma_ceruta, suma_cont, suma_atm: in std_logic_vector(15 downto 0);
	clk, enable: in std_logic;
	suma_ok, done_verif:out std_logic);
end verificator_suma;

architecture a1 of verificator_suma is 	  

component comparator is
	port(A,B:in std_logic_vector(15 downto 0); --A suma din cont/atm, B suma ceruta 
	enable:in std_logic;
	result:out std_logic_vector(2 downto 0)); --r(2)=grater(A>B)=> ok, r(1)=equal => ok,  r(0)=less (A<B) => not ok
end component comparator;	 

signal r1,r2,r3 :std_logic_vector(2 downto 0);
signal ok2: std_logic;

begin 
	
	C1: comparator port map (A=> suma_cont, B => suma_ceruta, enable => enable, result => r1);
	C2: comparator port map (A=> suma_atm, B => suma_ceruta, enable => enable, result => r2);
	C3: comparator port map (A=> "0000001111101000", B => suma_ceruta, enable => enable, result => r3);
	
	process(clk, enable, suma_ceruta, suma_cont, suma_atm)	
	variable ok:std_logic;
	begin 
		if clk'event and clk='1' then  
			if enable='1' then
				ok:='1';
				if r1(0)='1' or r2(0)='1' or r3(0)='1' then
					ok:='0';
				end if;
				suma_ok<= ok;
				done_verif<='1';
				ok2 <= ok;
			else 
				suma_ok<= ok2;
				done_verif<='0';
			end if;
		end if;
	end process;	
end a1;