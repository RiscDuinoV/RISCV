library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity Interrupt_Controller is
    port 
    (
        Rst         :   in  std_logic;
        Clk         :   in  std_logic;
        
        Intr_I      :   in  std_logic_vector(63 downto 0);

        CE_I        :   in  std_logic;
        Data_WE_I   :   in  std_logic;
        Data_SEL_I  :   in  std_logic_vector(3 downto 0);
        Data_ADR_I  :   in  std_logic_vector(1 downto 0);
        Data_DAT_I  :   in  std_logic_vector(31 downto 0);
        Data_DAT_O  :   out std_logic_vector(31 downto 0);

        Intr_O      :   out std_logic
    );
end entity Interrupt_Controller;

architecture rtl of Interrupt_Controller is
    signal Intr_Mask    :   std_logic_vector(63 downto 0) := (others => '0');
begin
    
    -- Bus Interface
    Data_DAT_O  <=  Intr_Mask(31 downto 0)  when Data_ADR_I = "00" else
                    Intr_Mask(63 downto 32) when Data_ADR_I = "01" else
                    Intr_I(31 downto 0)     when Data_ADR_I = "10" else
                    Intr_I(63 downto 32);
    pBusWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                Intr_Mask <= (others => '0');
            else
                if CE_I = '1' and Data_WE_I = '1'then
                    if Data_ADR_I = "00" then
                        Intr_Mask(31 downto 0) <= Data_DAT_I;
                    elsif Data_ADR_I = "01" then
                        Intr_Mask(63 downto 32) <= Data_DAT_I;
                    end if;
                end if;
            end if;
        end if;
    end process pBusWrite;
    -- End Bus Interface
    
    -- Logic
    Intr_O  <=  '1' when (Intr_I and Intr_Mask) /= 0 else '0';
    -- End Logic

end architecture rtl;