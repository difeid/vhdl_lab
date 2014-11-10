library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.lcd_package.all;

entity Symbol_Creator is
    Port ( 
			  -- входные сигналы
			  CG_RAM_ADDRESS  : in STD_LOGIC_VECTOR (0 to 2);
			  ARRAY_OF_PIXELS : in array_of_pixels_type;
			  START  : in  STD_LOGIC;
			  CLK_IN : in  STD_LOGIC;

			  -- выходные сигналы
			  RS_OUT  	: out  STD_LOGIC;
           RW_OUT  	: out  STD_LOGIC;
           DB7_OUT 	: out  STD_LOGIC;
           DB6_OUT 	: out  STD_LOGIC;
           DB5_OUT 	: out  STD_LOGIC;
           DB4_OUT 	: out  STD_LOGIC;
           DB3_OUT 	: out  STD_LOGIC;
           DB2_OUT 	: out  STD_LOGIC;
           DB1_OUT 	: out  STD_LOGIC;
           DB0_OUT 	: out  STD_LOGIC;
			  PAUSE_AFTER_COMMAND: out  pause_type;
		     START_OUT	: out	 STD_LOGIC
			);
end Symbol_Creator;

architecture Behavioral of Symbol_Creator is
	-- сигналы запоминания значений входных сигналов
	signal temp_CG_RAM_ADD	: STD_LOGIC_VECTOR (0 to 7) := "01000000";
	 signal temp_array_pixels	: array_of_pixels_type;

	-- набор временных выходных сигналы
    signal temp_RS_OUT   	: STD_LOGIC;
    signal temp_RW_OUT   	: STD_LOGIC;
	 signal temp_byte			: byte_type;
	 signal temp_START_OUT	: STD_LOGIC;
	 constant MAX_COUNTER : integer := 33296;

	 signal razreshenie_starta: boolean := false; 
	 -- внутренний сигнал, контролирующий разрешение старта обработки команды
    signal counter : integer range 0 to MAX_COUNTER := MAX_COUNTER; -- счетчик тактов
begin
    process (CLK_IN) begin
			if rising_edge(CLK_IN) then  -- проверка положительного фронта
					
					if razreshenie_starta = false then
						-- Временным выходным сигналам присваиваем значения
						temp_RS_OUT		<= '-';
						temp_RW_OUT		<= '-';
						temp_byte		<= "--------";
						temp_START_OUT <= '0';
						-- предусмотренные в случае если компонент не работает
						if counter = MAX_COUNTER and START = '0' then
							counter <= 0;
						end if;
					
						if counter = 0 and START = '1' then
						-- Копирование входных сигналов во внутреннюю память компонента
							temp_CG_RAM_ADD <= "01" & CG_RAM_ADDRESS & "000";
							temp_array_pixels <= ARRAY_OF_PIXELS;
							razreshenie_starta <= true;
						end if;
						
					-- Выполнение компонентом своей задачи
					elsif razreshenie_starta = true then
	
						-- Команда "Установить адрес CG RAM" (1 строка)
						if counter < 1 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(7) <= '1';
						elsif counter < 2081 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 2082 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(1);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 4162 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
						-- Команда "Установить адрес CG RAM" (2 строка)
						elsif counter < 4163 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(6) <= '1';
							temp_CG_RAM_ADD(7) <= '0';
						elsif counter < 6243 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
						-- Команда "Записать данные в CG RAM
						elsif counter < 6244 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(2);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 8324 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Установить адрес CG RAM"  (3 строка)
						elsif counter < 8325 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(7) <= '1';
						elsif counter < 10405 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
						-- Команда "Записать данные в CG RAM
						elsif counter < 10406 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(3);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 12486 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Установить адрес CG RAM"  (4 строка)
						elsif counter < 12487 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(5) <= '1';
							temp_CG_RAM_ADD(6) <= '0';
							temp_CG_RAM_ADD(7) <= '0';
						elsif counter < 14567 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 14568 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(4);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 16648 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Установить адрес CG RAM"  (5 строка)
						elsif counter < 16649 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(7) <= '1';
						elsif counter < 18729 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 18730 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(5);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 20810 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Установить адрес CG RAM"  (6 строка)
						elsif counter < 20811 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(6) <= '1';
							temp_CG_RAM_ADD(7) <= '0';
						elsif counter < 22891 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 22892 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(6);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 24972 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Установить адрес CG RAM"  (7 строка)
						elsif counter < 24973 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(7) <= '1';
						elsif counter < 27053 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 27054 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(7);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 29134 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
							-- Команда "Установить адрес CG RAM"  (8 строка)
						elsif counter < 29135 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_CG_RAM_ADD;
							temp_START_OUT <= '1';
							counter <= counter + 1;
							temp_CG_RAM_ADD(5) <= '0';
							temp_CG_RAM_ADD(6) <= '0';
							temp_CG_RAM_ADD(7) <= '0';
						elsif counter < 31215 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
						
						-- Команда "Записать данные в CG RAM
						elsif counter < 31216 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= "---" & temp_array_pixels(8);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 33296 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
						else
							-- Временным выходным сигналам присваиваем значения
							-- предусмотренные в случае если компонент не работает
							razreshenie_starta <= false;
							
							temp_RS_OUT		<= '-';
							temp_RW_OUT		<= '-';
							temp_byte		<= "--------";
							temp_START_OUT <= '0';
						end if;		
					end if;
			end if;
    end process; 
    
-- Присвоение выходным сигналам компонента 
-- значений временных выходных сигналов	
	 RS_OUT		<= temp_RS_OUT;
    RW_OUT  	<= temp_RW_OUT;
    DB7_OUT 	<= temp_byte(7);
    DB6_OUT 	<= temp_byte(6);
    DB5_OUT 	<= temp_byte(5);
    DB4_OUT 	<= temp_byte(4);
    DB3_OUT 	<= temp_byte(3);
    DB2_OUT 	<= temp_byte(2);
    DB1_OUT 	<= temp_byte(1);
    DB0_OUT 	<= temp_byte(0);
	 PAUSE_AFTER_COMMAND <= PAUSE2000;
	 START_OUT	<= temp_START_OUT;

end Behavioral;
