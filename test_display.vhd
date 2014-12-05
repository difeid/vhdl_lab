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

entity test_display is
    Port ( CLK50MHZ 	: in  STD_LOGIC;
           LCD_E 		: out  STD_LOGIC;
           LCD_RS 	: out  STD_LOGIC;
           LCD_RW 	: out  STD_LOGIC;
           LCD_DB7 	: out  STD_LOGIC;
           LCD_DB6 	: out  STD_LOGIC;
           LCD_DB5 	: out  STD_LOGIC;
           LCD_DB4 	: out  STD_LOGIC;
           LCD_DB3 	: out  STD_LOGIC;
           LCD_DB2 	: out  STD_LOGIC;
           LCD_DB1 	: out  STD_LOGIC;
           LCD_DB0 	: out  STD_LOGIC;
			  
			  SW0 : in STD_LOGIC;
			  SW1 : in STD_LOGIC;
			  BTN : in STD_LOGIC
			  
			);
end test_display;

architecture Behavioral of test_display is
    
-- группы сигналов данных для различных компонентов
-- ####################################################################

-- сигналы, относящиеся к компоненту test_display 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -- ВЫХОДНЫЕ
	 signal to_display_from_test_display: STD_LOGIC_VECTOR (1 to 7):= "-------";  		
	 -- временные сигналы, которые подаются от компонента test_display на дисплей
	 -- to_display_from_test_display(1) <=> temp_LCD_E  
	 -- to_display_from_test_display(2) <=> temp_LCD_RS
	 -- to_display_from_test_display(3) <=> temp_LCD_RW
	 -- to_display_from_test_display(4) <=> temp_LCD_DB7	 
	 -- to_display_from_test_display(5) <=> temp_LCD_DB6
	 -- to_display_from_test_display(6) <=> temp_LCD_DB5
	 -- to_display_from_test_display(7) <=> temp_LCD_DB4

	 signal command_from_test_display: STD_LOGIC_VECTOR (1 to 10):= "----------";  	
	 -- временные сигналы команды от компонента test_display
	 -- command_from_test_display(1) <=> RS_IN
	 -- command_from_test_display(2) <=> RW_IN
	 -- command_from_test_display(3) <=> DB7_IN	 
	 -- command_from_test_display(4) <=> DB6_IN
	 -- command_from_test_display(5) <=> DB5_IN
	 -- command_from_test_display(6) <=> DB4_IN
	 -- command_from_test_display(7) <=> DB3_IN	 
	 -- command_from_test_display(8) <=> DB2_IN
	 -- command_from_test_display(9) <=> DB1_IN
	 -- command_from_test_display(10) <=> DB0_IN

	 signal pause_after_command_from_test_display: pause_type := PAUSE82000;
	 -- пауза от компонента test_display
	 
	 signal START_OUT_TEST_DISPLAY: STD_LOGIC := '0'; 
	 -- сигнал START_OUT от компонента test_display

	 signal sel_to_LCD: integer range 0 to 1 := 0;
	 -- сигнал-селектор, который определяет, будут ли подключены к входам дисплея
	 -- выходы компонента test_display (sel_to_display = 0)
	 -- или выходы компонента Commander (sel_to_display = 1)

	 signal sel_to_Commander: integer range 0 to 2 := 0;
	 -- сигнал-селектор, который определяет, будут ли подключены к входам компонента Commander
	 -- выходы компонента test_display (sel_to_Commander = 0)
	 -- или выходы компонента Pisatel (sel_to_Commander = 1)

    signal counter : integer range 0 to 100000000 := 0; -- счетчик тактов
	 -- счетчик тактов

-- сигналы, относящиеся к компоненту Commander 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -- ВХОДНЫЕ
	 signal command_to_commander: STD_LOGIC_VECTOR (1 to 10):= "----------";  	
	 -- временные сигналы к компоненту Commander
	 -- command_to_commander(1) <=> RS_IN
	 -- command_to_commander(2) <=> RW_IN
	 -- command_to_commander(3) <=> DB7_IN	 
	 -- command_to_commander(4) <=> DB6_IN
	 -- command_to_commander(5) <=> DB5_IN
	 -- command_to_commander(6) <=> DB4_IN
	 -- command_to_commander(7) <=> DB3_IN	 
	 -- command_to_commander(8) <=> DB2_IN
	 -- command_to_commander(9) <=> DB1_IN
	 -- command_to_commander(10) <=> DB0_IN

	 signal pause_after_command_to_commander: pause_type := PAUSE82000;
	 -- пауза для компонента Commander

	 signal START_TO_COMMANDER: STD_LOGIC := '0';
	 -- Сигнал START_TO_COMMANDER идет напрямую к компоненту Commander
	 
	 -- ВЫХОДНЫЕ
	 signal from_commander: STD_LOGIC_VECTOR (1 to 7) := "-------";  	
	 -- временные сигналы от компонента Commander
	 -- from_commander(1) <=> temp_LCD_E
	 -- from_commander(2) <=> temp_LCD_RS
	 -- from_commander(3) <=> temp_LCD_RW
	 -- from_commander(4) <=> temp_LCD_DB7	 
	 -- from_commander(5) <=> temp_LCD_DB6
	 -- from_commander(6) <=> temp_LCD_DB5
	 -- from_commander(7) <=> temp_LCD_DB4

-- сигналы, относящиеся к компоненту Pisatel 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -- ВХОДНЫЕ
	 signal stroka1: array_of_16_bytes_type := 
	 ("01001001", -- "I"
	  "01101101", -- "m"
	  "01111001", -- "y"
	  "01100001", -- "a"
	  "11111110", -- " "
	  "01000110", -- "F"
	  "01100001", -- "a"
	  "01101101", -- "m"
	  "01101001", -- "i"
	  "01101100", -- "l"
	  "01101001", -- "i"
	  "01111001", -- "y"
	  "01100001", -- "a"
	  "00000000", -- " "
	  "11111110", -- " "
	  "11111110"  -- " "
	  );

	 signal stroka2: array_of_16_bytes_type := 
	 ("01001110", -- "N"
	  "01101111", -- "o"
	  "01101101", -- "m"
	  "00101110", -- "."
	  "01000111", -- "G"
	  "01110010", -- "r"
	  "01110101", -- "u"
	  "01110000", -- "p"
	  "01110000", -- "p"
	  "01101001", -- "i"
	  "11111110", -- " "
	  "00110000", -- "0"
	  "00110001", -- "1"
	  "00110010", -- "2"
	  "00110011", -- "3"
	  "00000001"  -- " "
	  );

	 signal START_IN_PISATEL: STD_LOGIC :=	'0'; 
	 -- сигнал START_IN к компоненту Pisatel
	 
	 -- ВЫХОДНЫЕ
	 signal command_from_pisatel: STD_LOGIC_VECTOR (1 to 10):="----------";  	
	 -- выходные сигналы от компонента Pisatel
	 -- command_from_pisatel(1) <=> RS_IN
	 -- command_from_pisatel(2) <=> RW_IN
	 -- command_from_pisatel(3) <=> DB7_IN	 
	 -- command_from_pisatel(4) <=> DB6_IN
	 -- command_from_pisatel(5) <=> DB5_IN
	 -- command_from_pisatel(6) <=> DB4_IN
	 -- command_from_pisatel(7) <=> DB7_IN	 
	 -- command_from_pisatel(8) <=> DB6_IN
	 -- command_from_pisatel(9) <=> DB5_IN
	 -- command_from_pisatel(10) <=> DB4_IN

	 signal pause_after_command_from_pisatel: pause_type := PAUSE2000;
	 -- для от компонента pisatel

	 signal START_OUT_PISATEL: STD_LOGIC := '0'; 
	 -- сигнал START_OUT от компонента Pisatel	 
	 
-- сигналы, относящиеся к компоненту Symbol_creater 
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	 -- ВХОДНЫЕ
	 signal addres: STD_LOGIC_VECTOR (0 to 2);
	 signal symbol: array_of_pixels_type;
	 
	 signal addres1: STD_LOGIC_VECTOR (0 to 2) :=  "000";

	 signal symbol1: array_of_pixels_type := 
	 ("00000",
	  "00000",
	  "01110",
	  "01010",
	  "01010",
	  "01010",
	  "11011",
	  "00000"
	  );
	  
	  signal addres2: STD_LOGIC_VECTOR (0 to 2) :=  "001";
	  
	  signal symbol2: array_of_pixels_type := 
	 ("00000",
	  "00000",
	  "00000",
	  "00000",
	  "00000",
	  "00000",
	  "11111",
	  "00000"
	  );

	 signal START_IN_SYMBOL_CREATOR: STD_LOGIC :=	'0'; 
	 -- сигнал START_IN к компоненту symbol_creator
	 
	 -- ВЫХОДНЫЕ
	 signal command_from_symbol_creator: STD_LOGIC_VECTOR (1 to 10):="----------";  	

	 signal pause_after_command_from_symbol_creator: pause_type := PAUSE2000;
	 -- для от компонента symbol_creator

	 signal START_OUT_SYMBOL_CREATOR: STD_LOGIC := '0'; 
	 -- сигнал START_OUT от компонента symbol_creator	 
	 
	 -- сигналы, относящиеся к компоненту Former
