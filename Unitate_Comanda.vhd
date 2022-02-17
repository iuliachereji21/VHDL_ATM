library IEEE;
use IEEE.std_logic_1164.all;

entity mealy is
	port(CLK,RST: in std_logic;
	Op: in std_logic_vector(1 downto 0);
	I1_senzor_card_introdus, I2_senzor_cod_introdus, I3_pin_introdus, I4_pin_bun, I5_reincercati, I6_operatie_aleasa: in std_logic;
	I7_alta_operatie, I8_suma_introdusa, I9_exista_suma, I10_doriti_chitanta, I11_decis_chitanta, I12_decis_continuare: in std_logic);
end mealy;

architecture arh_mealy of mealy is
type state_type is(Standby, Ast_introd_cod_card, Ast_introd_pin, Verificare, Pin_gresit, Ast_alegere_op, Ast_introd_suma, Ast_decizie_chitanta, Ast_introd_pin_nou, Verif_disponibilitate_suma, Ast_continuare);
signal curr_state, next_state: state_type;

begin
TRANSITIONS_CLC: process(curr_state, I1_senzor_card_introdus, I2_senzor_cod_introdus, I3_pin_introdus, I4_pin_bun, I5_reincercati, I6_operatie_aleasa, I7_alta_operatie, I8_suma_introdusa, I9_exista_suma, I10_doriti_chitanta, I11_decis_chitanta, I12_decis_continuare)
		begin
		   case curr_state is
			    when Standby => if I1_senzor_card_introdus = '0' then
				   					next_state <= Standby;
			   				   else next_state <= Ast_introd_cod_card;
				   			   end if;
			    when Ast_introd_cod_card => if I2_senzor_cod_introdus = '0' then
				   								next_state <= Ast_introd_cod_card;
				   						   else next_state <= Ast_introd_pin;		
										   end if;	
			    when Ast_introd_pin => if I3_pin_introdus = '0' then										   
				   								next_state<= Ast_introd_pin;
				   					  else next_state <= Verificare;
									  end if; 		 
				when Verificare => if I4_pin_bun = '0' then
										next_state<= Pin_gresit; 
								   else next_state <= Ast_alegere_op;
								   end if;
				when Pin_gresit => if I5_reincercati = '0' then
										next_state<= Standby;
								   else next_state<= Ast_introd_pin;				 
								   end if;
				when Ast_alegere_op => if I6_operatie_aleasa = '0' then
											next_state <= Ast_alegere_op;
									   else
											if Op(1) = '0'then --retragere numerar sau introducere numerar
										   		next_state <= Ast_introd_suma;
										   	else 
												 if Op(0) = '0' then --afisare sold
													  next_state <= Ast_decizie_chitanta;
												 else next_state <= Ast_introd_pin_nou;	--schimbare pin
												 end if;
											end if;	   
									   end if;		
				when Ast_introd_suma => if I8_suma_introdusa = '0' then					   
									   		next_state <= Ast_introd_suma;
										else 		
											 if Op(0) = '0' then --retragere numerar
											 	next_state <= Verif_disponibilitate_suma;		
											 else next_state <= Ast_decizie_chitanta; --introducere numerar
											 end if;	 
										end if;			 
				when Ast_decizie_chitanta => if I11_decis_chitanta = '0' then
												next_state<= Ast_decizie_chitanta;
											 else next_state<= Ast_continuare;
									 		 end if;
				when Ast_introd_pin_nou => if I3_pin_introdus = '0' then
												next_state <= Ast_introd_pin_nou;
										   else next_state <= Ast_continuare;
										   end if;
				when Verif_disponibilitate_suma => if I9_exista_suma = '0' then
														next_state <= Ast_continuare;	
												   else next_state <= Ast_decizie_chitanta;		
												   end if;
				when Ast_continuare => if I12_decis_continuare = '0' then
											next_state <= Ast_continuare;
									   else 
											if I7_alta_operatie = '0' then
												next_state<= Standby;
											else next_state <= Ast_alegere_op;
											end if;
									   end if;										 								
			end case;					  
		end process TRANSITIONS_CLC;
		
ACTUALIZARE_STARE_SLC: process(CLK,RST)
	begin	  
		if RST='1' then 
			curr_state<=Standby;
		else
			if (CLK'EVENT) and (CLK='1') then
			end if;	
		end if;
	
	
	end process ACTUALIZARE_STARE_SLC;
			
end arh_mealy;	