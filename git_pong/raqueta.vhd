LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------
ENTITY raqueta IS

	PORT(
	clk_game : IN STD_LOGIC;
   clk_FPGA : IN STD_LOGIC;
	direc1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	direc2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	postBar1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
   postBar2  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	reset : IN STD_LOGIC);
END ENTITY raqueta;
ARCHITECTURE caseArch OF raqueta IS

	TYPE state IS(initial,arriba1,arriba2,abajo1,abajo2,static1,static2);
	SIGNAL pr_state, nx_state: state;
	SIGNAL postBar1Sig: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL postBar2Sig: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
postBar1 <= postBar1Sig;
postBar2 <= postBar2Sig;
PROCESS(clk_FPGA,reset)
	BEGIN
		IF(reset = '1') THEN
			pr_state <= initial;
		ELSIF (rising_edge(clk_game)) THEN
			pr_state<= nx_state;
		END IF;	
	END PROCESS;
PROCESS(direc1,direc2,clk_game) 
	BEGIN
	----posMax <= STD_LOGIC_VECTOR(UNSIGNED(positionY)+1);
		IF(rising_edge(clk_game)) THEN
			CASE pr_state IS 
--------------------------------------------------------------
			   WHEN initial =>

					IF(reset = '0') THEN
					nx_state <= arriba1;
					postBar1Sig <= "0100";
					postBar2Sig <= "0100";
					ELSE
					nx_state <= initial;
					END IF;
				WHEN arriba1 =>
					IF(reset = '0') THEN
						nx_state <= arriba2;
						IF(direc1 ="11" AND (postBar1Sig < "0111")) THEN 
						postBar1Sig <= STD_LOGIC_VECTOR(UNSIGNED(postBar1Sig)+1);
						ELSE 
						postBar1Sig <= postBar1Sig;
						END IF;
					ELSE
					nx_state <= initial;
					END IF;
					
				WHEN arriba2 =>
					IF (reset = '0') THEN
					nx_state <= abajo1;
					IF(direc2 ="11" AND (postBar2Sig < "0111")) THEN 
						postBar2Sig <= STD_LOGIC_VECTOR(UNSIGNED(postBar2Sig)+1);
					ELSE 
						postBar2Sig <= postBar2Sig;
					END IF;
					ELSE
										nx_state <= initial;
					END IF;
					
				WHEN abajo1 =>
					IF(reset = '0') THEN
					nx_state <= abajo2;
					IF(direc1 = "00" AND postbar1Sig > "0010") THEN 
						postBar1Sig <= STD_LOGIC_VECTOR(UNSIGNED(postBar1Sig)-1);
					
					ELSE 
						postBar1Sig<=postBar1Sig;
					END IF;
					ELSE
										nx_state <= initial;
					END IF;
					
				WHEN abajo2 =>
					IF(reset = '0') THEN
					nx_state <= static1;
					IF(direc2 = "00" AND postbar2Sig > "0010")THEN
						postBar2Sig <= STD_LOGIC_VECTOR(UNSIGNED(postBar2Sig)-1);
						
					ELSE 
						postBar2Sig<=postBar2Sig;
					END IF;
					ELSE
										nx_state <= initial;
					END IF;
				WHEN static1 =>
					IF(reset = '0') THEN
					nx_state <= static2;
					IF(direc1 = "10") THEN 
						postBar1Sig <= postBar1Sig;
					ELSE 
						postBar1Sig<=postBar1Sig;
						
					END IF;
					ELSE
										nx_state <= initial;
					END IF;
				WHEN static2 =>
					IF(reset = '0') THEN
					nx_state <= arriba1;
					IF(direc2 ="10")THEN
						postBar2Sig <= postBar2Sig;
					ELSE
						postBar2Sig<=postBar2Sig;
					END IF;
					ELSE
										nx_state <= initial;
					END IF;
				END CASE;
			END IF;
		END PROCESS;
	END ARCHITECTURE; 