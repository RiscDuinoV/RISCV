library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mtime is
    port 
    (
        Rst             :   in  std_logic;
        Clk             :   in  std_logic;

        CE_I            :   in  std_logic;
        Data_WE_I       :   in  std_logic;
        Data_ADR_I      :   in  std_logic_vector(1 downto 0);
        data_SEL_I      :   in  std_logic_vector(3 downto 0);
        data_DAT_I      :   in  std_logic_vector(31 downto 0);
        data_DAT_O      :   out std_logic_vector(31 downto 0);
        MTIMECMP_INTR   :   out std_logic
    );
end entity mtime;


architecture rtl of mtime is
    constant N              :   integer :=  64;
    signal R_Cpt            :   std_logic_vector(N - 1 downto 0);
    signal R_CmpVal         :   std_logic_vector(N - 1 downto 0) := (others => '1');
    signal R_CmpOverflow    :   std_logic;
begin
    
    pBusWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                R_CmpVal <= (others => '1');
            else
                if CE_I = '1' and Data_We_I = '1' then
                    case to_integer(unsigned(Data_ADR_I)) is
                        when 16#02# =>
                            R_CmpVal(31 downto 0) <= data_DAT_I;
                        when 16#03# =>
                            R_CmpVal(63 downto 32) <= data_DAT_I;
                        when others =>
                    end case;
                end if;
            end if;
        end if;
    end process pBusWrite;

    pBusRead: process(Data_ADR_I, R_Cpt, R_CmpVal)
    begin
        case to_integer(unsigned(Data_ADR_I)) is
            when 16#00# =>
                data_DAT_O <= R_Cpt(31 downto 0);
            when 16#01# =>
                data_DAT_O <= R_Cpt(63 downto 32);
            when 16#02# =>
                data_DAT_O <= R_CmpVal(31 downto 0);
            when 16#03# =>
                data_DAT_O <= R_CmpVal(63 downto 32);
            when others =>
                data_DAT_O <= (others => '-');
            end case;
    end process pBusRead;

    timer : entity work.timer
        generic map
        (
            N       => 64
        )
        port map 
        (
            Rst             =>  Rst,
            Clk             =>  Clk,
            SLoad_I         =>  '0',
            Load_I          =>  (others => '0'),
            CmpVal_I        =>  R_CmpVal,
            UpDown_I        =>  '0',
            En_I            =>  '1',
            Overflow_O      =>  open,
            CmpOverflow_O   =>  R_CmpOverflow,
            EqZero_O        =>  open,
            Cpt_O           =>  R_Cpt
        );
        MTIMECMP_INTR   <= R_CmpOverflow;
end architecture rtl;