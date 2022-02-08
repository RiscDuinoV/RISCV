library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;
use work.utils.all;

entity xtr_i2c is
    generic (
        C_FREQ_IN : integer := 50_000_000;
        C_FREQ_SCL : integer := 100_000
    );
    port (
        arst_i : in std_logic := '0';
        clk_i : in std_logic;
        srst_i : in std_logic := '0';
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        scl_io : out std_logic;
        sda_io : inout std_logic
    );
end entity xtr_i2c;

architecture rtl of xtr_i2c is
    signal en       : std_logic;
    signal trg      : std_logic;
    signal we       : std_logic;
    signal freq     : std_logic_vector(15 downto 0);
    signal wdat     : std_logic_vector(7 downto 0);
    signal rdat     : std_logic_vector(7 downto 0);
    signal ack_err   : std_logic;
    signal last     : std_logic;
    signal busy     : std_logic;
begin
    pWriteMem: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            freq <= freq2slv(C_FREQ_SCL*2, C_FREQ_IN, freq'length);
            en <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                freq <= freq2slv(C_FREQ_SCL*2, C_FREQ_IN, freq'length);
                en <= '0';
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' then
                    if xtr_cmd_i.Sel(1) = '1' then
                        en <= xtr_cmd_i.Dat(8);
                        last <= xtr_cmd_i.Dat(11);
                    end if;
                    if xtr_cmd_i.Sel(2) = '1' then
                        freq <= xtr_cmd_i.Dat(31 downto 16);
                    end if;
                end if;
            end if;
        end if;
    end process pWriteMem;
    xtr_rsp_o.dat <= x"0000" & "0000" & "00" & busy & ack_err & rdat;
    xtr_rsp_o.rdy <= '1';
    trg <= xtr_cmd_i.Dat(9) when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.Sel(1) = '1' else '0';
    we <= xtr_cmd_i.Dat(10) when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.Sel(1) = '1' else '0';
    wdat <= xtr_cmd_i.Dat(7 downto 0);
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            xtr_rsp_o.vld <= xtr_cmd_i.vld;
        end if;
    end process;
    uI2C : entity work.i2c_master
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            en_i => en, freq_i => freq,
            trg_i => trg, we_i => we, wdat_i => wdat,
            rdat_o => rdat, rvld_o => open, last_i => last,
            ack_err_o => ack_err,  busy_o => busy,
            scl_io => scl_io, sda_io => sda_io);
    
end architecture rtl;
