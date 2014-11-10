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


-- Компонент Commander принимает на свои входы код команды микроконтроллера дисплея 
-- и подает ее на свои выходы с учетом синхронизации (для 4-битного интерфейса связи с дисплеем).
-- Типичная команда микроконтроллера дисплея длится 76 тактов 
-- (при условии использовании входного синхросигнала частотой 50 МГц)
-- После завершения подачи команды обязательно следует пауза, которая может быть либо 2000 тактов
-- (PAUSE_AFTER_COMMAND=PAUSE2000), либо 82000 тактов (PAUSE_AFTER_COMMAND=PAUSE82000) соответственно.
-- Пусть, команда длится 80 тактов + пауза PAUSE_AFTER_COMMAND, а на загрузку данных требуется 1 такт
-- Тогда, конфигурируя компонент Commander, мы сначала подаем на вход START "1" и загружаем команду
-- во внутреннюю память компонента (при условии, что до этого на входе START был "0"),
-- а затем подаем на вход START "0" и ждем 80 тактов + паузу после выполнения команды.
-- После этого компонент готов к приему следующей команды на выполнение
entity Commander is
    Port ( 
           RS_IN  : in  STD_LOGIC;
           RW_IN  : in  STD_LOGIC;
           DB7_IN : in  STD_LOGIC;
           DB6_IN : in  STD_LOGIC;
           DB5_IN : in  STD_LOGIC;
           DB4_IN : in  STD_LOGIC;
           DB3_IN : in  STD_LOGIC;
           DB2_IN : in  STD_LOGIC;
           DB1_IN : in  STD_LOGIC;
           DB0_IN : in  STD_LOGIC;
	   PAUSE_AFTER_COMMAND : in pause_type;
	   START  : in  STD_LOGIC;
	   CLK_IN : in  STD_LOGIC;

           E_OUT   : out  STD_LOGIC;
           RS_OUT  : out  STD_LOGIC;
           RW_OUT  : out  STD_LOGIC;
           DB7_OUT : out  STD_LOGIC;
           DB6_OUT : out  STD_LOGIC;
           DB5_OUT : out  STD_LOGIC;
           DB4_OUT : out  STD_LOGIC
			);
end Commander;

architecture Behavioral of Commander is
    signal temp_RS_IN   : STD_LOGIC;
    signal temp_RW_IN   : STD_LOGIC;
    signal temp_DB7_IN  : STD_LOGIC;
    signal temp_DB6_IN  : STD_LOGIC;
    signal temp_DB5_IN  : STD_LOGIC;
    signal temp_DB4_IN  : STD_LOGIC;
    signal temp_DB3_IN  : STD_LOGIC;
    signal temp_DB2_IN  : STD_LOGIC;
    signal temp_DB1_IN  : STD_LOGIC;
    signal temp_DB0_IN  : STD_LOGIC;

    signal temp_E_OUT   : STD_LOGIC;
    signal temp_RS_OUT  : STD_LOGIC;
    signal temp_RW_OUT  : STD_LOGIC;
    signal temp_DB7_OUT : STD_LOGIC;
    signal temp_DB6_OUT : STD_LOGIC;
    signal temp_DB5_OUT : STD_LOGIC;
    signal temp_DB4_OUT : STD_LOGIC;

	 signal pause: integer range 2000 to 82000 := 82000;
	 -- внутренний сигнал, в который запоминается значение паузы, которая должна
	 -- быть сделана после выполнения команды.
	 signal razreshenie_starta: boolean := false; 
	 -- внутренний сигнал, контролирующий разрешение старта обработки команды
    signal counter : integer range 0 to 83000 := 83000; -- счетчик тактов
