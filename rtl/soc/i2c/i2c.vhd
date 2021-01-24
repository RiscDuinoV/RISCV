library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c is
    generic
    (
        C_Freq_MHz  :   integer;
        C_Freq_I2C  :   integer := 100_000
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
        Scl         :   out     std_logic;
        Sda         :   inout   std_logic
    );
end entity i2c;

architecture rtl of i2c is
    constant C_I2C_Init :   std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned((C_Freq_I2C * 2**8)/1000 *  2**9 / (C_Freq_MHz * 1000), 16));

    signal DataTx               :   std_logic_vector(7 downto 0);
    signal DataRx               :   std_logic_vector(7 downto 0);
    signal AckErrFlag           :   std_logic;
    signal BusyFlag             :   std_logic;
    signal StartTransmission    :   std_logic;
    signal EndTransmission      :   std_logic;
    signal TrigWrite            :   std_logic;
    signal TrigRead             :   std_logic;
    signal SclFreq              :   std_logic_vector(15 downto 0) := C_I2C_Init;
begin
    data_DAT_O(9 downto 0) <= AckErrFlag & BusyFlag & DataRx;
    data_DAT_O(31 downto 10) <= (others => '-');
    pWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                TrigRead            <= '0';
                TrigWrite           <= '0';
                EndTransmission     <= '0';
                StartTransmission   <= '0';
                SclFreq             <= C_I2C_Init;
            else
                if Ce_I = '1' and data_WE_I = '1' and data_SEL_I(0) = '1' then
                    DataTx              <= data_DAT_I(7 downto 0);
                end if;
                if Ce_I = '1' and data_WE_I = '1' and data_SEL_I(1) = '1' then
                    TrigRead            <= data_DAT_I(8);
                    TrigWrite           <= data_DAT_I(9);
                    EndTransmission     <= data_DAT_I(10);
                    StartTransmission   <= data_DAT_I(11);
                else
                    TrigRead            <= '0';
                    TrigWrite           <= '0';
                    EndTransmission     <= '0';
                    StartTransmission   <= '0';
                end if;
                if Ce_I = '1' and data_WE_I = '1' and data_SEL_I(2) = '1' then
                    SclFreq <= data_DAT_I(31 downto 16);
                end if;
            end if;
        end if;
    end process pWrite;

    i2c_master : entity work.i2c_master
    port map
    (
        Clk                 =>  Clk,
        SRst                =>  Rst,

        SclFreq             =>  SclFreq,

        StartTransmission   =>  StartTransmission,
        EndTransmission     =>  EndTransmission,

        TrigWrite           =>  TrigWrite,
        DataTx              =>  DataTx,

        TrigRead            =>  TrigRead,
        DataRx              =>  DataRx,

        BusyFlag            =>  BusyFlag,
        AckErrFlag          =>  AckErrFlag,

        Scl                 =>  Scl,
        Sda                 =>  Sda
    );
    
end architecture rtl;