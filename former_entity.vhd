entity Former is
Port (
        SEQUENCE : in STD_LOGIC_VECTOR (1 to 16); -- Последовательность
        D : in STD_LOGIC_VECTOR (1 to 9); -- Выходы триггеров
        FREQ : in STD_LOGIC_VECTOR (15 downto 0); -- Частота 10^(-2) Гц
        MANUAL_MODE : in STD_LOGIC; -- Ручной режим - 1, авто - 0
        PAUSE : in STD_LOGIC; -- Пауза - 1.
        CLK : in STD_LOGIC; -- Тактовый сигнал с делителя
        
        ARRAY_STRING1 : out array_of_16_bytes_type; -- Первая строка
        ARRAY_STRING2 : out array_of_16_bytes_type -- Вторая строка
     );
end Former;
