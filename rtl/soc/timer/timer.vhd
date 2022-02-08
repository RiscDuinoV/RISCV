library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Timer is
    generic (
        N       : integer := 32
    );
    port (
        ARst        : in    std_logic := '0';
        Clk         : in    std_logic;
        SRst        : in    std_logic := '0';
        En          : in    std_logic;
        LoadValue   : in    std_logic_vector(N - 1 downto 0);
        LoadEn      : in    std_logic;
        Compare     : in    std_logic_vector(N - 1 downto 0);
        Ud          : in    std_logic;
        Q           : out   std_logic_vector(N - 1 downto 0);
        GE          : out   std_logic;
        LT          : out   std_logic
    );
end entity Timer;

architecture rtl of Timer is
    signal Cnt  : std_logic_vector(N - 1 downto 0);
begin
    
    process (Clk, ARst)
    begin
        if ARst = '1' then
            Cnt <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Cnt <= (others => '0');
            else
                if LoadEn = '1' then
                    Cnt <= LoadValue;
                elsif En = '1' then
                    if Ud = '1' then
                        Cnt <= std_logic_vector(unsigned(cnt) + 1);
                    else
                        Cnt <= std_logic_vector(unsigned(cnt) - 1);
                    end if;
                end if;
            end if;
        end if;
    end process;
    Q <= Cnt;
    GE <= '1' when Cnt >= Compare else '0';
    LT <= '1' when Cnt < Compare else '0';
    
end architecture rtl;