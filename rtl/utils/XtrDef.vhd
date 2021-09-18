library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package XtrDef is
    constant ADDRESS_WIDTH  : integer := 32;
    constant DATA_WIDTH     : integer := 32;

    type XtrCmd_t is record
        Adr : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
        Dat : std_logic_vector(DATA_WIDTH - 1 downto 0);
        Stb : std_logic;
        We  : std_logic;
        Sel : std_logic_vector(3 downto 0);
    end record XtrCmd_t;

    type XtrRsp_t is record
        Dat : std_logic_vector(DATA_WIDTH - 1 downto 0);
        CRdy: std_logic;
        RRdy: std_logic;
    end record XtrRsp_t;

    type vXtrCmd_t is array (natural range <>) of XtrCmd_t;
    type vXtrRsp_t is array (natural range <>) of XtrRsp_t;
    
end package XtrDef;