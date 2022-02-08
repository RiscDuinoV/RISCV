library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity spi_master is
    port (
        arst_i : in std_logic := '0';
        clk_i : in std_logic;
        srst_i : in std_logic := '0';
        freq_i : in std_logic_vector(15 downto 0);
        mode_i : in std_logic_vector(1 downto 0);
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
    signal sck_cnt : std_logic_vector(16 downto 0);
    signal bit_cnt : std_logic_vector(7 downto 0);
    signal d_bit_cnt : std_logic;
    signal sck, mosi, miso, ss : std_logic;
    signal sck_re, sck_fe : std_logic_vector(1 downto 0);
    signal rx_dat, tx_dat : std_logic_vector(7 downto 0);
    signal rx_vld, shift_en : std_logic;
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            miso <= miso_i;
        end if;
    end process;
    pGenFreq: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            sck <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                sck <= '0';
            else
                if current_st /= st_idle then
                    sck_cnt <= ('0' & sck_cnt(15 downto 0)) + ('0' & freq_i);
                else
                    sck_cnt <= '0' & freq_i;
                end if;
                if current_st = st_idle then
                    if mode_i(1) = '1' then
                        sck <= '1';
                    else
                        sck <= '0';
                    end if;
                elsif sck_cnt(16) = '1' then
                    sck <= not sck;
                end if;
            end if;
        end if;
    end process pGenFreq;
    sck_re(0) <= '1' when sck_cnt(16) = '1' and sck = '0' and current_st /= st_idle else '0';
    sck_fe(0) <= '1' when sck_cnt(16) = '1' and sck = '1' and current_st /= st_idle else '0';
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            sck_re(1) <= sck_re(0);
            sck_fe(1) <= sck_fe(0);
            d_bit_cnt <= bit_cnt(7);
        end if;
    end process;
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
                        if en_i = '1' then
                            if trg_i = '1' then
                                current_st <= st_data;
                            end if;
                        end if;
                    when st_data =>
                        if bit_cnt(7) = '1' and ((sck_fe(0) = '1' and mode_i(1) = '0') or (sck_re(0) = '1' and mode_i(1) = '1')) then
                            current_st <= st_idle;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    process (clk_i)
        variable vTxDat : std_logic_vector(7 downto 0);
    begin
        if rising_edge(clk_i) then
            if trg_i = '1' then
                tx_dat <= tx_dat_i;
            end if;
            if current_st = st_idle then
                bit_cnt <= x"01";
                ss <= en_i;
                shift_en <= '0';
            end if;
            if mode_i(1) = '0' then
                if sck_re(0) = '1' then
                    shift_en <= '1';
                end if;
            else
                if sck_fe(0) = '1' then
                    shift_en <= '1';
                end if;
            end if;
            if (mode_i(0) xor mode_i(1)) = '1' then
                if sck_re(0) = '1' and shift_en = '1' then
                    tx_dat <= tx_dat(6 downto 0) & '0';
                    bit_cnt <= bit_cnt(6 downto 0) & bit_cnt(7);
                end if;
                if sck_fe(1) = '1' then
                    rx_dat <= rx_dat(6 downto 0) & miso;
                    if d_bit_cnt = '1' then
                        rx_vld <= '1';
                    end if;
                else
                    rx_vld <= '0';
                end if;
            else
                if sck_re(1) = '1' then
                    rx_dat <= rx_dat(6 downto 0) & miso;
                    if d_bit_cnt = '1' then
                        rx_vld <= '1';
                    end if;
                else
                    rx_vld <= '0';
                end if;
                if sck_fe(0) = '1' and shift_en = '1' then
                    tx_dat <= tx_dat(6 downto 0) & '0';
                    bit_cnt <= bit_cnt(6 downto 0) & bit_cnt(7);
                end if;
            end if;
        end if;
    end process;
    mosi <= tx_dat(7);
    busy_o <= '1' when current_st = st_data else '0';
    sck_o  <= sck;
    mosi_o <= mosi;-- when current_st = st_data else '1';
    ss_o   <= ss;
    rx_dat_o <= rx_dat;
    rx_vld_o <= rx_vld;
end architecture rtl;
