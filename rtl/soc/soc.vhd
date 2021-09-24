library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity soc is
    generic (
        C_FREQ      : integer := 50_000_000;
        C_INIT_FILE : string  := "none"
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
        Ss      : out   std_logic;
        Scl     : out   std_logic;
        Sda     : inout std_logic
    );
end entity soc;

architecture rtl of soc is
    -- Infra
    signal SysRst           : std_logic;
    signal RstHold          : std_logic_vector(3 downto 0);
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
    -- I2C
    signal vI2cXtrCmd       : vXtrCmd_t(0 to 3);
    signal vI2cXtrRsp       : vXtrRsp_t(0 to 3);
    -- UART
    signal vUartXtrCmd      : vXtrCmd_t(0 to 3);
    signal vUartXtrRsp      : vXtrRsp_t(0 to 3);
    
    -- Spi
    signal vSpiXtrCmd       : vXtrCmd_t(0 to 3);
    signal vSpiXtrRsp       : vXtrRsp_t(0 to 3);
    -- Timers
    signal vTimerXtrCmd     : vXtrCmd_t(0 to 7);
    signal vTimerXtrRsp     : vXtrRsp_t(0 to 7);
    -- Boot trap
    signal BootTrapRstRqst  : std_logic;

begin
    -- Hold reset for at least 4 clock cycles
    process (Clk)
    begin
        if rising_edge(Clk) then
            if ARst = '1' or BootTrapRstRqst = '1' then
                RstHold <= (others => '1');
            elsif RstHold(3) = '1' then
                RstHold <= RstHold(2 downto 0) & '0';
            end if;
        end if;
    end process;
    SysRst <= RstHold(3);
    
    uCpu : entity work.VexRiscvWrapper
        port map (
            Clk         => Clk,         SRst        => SysRst,
            Tck         => Tck,         Tdi         => Tdi,         Tdo         => Tdo, Tms => Tms,
            InstrXtrCmd => InstrXtrCmd, InstrXtrRsp => InstrXtrRsp,
            DatXtrCmd   => DatXtrCmd,   DatXtrRsp   => DatXtrRsp,
            ExternalIrq => '0',         TimerIrq    => '0',         SoftwareIrq => '0');

    uXtrAbrLyr1 : entity work.XtrAbr
        generic map (
            C_MMSB => 31, C_MLSB => 32, C_Slave => 2)
        port map (
            ARst    => ARst,        Clk     => Clk,         SRst => SysRst, 
            XtrCmd  => DatXtrCmd,   XtrRsp  => DatXtrRsp,
            vXtrCmd => vXtrCmdLyr1, vXtrRsp => vXtrRspLyr1);
    
    BramInstrXtrCmd <= InstrXtrCmd;
    InstrXtrRsp     <= BramInstrXtrRsp;
    BramDatXtrCmd   <= vXtrCmdLyr1(0);
    vXtrRspLyr1(0)  <= BramDatXtrRsp;

    uBram : entity work.BramWrapper
        generic map (
            C_INIT_FILE => C_INIT_FILE
        )
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
    -- I2C
    -- CXXX XXXX XXXX F000
    -- FXXX XXXX XXXX F0FF
    uXtrAbrI2C : entity work.XtrAbr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF000", C_Slave  => 4)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr3(0),  XtrRsp  => vXtrRspLyr3(0),
            vXtrCmd => vI2cXtrCmd,      vXtrRsp => vI2cXtrRsp);
    uXtrI2C : entity work.XtrI2C
        generic map (
            C_FreqIn => C_FREQ, C_FreqOut => 200_000)
        port map (
            ARst    => ARst,    Clk => Clk, SRst    => SysRst,
            XtrCmd  => vI2cXtrCmd(0),       XtrRsp  => vI2cXtrRsp(0),
            Scl     => Scl,     Sda => Sda);
    -- UART
    -- CXXX XXXX XXXX FB00
    -- FXXX XXXX XXXX FBFF
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
            ARst    => ARst,            Clk     => Clk,             SRst => SysRst,
            XtrCmd  => vUartXtrCmd(0),  XtrRsp  => vUartXtrRsp(0),
            Rx      => Rx,              Tx      => Tx);
    -- SPI
    -- CXXX XXXX XXXX F200
    -- FXXX XXXX XXXX F2FF
    uXtrAbrSpi : entity work.XtrAbr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF200", C_Slave  => 4)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr3(1),  XtrRsp  => vXtrRspLyr3(1),
            vXtrCmd => vSpiXtrCmd,      vXtrRsp => vSpiXtrRsp);

    uXtrSpi : entity work.XtrSpiMaster
        generic map (
            C_FreqIn => C_Freq, C_FreqOut => 100e3)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => SysRst,
            XtrCmd  => vSpiXtrCmd(0),   XtrRsp  => vSpiXtrRsp(0),
            Sck     => Sck,             Mosi    => Mosi,            Miso => Miso,   Ss => Ss);
    -- Timers
    -- CXXX XXXX XXXX F400
    -- FXXX XXXX XXXX F5FF 
    uXtrAbrTimer : entity work.XtrAbr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF400", C_Slave  => 8)
        port map (
            ARst    => ARst,            Clk     => Clk,             SRst => '0', 
            XtrCmd  => vXtrCmdLyr3(2),  XtrRsp  => vXtrRspLyr3(2),
            vXtrCmd => vTimerXtrCmd,    vXtrRsp => vTimerXtrRsp);

    uMtime : entity work.XtrMtime
        port map (
            ARst    => ARst,    Clk => Clk, SRst    => SysRst,
            XtrCmd  => vTimerXtrCmd(0),     XtrRsp  => vTimerXtrRsp(0),
            Irq     => open);
    -- Boot trap
    -- CXXX XXXX XXXX FE00
    -- FXXX XXXX XXXX FFFF 
    XtrBootTrap_inst : entity work.XtrBootTrap
        port map (
            ARst    => ARst,                        Clk     => Clk,                     SRst    => '0',
            XtrCmd  => vXtrCmdLyr3(7),              XtrRsp  => vXtrRspLyr3(7),
            Baud    => vUartXtrRsp(0).Dat(11),      RxVld   => vUartXtrRsp(0).Dat(9),   RxDat   => vUartXtrRsp(0).Dat(7 downto 0),
            Trap    => BootTrapRstRqst);
          
end architecture rtl;