library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package xtr_def is
    constant ADDRESS_WIDTH  : integer := 32;
    constant DATA_WIDTH     : integer := 32;

    type xtr_cmd_t is record
        adr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
        dat : std_logic_vector(DATA_WIDTH - 1 downto 0);
        vld : std_logic;
        we  : std_logic;
        sel : std_logic_vector(3 downto 0);
    end record xtr_cmd_t;

    type xtr_rsp_t is record
        dat : std_logic_vector(DATA_WIDTH - 1 downto 0);
        rdy: std_logic;
        vld: std_logic;
    end record xtr_rsp_t;

    type v_xtr_cmd_t is array (natural range <>) of xtr_cmd_t;
    type v_xtr_rsp_t is array (natural range <>) of xtr_rsp_t;
    
end package xtr_def;
