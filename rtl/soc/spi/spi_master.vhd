library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity spi_master is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        freq_i : in std_logic_vector(15 downto 0);
        mode_i : in std_logic_vector(1 downto 0);
        ss_pol_i : in std_logic;
        bit_order_i : in std_logic;
        en_i : in std_logic;
        trg_i : in std_logic;
        tx_dat_i : in std_logic_vector(7 downto 0);
        rx_dat_o : out std_logic_vector(7 downto 0);
        rx_vld_o : out std_logic;
        busy_o : out std_logic;
        sck_o : out std_logic;
        mosi_o : out std_logic;
        miso_i : in std_logic;
        ss_o : out std_logic
    );
end entity spi_master;

architecture rtl of spi_master is
    type spi_st is (st_idle, st_data);
    signal current_st : spi_st;
    signal sck_cnt : unsigned(freq_i'length downto 0);
    signal sck_re, sck_fe : std_logic;
    signal d1_sck_re, d1_sck_fe : std_logic;
    signal d2_sck_re, d2_sck_fe : std_logic;
    signal tx_dat, rx_dat : std_logic_vector(7 downto 0);
    signal bit_cnt, d_bit_cnt : std_logic_vector(7 downto 0);
    signal sck, mosi, miso, ss : std_logic;
    signal shift_en : std_logic;
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if current_st /= st_idle then
                sck_cnt <= ('0' & sck_cnt(sck_cnt'left - 1 downto 0)) + unsigned('0' & freq_i);
            else
                sck_cnt <= (others => '0');
            end if;
        end if;
    end process;

    sck_re <= '1' when sck = '0' and sck_cnt(sck_cnt'left) = '1' else '0';
    sck_fe <= '1' when sck = '1' and sck_cnt(sck_cnt'left) = '1' else '0';
    
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            current_st <= st_idle;
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                current_st <= st_idle;
            else
                case current_st is
                    when st_idle =>
                        if trg_i = '1' then
                            current_st <= st_data;
                        end if;
                    when st_data =>
                        if bit_cnt(bit_cnt'left) = '1' and sck_fe = '1' then
                            current_st <= st_idle;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                
            else
                rx_vld_o <= '0';
                if trg_i = '1' then
                    tx_dat <= tx_dat_i;
                end if;
                if current_st = st_data then
                    if sck_fe = '1' and mode_i(0) = '0' then
                        bit_cnt <= bit_cnt(bit_cnt'left - 1 downto 0) & '0';
                        tx_dat <= tx_dat(tx_dat'left - 1 downto 0) & '0';
                    end if;
                    if sck_re = '1' and mode_i(0) = '1' then
                        shift_en <= '1';
                        if shift_en = '1' then
                            bit_cnt <= bit_cnt(bit_cnt'left - 1 downto 0) & '0';
                            tx_dat <= tx_dat(tx_dat'left - 1 downto 0) & '0';
                        end if;
                    end if;

                else
                    bit_cnt <= std_logic_vector(to_unsigned(1, bit_cnt'length));
                    shift_en <= '0';
                end if;
                if trg_i = '1' then
                    tx_dat <= tx_dat_i;
                elsif sck_fe = '1' and mode_i(0) = '0' then
                    if bit_order_i = '1' then
                        tx_dat <= '0' & tx_dat(tx_dat'left downto 1);
                    else
                        tx_dat <= tx_dat(tx_dat'left - 1 downto 0) & '0';
                    end if;
                elsif sck_re = '1' and mode_i(0) = '1' and shift_en = '1' then
                    if bit_order_i = '1' then
                        tx_dat <= '0' & tx_dat(tx_dat'left downto 1);
                    else
                        tx_dat <= tx_dat(tx_dat'left - 1 downto 0) & '0';
                    end if;
                end if;
                if d2_sck_re = '1' and mode_i(0) = '0' then
                    if bit_order_i = '1' then
                        rx_dat <=  miso & rx_dat(rx_dat'left downto 1);
                    else
                        rx_dat <= rx_dat(rx_dat'left - 1 downto 0) & miso;
                    end if;
                    if d_bit_cnt(d_bit_cnt'left) = '1' then
                        rx_vld_o <= '1';
                    end if;
                end if;
                if d2_sck_fe = '1' and mode_i(0) = '1' then
                    if bit_order_i = '1' then
                        rx_dat <=  miso & rx_dat(rx_dat'left downto 1);
                    else
                        rx_dat <= rx_dat(rx_dat'left - 1 downto 0) & miso;
                    end if;
                    if d_bit_cnt(d_bit_cnt'left) = '1' then
                        rx_vld_o <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            sck <= '0';
            ss <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                sck <= '0';
                ss <= '0';
            else
                ss <= en_i xor ss_pol_i;
                if sck_cnt(sck_cnt'left) = '1' and current_st = st_data then
                    sck <= not sck;
                end if;
            end if;
        end if;
    end process;
    
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            miso <= miso_i;
            d1_sck_re <= sck_re;    
            d1_sck_fe <= sck_fe;
            d2_sck_re <= d1_sck_re;    
            d2_sck_fe <= d1_sck_fe;
            d_bit_cnt <= bit_cnt;
        end if;
    end process;

    rx_dat_o <= rx_dat;
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            ss_o <= '0';
            sck_o <= '0';
            mosi <= '0';
        elsif rising_edge(clk_i) then
            if bit_order_i = '1' then
                mosi <= tx_dat(0);
            else
                mosi <= tx_dat(tx_dat'left);
            end if;
            sck_o <= sck xor mode_i(1);
            ss_o <= ss;
        end if;
    end process;
    mosi_o <= mosi;

    busy_o <= '1' when current_st = st_data else '0';

end architecture rtl;
