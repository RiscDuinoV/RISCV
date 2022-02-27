library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;
use work.utils.all;

entity xtr_spi_master is
    generic (
        C_FREQ_IN : integer := 50e6;
        C_FREQ_SCK : integer := 100e3
    );
    port (
        arst_i : in std_logic := '0';
        clk_i : in std_logic;
        srst_i : in std_logic := '0';
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        sck_o : out std_logic;
        mosi_o : out std_logic;
        miso_i : in std_logic;
        ss_o : out std_logic
    );
end entity xtr_spi_master;

architecture rtl of xtr_spi_master is
    signal address : std_logic_vector(0 downto 0);
    signal freq : std_logic_vector(15 downto 0);
    signal mode : std_logic_vector(1 downto 0);
    signal en, trg, busy, ss_pol, bit_order : std_logic;
    signal rx_dat, tx_dat : std_logic_vector(7 downto 0);
begin
    xtr_rsp_o.rdy <= '1';
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            xtr_rsp_o.vld <= xtr_cmd_i.vld;
            case to_integer(unsigned(xtr_cmd_i.adr(3 downto 2))) is
                when 0 =>
                    xtr_rsp_o.dat <= x"000000" & rx_dat;
                when 1 =>
                    xtr_rsp_o.dat <= x"00000"& bit_order & ss_pol & mode & x"0" & "000" & busy;
                when others =>
            end case;
        end if;
    end process;
    pWriteMem: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            freq <= freq2slv(C_FREQ_SCK*2, C_FREQ_IN, 16);
            en <= '0';
            ss_pol <= '1';
            bit_order <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                freq <= freq2slv(C_FREQ_SCK*2, C_FREQ_IN, 16);
                en <= '0';
                ss_pol <= '1';
                bit_order <= '0';
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.We = '1' then
                    case to_integer(unsigned(xtr_cmd_i.adr(3 downto 2))) is
                        when 1 =>
                            if xtr_cmd_i.sel(0) = '1' then
                                en <= xtr_cmd_i.dat(0);
                            end if;
                            if xtr_cmd_i.sel(1) = '1' then
                                mode <= xtr_cmd_i.dat(9 downto 8);
                                bit_order <= xtr_cmd_i.dat(11);
                            end if;
                            if xtr_cmd_i.sel(2) = '1' then
                                ss_pol <= xtr_cmd_i.dat(16);
                            end if;
                        when 2 =>
                            freq <= xtr_cmd_i.dat(31 downto 16);
                        when others =>
                    end case;
                end if;
            end if;
        end if;
    end process pWriteMem;
    trg <= '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.adr(3 downto 2) = "00" else '0';
    tx_dat <= xtr_cmd_i.dat(7 downto 0);
    u_spi_master : entity work.spi_master
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i, busy_o => busy,
            freq_i => freq, mode_i => mode, ss_pol_i => ss_pol, bit_order_i => bit_order,
            en_i => en, trg_i => trg, tx_dat_i => tx_dat, rx_dat_o => rx_dat, rx_vld_o => open,
            sck_o => sck_o, mosi_o => mosi_o, miso_i => miso_i, ss_o => ss_o);
end architecture rtl;
