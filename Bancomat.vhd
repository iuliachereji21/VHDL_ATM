library IEEE;
use IEEE.std_logic_1164.all;
entity bancomat is
	port (switch:in std_logic_vector(15 downto 0);
	but_done, reset: in std_logic; --butoane
	clock:in std_logic;
	led:out std_logic_vector(15 downto 0)); 
end bancomat;

architecture arh_bancomat of bancomat is

----------------------------------------------------------------------------------------------------------------------
component mealy is
	port (CLK, RST, buton_done, Switch_da_nu, I4_pin_bun, I9_exista_suma: in std_logic;
		  Op: in std_logic_vector(1 downto 0); 
		  done_verif: in std_logic_vector(1 downto 0); --(0)= done verificare pin; (1)= done verif suma
		  led: out std_logic_vector(15 downto 0);
		  enables: out std_logic_vector(8 downto 0)); 
		  -- en(8)= ram card pin, en(7)= ram sold ram banc adder, en(6)= ram sold ram banc subtr, en(5)=verificare disp suma, en(4)=reg citire suma, en(3)= reg citire op, en(2)=verif pin, en(1)=reg citire pin, en(0)=reg cod card
end component;

component registru_cod_card is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(3 downto 0);
	Out_cod: out std_logic_vector(3 downto 0));
end component;

component registru_pin is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(15 downto 0);
	Out_pin: out std_logic_vector(15 downto 0));
end component; 

component verificator_pin is
	port (A, B: in std_logic_vector(15 downto 0);
	clk, enable: in std_logic;
	pin_bun, done: out std_logic);
end component;

component registru_operatie is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(1 downto 0);
	Out_operatie: out std_logic_vector(1 downto 0));
end component; 

component registru_suma is
	port (clk,rst, enable: in std_logic;
	In_switchuri: in std_logic_vector(15 downto 0);
	Out_suma: out std_logic_vector(15 downto 0));
end component;

component verificator_suma is
	port(suma_ceruta, suma_cont, suma_atm: in std_logic_vector(15 downto 0);
	clk, enable: in std_logic;
	suma_ok, done_verif:out std_logic);
end component;

component mux is
	port(sub,add:in std_logic_vector(15 downto 0);
	sel:in std_logic; --0=>sub, 1=>add
	out_mux: out std_logic_vector(15 downto 0));
end component;

component fullsubtr is --A-B
	generic(N:integer:=16);
	port(A,B:in std_logic_vector(N-1 downto 0);
	BIN, enable:in std_logic;
	DIFF:out std_logic_vector(N-1 downto 0);
	BOUT:out std_logic);
end component;

component fulladder is
	generic(N:integer:=16);
	port(A,B:in std_logic_vector(N-1 downto 0);
	CIN, enable:in std_logic;
	SUM:out std_logic_vector(N-1 downto 0);
	COUT:out std_logic);
end component;	 

component ram_card_sold  is
	port(cod_card: in std_logic_vector(3 downto 0);
	we:in std_logic;
	clk:in std_logic;
	data_in:in std_logic_vector(15 downto 0);
	sold:out std_logic_vector(15 downto 0));
end component;

component ram_atm is
	port(write_en,clk:in std_logic;
	suma_in: in std_logic_vector(15 downto 0);
	suma_out: out std_logic_vector(15 downto 0));
end component;

component ram_card_pin is
	port(cod_card: in std_logic_vector(3 downto 0); --adresele(16 adrese capacitate)
	write_en: in std_logic;
	clock: in std_logic;
	data_in_pin: in std_logic_vector(15 downto 0);	--pinul pe 16 biti (4 cifre BCD)
	out_pin: out std_logic_vector(15 downto 0));
end component;

---------------------------------------------------------------------------------------------------------------------

signal enables: std_logic_vector(8 downto 0);
signal cod_card: std_logic_vector(3 downto 0);
signal pin_citit: std_logic_vector(15 downto 0);
signal pin_ram: std_logic_vector(15 downto 0);
signal pin_bun: std_logic;
signal done: std_logic_vector(1 downto 0);
signal operatie: std_logic_vector(1 downto 0);
signal suma_citita: std_logic_vector(15 downto 0);
signal suma_cont: std_logic_vector(15 downto 0);
signal suma_atm: std_logic_vector(15 downto 0);
signal suma_ok: std_logic;
signal dif_in_cont: std_logic_vector(15 downto 0);
signal dif_in_atm: std_logic_vector(15 downto 0); 
signal sum_in_cont: std_logic_vector(15 downto 0);
signal sum_in_atm: std_logic_vector(15 downto 0);
signal in_cont: std_logic_vector(15 downto 0);
signal in_atm: std_logic_vector(15 downto 0);
signal enable_ram: std_logic;

begin
  
	box1: mealy port map(CLK => clock, RST => reset, buton_done => but_done, Switch_da_nu => switch(15),I4_pin_bun => pin_bun, I9_exista_suma => suma_ok, Op => operatie, done_verif => done, led => led, enables => enables); 
	box2: registru_cod_card port map(clk => clock, rst=> reset, enable => enables(0), In_switchuri => switch(15 downto 12), Out_cod => cod_card);
	box3: registru_pin port map (clk => clock, rst=> reset, enable => enables(1), In_switchuri=> switch, Out_pin => pin_citit);
	box4: verificator_pin port map (A => pin_citit, B=> pin_ram, clk => clock, enable => enables(2), pin_bun => pin_bun, done => done(0)); 
	box5: registru_operatie port map(clk => clock, rst=> reset, enable => enables(3), In_switchuri => switch(14 downto 13), Out_operatie => operatie);
	box6: registru_suma port map (clk => clock, rst=> reset, enable => enables(4), In_switchuri => switch, Out_suma => suma_citita);
	box7: verificator_suma port map (suma_ceruta => suma_citita, suma_cont => suma_cont, suma_atm => suma_atm, clk => clock, enable => enables(5), suma_ok => suma_ok, done_verif => done(1));
	box8: mux port map (sub=>dif_in_cont, add=>sum_in_cont, sel=> enables(7), out_mux=> in_cont);
	box9: mux port map (sub=>dif_in_atm, add=>sum_in_atm, sel=> enables(7), out_mux=> in_atm);
	box10: fullsubtr port map(A=> suma_cont, B=> suma_citita, BIN => '0',enable => enables(6), DIFF=> dif_in_cont);
	box11: fullsubtr port map(A=> suma_atm, B=> suma_citita, BIN => '0', enable => enables(6), DIFF=> dif_in_atm);
	box12: fulladder port map(A=> suma_cont, B=> suma_citita, CIN => '0', enable => enables(7), SUM=> sum_in_cont);
	box13: fulladder port map(A=> suma_atm, B=> suma_citita, CIN => '0', enable => enables(7), SUM=> sum_in_atm);
	box14: ram_card_sold port map(cod_card => cod_card, we => enable_ram, clk => clock, data_in => in_cont, sold => suma_cont);
	box15: ram_atm port map(write_en => enable_ram, clk=> clock, suma_in => in_atm, suma_out => suma_atm);	
	box16: ram_card_pin port map(cod_card => cod_card, write_en => enables(8), clock=> clock, data_in_pin => pin_citit, out_pin => pin_ram);
	enable_ram <= enables(6) or enables(7);

end arh_bancomat;