begin
    process (CLK_IN) begin
			if rising_edge(CLK_IN) then  -- проверка положительного фронта
					
					if razreshenie_starta = false then
						temp_E_OUT   <= '0';  
						temp_RS_OUT  <= '0';
						temp_RW_OUT  <= '1';
						temp_DB7_OUT <= '-';
						temp_DB6_OUT <= '-';
						temp_DB5_OUT <= '-';
						temp_DB4_OUT <= '-';					
							
						if counter >= (76+pause) and START = '0' then
							counter <= 0;
						end if;
					
						if counter = 0 and START = '1' then
						-- Копирование входной команды во внутреннюю память компонента
							temp_RS_IN  <= RS_IN;
							temp_RW_IN  <= RW_IN;
							temp_DB7_IN <= DB7_IN;
							temp_DB6_IN <= DB6_IN;
							temp_DB5_IN <= DB5_IN;
							temp_DB4_IN <= DB4_IN;
							temp_DB3_IN <= DB3_IN;
							temp_DB2_IN <= DB2_IN;
							temp_DB1_IN <= DB1_IN;
							temp_DB0_IN <= DB0_IN;
							if PAUSE_AFTER_COMMAND = PAUSE2000 then
								pause <= 2000;
							elsif PAUSE_AFTER_COMMAND = PAUSE82000 then
								pause <= 82000;
							end if;
							
							razreshenie_starta <= true;
						end if;
						
					-- Подача команды на дисплей
					elsif razreshenie_starta = true then

						-- передача верхних 4 бит (7-4 биты)
						if    counter < 2 then	-- 2
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB7_IN;
							temp_DB6_OUT <= temp_DB6_IN;
							temp_DB5_OUT <= temp_DB5_IN;
							temp_DB4_OUT <= temp_DB4_IN;
							counter <= counter + 1;
							
						elsif counter < 13 then -- 11
							temp_E_OUT   <= '1';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB7_IN;
							temp_DB6_OUT <= temp_DB6_IN;
							temp_DB5_OUT <= temp_DB5_IN;
							temp_DB4_OUT <= temp_DB4_IN;
							counter <= counter + 1;
						
						elsif counter < 14 then -- 1
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB7_IN;
							temp_DB6_OUT <= temp_DB6_IN;
							temp_DB5_OUT <= temp_DB5_IN;
							temp_DB4_OUT <= temp_DB4_IN;
							counter <= counter + 1;
												
						-- пауза между пересылками
						elsif counter < 62 then -- 48
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= '0';
							temp_RW_OUT  <= '1';
							temp_DB7_OUT <= '-';
							temp_DB6_OUT <= '-';
							temp_DB5_OUT <= '-';
							temp_DB4_OUT <= '-';
							counter <= counter + 1;
							
						-- передача нижних 4 бит (3-0 биты)
						elsif counter < 64 then	-- 2
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB3_IN;
							temp_DB6_OUT <= temp_DB2_IN;
							temp_DB5_OUT <= temp_DB1_IN;
							temp_DB4_OUT <= temp_DB0_IN;
							counter <= counter + 1;
						
						elsif counter < 75 then -- 11
							temp_E_OUT   <= '1';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB3_IN;
							temp_DB6_OUT <= temp_DB2_IN;
							temp_DB5_OUT <= temp_DB1_IN;
							temp_DB4_OUT <= temp_DB0_IN;
							counter <= counter + 1;
						
						elsif counter < 76 then -- 1
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= temp_RS_IN;
							temp_RW_OUT  <= temp_RW_IN;
							temp_DB7_OUT <= temp_DB3_IN;
							temp_DB6_OUT <= temp_DB2_IN;
							temp_DB5_OUT <= temp_DB1_IN;
							temp_DB4_OUT <= temp_DB0_IN;
							counter <= counter + 1;
						
						-- пауза после выполнения команды
						elsif counter < (76+pause) then -- pause
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= '0';
							temp_RW_OUT  <= '1';
							temp_DB7_OUT <= '-';
							temp_DB6_OUT <= '-';
							temp_DB5_OUT <= '-';
							temp_DB4_OUT <= '-';
							counter <= counter + 1;
						else
							razreshenie_starta <= false;
							temp_E_OUT   <= '0';  
							temp_RS_OUT  <= '0';
							temp_RW_OUT  <= '1';
							temp_DB7_OUT <= '-';
							temp_DB6_OUT <= '-';
							temp_DB5_OUT <= '-';
							temp_DB4_OUT <= '-';					
						end if;		
					end if;
			end if;
    end process; 
    
    E_OUT   <= temp_E_OUT;
    RS_OUT  <= temp_RS_OUT;
    RW_OUT  <= temp_RW_OUT;
    DB7_OUT <= temp_DB7_OUT;
    DB6_OUT <= temp_DB6_OUT;
    DB5_OUT <= temp_DB5_OUT;
    DB4_OUT <= temp_DB4_OUT;

end Behavioral;
