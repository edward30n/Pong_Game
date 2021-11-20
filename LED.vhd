LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------
	ENTITY LED IS
	PORT(	
			posMatriz1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negMatriz1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			posMatriz2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negMatriz2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			clk : IN STD_LOGIC;
			posicionBar1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	      posicionBar2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	      posicionBallX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	      posicionBallY : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
	);	
	END ENTITY;
-------------------------------------
ARCHITECTURE careArch OF LED IS
	
	TYPE state IS (zero, one, two, three, fourth, five, six);
	SIGNAL pr_state, nx_state: state;
	SIGNAL paintPositionX1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL paintPositionX2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL paintPositionY1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL paintPositionY2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL paintPositionX2_5bits : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL rst : STD_LOGIC;
	SIGNAL clkDisplay : STD_LOGIC;
BEGIN
	rst <= '0';
	CRONOMETRO : ENTITY work.contador23Bits
	PORT MAP(	clk => clk,
					rst => rst,
					up => '1',
					load => '0',
					syn_clr => '0',
					ena => '1',
					maximo => "00000000110010110010000",
					max_tick => clkDisplay);
					
	LED8X8_N1 : ENTITY work.LED8X8
		PORT MAP(	positionX => paintPositionX1,
						positionY => paintPositionY1,
						positivo => posMatriz1,
						negativo => negMatriz1);
	
	LED8X8_N2 : ENTITY work.LED8X8
		PORT MAP(	positionX => paintPositionX2,
						positionY => paintPositionY2,
						positivo => posMatriz2,
						negativo => negMatriz2);
						
	pr_state <= nx_state;
	
	PROCESS(clkDisplay,posicionBar1,posicionBar2,posicionBallX,posicionBallY,pr_state,nx_state)
	BEGIN
		IF(rising_edge(clkdisplay)) THEN
		
			CASE pr_state IS
			
			WHEN zero =>
				
				IF(posicionBallX > "01000") THEN
				
					paintPositionX2_5bits <= STD_LOGIC_VECTOR(UNSIGNED(posicionBallX)-8);
					paintPositionX2(0) <= paintPositionX2_5bits(0);
					paintPositionX2(1) <= paintPositionX2_5bits(1);
					paintPositionX2(2) <= paintPositionX2_5bits(2);
					paintPositionX2(3) <= paintPositionX2_5bits(3);					
					paintPositionX1 <= "0000";
					paintPositionY1 <= "0000";
					paintPositionY2 <= posicionBallY;
					nx_state <= one;
				ELSIF(posicionBallX <= "01000") THEN
					paintPositionX2 <= "0000";
					paintPositionX1(0) <= PoSicionBallX(0);
					paintPositionX1(1) <= PoSicionBallX(1);
					paintPositionX1(2) <= PoSicionBallX(2);
					paintPositionX1(3) <= PoSicionBallX(3);
					paintPositionY1 <= posicionBallY;
					paintPositionY2 <= "0000";
					nx_state <= one;
				ELSE 
					paintPositionX2 <= "0000";
					paintPositionX1 <= "0000";
					paintPositionY1 <= "0000";
					paintPositionY2 <= "0000";
					nx_state <= one;
				END IF;

				
			WHEN one =>
				if(rst = '0') THEN
				paintPositionX2 <= "0000";
				paintPositionX1 <= "0001";
				paintPositionY1 <= posicionBar1;
				paintPositionY2 <= "0000";
				nx_state <= two;
				END IF;
			WHEN two =>

				paintPositionX2 <= "0000";
				paintPositionX1 <= "0001";
				paintPositionY1 <= STD_LOGIC_VECTOR(UNSIGNED(posicionBar1)+1);
				paintPositionY2 <= "0000";
				nx_state <= three;
				
			WHEN three =>

				paintPositionX2 <= "0000";
				paintPositionX1 <= "0001";
				paintPositionY1 <= STD_LOGIC_VECTOR(UNSIGNED(posicionBar1)-1);
				paintPositionY2 <= "0000";
				nx_state <= fourth;
			
			WHEN fourth =>

				paintPositionX2 <= "1000";
				paintPositionX1 <= "0000";
				paintPositionY2 <= posicionBar2;
				paintPositionY1 <= "0000";
				nx_state <= five;
				
			WHEN five =>

				paintPositionX2 <= "1000";
				paintPositionX1 <= "0000";
				paintPositionY2 <= STD_LOGIC_VECTOR(UNSIGNED(posicionBar2)+1);
				paintPositionY1 <= "0000";
				nx_state <= six;
			
			WHEN six =>

				paintPositionX2 <= "1000";
				paintPositionX1 <= "0000";
				paintPositionY2 <= STD_LOGIC_VECTOR(UNSIGNED(posicionBar2)-1);
				paintPositionY1 <= "0000";
				nx_state <= zero;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE;