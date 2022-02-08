library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;

entity xtr_gpio is
    port (
        arst_i : in std_logic := '0';
        clk_i : in std_logic;
        srst_i : in std_logic := '0';
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        gpio_io : inout std_logic
    );
end entity xtr_gpio;

architecture rtl of xtr_gpio is
    signal pin_i, pin_o : std_logic;
    signal pin_mode     : std_logic_vector(0 downto 0);
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            pin_i <= gpio_io;
            if pin_mode = "1" then
                gpio_io <= pin_o;
            else
                gpio_io <= 'Z';
            end if;
        end if;
    end process;
    pXtrWrite: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            pin_mode <= "0";
            pin_o <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                pin_mode <= "0";
                pin_o <= '0';
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' then
                    case to_integer(unsigned(xtr_cmd_i.Adr(2 downto 2))) is
                        when 0 =>
                            pin_o <= xtr_cmd_i.Dat(0);
                        when 1 => 
                            pin_mode <= xtr_cmd_i.Dat(0 downto 0);
                        when others =>
                    end case;
                end if;        
            end if;
        end if;
    end process pXtrWrite;
    
    xtr_rsp_o.dat <= x"0000000" & "000" & pin_i;
    xtr_rsp_o.rdy <= '1';
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            xtr_rsp_o.vld <= xtr_cmd_i.vld;
        end if;
    end process;
    
end architecture rtl;
