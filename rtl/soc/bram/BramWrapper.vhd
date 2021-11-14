library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity BramWrapper is
    generic (
        C_INIT_FILE : string := "none"
    );
    port (
        Clk         : in    std_logic;
        InstrXtrCmd : in    XtrCmd_t;
        InstrXtrRsp : out   XtrRsp_t;
        DatXtrCmd   : in    XtrCmd_t;
        DatXtrRsp   : out   XtrRsp_t
    );
end entity BramWrapper;

architecture rtl of BramWrapper is
    signal DatStb       : std_logic;
    signal DebugAddr    : std_logic_vector(31 downto 0);
    signal DebugRDat    : std_logic_vector(31 downto 0);

    -- Mux
    signal vXtrCmd  : vXtrCmd_t(0 to 1);
    signal vXtrRsp  : vXtrRsp_t(0 to 1);
    signal XtrCmd   : XtrCmd_t;
    signal XtrRsp   : XtrRsp_t;

    signal DebugAdr : std_logic_vector(12 downto 0);
    signal DebugWe  : std_logic;
    signal DebugSel : std_logic_vector(3 downto 0);

    signal We       : std_logic_vector(3 downto 0);
begin
    uBram : entity work.ram_1x2
        generic map (
            C_RAM_SIZE      => 8192,
            C_ADDR_WIDTH    => 13,
            C_BYTE_WIDTH    => 8,
            C_NB_BYTE       => 4,
            C_INIT_FILE     => C_INIT_FILE)
        port map (
            Clk     => Clk,
            En      => '1',
            We      => We,
            Addr    => DatXtrCmd.Adr(14 downto 2),
            Di      => DatXtrCmd.Dat,
            AddrA   => InstrXtrCmd.Adr(14 downto 2),
            DoA     => InstrXtrRsp.Dat,
            AddrB   => DatXtrCmd.Adr(14 downto 2),
            DoB     => DatXtrRsp.Dat);
    genWe: for i in 0 to 3 generate
        We(i) <= DatXtrCmd.Sel(i) and DatXtrCmd.We and DatXtrCmd.Stb;
    end generate genWe;
    InstrXtrRsp.CRDY <= InstrXtrCmd.Stb;
    DatXtrRsp.CRDY   <= DatXtrCmd.Stb;
    process (Clk)
    begin
        if rising_edge(Clk) then
            InstrXtrRsp.RRDY <= InstrXtrCmd.Stb;
            DatXtrRsp.RRDY   <= DatXtrCmd.Stb;
        end if;
    end process;
end architecture rtl;