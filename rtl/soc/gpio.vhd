library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gpio is
    generic
    (
        PWM_Support :   boolean := false;
        IRQ_Support :   boolean := false
    );
    port 
    (
        Rst         :   in      std_logic;
        Clk         :   in      std_logic;
        Ce_I        :   in      std_logic;
        data_DAT_O  :   out     std_logic_vector(31 downto 0);
        data_DAT_I  :   in      std_logic_vector(31 downto 0);
        data_WE_I   :   in      std_logic;
        data_SEL_I  :   in      std_logic_vector(3 downto 0);
        Pin         :   inout   std_logic;
        Irq         :   out     std_logic := '0'
    );
end entity gpio;

architecture rtl of gpio is
    signal OutputMode   :   std_logic; 
    signal S_Pin        :   std_logic;
    signal D_S_Pin      :   std_logic;
    signal LatchedPin   :   std_logic;
    signal WriteValue   :   std_logic;
    signal RE_Status    :   std_logic;
    signal FE_Status    :   std_logic;
    signal RE_IRQ_en    :   std_logic;
    signal FE_IRQ_en    :   std_logic;
    signal PinRE        :   std_logic;
    signal PinFE        :   std_logic;
begin
    data_DAT_O(15 downto 0) <= "000000000000000" & S_Pin;
    data_DAT_O(17 downto 16) <= (others => '-');
    data_DAT_O(19 downto 18) <= FE_IRQ_en & RE_IRQ_en;
    data_DAT_O(31 downto 20) <= (others => '-');
    -- Bus interface
    pWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                WriteValue <= '0';
                OutputMode <= '0';
                RE_IRQ_en <= '0';
                FE_IRQ_en <= '0';
                RE_Status <= '0';
                FE_Status <= '0';
            else
                if Ce_I = '1' and data_WE_I = '1' then
                    if data_SEL_I(0) = '1' then
                        WriteValue <= data_DAT_I(0);    
                    end if;
                    if data_SEL_I(2) = '1' then
                        OutputMode <= data_DAT_I(16);
                        RE_IRQ_en <= data_DAT_I(18);
                        FE_IRQ_en <= data_DAT_I(19);
                    end if;
                end if;
                if IRQ_Support = true then
                    if Ce_I = '1' and data_WE_I = '0' and data_SEL_I(3) = '1' then
                        RE_Status <= '0';
                        FE_Status <= '0';
                    else
                        if RE_IRQ_en = '1' and PinRE = '1' then
                            RE_Status <= '1';
                        end if;
                        if FE_IRQ_en = '1' and PinFE = '1' then
                            FE_Status <= '1';
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process pWrite;
    PinRE <= not S_Pin and D_S_Pin;
    PinFE <= S_Pin and not D_S_Pin;
    -- Logic
    pLogic: process(Clk)
    begin
        if rising_edge(Clk) then
            S_Pin <= Pin;
            D_S_Pin <= S_Pin;
            Pin <= LatchedPin;
            if OutputMode = '1' then
                LatchedPin <= WriteValue;
            else
                LatchedPin <= 'Z';
            end if;
        end if;
    end process pLogic;
    Irq <= RE_Status or FE_Status;
end architecture rtl;