library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;

entity xtr_interrupt_controller is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        src_i : in std_logic_vector(63 downto 0);
        irq_o : out std_logic
    );
end entity xtr_interrupt_controller;

architecture rtl of xtr_interrupt_controller is
    type interrupt_st is (st_idle, st_on_interrupt);
    signal current_st : interrupt_st;
    signal interrupt_src, interrupt_mask : std_logic_vector(63 downto 0);
    signal done : std_logic;
begin
    
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            current_st <= st_idle;
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                current_st <= st_idle;
            else
                case current_st is
                    when st_idle =>
                        if unsigned(src_i and interrupt_mask) > 0 then
                            current_st <= st_on_interrupt;
                        end if;
                    when st_on_interrupt =>
                        if done = '1' then
                            current_st <= st_idle;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if current_st = st_idle then
                interrupt_src <= src_i;
            end if;
        end if;
    end process;
    irq_o <= '1' when current_st = st_on_interrupt else '0';

    done <= 
        '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and unsigned(xtr_cmd_i.adr(3 downto 2)) = 0 else 
        '0';
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            interrupt_mask <= (others => '0');
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                interrupt_mask <= (others => '0');
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' then
                    case to_integer(unsigned(xtr_cmd_i.adr(3 downto 2))) is
                        when 2 =>
                            interrupt_mask(31 downto 0) <= xtr_cmd_i.dat;
                        when 3 =>
                            interrupt_mask(63 downto 32) <= xtr_cmd_i.dat;
                        when others =>
                    end case;
                end if;
            end if;
        end if;
    end process;
    xtr_rsp_o.rdy <= '1';

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            xtr_rsp_o.vld <= '0';
        elsif rising_edge(clk_i) then
            xtr_rsp_o.vld <= xtr_cmd_i.vld and (not xtr_cmd_i.we);
        end if;
    end process;
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '0' then
                case to_integer(unsigned(xtr_cmd_i.adr(3 downto 2))) is
                    when 0 =>
                        xtr_rsp_o.dat <= interrupt_src(31 downto 0);
                    when 1 =>
                        xtr_rsp_o.dat <= interrupt_src(63 downto 32);
                    when 2 =>
                        xtr_rsp_o.dat <= interrupt_mask(31 downto 0);
                    when 3 =>
                        xtr_rsp_o.dat <= interrupt_mask(63 downto 32);
                    when others =>
                end case;
            end if;
        end if;
    end process;
--    xtr_rsp_o.dat <= 
--        interrupt_src(31 downto 0) when unsigned(xtr_cmd_i.adr(3 downto 2)) = 0 else
--        interrupt_src(63 downto 32) when unsigned(xtr_cmd_i.adr(3 downto 2)) = 1 else
--        interrupt_mask(31 downto 0) when unsigned(xtr_cmd_i.adr(3 downto 2)) = 2 else
--        interrupt_mask(63 downto 32);
    
        
end architecture rtl;