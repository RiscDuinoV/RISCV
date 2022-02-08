library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

use work.xtr_def.all;

entity xtr_ram is
    generic (
        C_RAM_SIZE : integer := 8192;
        C_INIT_FILE : string := "none"
    );
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        instr_xtr_cmd_i : in xtr_cmd_t;
        instr_xtr_rsp_o : out xtr_rsp_t;
        dat_xtr_cmd_i : in xtr_cmd_t;
        dat_xtr_rsp_o : out xtr_rsp_t
    );
end entity xtr_ram;

architecture rtl of xtr_ram is
    constant C_ADDR_WIDTH : integer := integer(log2(real(C_RAM_SIZE / 4)));
    signal we : std_logic_vector(3 downto 0);
begin
    we(0) <= dat_xtr_cmd_i.sel(0) and dat_xtr_cmd_i.we and dat_xtr_cmd_i.vld;
    we(1) <= dat_xtr_cmd_i.sel(1) and dat_xtr_cmd_i.we and dat_xtr_cmd_i.vld;
    we(2) <= dat_xtr_cmd_i.sel(2) and dat_xtr_cmd_i.we and dat_xtr_cmd_i.vld;
    we(3) <= dat_xtr_cmd_i.sel(3) and dat_xtr_cmd_i.we and dat_xtr_cmd_i.vld;
    
    u_bram : entity work.ram_1x2
        generic map (
            C_RAM_SIZE => C_RAM_SIZE / 4, C_ADDR_WIDTH => C_ADDR_WIDTH, C_BYTE_WIDTH => 8, C_NB_BYTE => 4, C_INIT_FILE => C_INIT_FILE)
        port map (
            clk_i => clk_i,
            addr_i => dat_xtr_cmd_i.adr(C_ADDR_WIDTH + 1 downto 2), we_i => we, dat_i => dat_xtr_cmd_i.dat,
            addr_a_i => instr_xtr_cmd_i.adr(C_ADDR_WIDTH + 1 downto 2), dat_a_o => instr_xtr_rsp_o.dat,
            addr_b_i => dat_xtr_cmd_i.adr(C_ADDR_WIDTH + 1 downto 2), dat_b_o => dat_xtr_rsp_o.dat);
          
    instr_xtr_rsp_o.rdy <= '1';
    dat_xtr_rsp_o.rdy <= '1';

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            instr_xtr_rsp_o.vld <= '0';
            dat_xtr_rsp_o.vld <= '0';
        elsif rising_edge(clk_i) then
            instr_xtr_rsp_o.vld <= instr_xtr_cmd_i.vld;
            dat_xtr_rsp_o.vld <= dat_xtr_cmd_i.vld;
        end if;
    end process;
    
end architecture rtl;
