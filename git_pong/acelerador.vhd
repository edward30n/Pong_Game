LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------

ENTITY acelerador IS

	PORT(
	 reset : IN STD_LOGIC;
	 clk : IN STD_LOGIC;
	 accelerate: IN STD_LOGIC;
	 maxTick	:	OUT STD_LOGIC
	);
END ENTITY acelerador;
--------------------------------------
ARCHITECTURE caseArch OF acelerador IS

	TYPE state IS(uno,dos,tres,cuatro,cinco);
	SIGNAL pr_state, nx_state: state;
	SIGNAL memEnt: STD_LOGIC_VECTOR (22 DOWNTO 0);
	SIGNAL memSal :STD_LOGIC_VECTOR (22 DOWNTO 0);
	SIGNAL reduceMemSal : STD_LOGIC_VECTOR(22 DOWNTO 0);
	SIGNAL entsignalAcelerate : STD_LOGIC;
	SIGNAL signalAcelerate : STD_LOGIC;
	
BEGIN 

reduceMemSal(0)<= memSal(2);
reduceMemSal(1)<= memSal(3);
reduceMemSal(2)<= memSal(4);
reduceMemSal(3)<= memSal(5);
reduceMemSal(4)<= memSal(6);
reduceMemSal(5)<= memSal(7);
reduceMemSal(6)<= memSal(8);
reduceMemSal(7)<= memSal(9);
reduceMemSal(8)<= memSal(10);
reduceMemSal(9)<= memSal(11);
reduceMemSal(10)<= memSal(12);
reduceMemSal(11)<= memSal(13);
reduceMemSal(12)<= memSal(14);
reduceMemSal(13)<= memSal(15);
reduceMemSal(14)<= memSal(16);
reduceMemSal(15)<= memSal(17);
reduceMemSal(16)<= memSal(18);
reduceMemSal(17)<= memSal(19);
reduceMemSal(18)<= memSal(20);
reduceMemSal(19)<= memSal(21);
reduceMemSal(20)<= memSal(22);
reduceMemSal(21)<= '0';
reduceMemSal(22)<= '0';

	Mem_clock : ENTITY work.my_regDFF23
	PORT MAP( clk => clk,
				 rst => reset,
				 ena => '1',
				 d => memEnt,
				 q => memSal
	);
	CRONOMETRO: ENTITY work.contador23Bits
	PORT MAP( clk => clk,
				 rst => reset,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 maximo => memSal,
				 max_tick => maxTick
				 
	);
	SIGNAL_ACCELERATE_MEMORY : ENTITY work.my_dff
	PORT MAP(clk => clk,
				rst => reset,
				ena => '1',
				d => EntsignalAcelerate,
				q => signalAcelerate);
				
	PROCESS(reset,clk)
	BEGIN
		IF(reset = '1') THEN
			pr_state <= uno;
		ELSIF(rising_edge(clk)) THEN 
			pr_state<= nx_state;
		END IF;	
	END PROCESS;
--------------------------------------------------------------

	PROCESS(pr_state,nx_state,clk)
	BEGIN
	
			CASE pr_state IS 
			

--------------------------------------------------------------
				WHEN uno =>
					memEnt <= "01001100010010110100000";
					entsignalAcelerate <= '0';
					nx_state <= dos;
--------------------------------------------------------------
					WHEN dos =>
					memEnt <= memSal;
					nx_state <= dos;
					entsignalAcelerate <= '0';
					IF(accelerate ='1') THEN
					nx_state <= tres;
					END IF;
						
---------------------------------------------------------------------------
					WHEN tres =>
					memEnt <= memSal;
					entsignalAcelerate <= '1';
					nx_state <= cuatro;
					
					WHEN cuatro =>
					entsignalAcelerate <= signalAcelerate;
					memEnt <= memSal;
					IF(accelerate = '0' AND signalAcelerate = '1') THEN
					nx_state <= cinco;
					ELSE
					nx_state <= cuatro;
					END IF;
					
					WHEN cinco =>
					entsignalAcelerate <= '0';
					memEnt <= STD_LOGIC_VECTOR(UNSIGNED(memSal)-UNSIGNED(reduceMemSal));
					nx_state <= dos;
					
					
					
			END CASE;
	END PROCESS;
END ARCHITECTURE;