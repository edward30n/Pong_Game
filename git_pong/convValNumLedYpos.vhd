LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------------------------
ENTITY convValNumLedYpos IS
	PORT(bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  position : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
-----------------------------------------------------
ARCHITECTURE gateLevel OF convValNumLedYpos IS
BEGIN
	WITH bin SELECT
		position <=
							NOT ("00100000") WHEN "0001",
							NOT ("10000000") WHEN "0010",
							NOT ("00000001") WHEN "0011",
							NOT ("01000000") WHEN "0100",
							NOT ("00010000") WHEN "0101",
							NOT ("00000010") WHEN "0110",
							NOT ("00001000") WHEN "0111",
							NOT ("00000100") WHEN "1000",
							NOT ("00000000") WHEN OTHERS;
END ARCHITECTURE;