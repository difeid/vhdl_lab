library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use lcd_package.ALL;

entity Former is
Port (
		SEQUENCE : in STD_LOGIC_VECTOR (1 to 16);
		D : in STD_LOGIC_VECTOR (1 to 10);
		FREQ : in STD_LOGIC_VECTOR (7 downto 0);
		MANUAL_MODE : in STD_LOGIC;
		PAUSE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		
		ARRAY_STRING1 : out array_of_16_bytes_type;
		ARRAY_STRING2 : out array_of_16_bytes_type
     );
end Former;

architecture Behavioral of Former is
	signal TEMP_STRING1: array_of_16_bytes_type:= 
	("00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000");
	 
	signal TEMP_STRING2: array_of_16_bytes_type :=
	("00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000",
	 "00100000");
	 
	 function char_to_byte
	 -- Функция преобразует входной символ в код этого символа в соответствии с таблицей 
	 -- символов CG ROM и возвращает полученное значение. Если такого символа нет в таблице,
	 -- то возвращает значение пробела
	 (
		ch: CHARACTER
	 )
	 return byte_type is
	 begin
			if 	ch = ' ' then return "00100000";
			elsif ch = ',' then return "00101100";
			elsif ch = '0' then return "00110000";
			elsif ch = '1' then return "00110001";
			elsif ch = '2' then return "00110010";
			elsif ch = '3' then return "00110011";
			elsif ch = '4' then return "00110100";
			elsif ch = '5' then return "00110101";
			elsif ch = '6' then return "00110110";
			elsif ch = '7' then return "00110111";
			elsif ch = '8' then return "00111000";
			elsif ch = '9' then return "00111001";
			elsif ch = 'A' then return "01000001";
			elsif ch = 'B' then return "01000010";
			elsif ch = 'C' then return "01000011";
			elsif ch = 'D' then return "01000100";
			elsif ch = 'E' then return "01000101";
			elsif ch = 'F' then return "01000110";
			elsif ch = 'G' then return "01000111";
			elsif ch = 'H' then return "01001000";
			elsif ch = 'I' then return "01001001";
			elsif ch = 'J' then return "01001010";
			elsif ch = 'K' then return "01001011";
			elsif ch = 'L' then return "01001100";
			elsif ch = 'M' then return "01001101";
			elsif ch = 'N' then return "01001110";
			elsif ch = 'O' then return "01001111";
			elsif ch = 'P' then return "01010000";
			elsif ch = 'Q' then return "01010001";
			elsif ch = 'R' then return "01010010";
			elsif ch = 'S' then return "01010011";
			elsif ch = 'T' then return "01010100";
			elsif ch = 'U' then return "01010101";
			elsif ch = 'V' then return "01010110";
			elsif ch = 'W' then return "01010111";
			elsif ch = 'X' then return "01011000";
			elsif ch = 'Y' then return "01011001";
			elsif ch = 'Z' then return "01011010";
			else return "00100000";
			end if;
	 end char_to_byte;
	
begin
	process (CLK) begin
		-- Запись в буферы строк по фронту импульса
		if rising_edge(CLK) then
		
			-- Запись буфера первой строки
			L1: for cnt in 1 to 16 loop
				if SEQUENCE(cnt) = '1' then
					TEMP_STRING1(cnt) <= char_to_byte('1');
				else
					TEMP_STRING1(cnt) <= char_to_byte('0');
				end if;
			end loop L1;
			
			-- Запись буфера второй стоки (символы 1 - 9)
			L2: for cnt in 1 to 10 loop
				if D(cnt) = '1' then
					TEMP_STRING2(cnt) <= char_to_byte('1');
				elsif D(cnt) = '0' then
					TEMP_STRING2(cnt) <= char_to_byte('0');
				else
					TEMP_STRING2(cnt) <= char_to_byte(' ');
				end if;
			end loop L2;
			
		end if;	
	end process;
	
	-- Запись 10ого символа второй строки
	TEMP_STRING2(11) <=  "00000001" WHEN CLK = '1' ELSE
								"00000000";
								
	
	process (MANUAL_MODE, PAUSE, FREQ)
		variable TEMP_FREQ : integer range 0 to 256;
		variable STRING_FREQ : STRING (1 to 3);
		begin
		TEMP_FREQ := TO_INTEGER(unsigned(FREQ));
		STRING_FREQ := integer'image(TEMP_FREQ);
		
		if PAUSE = '1' then
			TEMP_STRING2(12) <= char_to_byte('P');
			TEMP_STRING2(13) <= char_to_byte('A');
			TEMP_STRING2(14) <= char_to_byte('U');
			TEMP_STRING2(15) <= char_to_byte('S');
			TEMP_STRING2(16) <= char_to_byte('E');
		else
			if MANUAL_MODE = '1' then
				TEMP_STRING2(12) <= char_to_byte('H');
				TEMP_STRING2(13) <= char_to_byte('A');
				TEMP_STRING2(14) <= char_to_byte('N');
				TEMP_STRING2(15) <= char_to_byte('D');
				TEMP_STRING2(16) <= "00000011"; -- Символ кнопки
			else
				TEMP_STRING2(12) <= char_to_byte(STRING_FREQ(1));
				if STRING_FREQ(2) /= '0' and  STRING_FREQ(2) /= '1' then 
					TEMP_STRING2(13) <= char_to_byte('0');
				else
					TEMP_STRING2(13) <= char_to_byte(STRING_FREQ(2));
				end if;
				TEMP_STRING2(14) <= char_to_byte(',');
				TEMP_STRING2(15) <= char_to_byte(STRING_FREQ(3));
				TEMP_STRING2(16) <= "00000010"; -- 'HZ'
			end if;
		end if;
	end process;
	
	ARRAY_STRING1 <= TEMP_STRING1;
	ARRAY_STRING2 <= TEMP_STRING2;
	
end Behavioral;
