LIBRARY IEEE;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------
ENTITY contador23 IS
	GENERIC	( N	 	  :	INTEGER := 23);
	PORT		( clk	 	  :	IN  STD_LOGIC;
				  rst  	  :	IN  STD_LOGIC;
				  ena	 	  :	IN  STD_LOGIC;
				  syn_clr  :	IN  STD_LOGIC;
				  load     :	IN  STD_LOGIC;
				  up		  :	IN  STD_LOGIC;
				  d		  :   IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
				  max_tick :	OUT STD_LOGIC;
				  min_tick :	OUT STD_LOGIC;
				  counter  :	OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
				  
				  END ENTITY;
				  
				  ---------------------------------------
				  
	ARCHITECTURE rtl OF contador23 IS
		CONSTANT ONES	   : UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '1');
		CONSTANT ZEROS    : UNSIGNED(N-1 DOWNTO 0) := (OTHERS => '0');
		--SIGNAL count_s  : INTEGER RANGE 0 (2**N - 1);
					
		SIGNAL count_s		: UNSIGNED(N-1 DOWNTO 0);
		SIGNAL count_next : UNSIGNED(N-1 DOWNTO 0);
	BEGIN
	
		count_next <= (OTHERS => '0') WHEN syn_clr ='1'		       ELSE
							unsigned(d)		WHEN load ='1'			       ELSE
							count_s + 1 	WHEN	(ena ='1' AND up='1') ELSE
							count_s - 1 	WHEN	(ena ='1' AND up='0') ELSE
							count_s;
							
				
PROCESS (clk, rst)
	VARIABLE 	temp	:	UNSIGNED (N-1 DOWNTO 0);
BEGIN
	IF(rst='1') THEN 
		temp := (OTHERS => '0');
		ELSIF (rising_edge(clk)) THEN 
			IF (ena='1')THEN	
			temp := count_next;
			END IF;
		END IF;
		counter <= STD_LOGIC_VECTOR (temp);
		count_s <= temp;
	END PROCESS;
	
	-- OUTPUT LOGIC
	max_tick <= '1' when count_s = ONES	 ELSE '0';
	min_tick <= '1' when count_s = ZEROS ELSE '0';
	
	END ARCHITECTURE;