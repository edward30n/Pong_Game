LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------------------------
ENTITY convValNumLedXpos IS
	PORT(bin : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  position : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY;
-----------------------------------------------------
ARCHITECTURE gateLevel OF convValNumLedXpos IS
BEGIN
	WITH bin SELECT
		position <=
							 ("10000000") WHEN "0001",
							 ("01000000") WHEN "0010",
							 ("00010000") WHEN "0011",
							 ("00000001") WHEN "0100",
							 ("00001000") WHEN "0101",
							 ("00000010") WHEN "0110",
							 ("00000100") WHEN "0111",
							 ("00100000") WHEN "1000",
							 ("00000000") WHEN OTHERS;
END ARCHITECTURE;