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
    signal en, trg, busy : std_logic;
    signal rx_dat, tx_dat : std_logic_vector(7 downto 0);
begin
    xtr_rsp_o.dat <= 
        x"000000" & rx_dat when to_integer(unsigned(address)) = 0 else 
        x"0000000" & "000" & busy;
    xtr_rsp_o.rdy <= '1';
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            xtr_rsp_o.vld <= xtr_cmd_i.vld;
            address <= xtr_cmd_i.Adr(2 downto 2);
        end if;
    end process;
    pWriteMem: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            freq <= freq2slv(C_FREQ_SCK*2, C_FREQ_IN, 16);
            en <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                freq <= freq2slv(C_FREQ_SCK*2, C_FREQ_IN, 16);
                en <= '0';
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.We = '1' then
                    if xtr_cmd_i.Adr(2) = '1' then
                        if xtr_cmd_i.sel(0) = '1' then
                            en <= xtr_cmd_i.Dat(0);
                        end if;
                        if xtr_cmd_i.sel(1) = '1' then
                            mode <= xtr_cmd_i.Dat(9 downto 8);
                        end if;
                        if xtr_cmd_i.sel(2) = '1' then
                            freq <= xtr_cmd_i.Dat(31 downto 16);
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process pWriteMem;
    trg <= '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.adr(2) = '0' else '0';
    tx_dat <= xtr_cmd_i.dat(7 downto 0);
    u_spi_master : entity work.spi_master
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            freq_i => freq, en_i => en, mode_i => mode,
            trg_i => trg, tx_dat_i => tx_dat, busy_o => busy,
            rx_dat_o => rx_dat, rx_vld_o => open,
            sck_o => sck_o, mosi_o => mosi_o, miso_i => miso_i, ss_o  => ss_o);
end architecture rtl;
