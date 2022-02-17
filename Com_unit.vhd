library IEEE;
use IEEE.std_logic_1164.all;

entity mealy is
	port (CLK, RST, buton_done, Switch_da_nu, I4_pin_bun, I9_exista_suma: in std_logic;
		  Op: in std_logic_vector(1 downto 0); 
		  done_verif: in std_logic_vector(1 downto 0); --(0)= done verificare pin; (1)= done verif suma
		  led: out std_logic_vector(15 downto 0);
		  enables: out std_logic_vector(8 downto 0)); 
		  -- en(8)= ram card pin, en(7)= ram sold ram banc adder, en(6)= ram sold ram banc subtr, en(5)=verificare disp suma, en(4)=reg citire suma, en(3)= reg citire op, en(2)=verif pin, en(1)=reg citire pin, en(0)=reg cod card
end mealy;

architecture arh_mealy of mealy is
type state_type is(Standby, Ast_introd_cod_card, Ast_introd_pin, Verificare, Pin_gresit, Ast_alegere_op, Ast_introd_suma, Ast_decizie_chitanta, Ast_introd_pin_nou, Verif_disponibilitate_suma, Ast_continuare, Retragere_numerar, Introducere_numerar, Schimbare_pin);
signal curr_state, next_state: state_type;

begin
TRANSITIONS_CLC: process(curr_state, buton_done, I4_pin_bun, I9_exista_suma, Switch_da_nu, Op, done_verif)
		begin
		   case curr_state is
			    when Standby => if buton_done = '0' then
				   					next_state <= Standby;
			   				   else next_state <= Ast_introd_cod_card;
				   			   end if;
			    when Ast_introd_cod_card => if buton_done = '0' then
				   								next_state <= Ast_introd_cod_card;
				   						   else next_state <= Ast_introd_pin;		
										   end if;	
			    when Ast_introd_pin => if buton_done = '0' then										   
				   								next_state<= Ast_introd_pin;
				   					  else next_state <= Verificare;
									  end if; 		 
				when Verificare =>  if done_verif(0) = '1' then
										if I4_pin_bun = '0' then
											next_state<= Pin_gresit; 
								   		else next_state <= Ast_alegere_op;
								   		end if;	   
									else next_state <= Verificare;
									end if;	
				when Pin_gresit => if buton_done = '0' then
										next_state<= Pin_gresit;
								   else 		
										if Switch_da_nu = '0' then
											next_state<= Standby;
								   		else next_state<= Ast_introd_pin;				 
								   		end if;	  
								   end if;	   
				when Ast_alegere_op => if buton_done = '0' then
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
				when Ast_introd_suma => if buton_done = '0' then					   
									   		next_state <= Ast_introd_suma;
										else 		
											 if Op(0) = '0' then --retragere numerar
											 	next_state <= Verif_disponibilitate_suma;		
											 else next_state <= Introducere_numerar; --introducere numerar
											 end if;	 
										end if;
				when Introducere_numerar => next_state <= Ast_decizie_chitanta; 							
				when Ast_decizie_chitanta => if buton_done = '0' then
												next_state<= Ast_decizie_chitanta;
											 else next_state<= Ast_continuare;
									 		 end if;
				when Ast_introd_pin_nou => if buton_done = '0' then
												next_state <= Ast_introd_pin_nou;
										   else next_state <= Schimbare_pin;  --AICI SCH PIN
										   end if; 
				when Schimbare_pin => next_state <= Ast_decizie_chitanta; 						   
				when Verif_disponibilitate_suma => if done_verif(1)='1' then 
														if I9_exista_suma = '0' then
															next_state <= Ast_continuare;	
												   		else next_state <= Retragere_numerar;		
												   		end if;	
												   else next_state <= Verif_disponibilitate_suma;
												   end if;
				when Retragere_numerar => next_state <=	Ast_decizie_chitanta;							   
				when Ast_continuare => if buton_done = '0' then
											next_state <= Ast_continuare;
									   else 
											if Switch_da_nu = '0' then
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
			led <= "1000000000000000";
			enables <= "000000000";
		else
			if (CLK'EVENT) and (CLK='1') then 
				case curr_state is
					when Standby => 
							led <= "1000000000000000"; 	
							enables <= "000000000";
					when Ast_introd_cod_card => 
							led <= "0100000000000000"; 
							enables<= "000000001";
					when Ast_introd_pin => 
							led <= "0010000000000000";	
						   	enables <="000000010"; 
					when Verificare => 
							led <= "0010000000000000";	
						   	enables <="000000100"; 		   
					when Pin_gresit => led <= "0001000000000000";
					when Ast_alegere_op => 
							led <= "0000100000000000"; 
						   	enables <="000001000";
					when Ast_introd_suma =>  
							led <= "0000010000000000";
						   	enables <= "000010000";	 
					when Verif_disponibilitate_suma =>
							led <= "0000010000000000";
						   	enables <= "000100000";
					when Retragere_numerar =>
							led <= "0000001000000000";
						   	enables <= "001000000";
					when Introducere_numerar =>
							led <= "0000001000000000";
							enables <= "010000000";
					
					when Ast_decizie_chitanta =>  
						led <= "0000001000000000";
						enables <= "000000000";
					when Ast_continuare => if I9_exista_suma = '0' then
												led <="0000000101000000";
										   else
											   if (buton_done = '0') then
													if switch_da_nu = '1' then --am vrut chitanta	   
												   		led <= "0000000011000000";
												   	else led <="0000000001000000";
												   	end if;
											   else led <= "0000000000000000"; --nu ar trebui sa ajunga aici		
											   end if;
										   end if;					   
					when Ast_introd_pin_nou => 
							led <= "0010000000000000";					   
							enables <="000000010";	
					when Schimbare_pin =>	
							led <= "0000000000000000";					   
							enables <="100000000";
					when others => led <= "0000000000000000";
				end case;
				curr_state <= next_state;
			end if;
		end if;
	end process ACTUALIZARE_STARE_SLC;	
				
					
end arh_mealy;	