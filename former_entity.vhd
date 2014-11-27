entity Former is
Port (
        SEQUENCE : in STD_LOGIC_VECTOR (1 to 16); -- Последовательность (пример: "0101010101010101")
        D : in STD_LOGIC_VECTOR (1 to 10); -- Выходы триггеров (пример: "0101------")
        FREQ : in STD_LOGIC_VECTOR (15 downto 0); -- Частота 10^(-1) Гц (пример: "0000000010000010", частота 13,0Гц )
        MANUAL_MODE : in STD_LOGIC; -- Ручной режим - 1, авто - 0
        PAUSE : in STD_LOGIC; -- Пауза - 1.
        CLK : in STD_LOGIC; -- Тактовый сигнал с делителя
        
        ARRAY_STRING1 : out array_of_16_bytes_type; -- Первая строка (Байты символов с 1 по 16)
        ARRAY_STRING2 : out array_of_16_bytes_type -- Вторая строка (Байты символов с 1 по 16)
        -- Адреса CGRAM "00000000" и "00000001" для символа синхроимпульса, нижний и высокий уровни соответственно
        -- Адрес  CGRAM "00000010" для символа "Hz"
        -- Адрес  CGRAM "00000010" для символа "Кнопка"
     );
end Former;
