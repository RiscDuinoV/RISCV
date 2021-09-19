library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BootTrap is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        Baud    : in    std_logic;
        RxVld   : in    std_logic;
        RxDat   : in    std_logic_vector(7 downto 0);
        Trap    : out   std_logic
    );
end entity BootTrap;

architecture rtl of BootTrap is
    constant C_CHAR_SEQ             : std_logic_vector(7 downto 0) := x"2B";
    constant TIMER_CNT_LOAD_VALUE   : integer := 16*8*3;
    type BOOTTRAP_ST                is (ST_IDLE, ST_TYPE);
    signal CurrentST                : BOOTTRAP_ST;
    signal WordCnt                  : std_logic_vector(2 downto 0);
    signal TimerCnt                 : std_logic_vector(8 downto 0);
    signal Timeout                  : std_logic;
    -- Debug
    signal iBaud                    : std_logic;
    signal iRxVld                   : std_logic;
    signal iRxDat                   : std_logic_vector(7 downto 0);
begin
    
    pFsm: process(Clk, ARst)
    begin
        if ARst = '1' then
            CurrentST <= ST_IDLE;
        elsif rising_edge(Clk) then
            if SRst = '1' then
                CurrentST <= ST_IDLE;
            else
                case CurrentST is
                    when ST_IDLE =>
                        if WordCnt(WordCnt'left) = '1' and RxVld = '1' and RxDat = C_CHAR_SEQ then
                            CurrentST <= ST_TYPE;
                        end if;
                    when ST_TYPE =>
                        if RxVld = '1' or Timeout = '1' then
                            CurrentST <= ST_IDLE;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pFsm;
    
    process (Clk, ARst)
    begin
        if ARst = '1' then
            TimerCnt <= std_logic_vector(to_unsigned(TIMER_CNT_LOAD_VALUE, TimerCnt'length)); -- 3 bytes before setting Timeout
            WordCnt  <= "001";
        elsif rising_edge(Clk) then
            if SRst = '1' then
                TimerCnt <= std_logic_vector(to_unsigned(TIMER_CNT_LOAD_VALUE, TimerCnt'length));
                WordCnt  <= "001";
            else
                if RxVld = '1' or Timeout = '1' then
                    TimerCnt <= std_logic_vector(to_unsigned(TIMER_CNT_LOAD_VALUE, TimerCnt'length));
                elsif Baud = '1' then
                    TimerCnt <= std_logic_vector(unsigned(TimerCnt) - "1");
                end if;
                if CurrentST = ST_IDLE then
                    if RxVld = '1' then
                        WordCnt <= WordCnt(1 downto 0) & WordCnt(2);
                    elsif Timeout = '1' then
                        WordCnt <= "001";
                    end if;
                end if;
            end if;
        end if;
    end process;
    Timeout <= '1' when unsigned(TimerCnt) = 0 and Baud = '1' else '0';
    Trap <= '1' when CurrentST = ST_TYPE and RxVld = '1' else '0';

    process (Clk)
    begin
        if rising_edge(Clk) then
            iBaud   <= Baud;
            iRxVld  <= RxVld;
            iRxDat  <= RxDat;
        end if;
    end process;
end architecture rtl;