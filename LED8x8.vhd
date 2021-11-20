LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------
ENTITY LED8x8 IS
	PORT( positionX : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			positionY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			positivo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			negativo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;
------------------------------------------
ARCHITECTURE gateLevel OF LED8x8 IS
BEGIN
	POSI :ENTITY work.convValNumLedXpos
		PORT MAP(
					bin => positionX,
					position => positivo);
	NEGI :ENTITY work.convValNumLedYpos
		PORT MAP(bin => positionY,
					position => negativo);	

END ARCHITECTURE;