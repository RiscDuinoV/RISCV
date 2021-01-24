library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.type_package.all;

entity Example is
    port 
    (
        Rst     :   in  std_logic;
        Clk     :   in  std_logic;
        Ce      :   in  std_logic;
        
        Bp      :   in  std_logic;

        Cmd     :   in  bus_cmd_t;
        Rsp     :   out bus_rsp_t;

        IRQ     :   out std_logic
    );
end entity Example;

architecture rtl of Example is
    signal SBp      :   std_logic_vector(1 downto 0);
    signal Bp_FE    :   std_logic;
    signal Reg      :   std_logic_vector(31 downto 0);
begin
    Rsp.RSP_ACK <= Cmd.STB;
    pRead: process(Clk)
    begin
        if rising_edge(Clk) then
            if Ce = '1' and Cmd.WE = '0' then
                Rsp.DAT <= Reg;
            end if;
            Rsp.CMD_ACK <= Cmd.STB;
        end if;
    end process pRead;
    pWrite: process(Clk, Rst)
    begin
        if Rst = '1' then
            Reg <= (others => '0');
            IRQ <= '0';
        elsif rising_edge(Clk) then
            if Ce = '1' and Cmd.WE = '1' then
                Reg <= Cmd.DAT;
            end if;
            if Bp_FE = '1' then
                IRQ <= '1';
            elsif Ce = '1' and Cmd.WE = '1' then
                IRQ <= '0';
            end if;
        end if;
    end process pWrite;
    pED: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                SBp <= (others => '0');
            else
                SBp(0) <= Bp;
                SBp(1) <= SBp(0);
            end if;
        end if;
    end process pED;
    Bp_FE <= not SBp(0) and SBp(1);
end architecture rtl;