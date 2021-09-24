library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;
use work.utils.all;

entity XtrI2C is
    generic (
        C_FreqIn    : integer := 50_000_000;
        C_FreqOut   : integer := 100_000
    );
    port (
        ARst        : in    std_logic := '0';
        Clk         : in    std_logic;
        SRst        : in    std_logic := '0';
        XtrCmd      : in    XtrCmd_t;
        XtrRsp      : out   XtrRsp_t;
        Scl         : out   std_logic;
        Sda         : inout std_logic
    );
end entity XtrI2C;

architecture rtl of XtrI2C is
    signal En       : std_logic;
    signal Trg      : std_logic;
    signal We       : std_logic;
    signal Freq     : std_logic_vector(15 downto 0);
    signal WDat     : std_logic_vector(7 downto 0);
    signal RDat     : std_logic_vector(7 downto 0);
    signal AckErr   : std_logic;
    signal Last     : std_logic;
    signal Busy     : std_logic;
begin
    pWriteMem: process(Clk, ARst)
    begin
        if ARst = '1' then
            Freq <= Freq2Reg(C_FreqOut, C_FreqIn, Freq'length);
            En <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Freq <= Freq2Reg(C_FreqOut, C_FreqIn, Freq'length);
                En <= '0';
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    if XtrCmd.Sel(1) = '1' then
                        En <= XtrCmd.Dat(8);
                        Last <= XtrCmd.Dat(11);
                    end if;
                    if XtrCmd.Sel(2) = '1' then
                        Freq <= XtrCmd.Dat(31 downto 16);
                    end if;
                end if;
            end if;
        end if;
    end process pWriteMem;
    XtrRsp.Dat <= x"0000" & "0000" & "00" & Busy & AckErr & RDat;
    XtrRsp.CRDY <= XtrCmd.Stb;
    Trg <= XtrCmd.Dat(9) when XtrCmd.Stb = '1' and XtrCmd.We = '1' and XtrCmd.Sel(1) = '1' else '0';
    We <= XtrCmd.Dat(10) when XtrCmd.Stb = '1' and XtrCmd.We = '1' and XtrCmd.Sel(1) = '1' else '0';
    WDat <= XtrCmd.Dat(7 downto 0);
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
        end if;
    end process;
    uI2C : entity work.i2c
        port map (
            ARst    => ARst,    Clk     => Clk,     SRst    => SRst,
            En      => En,      Freq    => Freq,
            Trg     => Trg,     We      => We,      WDat    => WDat,
            RDat    => RDat,    RVld    => open,    Last    => Last,
            AckErr  => AckErr,  Busy    => Busy,
            Scl     => Scl,     Sda     => Sda);
    
end architecture rtl;