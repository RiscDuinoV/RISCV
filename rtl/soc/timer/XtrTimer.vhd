library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity XtrTimer is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Irq     : out   std_logic
    );
end entity XtrTimer;

architecture rtl of XtrTimer is
    signal Compare  : std_logic_vector(31 downto 0);
    signal CntQ     : std_logic_vector(31 downto 0);
    signal IrqSel   : std_logic;
    signal LoadValue: std_logic_vector(31 downto 0);
    signal LoadEn   : std_logic;
    signal En       : std_logic;
    signal Ud       : std_logic;
    signal LE, GE   : std_logic;
begin
    
    process (Clk, ARst)
    begin
        if ARst = '1' then
            Compare <= (others => '1');
            En <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Compare <= (others => '1');
                En <= '0';
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    case unsigned(XtrCmd.Adr(3 downto 2)) is
                        when 0 =>
                            if XtrCmd.Sel(0) = '1' then
                                En <= XtrCmd.Dat(0);
                                Ud <= XtrCmd.Dat(1);
                            end if;
                            if XtrCmd.Sel(1) = '1' then
                                IrqSel <= XtrCmd.Dat(8);
                            end if;
                        when 1 =>
                            Compare <= XtrCmd.Dat;
                        when others =>
                    end case;
                end if;
            end if;
        end if;
    end process;
    LoadValue  <= XtrCmd.Dat;
    LoadEn     <= '1' when XtrCmd.Stb = '1' and XtrCmd.We = '1' and unsigned(XtrCmd.Adr(3 downto 2)) = 2 else '0';
    XtrCmd.Dat <= CntQ;
    XtrRsp.CRDY <= XtrCmd.Stb;
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
        end if;
    end process;

    uTimer : entity work.Timer
        generic map (
            N => 32)
        port map (
            ARst    => ARst,    Clk         => Clk,         SRst    => SRst,
            En      => En,      Ud          => Ud,          Compare => Compare, 
            LoadEn  => LoadEn,  LoadValue   => LoadValue,
            Q       => Q,       GE          => GE,          LT      => LT);

    Irq <= GE when IrqSel = '1' else LT;

end architecture rtl;