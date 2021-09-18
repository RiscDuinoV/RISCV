library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity XtrUart is
    generic (
        C_Freq  : integer := 50_000_000;
        C_Baud  : integer := 115_200
    );
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Rx      : in    std_logic;
        Tx      : out   std_logic
    );
end entity XtrUart;

architecture rtl of XtrUart is
    signal TxVld        : std_logic;
    signal TxDat        : std_logic_vector(7 downto 0);
    signal TxBusy       : std_logic;
    signal RxVld        : std_logic;
    signal RxDat        : std_logic_vector(7 downto 0);
    signal RxAvailable  : std_logic;
    signal RxDatVld     : std_logic_vector(7 downto 0);
begin
    XtrRsp.Dat <= x"00000" & '0' & TxBusy & '0' & RxAvailable & RxDatVld;
    XtrRsp.CRdy <= XtrCmd.Stb;
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRdy <= XtrCmd.Stb;
        end if;
    end process;
    process (Clk, ARst)
    begin
        if ARst = '1' then
            RxAvailable <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                RxAvailable <= '0';
            else
                if RxVld = '1' then
                    RxAvailable <= '1';
                    RxDatVld    <= RxDat;
                elsif XtrCmd.Stb = '1' and XtrCmd.We = '0' and XtrCmd.Sel(0) = '1' then
                    RxAvailable <= '0';
                end if;
            end if;
        end if;
    end process;
    TxVld <= '1' when XtrCmd.Stb = '1' and XtrCmd.We = '1' and XtrCmd.Sel(0) = '1' else '0';
    TxDat <= XtrCmd.Dat(7 downto 0);
    
    uUart : entity work.Uart
        generic map (
            C_Freq => C_Freq, C_Baud => C_Baud)
        port map (
            ARst    => ARst,    Clk     => Clk,     SRst    => SRst,
            En      => '1',
            TxVld   => TxVld,   TxDat   => TxDat,   TxBusy  => TxBusy,
            RxVld   => RxVld,   RxDat   => RxDat,
            Rx      => Rx,      Tx      => Tx);
    
end architecture rtl;