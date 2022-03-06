library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils.all;

entity fifo is
    generic (
        C_DEPTH : integer := 1024;
        C_WIDTH : integer := 32
    );
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        we_i : in std_logic;
        wdat_i : in std_logic_vector(C_WIDTH - 1 downto 0);
        re_i : in std_logic;
        rdat_o : out std_logic_vector(C_WIDTH - 1 downto 0);
        empty_o : out std_logic;
        full_o : out std_logic
    );
end entity fifo;

architecture rtl of fifo is
    type fifo_t is array (natural range <>) of std_logic_vector(C_WIDTH - 1 downto 0);
    signal arr : fifo_t(0 to C_DEPTH - 1);
    signal wptr, rptr, count : unsigned(bit_width(C_DEPTH) - 1 downto 0);
    signal empty, full : std_logic;
begin

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            wptr <= (others => '0');
            rptr <= (others => '0');
            count <= (others => '0');
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                wptr <= (others => '0');
                rptr <= (others => '0');
                count <= (others => '0');
            else
                if we_i = '1' and full = '0' then
                    wptr <= wptr + 1;
                    if wptr >= C_DEPTH then
                        wptr <= (others => '0');
                    end if;
                end if;
                if re_i = '1' and empty = '0' then
                    rptr <= rptr + 1;
                    if rptr >= C_DEPTH then
                        rptr <= (others => '0');
                    end if;
                end if;
                if we_i = '1' and re_i = '0' and full = '0' then
                    count <= count + 1;
                elsif we_i = '0' and re_i = '1' and empty = '0' then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if we_i = '1' and full = '0' then
                arr(to_integer(wptr)) <= wdat_i;
            end if;
            if re_i = '1' and empty = '0' then
                rdat_o <= arr(to_integer(rptr));
            end if;
        end if;
    end process;
    full <= '1' when count >= C_DEPTH else '0';
    empty <= '1' when count = 0 else '0';

    full_o <= full;
    empty_o <= empty;
    
    
end architecture rtl;
