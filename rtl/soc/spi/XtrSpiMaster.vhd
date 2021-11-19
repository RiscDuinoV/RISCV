library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;
use work.utils.all;

entity XtrSpiMaster is
    generic (
        C_FreqIn    : integer := 50e6;
        C_FreqOut   : integer := 100e3
    );
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Sck     : out   std_logic;
        Mosi    : out   std_logic;
        Miso    : in    std_logic;
        Ss      : out   std_logic
    );
end entity XtrSpiMaster;

architecture rtl of XtrSpiMaster is
    signal Freq             : std_logic_vector(15 downto 0);
    signal En               : std_logic;
    signal Trg              : std_logic;
    signal TxDat            : std_logic_vector(7 downto 0);
    signal TxBusy           : std_logic;
    signal RxVld            : std_logic;
    signal RxDat            : std_logic_vector(7 downto 0);
    signal Mode             : std_logic_vector(1 downto 0);
    signal Address          : std_logic_vector(0 downto 0);
begin
    XtrRsp.Dat <= x"000000" & RxDat when to_integer(unsigned(Address)) = 0 else 
                  x"0000000" & "000" & TxBusy;
    XtrRsp.CRDY <= '1';
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
            Address <= XtrCmd.Adr(2 downto 2);
        end if;
    end process;
    pWriteMem: process(Clk, ARst)
    begin
        if ARst = '1' then
            Freq <= freq2reg(C_FreqOut, C_FreqIn*2, 16);
            En <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Freq <= freq2reg(C_FreqOut, C_FreqIn*2, 16);
                En <= '0';
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    if XtrCmd.Adr(2) = '1' then
                        if XtrCmd.Sel(0) = '1' then
                            En <= XtrCmd.Dat(0);
                        end if;
                        if XtrCmd.Sel(1) = '1' then
                            Mode <= XtrCmd.Dat(9 downto 8);
                        end if;
                        if XtrCmd.Sel(2) = '1' then
                            Freq <= XtrCmd.Dat(31 downto 16);
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process pWriteMem;
    Trg <= '1' when XtrCmd.Stb = '1' and XtrCmd.We = '1' and XtrCmd.Adr(2) = '0' else '0';
    TxDat <= XtrCmd.Dat(7 downto 0);
    uSpiMaster : entity work.SpiMaster
        port map (
            ARst    => ARst,    Clk     => Clk,     SRst        => SRst,
            Freq    => Freq,    En      => En,      Mode        => Mode,
            Trg     => Trg,     TxDat   => TxDat,   BusyFlag    => TxBusy,
            RxDat   => RxDat,   RxVld   => open,
            Sck     => Sck,     Mosi    => Mosi,    Miso        => Miso,    Ss  => Ss);
end architecture rtl;