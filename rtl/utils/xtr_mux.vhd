library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity XtrMux is
    port 
    (
        ARst    : in    std_logic;
        Clk     : in    std_logic;
        SRst    : in    std_logic;
        vXtrCmd : in    vXtrCmd_t(0 to 1);
        vXtrRsp : out   vXtrRsp_t(0 to 1);
        XtrCmd  : out   XtrCmd_t;
        XtrRsp  : in    XtrRsp_t    
    );
end entity XtrMux;

architecture rtl of XtrMux is
    signal XtrBusy  : std_logic;
    signal XtrSelA  : std_logic;
    signal XtrSelB  : std_logic;
    signal dXtrSelA : std_logic;
    signal dXtrSelB : std_logic;
begin
    
    XtrCmd <= vXtrCmd(0) when XtrSelA = '1' else vXtrCmd(1);
    vXtrRsp(0).Dat  <= XtrRsp.Dat;
    vXtrRsp(0).CRDY <= XtrRsp.CRDY when XtrSelA  = '1' else '0';
    vXtrRsp(0).RRDY <= XtrRsp.RRDY when dXtrSelA = '1' else '0';

    vXtrRsp(1).Dat  <= XtrRsp.Dat;
    vXtrRsp(1).CRDY <= XtrRsp.CRDY when XtrSelB  = '1' else '0';
    vXtrRsp(1).RRDY <= XtrRsp.RRDY when dXtrSelB = '1' else '0';

    process (Clk)
    begin
        if rising_edge(Clk) then
            dXtrSelA <= XtrSelA;
            dXtrSelB <= XtrSelB;
        end if;
    end process;
    
--    process (Clk, ARst)
--    begin
--        if ARst = '1' then
--            XtrSelA <= '0';
--            XtrSelB <= '0';
--        elsif rising_edge(Clk) then
--            if SRst = '1' then
--                XtrSelA <= '0';
--                XtrSelB <= '0';
--            else
--                if vXtrCmd(0).Stb = '1' and XtrSelB = '0' then
--                    XtrSelA <= '1';
--                elsif XtrRsp.RRDY = '1' then
--                    XtrSelA <= '0';
--                end if;
--                if vXtrCmd(1).Stb = '1' and XtrSelA = '0' then
--                    XtrSelB <= '1';
--                elsif XtrRsp.RRDY = '1' then
--                    XtrSelB <= '0';
--                end if;
--            end if;
--        end if;
--    end process;

    XtrSelA <= vXtrCmd(0).Stb when XtrSelB = '0' else '0';
    XtrSelB <= vXtrCmd(1).Stb when XtrSelA = '0' else '0';

end architecture rtl;