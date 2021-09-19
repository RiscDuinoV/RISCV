library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;
use work.utils.all;

entity Uart is
    generic
    (
        C_Freq      : integer := 50_000_000;
        C_Baud      : integer := 115_200
    );
    port 
    (
        ARst        : in    std_logic := '0';
        Clk         : in    std_logic;
        SRst        : in    std_logic := '0';
        En          : in    std_logic;
        TxVld       : in    std_logic;
        TxDat       : in    std_logic_vector(7 downto 0);
        TxBusy      : out   std_logic;
        RxVld       : out   std_logic;
        RxDat       : out   std_logic_vector(7 downto 0);
        Baud        : out   std_logic;
        Rx          : in    std_logic;
        Tx          : out   std_logic
    );
end entity Uart;

architecture rtl of Uart is
    signal Baud16 : std_logic;
begin
    
    uBaud : entity work.Pulse
        generic map (N => 16)
        port map (
            ARst    => ARst,    Clk     => Clk, SRst   => SRst, 
            En      => En,      Freq    => freq2reg(C_Baud * 16, C_Freq, 16),
            Cnt     => open,    Q       => Baud16);
    
    uUartTx : entity work.UartTx
        port map (
            ARst    => ARst,    Clk     => Clk,     SRst        => SRst,
            En      => En,      Baud16  => Baud16,
            TxEn    => TxVld,   TxDat   => TxDat,   BusyFlag    => TxBusy,
            Tx      => Tx);
    uUartRx : entity work.UartRx
        port map (
            ARst    => ARst,    Clk     => Clk,     SRst    => SRst,
            En      => En,      Baud16  => Baud16,
            RxEn    => RxVld,   RxDat   => RxDat,
            Rx      => Rx);
    Baud <= Baud16;
end architecture rtl;