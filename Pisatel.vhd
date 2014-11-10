library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.lcd_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- Компонент Pisatel принимает на свои входы два массива из 16 байт, каждый байт в 
-- которых хранит адрес графического изображения символа в CG ROM или CG RAM, и 
-- рассчитывает синхронизацию последовательности необходимых команд для вывода этих 
-- графических изображений на LCD дисплей в виде двух строк по 16 символов. В течение 
-- выполнения своей задачи подает в соответствующие моменты коды команд и значения 
-- задержек после выполнения этих команд на свои выходы. 
-- Компонент Pisatel рассчитан на работу в паре с компонентом Commander. 
-- Их взаимодействие контролируется компонентом верхнего уровня.
-- Вывод двух строк по 16 символов занимает по времени 70760 тактов.
-- (при условии использовании входного синхросигнала частотой 50 МГц)
-- На загрузку данных с входов компонента требуется 1 такт
-- Тогда, конфигурируя компонент Pisatel, мы сначала подаем на вход START "1" и загружаем 
-- данные во внутреннюю память компонента (при условии, что до этого на входе START был "0"),
-- а затем подаем на вход START "0" и ждем 70760 тактов.
-- После этого компонент готов к приему следующей партии данных.
entity Pisatel is
    Port ( 
			  ARRAY1_OF_16BYTES
			  : in array_of_16_bytes_type;
			  ARRAY2_OF_16BYTES
			  : in array_of_16_bytes_type;
			  START_IN  : in  STD_LOGIC;
			  CLK_IN 	: in  STD_LOGIC;

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
			  PAUSE_AFTER_COMMAND
							: out  pause_type;
		     START_OUT	: out	 STD_LOGIC
			);
end Pisatel;

architecture Behavioral of Pisatel is
	 signal temp_array1		:	array_of_16_bytes_type;
	 signal temp_array2		:	array_of_16_bytes_type;

    signal temp_RS_OUT   	: STD_LOGIC;
    signal temp_RW_OUT   	: STD_LOGIC;
	 signal temp_byte			: byte_type;
	 signal temp_START_OUT	: STD_LOGIC;

	 signal razreshenie_starta: boolean := false; 
	 -- внутренний сигнал, контролирующий разрешение старта обработки команды
    signal counter : integer range 0 to 70754 := 70754; -- счетчик тактов
