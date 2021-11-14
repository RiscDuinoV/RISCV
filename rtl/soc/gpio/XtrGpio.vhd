library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.XtrDef.all;

entity XtrGpio is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Gpio    : inout std_logic
    );
end entity XtrGpio;

architecture rtl of XtrGpio is
    signal pin_i, pin_o : std_logic;
    signal pin_mode     : std_logic_vector(0 downto 0);
begin
    process (Clk)
    begin
        if rising_edge(Clk) then
            pin_i <= Gpio;
            if pin_mode = "1" then
                Gpio <= pin_o;
            else
                Gpio <= 'Z';
            end if;
        end if;
    end process;
    pXtrWrite: process(Clk, ARst)
    begin
        if ARst = '1' then
            pin_mode <= "0";
            pin_o <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                pin_mode <= "0";
                pin_o <= '0';
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    case to_integer(unsigned(XtrCmd.Adr(2 downto 2))) is
                        when 0 =>
                            pin_o <= XtrCmd.Dat(0);
                        when 1 => 
                            pin_mode <= XtrCmd.Dat(0 downto 0);
                        when others =>
                    end case;
                end if;        
            end if;
        end if;
    end process pXtrWrite;
    
    XtrRsp.Dat <= x"0000000" & "000" & pin_i;
    XtrRsp.CRDY <= '1';
    process (Clk)
    begin
        if rising_edge(Clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
        end if;
    end process;


    
end architecture rtl;