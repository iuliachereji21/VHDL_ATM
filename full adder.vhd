-------------------------------------------------------------------------------
--
-- Title       : \full adder\
-- Design      : PROIECT
-- Author      : asus
-- Company     : Technical University of Cluj Napoca
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\PROIECT\PROIECT\src\full adder.vhd
-- Generated   : Wed Apr 15 16:53:21 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {\full adder\} architecture {\full adder\}}
library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity fulladder is
	generic(N:integer:=16);
	port(A,B:in std_logic_vector(N-1 downto 0);
	CIN, enable:in std_logic;
	SUM:out std_logic_vector(N-1 downto 0);
	COUT:out std_logic);
end fulladder;

--}} End of automatically maintained section

architecture arh_full of fulladder is  
signal mem_adunare: std_logic_vector(15 downto 0):="0000000000000000"; --ca sa retina suma
begin
	process (A,B,CIN,enable)
	variable Extended_sum:std_logic_vector(N downto 0);
	begin
		if enable='1' then
			Extended_sum:=('0'&A)+('0'&B)+CIN;
			COUT<=Extended_sum(N);
			SUM<=Extended_sum(N-1 downto 0);
			mem_adunare<= Extended_sum(N-1 downto 0);
		else SUM <= mem_adunare;
		end if;	
	end process;	
end arh_full;
