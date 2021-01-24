library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity timer is
    generic
    (
        N               :   integer :=  32
    );
    port 
    (
        Rst             :   in  std_logic;
        Clk             :   in  std_logic;
        SLoad_I         :   in  std_logic;
        Load_I          :   in  std_logic_vector(N - 1 downto 0);
        CmpVal_I        :   in  std_logic_vector(N - 1 downto 0);
        UpDown_I        :   in  std_logic;
        En_I            :   in  std_logic;
        Overflow_O      :   out std_logic;
        CmpOverflow_O   :   out std_logic;
        EqZero_O        :   out std_logic;
        Cpt_O           :   out std_logic_vector(N - 1 downto 0)
    );
end entity timer;

architecture rtl of timer is
    constant MAX_VALUE      :   std_logic_vector(N - 1 downto 0) := (others => '1');
    signal R_Cpt            :   std_logic_vector(N - 1 downto 0) := (others => '0');
begin
    
    pCpt: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                R_Cpt <= (others => '0');
            else
                if SLoad_I = '1' then
                    R_Cpt <= Load_I;
                elsif En_I = '1' then
                    if UpDown_I = '1' then
                        R_Cpt <= R_Cpt - 1;
                    else
                        R_Cpt <= R_Cpt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process pCpt;

    pOutputs: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                Overflow_O <= '0';
                CmpOverflow_O <= '0';
                EqZero_O <= '0';
            else
                if R_Cpt >= CmpVal_I then
                    CmpOverflow_O <= '1';
                else
                    CmpOverflow_O <= '0';
                end if;
                if R_Cpt = MAX_VALUE then
                    Overflow_O <= '1';
                else
                    Overflow_O <= '0';
                end if;
                if R_Cpt = 0 then
                    EqZero_O <= '1';
                else
                    EqZero_O <= '0';
                end if;
            end if;
        end if;
    end process pOutputs;
    Cpt_O <= R_Cpt;
end architecture rtl;