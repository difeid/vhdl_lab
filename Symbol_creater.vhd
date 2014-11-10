library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.lcd_package.all;

entity Symbol_creater is
    Port ( 
			  -- входные сигналы
			  CG_RAM_ADDRESS: in SDT_LOGIC_VECTOR (0 to 2);
  			  ARRAY_OF_PIXELS: in array_of_pixels_type;
			  
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
			  PAUSE_AFTER_COMMAND: out pause_type;
			  START_OUT: out STD_LOGIC

			);
end Symbol_creater;

architecture Behavioral of Symbol_creater is
	-- сигналы запоминания значений входных сигналов
	
	-- набор временных выходных сигналы

	 signal razreshenie_starta: boolean := false; 
	 -- внутренний сигнал, контролирующий разрешение старта обработки команды
    signal counter : integer range 0 to MAX_COUNTER := MAX_COUNTER; -- счетчик тактов
begin
    process (CLK_IN) begin
			if rising_edge(CLK_IN) then  -- проверка положительного фронта
					
					if razreshenie_starta = false then
						-- Временным выходным сигналам присваиваем значения
						-- предусмотренные в случае если компонент не работает
						if counter = MAX_COUNTER and START = '0' then
							counter <= 0;
						end if;
					
						if counter = 0 and START = '1' then
						-- Копирование входных сигналов во внутреннюю память компонента
							
							razreshenie_starta <= true;
						end if;
						
					-- Выполнение компонентом своей задачи
					elsif razreshenie_starta = true then
						
						-- ЧТО НАПИСАТЬ ЗДЕСЬ?
						-- ЗДЕСЬ КОМПОНЕНТ БУДЕТ ВЫПОЛНЯТЬ СВОЮ ЗАДАЧУ
						
						-- Установить адрес DD RAM
						elsif counter < 1 then  -- 1
							--Временным выходным сигналам <= "0010000000";
							START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 2081 then	-- 2080
							START_OUT <= '0';
							counter <= counter + 1;

						-- Вывести 1-ый символ на дисплей
						elsif counter < 2082 then  -- 1
							--Временным выходным сигналам <= "0010000000";
							START_OUT <= '1';
							counter <= counter + 1;
						elsif counter < 4162 then	-- 2080
							START_OUT <= '0';
							counter <= counter + 1;
						
						else
							razreshenie_starta <= false;
							-- Временным выходным сигналам присваиваем значения
							-- предусмотренные в случае если компонент не работает
						end if;		
					end if;
			end if;
    end process; 
    
-- Присвоение выходным сигналам компонента 
-- значений временных выходных сигналов

end Behavioral;

