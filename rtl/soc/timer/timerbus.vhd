library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timerbus is
    port 
    (
        Rst           :   in  std_logic;
        Clk           :   in  std_logic;

        CE_I            :   in  std_logic;
        Data_WE_I       :   in  std_logic;
        Data_ADR_I      :   in  std_logic_vector(2 downto 0);
        data_SEL_I      :   in  std_logic_vector(3 downto 0);
        data_DAT_I      :   in  std_logic_vector(31 downto 0);
        data_DAT_O      :   out std_logic_vector(31 downto 0);
        Overflow_O      :   out std_logic;
        CmpOverflow_O   :   out std_logic;
        EqZero_O        :   out std_logic
    );
end entity timerbus;


architecture rtl of timerbus is
    constant N              :   integer :=  32;
    signal R_Cpt            :   std_logic_vector(N - 1 downto 0);
    signal R_SLoad          :   std_logic := '0';
    signal R_Load           :   std_logic_vector(N - 1 downto 0);
    signal R_CmpVal         :   std_logic_vector(N - 1 downto 0);
    signal R_UpDown         :   std_logic := '0';
    signal R_En             :   std_logic := '0';
    signal R_Overflow       :   std_logic;
    signal R_CmpOverflow    :   std_logic;
    signal R_EqZero         :   std_logic;
begin
    
    pBusWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                R_SLoad <= '0';
                R_UpDown <= '0';
                R_En <= '0';
                R_CmpVal <= (others => '1');
                R_Load  <= (others => '0');
            else
                if CE_I = '1' and Data_We_I = '1' then
                    case to_integer(unsigned(Data_ADR_I)) is
                        when 16#00# =>   
                            R_UpDown <= data_DAT_I(1);
                            R_En <= data_DAT_I(0);
                        when 16#01# =>
                            R_Load(31 downto 0) <= data_DAT_I;
                            R_SLoad <= '1';
                        when 16#02# =>
                            R_CmpVal(31 downto 0) <= data_DAT_I;
                        when others =>
                    end case;
                else
                    R_SLoad <= '0';
                end if;
            end if;
        end if;
    end process pBusWrite;

    pBusRead: process(Data_ADR_I)
    begin
        case to_integer(unsigned(Data_ADR_I)) is
            when 16#00# =>   
                data_DAT_O(4 downto 0) <= R_Overflow & R_CmpOverflow & R_EqZero & R_UpDown & R_En;
                data_DAT_O(31 downto 5) <= (others => '-');
            when 16#01# =>
                data_DAT_O <= R_Cpt(31 downto 0);
            when 16#02# =>
                data_DAT_O <= R_CmpVal(31 downto 0);
            when others =>
                data_DAT_O <= (others => '-');
            end case;
    end process pBusRead;

    timer : entity work.timer
        generic map
        (
            N           => N
        )
        port map 
        (
            Rst             =>  Rst,
            Clk             =>  Clk,
            SLoad_I         =>  R_SLoad,
            Load_I          =>  R_Load,
            CmpVal_I        =>  R_CmpVal,
            UpDown_I        =>  R_UpDown,
            En_I            =>  R_En,
            Overflow_O      =>  R_Overflow,
            CmpOverflow_O   =>  R_CmpOverflow,
            EqZero_O        =>  R_EqZero,
            Cpt_O           =>  R_Cpt
        );
    
    Overflow_O      <= R_Overflow;
    CmpOverflow_O   <= R_CmpOverflow;
    EqZero_O        <= R_EqZero;
    
end architecture rtl;