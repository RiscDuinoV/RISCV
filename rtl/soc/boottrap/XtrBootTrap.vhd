library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity XtrBootTrap is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Baud    : in    std_logic;
        RxVld   : in    std_logic;
        RxDat   : in    std_logic_vector(7 downto 0);
        Trap    : out   std_logic
    );
end entity XtrBootTrap;

architecture rtl of XtrBootTrap is
    signal RstFromCpu   : std_logic;
    signal TrapRst      : std_logic;
    signal TrapRom      : std_logic;
    signal TrapRam      : std_logic;
    signal TrapEvt      : std_logic;
    signal ProgramVect  : std_logic_vector(31 downto 2);
    signal RomFlag      : std_logic;
    signal RamFlag      : std_logic;
    signal dRomFlag     : std_logic;
    signal dRamFlag     : std_logic;
begin
    TrapRst <= '1' when TrapEvt = '1' and RxDat = x"30" else '0';
    TrapRom <= '1' when TrapEvt = '1' and RxDat = x"31" else '0';
    TrapRam <= '1' when TrapEvt = '1' and RxDat = x"32" else '0';
    Trap <= TrapRst or TrapRom or TrapRam or RstFromCpu;
    pWriteMem: process(Clk, ARst)
    begin
        if ARst = '1' then
            ProgramVect <= (others => '0');
            RomFlag     <= '0';
            RamFlag     <= '0';
            RstFromCpu  <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                ProgramVect <= (others => '0');
                RomFlag     <= '0';
                RamFlag     <= '0';
                RstFromCpu  <= '0';
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    ProgramVect <= XtrCmd.Dat(31 downto 2);
                    RstFromCpu  <= '1';
                else
                    RstFromCpu  <= '0';
                end if;
                if TrapRom = '1' then
                    RomFlag <= '1';
                elsif XtrCmd.Stb = '1' and XtrCmd.We = '0' then
                    RomFlag <= '0';
                end if;
                if TrapRam = '1' then
                    RamFlag <= '1';
                elsif XtrCmd.Stb = '1' and XtrCmd.We = '0' then
                    RamFlag <= '0';
                end if;
            end if;
        end if;
    end process pWriteMem;
    XtrRsp.CRDY <= XtrCmd.Stb;
    XtrRsp.Dat  <= ProgramVect & dRamFlag & dRomFlag;
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
            dRomFlag <= RomFlag;
            dRamFlag <= RamFlag;
        end if;
    end process;
    uBootTrap : entity work.BootTrap
        port map (
            ARst    => ARst, Clk    => Clk,     SRst    => SRst,
            Baud    => Baud, RxVld  => RxVld,   RxDat   => RxDat,
            Trap    => TrapEvt);

end architecture rtl;