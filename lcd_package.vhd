--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package lcd_package is
	type pause_type is (PAUSE2000,PAUSE82000);
	subtype byte_type is STD_LOGIC_VECTOR(7 downto 0);
	type array_of_16_bytes_type is array (1 to 16) of byte_type;
end lcd_package;


package body lcd_package is
end lcd_package;
