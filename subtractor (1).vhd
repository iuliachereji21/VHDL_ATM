-------------------------------------------------------------------------------
--
-- Title       : sumator
-- Design      : PROIECT
-- Author      : asus
-- Company     : Technical University of Cluj Napoca
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\PROIECT\PROIECT\src\sumator.vhd
-- Generated   : Wed Apr 15 14:56:45 2020
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
--{entity {sumator} architecture {sumator}}


library IEEE;
use IEEE.std_logic_1164.all;	
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity fullsubtr is
	generic(N:integer:=16);
	port(A,B:in std_logic_vector(N-1 downto 0);
	BIN, enable:in std_logic;
	DIFF:out std_logic_vector(N-1 downto 0);
	BOUT:out std_logic);
end fullsubtr;

--}} End of automatically maintained section

architecture arh_full of fullsubtr is 
signal mem_scadere: std_logic_vector(15 downto 0):="0000000000000000"; --ca sa retina diferenta
begin  
	process (A,B,BIN,enable)
	variable Extended_diff:std_logic_vector(N downto 0);
	begin
		if enable='1' then
			Extended_diff:=('0'&A)-('0'&B)-BIN;
			BOUT<=Extended_diff(N);
			DIFF<=Extended_diff(N-1 downto 0);
			mem_scadere<= Extended_diff(N-1 downto 0);
		else DIFF <= mem_scadere;
		end if;	
	end process;
end arh_full;
