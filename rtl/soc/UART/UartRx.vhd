library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
entity UartRx is
    generic
    (
        C_WordWidth :   integer :=  8
    );
    port 
    (
        Rst         :   in  std_logic;
        Clk         :   in  std_logic;
        BaudRate16  :   in  std_logic;
        BaudRate    :   in  std_logic_vector(3 downto 0);
        TrigRx      :   out std_logic := '0';
        ByteRx      :   out std_logic_vector(C_WordWidth - 1 downto 0) := (others => '0');
        Rx          :   in  std_logic
    );
end entity UartRx;

architecture rtl of UartRx is
    constant CptByteLen         :   integer := integer(log2(ceil(real(C_WordWidth))));
    constant CptByteLoadValue   : std_logic_vector(CptByteLen - 1 downto 0) := std_logic_vector(to_unsigned(C_WordWidth, CptByteLen)) - 1;
    type UART_ST                is  (ST_IDLE, ST_START, ST_DATA, ST_STOP);
    signal PresentST            :   UART_ST := ST_IDLE;
    signal S_Rx                 :   std_logic;
    signal BaudRate_Offset      :   std_logic_vector(3 downto 0);
    signal BaudRate_EQ          :   std_logic;
    signal CptByte              :   std_logic_vector(CptByteLen - 1 downto 0) := CptByteLoadValue;
    signal R_ByteRx             :   std_logic_vector(C_WordWidth - 1 downto 0) := (others => '0');
begin
    pSampleRx: process(Clk, Rst)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                S_Rx <= '1';
            else
                S_Rx <= Rx;
            end if;
        end if;
    end process pSampleRx;
    pFSM: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                PresentST <= ST_IDLE;
            else
                case PresentST is
                    when ST_IDLE =>
                        if S_Rx = '0' then
                            PresentST <= ST_START;
                        end if;
                    when ST_START =>
                        if BaudRate_EQ = '1' then
                            PresentST <= ST_DATA;
                        end if;
                    when ST_DATA =>
                        if BaudRate_EQ = '1' and CptByte = 0 then
                            PresentST <= ST_STOP;
                        end if;
                    when ST_STOP =>
                        if BaudRate_EQ = '1' then 
                            PresentST <= ST_IDLE;
                        end if;
                    when others =>
                end case; 
            end if;
        end if;
    end process pFSM;

    pLogic: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                R_ByteRx <= (others => '0');
                ByteRx <= (others => '0');
                TrigRx <= '0';
                CptByte <= CptByteLoadValue;
                BaudRate_Offset <= (others => '1');
            else
                case PresentST is
                    when ST_IDLE =>
                        BaudRate_Offset <= BaudRate + 8;
                        CptByte <= CptByteLoadValue;
                        TrigRx <= '0';
                    when ST_DATA =>
                        if BaudRate_EQ = '1' then
                            R_ByteRx <= S_Rx & R_ByteRx(C_WordWidth - 1 downto 1);
                            CptByte <= CptByte - 1;
                        end if;
                    when ST_STOP =>
                        if BaudRate_EQ = '1' then
                            TrigRx <= '1';
                            ByteRx <= R_ByteRx;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pLogic;
    pBaudrateTrig: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                BaudRate_EQ <= '0';
            else
                if (BaudRate - BaudRate_Offset) = 0 and BaudRate16 = '1' then
                    BaudRate_EQ <= '1';
                else 
                    BaudRate_EQ <= '0';
                end if;
            end if;
        end if;
    end process pBaudrateTrig;
end architecture rtl;