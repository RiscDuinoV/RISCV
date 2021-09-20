library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity XtrMtime is
    port (
        ARst    : in    std_logic;
        Clk     : in    std_logic;
        SRst    : in    std_logic;
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        Irq     : out   std_logic
    );
end entity XtrMtime;

architecture rtl of XtrMtime is
    signal mtime    : std_logic_vector(63 downto 0);
    signal mtimecmp : std_logic_vector(63 downto 0);
begin
    
    pWriteMem : process (Clk, ARst)
    begin
        if ARst = '1' then
            mtimecmp <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                mtimecmp <= (others => '0');
            else
                if XtrCmd.Stb = '1' and XtrCmd.We = '1' then
                    case XtrCmd.Adr(3 downto 2) is
                        when "10" =>
                            mtimecmp(31 downto 0) <= XtrCmd.Dat;
                        when "11" =>
                            mtimecmp(63 downto 32) <= XtrCmd.Dat;
                        when others =>
                    end case;
                end if;
            end if;
        end if;
    end process pWriteMem;
    XtrRsp.CRDY <= XtrCmd.Stb;
    pMemRead: process(clk)
    begin
        if rising_edge(clk) then
            XtrRsp.RRDY <= XtrCmd.Stb;
            if XtrCmd.Stb = '1' then
                case XtrCmd.Adr(3 downto 2) is
                    when "00" =>
                        XtrRsp.Dat <= mtime(31 downto 0);
                    when "01" =>
                        XtrRsp.Dat <= mtime(63 downto 32);
                    when "10" =>
                        XtrRsp.Dat <= mtimecmp(31 downto 0);
                    when "11" =>
                        XtrRsp.Dat <= mtimecmp(63 downto 32);
                    when others =>
                end case;
            end if;
        end if;
    end process pMemRead;

    pMtime: process(Clk, ARst)
    begin
        if ARst = '1' then
            mtime <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                mtime <= (others => '0');
            else
                mtime <= std_logic_vector(unsigned(mtime) + "1");
            end if;
        end if;
    end process pMtime;
    
end architecture rtl;