-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	signal SEQUENCE_IN_FORMER : STD_LOGIC_VECTOR (1 to 16) := "1010101010101010";
	signal D_IN_FORMER : STD_LOGIC_VECTOR (1 to 10):= "1010------";
	signal FREQ_IN_FORMER :  STD_LOGIC_VECTOR (7 downto 0) := "00000101";
	signal CLK_BTN : STD_LOGIC := '0';
		
	signal ARRAY_STRING1_OUT_FORMER : array_of_16_bytes_type;
	signal ARRAY_STRING2_OUT_FORMER : array_of_16_bytes_type;

	
-- Описания используемых функций и процедур
-- ####################################################################
	 function connector_to_LCD
	 -- Функция определяет, какой из входов in1 или in2 будет подключен к
	 -- входу LCD дисплея в зависимости от значения сигнала-селектора sel
	 -- если sel = 0, то возвращает значение сигнала in1
	 -- иначе возвращает значение сигнала in2
	 (
		in1: STD_LOGIC;
		in2: STD_LOGIC;
		sel : integer range 0 to 1
	 )
	 return STD_LOGIC is
	 begin
			if sel=0 then
				return in1;
			else
				return in2;
			end if;
	 end connector_to_LCD;

	 procedure connector_to_Commander
	 -- Процедура определяет, какой из наборов входных сигналов будет подключен к
	 -- входам компонента Commander в зависимости от значения сигнала-селектора sel
	 -- если sel = 0, то подключает набор сигналов с индексом 1
	 -- иначе подключает набор сигналов с индексом 2
	 (
		signal command1: in STD_LOGIC_VECTOR (1 to 10);
		signal pause_after_command1: in pause_type; 
		signal START1: in STD_LOGIC;

		signal command2: in STD_LOGIC_VECTOR (1 to 10);
		signal pause_after_command2: in pause_type; 
		signal START2: in STD_LOGIC;
		
		signal command3: in STD_LOGIC_VECTOR (1 to 10);
		signal pause_after_command3: in pause_type; 
		signal START3: in STD_LOGIC;
	 
		signal sel: in integer range 0 to 2;
	 
		signal command: out STD_LOGIC_VECTOR (1 to 10);
		signal pause_after_command: out pause_type; 
		signal START: out STD_LOGIC	 
	 ) is
	 begin
			if sel=0 then
				command <= command1;
				pause_after_command <= pause_after_command1;
				START <= START1;
			elsif sel=1 then
				command <= command2;
				pause_after_command <= pause_after_command2;
				START <= START2;
			else
				command <= command3;
				pause_after_command <= pause_after_command3;
				START <= START3;
			end if;
	end procedure;
	

-- Описания используемых компонентов
-- ####################################################################
	 component Commander is
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
			  PAUSE_AFTER_COMMAND
						: in pause_type;
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
	 end component;	 
	 
	 component Pisatel is