begin
    process (CLK_IN) begin
			if rising_edge(CLK_IN) then  -- проверка положительного фронта
					
					if razreshenie_starta = false then
						temp_RS_OUT		<= '-';
						temp_RW_OUT		<= '-';
						temp_byte		<= "--------";
						temp_START_OUT <= '0';
							
						if counter = 70754 and START_IN = '0' then
							counter <= 0;
						end if;
					
						if counter = 0 and START_IN = '1' then
						-- Копирование входных данных во внутреннюю память компонента
							temp_array1 <= ARRAY1_OF_16BYTES;
							temp_array2 <= ARRAY2_OF_16BYTES;
							razreshenie_starta <= true;
						end if;
						
					-- Подача команд для вывода соответствующих строк на дисплей на выходы компонента
					elsif razreshenie_starta = true then
							
							--ВЫВОД 1-ОЙ СТРОКИ
							-- 1 Команда "Установить адрес DD RAM" (0H-й адрес)
						--###############################################################
						if 	counter < 1 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= "10000000";
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 2081 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 2 Команда "Записать данные в CG RAM или DD RAM" ( 1-й символ)
						--###############################################################
						elsif counter < 2082 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(1);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 4162 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 3 Команда "Записать данные в CG RAM или DD RAM" ( 2-й символ)
						--###############################################################
						elsif counter < 4163 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(2);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 6243 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 4 Команда "Записать данные в CG RAM или DD RAM" ( 3-й символ)
						--###############################################################
						elsif counter < 6244 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(3);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 8324 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 5 Команда "Записать данные в CG RAM или DD RAM" ( 4-й символ)
						--###############################################################
						elsif counter < 8325 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(4);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 10405 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 6 Команда "Записать данные в CG RAM или DD RAM" ( 5-й символ)
						--###############################################################
						elsif counter < 10406 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(5);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 12486 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 7 Команда "Записать данные в CG RAM или DD RAM" ( 6-й символ)
						--###############################################################
						elsif counter < 12487 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(6);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 14567 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 8 Команда "Записать данные в CG RAM или DD RAM" ( 7-й символ)
						--###############################################################
						elsif counter < 14568 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(7);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 16648 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 9 Команда "Записать данные в CG RAM или DD RAM" ( 8-й символ)
						--###############################################################
						elsif counter < 16649 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(8);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 18729 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 10 Команда "Записать данные в CG RAM или DD RAM" ( 9-й символ)
						--###############################################################
						elsif counter < 18730 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(9);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 20810 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 11 Команда "Записать данные в CG RAM или DD RAM" ( 10-й символ)
						--###############################################################
						elsif counter < 20811 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(10);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 22891 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 12 Команда "Записать данные в CG RAM или DD RAM" ( 11-й символ)
						--###############################################################
						elsif counter < 22892 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(11);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 24972 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 13 Команда "Записать данные в CG RAM или DD RAM" ( 12-й символ)
						--###############################################################
						elsif counter < 24973 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(12);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 27053 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 14 Команда "Записать данные в CG RAM или DD RAM" ( 13-й символ)
						--###############################################################
						elsif counter < 27054 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(13);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 29134 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 15 Команда "Записать данные в CG RAM или DD RAM" ( 14-й символ)
						--###############################################################
						elsif counter < 29135 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(14);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 31215 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 16 Команда "Записать данные в CG RAM или DD RAM" ( 15-й символ)
						--###############################################################
						elsif counter < 31216 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(15);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 33296 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 17 Команда "Записать данные в CG RAM или DD RAM" ( 16-й символ)
						--###############################################################
						elsif counter < 33297 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array1(16);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 35377 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							--ВЫВОД 2-ОЙ СТРОКИ
							-- 18 Команда "Установить адрес DD RAM" (40H-й адрес)
						--###############################################################
						elsif	counter < 35378 then	-- 1
							temp_RS_OUT		<= '0';
							temp_RW_OUT		<= '0';
							temp_byte		<= "11000000";
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 37458 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;
							
							-- 19 Команда "Записать данные в CG RAM или DD RAM" ( 1-й символ)
						--###############################################################
						elsif counter < 37459 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(1);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 39539 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 20 Команда "Записать данные в CG RAM или DD RAM" ( 2-й символ)
						--###############################################################
						elsif counter < 39540 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(2);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 41620 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 21 Команда "Записать данные в CG RAM или DD RAM" ( 3-й символ)
						--###############################################################
						elsif counter < 41621 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(3);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 43701 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 22 Команда "Записать данные в CG RAM или DD RAM" ( 4-й символ)
						--###############################################################
						elsif counter < 43702 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(4);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 45782 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 23 Команда "Записать данные в CG RAM или DD RAM" ( 5-й символ)
						--###############################################################
						elsif counter < 45783 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(5);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 47863 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 24 Команда "Записать данные в CG RAM или DD RAM" ( 6-й символ)
						--###############################################################
						elsif counter < 47864 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(6);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 49944 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 25 Команда "Записать данные в CG RAM или DD RAM" ( 7-й символ)
						--###############################################################
						elsif counter < 49945 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(7);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 52025 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 26 Команда "Записать данные в CG RAM или DD RAM" ( 8-й символ)
						--###############################################################
						elsif counter < 52026 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(8);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 54106 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 27 Команда "Записать данные в CG RAM или DD RAM" ( 9-й символ)
						--###############################################################
						elsif counter < 54107 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(9);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 56187 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 28 Команда "Записать данные в CG RAM или DD RAM" ( 10-й символ)
						--###############################################################
						elsif counter < 56188 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(10);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 58268 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 29 Команда "Записать данные в CG RAM или DD RAM" ( 11-й символ)
						--###############################################################
						elsif counter < 58269 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(11);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 60349 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 30 Команда "Записать данные в CG RAM или DD RAM" ( 12-й символ)
						--###############################################################
						elsif counter < 60350 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(12);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 62430 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 31 Команда "Записать данные в CG RAM или DD RAM" ( 13-й символ)
						--###############################################################
						elsif counter < 62431 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(13);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 64511 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 32 Команда "Записать данные в CG RAM или DD RAM" ( 14-й символ)
						--###############################################################
						elsif counter < 64512 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(14);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 66592 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 33 Команда "Записать данные в CG RAM или DD RAM" ( 15-й символ)
						--###############################################################
						elsif counter < 66593 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(15);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 68673 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

							-- 34 Команда "Записать данные в CG RAM или DD RAM" ( 16-й символ)
						--###############################################################
						elsif counter < 68674 then	-- 1
							temp_RS_OUT		<= '1';
							temp_RW_OUT		<= '0';
							temp_byte		<= temp_array2(16);
							temp_START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 70754 then	-- 2080
							temp_START_OUT <= '0';
							counter <= counter + 1;

						else
							razreshenie_starta <= false;
							
							temp_RS_OUT		<= '-';
							temp_RW_OUT		<= '-';
							temp_byte		<= "--------";
							temp_START_OUT <= '0';
						end if;		
					end if;
			end if;
    end process; 

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

