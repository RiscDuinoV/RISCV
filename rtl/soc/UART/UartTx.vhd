library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
entity UartTx is
    generic
    (
        C_WordWidth :   integer :=  8
    );
    port 
    (
        Rst         :   in  std_logic;
        Clk         :   in  std_logic;
        Baudrate    :   in  std_logic;
        Trig        :   in  std_logic;
        ByteTx      :   in  std_logic_vector(C_WordWidth - 1 downto 0);
        BusyTx      :   out std_logic := '0';
        Tx          :   out std_logic := '1'
    );
end entity UartTx;

architecture rtl of UartTx is
    constant CptByteLen         :   integer := integer(log2(ceil(real(C_WordWidth))));
    constant CptByteLoadValue   : std_logic_vector(CptByteLen - 1 downto 0) := std_logic_vector(to_unsigned(C_WordWidth, CptByteLen)) - 1;
    type UART_ST                is  (ST_IDLE, ST_SYNC_BR, ST_START, ST_DATA, ST_STOP);
    signal Present_ST           :   UART_ST := ST_IDLE;
    signal CptByte              :   std_logic_vector(CptByteLen - 1 downto 0) := CptByteLoadValue; 
    signal R_ByteTx             :   std_logic_vector(C_WordWidth - 1 downto 0);
begin
    
    pFSM: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                Present_ST <= ST_IDLE;
            else
                case Present_ST is
                    when ST_IDLE =>
                        if Trig = '1' then
                            Present_ST <= ST_SYNC_BR;
                        end if;
                    when ST_SYNC_BR =>
                        if Baudrate = '1' then
                            Present_ST <= ST_START;
                        end if; 
                    when ST_START =>
                        if Baudrate = '1' then
                            Present_ST <= ST_DATA;
                        end if;
                    when ST_DATA =>
                        if Baudrate = '1' and CptByte = 0 then
                            Present_ST <= ST_STOP;
                        end if;
                    when ST_STOP =>
                        if Baudrate = '1' then
                            Present_ST <= ST_IDLE;
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
                CptByte <= CptByteLoadValue;
                Tx <= '1';
            else
                case Present_ST is
                    when ST_IDLE =>
                        R_ByteTx <= ByteTx;
                    when ST_START =>
                        if Baudrate = '1' then
                            Tx <= '0';
                        end if;
                    when ST_DATA =>
                        if Baudrate = '1' then
                            CptByte <= CptByte - 1;
                            Tx <= R_ByteTx(0);
                            R_ByteTx <= '0' & R_ByteTx(C_WordWidth - 1 downto 1);
                        end if;
                    when ST_STOP =>
                        if Baudrate = '1' then
                            Tx <= '1';
                        end if;
                    when others =>
                        CptByte <= CptByteLoadValue;
                end case;
            end if;
        end if;
    end process pLogic;
    BusyTx <= '1' when Present_ST /= ST_IDLE else '0';
end architecture rtl;