-- Компонент Pisatel принимает на свои входы два массива из 16 байт, каждый байт в 
-- которых хранит адрес графического изображения символа в CG ROM или CG RAM, и 
-- рассчитывает синхронизацию последовательности необходимых команд для вывода этих 
-- графических изображений на LCD дисплей в виде двух строк по 16 символов. В течение 
-- выполнения своей задачи подает в соответствующие моменты коды команд и значения 
-- задержек после выполнения этих команд на свои выходы. 
-- Компонент Pisatel рассчитан на работу в паре с компонентом Commander. 
-- Их взаимодействие контролируется компонентом верхнего уровня test_display.
-- Вывод двух строк по 16 символов занимает по времени 70760 тактов.
-- (при условии использовании входного синхросигнала частотой 50 МГц)
-- На загрузку данных с входов компонента требуется 1 такт
-- Тогда, конфигурируя компонент Pisatel, мы сначала подаем на вход START "1" и загружаем 
-- данные во внутреннюю память компонента (при условии, что до этого на входе START был "0"),
-- а затем подаем на вход START "0" и ждем 70760 тактов.
-- После этого компонент готов к приему следующей партии данных.
    Port ( 
			  ARRAY1_OF_16BYTES : in array_of_16_bytes_type;
			  ARRAY2_OF_16BYTES : in array_of_16_bytes_type;
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
	end component;
	
	 component Symbol_Creator is

    Port ( 
			  CG_RAM_ADDRESS  : in STD_LOGIC_VECTOR (0 to 2);
			  ARRAY_OF_PIXELS : in array_of_pixels_type;
			  START  : in  STD_LOGIC;
			  CLK_IN : in  STD_LOGIC;

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
	end component;
	
	component Former is

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
	end component;
	
begin
	 -- Вызов конкретного экземпляра компонента Commander
	 metka1: Commander
	 -- карта портов или иначе карта подключения сигналов
	 -- слева выходы и выходы компонента
	 -- потом идет значок ключевого соответствия => 
	 -- справа подключаются входные и выходные сигналы
	 Port map( 
				  RS_IN   => command_to_commander(1),
              RW_IN   => command_to_commander(2),
              DB7_IN  => command_to_commander(3),
              DB6_IN  => command_to_commander(4),
              DB5_IN  => command_to_commander(5),
              DB4_IN  => command_to_commander(6),
              DB3_IN  => command_to_commander(7),
              DB2_IN  => command_to_commander(8),
              DB1_IN  => command_to_commander(9),
              DB0_IN  => command_to_commander(10),
				  PAUSE_AFTER_COMMAND 
							 => pause_after_command_to_commander, 
				  START   => START_TO_COMMANDER, 
				  CLK_IN  => CLK50MHZ,

              E_OUT   => from_commander(1),
              RS_OUT  => from_commander(2),
              RW_OUT  => from_commander(3),
              DB7_OUT => from_commander(4),
              DB6_OUT => from_commander(5),
              DB5_OUT => from_commander(6),
              DB4_OUT => from_commander(7)
			   );


	 metka2: Pisatel
    Port map( 
			  ARRAY1_OF_16BYTES => stroka1,
			  ARRAY2_OF_16BYTES => stroka2,
			  START_IN 	=> START_IN_PISATEL,
			  CLK_IN 	=> CLK50MHZ,

           RS_OUT  	=> command_from_pisatel(1),
           RW_OUT  	=> command_from_pisatel(2),
           DB7_OUT 	=> command_from_pisatel(3),
           DB6_OUT 	=> command_from_pisatel(4),
           DB5_OUT 	=> command_from_pisatel(5),
           DB4_OUT 	=> command_from_pisatel(6),
           DB3_OUT 	=> command_from_pisatel(7),
           DB2_OUT 	=> command_from_pisatel(8),
           DB1_OUT 	=> command_from_pisatel(9),
           DB0_OUT 	=> command_from_pisatel(10),
			  PAUSE_AFTER_COMMAND 
							=> pause_after_command_from_pisatel,
		     START_OUT	=> START_OUT_PISATEL
			);
			
	 metka3: Symbol_Creator
    Port map( 
			  CG_RAM_ADDRESS => addres,
			  ARRAY_OF_PIXELS => symbol,
			  START 	=> START_IN_SYMBOL_CREATOR,
			  CLK_IN 	=> CLK50MHZ,

           RS_OUT  	=> command_from_symbol_creator(1),
           RW_OUT  	=> command_from_symbol_creator(2),
           DB7_OUT 	=> command_from_symbol_creator(3),
           DB6_OUT 	=> command_from_symbol_creator(4),
           DB5_OUT 	=> command_from_symbol_creator(5),
           DB4_OUT 	=> command_from_symbol_creator(6),
           DB3_OUT 	=> command_from_symbol_creator(7),
           DB2_OUT 	=> command_from_symbol_creator(8),
           DB1_OUT 	=> command_from_symbol_creator(9),
           DB0_OUT 	=> command_from_symbol_creator(10),
			  PAUSE_AFTER_COMMAND 
							=> pause_after_command_from_symbol_creator,
		     START_OUT	=> START_OUT_SYMBOL_CREATOR
			);
			
	metka4: Former
	Port map( 
		SEQUENCE => SEQUENCE_IN_FORMER,
		D => D_IN_FORMER,
		FREQ => FREQ_IN_FORMER, 
		MANUAL_MODE => SW0,
		PAUSE => SW1,
		CLK => CLK_BTN,
		
		ARRAY_STRING1 => ARRAY_STRING1_OUT_FORMER,
		ARRAY_STRING2 => ARRAY_STRING2_OUT_FORMER
			);

    process (CLK50MHZ) begin
		  if rising_edge(CLK50MHZ) then  -- проверка положительного фронта
        
				-- Инициализация дисплея
		  --###############################################################
				if counter < 750000 then	  	-- 750000
					to_display_from_test_display <= "0------";
					counter <= counter + 1;
					
				elsif counter < 750012 then 	-- 12
					to_display_from_test_display <= "1000011";
					counter <= counter + 1;

				elsif counter < 955012 then 	-- 205000
					to_display_from_test_display <= "0------";
					counter <= counter + 1;
				
				elsif counter < 955024  then  -- 12
					to_display_from_test_display <= "1000011";
					counter <= counter + 1;
		
				elsif counter < 960024 then 	-- 5000
					to_display_from_test_display <= "0------";
					counter <= counter + 1;
		
				elsif counter < 960036 then   -- 12
					to_display_from_test_display <= "1000011";
					counter <= counter + 1;
		
				elsif counter < 962036 then 	-- 2000 
					to_display_from_test_display <= "0------";
					counter <= counter + 1;
		
				elsif counter < 962048 then 	-- 12
					to_display_from_test_display <= "1000010";
					counter <= counter + 1;
		
				elsif counter < 964048 then 	-- 2000
					to_display_from_test_display <= "0------";
					counter <= counter + 1;		
		
				-- Конфигурация дисплея
					-- Команда "Установка функций"
		  --###############################################################
				elsif counter < 964049 then  -- 1
					sel_to_LCD <= 1;			-- Выбор подачи сигналов на дисплей от компонента Commander
					sel_to_Commander <= 0;	-- Настройка компонента Commander на прием данных от компонента test_display
					command_from_test_display <= "0000101000";
					pause_after_command_from_test_display <= PAUSE2000;
					START_OUT_TEST_DISPLAY <= '1';
					counter <= counter + 1;
				elsif counter < 966129 then	-- 2080
					START_OUT_TEST_DISPLAY <= '0';
					counter <= counter + 1;

					-- Команда "Установка режима ввода"
		  --###############################################################
				elsif counter < 966130 then  -- 1
					command_from_test_display <= "0000000110";
					START_OUT_TEST_DISPLAY <= '1';
					counter <= counter + 1;
				elsif counter < 968210 then	-- 2080
					START_OUT_TEST_DISPLAY <= '0';
					counter <= counter + 1;

					-- Команда "Включение/Выключение дисплея"
		  --###############################################################
				elsif counter < 968211 then  -- 1
					command_from_test_display <= "0000001100";
					START_OUT_TEST_DISPLAY <= '1';
					counter <= counter + 1;
				elsif counter < 970291 then	-- 2080
					START_OUT_TEST_DISPLAY <= '0';
					counter <= counter + 1;

					-- Команда "Очистка дисплея"
		  --###############################################################
				elsif counter < 970292 then  -- 1
					command_from_test_display <= "0000000001";
					pause_after_command_from_test_display <= PAUSE82000;
					START_OUT_TEST_DISPLAY <= '1';
					counter <= counter + 1;
				elsif counter < 1052372 then	-- 82080
					START_OUT_TEST_DISPLAY <= '0';
					counter <= counter + 1;
					
			-- Создание символа 1 с помощью компонента Symbol_Creator
		  --###############################################################
				elsif counter < 1052373 then  -- 1
					sel_to_LCD <= 1;			-- Выбор подачи сигналов на дисплей от компонента Commander
					sel_to_Commander <= 2;	-- Настройка компонента Commander на прием данных от компонента Symbol_Creator
					addres <= addres1;
					symbol <= symbol1;
					START_IN_SYMBOL_CREATOR <= '1';
					counter <= counter + 1;
				elsif counter < 1085669 then	-- 33296
					START_IN_SYMBOL_CREATOR <= '0';
					counter <= counter + 1;
			
			-- Создание символа 2 с помощью компонента Symbol_Creator
		  --###############################################################
				elsif counter < 1085670 then  -- 1
					sel_to_LCD <= 1;			-- Выбор подачи сигналов на дисплей от компонента Commander
					sel_to_Commander <= 2;	-- Настройка компонента Commander на прием данных от компонента Symbol_Creator
					addres <= addres2;
					symbol <= symbol2;
					START_IN_SYMBOL_CREATOR <= '1';
					counter <= counter + 1;
				elsif counter < 1118966 then	-- 33296
					START_IN_SYMBOL_CREATOR <= '0';
					counter <= counter + 1;	
			

				-- Вывод символов 2-ух строк на дисплей с помощью компонента Pisatel
		  --###############################################################
				elsif counter < 1118967 then  -- 1
					stroka1 <= ARRAY_STRING1_OUT_FORMER;
					stroka2 <= ARRAY_STRING2_OUT_FORMER;
					sel_to_LCD <= 1;			-- Выбор подачи сигналов на дисплей от компонента Commander
					sel_to_Commander <= 1;	-- Настройка компонента Commander на прием данных от компонента Pisatel
					-- входные сигналы stroka1 и stroka2 уже инициализированы и заполнены значениями в начале секции Architecture
					-- присваивать им значения сейчас нет нужды
					START_IN_PISATEL <= '1';
					counter <= counter + 1;
				elsif counter < 1189727 then	-- 70760
					START_IN_PISATEL <= '0';
					counter <= counter + 1;
					
				else
					to_display_from_test_display <= "001----";
					sel_to_LCD <= 0;
					
					if BTN = '1' and CLK_BTN = '0' then
						SEQUENCE_IN_FORMER <= SEQUENCE_IN_FORMER(2 to 16) & '0' ;
						D_IN_FORMER <= D_IN_FORMER(2 to 10) & '-';
						CLK_BTN <= '1';
					elsif BTN = '0' and CLK_BTN = '1' then
						FREQ_IN_FORMER <= FREQ_IN_FORMER(6 downto 0) & '0';
						CLK_BTN <= '0';
					end if;
						
				
            end if;
        end if;
    end process; 
           
	 -- Подача выходных сигналов компонентов на входы компонента Commander
	 connector_to_Commander
	 (
		-- от компонента test_display
		command_from_test_display,
		pause_after_command_from_test_display, 
		START_OUT_TEST_DISPLAY,
		
		-- от компонента Pisatel
		command_from_pisatel,
		pause_after_command_from_pisatel, 
		START_OUT_PISATEL,
		
		-- от компонента Symbol_Creator
		command_from_symbol_creator,
		pause_after_command_from_symbol_creator, 
		START_OUT_SYMBOL_CREATOR,
	 
		sel_to_Commander,
		
		-- ко входам компонента Commander
		command_to_commander,
		pause_after_command_to_commander,
		START_TO_COMMANDER
	 );


	 -- Подача выходных сигналов компонентов на входы LCD дисплея
	 LCD_E 	<= connector_to_LCD(to_display_from_test_display(1) , from_commander(1) , sel_to_LCD);
    LCD_RS 	<= connector_to_LCD(to_display_from_test_display(2) , from_commander(2) , sel_to_LCD);
    LCD_RW 	<= connector_to_LCD(to_display_from_test_display(3) , from_commander(3) , sel_to_LCD);
    LCD_DB7 <= connector_to_LCD(to_display_from_test_display(4) , from_commander(4) , sel_to_LCD);	 
    LCD_DB6 <= connector_to_LCD(to_display_from_test_display(5) , from_commander(5) , sel_to_LCD);
    LCD_DB5 <= connector_to_LCD(to_display_from_test_display(6) , from_commander(6) , sel_to_LCD);
    LCD_DB4 <= connector_to_LCD(to_display_from_test_display(7) , from_commander(7) , sel_to_LCD);
    LCD_DB3 <= '1';
    LCD_DB2 <= '1';
    LCD_DB1 <= '1';
    LCD_DB0 <= '1';

end Behavioral;

