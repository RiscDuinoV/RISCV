library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

library work;
use work.XtrDef.all;
use work.utils.all;

entity XtrAbr is
    generic
    (
        C_MMSB  : integer := 31;
        C_MLSB  : integer := 16;
        C_MASK  : std_logic_vector(XtrCmd_t.Adr'length - 1 downto 0) := (others => '0');
        C_Slave : integer := 4
    );
    port 
    (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        XtrCmd  : in    XtrCmd_t;
        XtrRsp  : out   XtrRsp_t;
        vXtrCmd : out   vXtrCmd_t(0 to C_Slave - 1);
        vXtrRsp : in    vXtrRsp_t(0 to C_Slave - 1)
    );
end entity XtrAbr;

architecture rtl of XtrAbr is
    constant C_SMSB         : integer := C_MLSB - 1;
    constant C_SLSB         : integer := C_MLSB - bitWidth(C_Slave);
    constant C_MASK_SLV     : std_logic_vector(XtrCmd.Adr'left downto 0) := C_MASK;
    signal LastXtrCmdAdr    : std_logic_vector(XtrCmd.Adr'left downto 0);
begin
    --assert False report "The value of 'C_SMSB' is " & integer'image(C_SMSB) & " and 'C_SLSB' is " & integer'image(C_SLSB) severity error;--integer'image(a);
    genCmd: for i in 0 to C_Slave - 1 generate
        vXtrCmd(i).Adr <= XtrCmd.Adr;
        vXtrCmd(i).Dat <= XtrCmd.Dat;
        vXtrCmd(i).We  <= XtrCmd.We;
        vXtrCmd(i).Stb <= XtrCmd.Stb when C_MMSB < C_MLSB and XtrCmd.Adr(C_SMSB downto C_SLSB) = i else
                          XtrCmd.Stb when XtrCmd.Adr(C_MMSB downto C_MLSB) = C_MASK_SLV(C_MMSB downto C_MLSB) and XtrCmd.Adr(C_SMSB downto C_SLSB) = i else 
                          '0';
        vXtrCmd(i).Sel <= XtrCmd.Sel;
    end generate genCmd;
    
    XtrRsp.CRDY <= vXtrRsp(to_integer(unsigned(XtrCmd.Adr(C_SMSB downto C_SLSB)))).CRDY when XtrCmd.Adr(C_SMSB downto C_SLSB) <= (C_Slave - 1) else '0';
    XtrRsp.RRDY <= vXtrRsp(to_integer(unsigned(LastXtrCmdAdr(C_SMSB downto C_SLSB)))).RRDY;  
    XtrRsp.Dat  <= vXtrRsp(to_integer(unsigned(LastXtrCmdAdr(C_SMSB downto C_SLSB)))).Dat;

    process (Clk, ARst)
    begin
        if ARst = '1' then
            LastXtrCmdAdr <= (others => '0');
        elsif rising_edge(Clk) then
            if SRst = '1' then
                LastXtrCmdAdr <= (others => '0');
            else
                if XtrCmd.Stb = '1' and XtrCmd.Adr(C_SMSB downto C_SLSB) <= (C_Slave - 1) then
                    LastXtrCmdAdr <= XtrCmd.Adr;
                end if;
            end if;
        end if;
    end process;
    
end architecture rtl;