library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity soc is
    generic (
        C_Freq      : integer := 50_000_000;
        C_InitFile  : string  := "none"
    );
    port 
    (
        ARst    : in    std_logic;
        Clk     : in    std_logic;
        Tck     : in    std_logic := '0';
        Tdi     : in    std_logic := '0';
        Tdo     : out   std_logic;
        Tms     : in    std_logic := '0';
        Rx      : in    std_logic;
        Tx      : out   std_logic;
        Sck     : out   std_logic;
        Mosi    : out   std_logic;
        Miso    : in    std_logic;
        Ss      : out   std_logic
    );
end entity soc;

architecture rtl of soc is
    -- Infra
    signal CpuRst           : std_logic;
    -- Root of Xtr bus
    signal InstrXtrCmd      : XtrCmd_t;
    signal InstrXtrRsp      : XtrRsp_t;
    signal DatXtrCmd        : XtrCmd_t;
    signal DatXtrRsp        : XtrRsp_t;
    -- Layer
    signal vXtrCmdLyr1      : vXtrCmd_t(0 to 1);
    signal vXtrRspLyr1      : vXtrRsp_t(0 to 1);
    signal vXtrCmdLyr2      : vXtrCmd_t(0 to 1);
    signal vXtrRspLyr2      : vXtrRsp_t(0 to 1);
    signal vXtrCmdLyr3      : vXtrCmd_t(0 to 7);
    signal vXtrRspLyr3      : vXtrRsp_t(0 to 7);

    -- Bram
    signal BramInstrXtrCmd  : XtrCmd_t;
    signal BramInstrXtrRsp  : XtrRsp_t;
    signal BramDatXtrCmd    : XtrCmd_t;
    signal BramDatXtrRsp    : XtrRsp_t;

    -- UART
    signal vUartXtrCmd      : vXtrCmd_t(0 to 3);
    signal vUartXtrRsp      : vXtrRsp_t(0 to 3);
    
    -- Spi
    signal vSpiXtrCmd       : vXtrCmd_t(0 to 3);
    signal vSpiXtrRsp       : vXtrRsp_t(0 to 3);

begin
    process (Clk)
    begin
        if rising_edge(Clk) then
            CpuRst <= ARst;
        end if;
    end process;
    --CpuRst <= ARst;
    uCpu : entity work.VexRiscvWrapper
        port map (
            Clk         => Clk,         SRst        => CpuRst,
            Tck         => Tck,         Tdi         => Tdi,         Tdo         => Tdo, Tms => Tms,
            InstrXtrCmd => InstrXtrCmd, InstrXtrRsp => InstrXtrRsp,
            DatXtrCmd   => DatXtrCmd,   DatXtrRsp   => DatXtrRsp,
            ExternalIrq => '0',         TimerIrq    => '0',         SoftwareIrq => '0');

    uXtrAbrLyr1 : entity work.XtrAbr
        generic map (
            C_MMSB => 31, C_MLSB => 32, C_Slave => 2)
        port map (
            ARst    => ARst,        Clk     => Clk,         SRst => '0', 
            XtrCmd  => DatXtrCmd,   XtrRsp  => DatXtrRsp,
            vXtrCmd => vXtrCmdLyr1, vXtrRsp => vXtrRspLyr1);
    
    BramInstrXtrCmd <= InstrXtrCmd;
    InstrXtrRsp     <= BramInstrXtrRsp;
    BramDatXtrCmd   <= vXtrCmdLyr1(0);
    vXtrRspLyr1(0)  <= BramDatXtrRsp;

    uBram : entity work.BramWrapper
        port map (
            Clk         => Clk,
            InstrXtrCmd => BramInstrXtrCmd, InstrXtrRsp => BramInstrXtrRsp,
            DatXtrCmd   => BramDatXtrCmd,   DatXtrRsp   => BramDatXtrRsp);

-- Peripherials
    -- 8000 0000 0000 0000
    -- FFFF FFFF FFFF FFFF
    uXtrAbrLyr2 : entity work.XtrAbr
        generic map (
            C_MMSB => 31, C_MLSB => 31, C_MASK => x"80000000", C_Slave => 2)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr1(1),  XtrRsp  => vXtrRspLyr1(1),
            vXtrCmd => vXtrCmdLyr2,     vXtrRsp => vXtrRspLyr2);

    -- CXXX XXXX XXXX F000
    -- FXXX XXXX XXXX FFFF
    uXtrAbrLyr3 : entity work.XtrAbr
        generic map (
            C_MMSB => 11, C_MLSB => 12, C_MASK => x"FFFFF000", C_Slave  => 8)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr2(1),  XtrRsp  => vXtrRspLyr2(1),
            vXtrCmd => vXtrCmdLyr3,     vXtrRsp => vXtrRspLyr3);
    -- UART
    -- CXXX XXXX XXXX FB00
    -- CXXX XXXX XXXX FBFF
    uXtrAbrUart : entity work.XtrAbr
        generic map (
            C_MMSB => 9, C_MLSB => 8,  C_MASK => x"FFFFFB00", C_Slave  => 4)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr3(5),  XtrRsp  => vXtrRspLyr3(5),
            vXtrCmd => vUartXtrCmd,     vXtrRsp => vUartXtrRsp);
    uXtrUart : entity work.XtrUart
        generic map (
            C_Freq => C_Freq, C_Baud => 115_200)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0',
            XtrCmd  => vUartXtrCmd(0),  XtrRsp  => vUartXtrRsp(0),
            Rx      => Rx,              Tx      => Tx);
    -- SPI
    -- CXXX XXXX XXXX F100
    -- CXXX XXXX XXXX F1FF
    uXtrAbrSpi : entity work.XtrAbr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF100", C_Slave  => 4)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr3(1),  XtrRsp  => vXtrRspLyr3(1),
            vXtrCmd => vSpiXtrCmd,      vXtrRsp => vSpiXtrRsp);

    uXtrSpi : entity work.XtrSpiMaster
        generic map (
            C_FreqIn => C_Freq, C_FreqOut => 100e3)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0',
            XtrCmd  => vSpiXtrCmd(0),   XtrRsp  => vSpiXtrRsp(0),
            Sck     => Sck,             Mosi    => Mosi,            Miso => Miso,   Ss => Ss);
    
end architecture rtl;