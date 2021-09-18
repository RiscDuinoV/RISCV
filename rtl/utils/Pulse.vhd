library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pulse is
    generic (
        N       : integer := 16
    );
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        En      : in    std_logic := '1';
        Freq    : in    std_logic_vector(N - 1 downto 0);
        Cnt     : out   std_logic_vector(N downto 0);
        Q       : out   std_logic
    );
end entity Pulse;

architecture rtl of Pulse is
    signal r : std_logic_vector(N downto 0);
begin
    
    process (Clk, ARst)
    begin
        if ARst = '1' then
            r <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                r <= (others => '0');
            else
                if En = '1' then
                    r <= std_logic_vector(unsigned('0' & r(N - 1 downto 0)) + unsigned('0' & Freq));
                else
                    r <= '0' & r(N - 1 downto 0);
                end if;
            end if;
        end if;
    end process;
    Cnt <= r;
    Q   <= r(N);
end architecture rtl;