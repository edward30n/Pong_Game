LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------
ENTITY pong IS 
	PORT( bar1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			bar2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			clk : IN STD_LOGIC;
			posMatriz1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negMatriz1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			posMatriz2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negMatriz2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			unidades_1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			unidades_2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			decenas_1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			decenas_2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			reset : IN STD_LOGIC
	);
END ENTITY;
-------------------------------------
ARCHITECTURE caseArch OF pong IS
	SIGNAL clkGame_raquetas : STD_LOGIC;
	SIGNAL clkGame_ball : STD_LOGIC;
	SIGNAL postBar1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL postBar2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL postBallX : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL postBallY : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL pointBar1 : STD_LOGIC;
	SIGNAL pointBar2 : STD_LOGIC;
	SIGNAL deathBar1 : STD_LOGIC;
	SIGNAL deathBar2 : STD_LOGIC;
	SIGNAL accelerate : STD_LOGIC; 
	SIGNAL unidades_1_bits : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL unidades_2_bits : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL decenas_1_bits : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL decenas_2_bits : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL go_decenas_1 : STD_LOGIC;
	SIGNAL go_decenas_2 : STD_LOGIC;
	SIGNAL final : STD_LOGIC;
	SIGNAL final1 : STD_LOGIC;
	SIGNAL final2 : STD_LOGIC;

BEGIN 
	final <= final1 OR final2;
	
	CRONOMETRO_GAME: ENTITY work.acelerador
	PORT MAP(	clk => clk,
					reset => reset OR final,
					accelerate => accelerate,
					maxTick => clkGame_ball
	);
	Contador_acelerador: ENTITY work.contador4Bits
		PORT MAP(
					clk => pointBar1 OR pointBar2,
					rst => reset,
					syn_clr => '0',
					ena => '1',
					load => '0',
					up => '1',
					d => "0000",
					maximo => "1001",
					max_tick => accelerate		
		);
	CRONOMETRO_RAQUETAS: ENTITY work.contador23Bits
	PORT MAP( clk => clk,
				 rst => reset,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 maximo => "00100110001001011010000",
				 max_tick => clkGame_raquetas	
	);
	RAQUETAS : ENTITY work.raqueta 
	PORT MAP(	clk_FPGA => clk,
					clk_game => clkGame_raquetas,
					direc1 => bar1,
					direc2 => bar2,
					reset => reset,
					PostBar1 => PostBar1,
					PostBar2 => PostBar2
	);
	BALL : ENTITY work.balL
	PORT MAP(	clk_FPGA => clk,
					clk_game => clkGame_ball,
					postBar1 => postBar1,
					postBar2 => postBar2,
					reset => reset OR deathBar1 OR deathBar2,
					outPositionX => postBallX,
					outPositionY => postBallY,
					pointBar1 => pointBar1,
					pointBar2 => pointBar2,
					deathBar1 => deathBar1,
					deathBar2 => deathBar2
	);
	LED : ENTITY work.LED
	PORT MAP(	clk => clk,
					posicionBar1 => postBar1,
					posicionBar2 => postBar2,
					posicionBallX => postBallX,
					posicionBallY => postBallY,
					posMatriz1 => posMatriz1,
					posMatriz2 => posMatriz2,
					negMatriz1 => negMatriz1,
					negMatriz2 => negMatriz2);
					
	CONTADOR_UNIDADES_1 : ENTITY work.contador4Bits2
	PORT MAP( clk => pointBar1,
				 clk_FPGA => clk,
				 rst => reset OR final,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 counter => unidades_1_bits,
				 maximo => "1010",
				 max_tick => go_decenas_1);
				 
	CONTADOR_UNIDADES_2 : ENTITY work.contador4Bits2
	PORT MAP( clk => pointBar2,
				 clk_FPGA => clk,
				 rst => reset OR final,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 counter => unidades_2_bits,
				 maximo => "1010",
				 max_tick => go_decenas_2);
		
	CONTADOR_DECENAS_1 : ENTITY work.contador4Bits2
	PORT MAP( clk => go_decenas_1,
				 clk_FPGA => clk,
				 rst => reset OR final,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 counter => decenas_1_bits,
				 maximo => "1010");
				 
	CONTADOR_DECENAS_2 : ENTITY work.contador4Bits2
	PORT MAP( clk => go_decenas_2,
				 clk_FPGA => clk,
				 rst => reset OR final,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 counter => decenas_2_bits,
				 maximo => "1010");
				 
	CONTADOR_MUERTES_1 : ENTITY work.contador4Bits2
	PORT MAP(clk => deathBar1,
				clk_FPGA => clk,
				 rst => reset,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 maximo => "0011",
				 max_tick => final1);

	
	CONTADOR_MUERTES_2 : ENTITY work.contador4Bits2
	PORT MAP(clk => deathBar2,
				clk_FPGA => clk,
				 rst => reset,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 d => "0000",
				 up => '1',
				 maximo => "0011",
				 max_tick => final2);
				 

	SIETE_SEGMENTO_UNIDADES_1 : ENTITY work.sevenSeg
	PORT MAP( bin => unidades_1_bits,
				sseg => unidades_1);
				
	SIETE_SEGMENTO_UNIDADES_2 : ENTITY work.sevenSeg
	PORT MAP( bin => unidades_2_bits,
				sseg => unidades_2);
	
	SIETE_SEGMENTO_DECENAS_1 : ENTITY work.sevenSeg
	PORT MAP( bin => decenas_1_bits,
				sseg => decenas_1);
	
	SIETE_SEGMENTO_DECENAS_2 : ENTITY work.sevenSeg
	PORT MAP( bin => decenas_2_bits,
				sseg => decenas_2);
	
	
END ARCHITECTURE;