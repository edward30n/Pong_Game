LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

				ENTITY contador23Bits IS
	PORT		( clk	 	  :	IN  STD_LOGIC;
				  rst  	  :	IN  STD_LOGIC;
				  ena	 	  :	IN  STD_LOGIC;
				  syn_clr  :	IN  STD_LOGIC;
				  load     :	IN  STD_LOGIC;
				  up		  :	IN  STD_LOGIC;
				  counter  :	OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
				  maximo	  :   IN  STD_LOGIC_VECTOR (22 DOWNTO 0);
				  max_tick :	OUT STD_LOGIC);
				  
				  END ENTITY;
				  
				  ---------------------------------------
				  
				  
	ARCHITECTURE rtl OF contador23Bits IS
	SIGNAL reset	: STD_LOGIC;
	SIGNAL signalCounter	: STD_LOGIC_VECTOR (22 DOWNTO 0);
	SIGNAL signalMaximo	: STD_LOGIC_VECTOR (22 DOWNTO 0);
	BEGIN
	
	CONTADOR: ENTITY work.contador23
	PORT MAP(	clk	 	=> clk,
				  rst  	   =>	rst   OR reset,
				  ena	 	   =>	ena,
				  syn_clr   =>	syn_clr,
				  load      =>	load,
				  up		   =>	up,
				  d			=> "00000000000000000000000",
				  counter   =>	signalCounter);
				  
signalMaximo <= STD_LOGIC_VECTOR ( UNSIGNED (maximo)+ 1);		
counter <= signalCounter;
PROCESS (signalCounter,reset,signalMaximo)
	
BEGIN
	IF(ena='1') THEN
		IF(rising_edge(clk)) THEN
			IF(signalCounter = (signalMaximo )) THEN 
			reset <='1';
			max_tick <='1';
			ELSE  reset <='0';
			max_tick <= '0';
			END IF;
		END IF;
	ELSE
	reset <='0';
	max_tick <='0';
	END IF;
	END PROCESS;
				  
				END ARCHITECTURE;