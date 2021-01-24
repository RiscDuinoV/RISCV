library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity Uart is
    generic
    (
        C_Freq_MHz      : integer;
        C_init_baud     : integer := 115200;
        C_Rx_Fifo_Depth : integer :=  16;
        C_Tx_Fifo_Depth : integer :=  16
    );
    port 
    (
        Rst             :   in  std_logic;
        Clk             :   in  std_logic;
        Ce_I            :   in  std_logic;
        data_DAT_O      :   out std_logic_vector(31 downto 0);
        data_DAT_I      :   in  std_logic_vector(31 downto 0);
        data_WE_I       :   in  std_logic;
        data_SEL_I      :   in  std_logic_vector(3 downto 0);
        Rx              :   in  std_logic;
        Tx              :   out std_logic
    );
end entity Uart;

architecture rtl of Uart is
    constant C_Baud_Init    :   std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(C_init_baud * 2**10 / 1000 * 2**10 / C_Freq_MHz / 1000, 16));
    signal BaudClk          :   std_logic := '0';
    signal BaudGen          :   std_logic_vector(3 downto 0) := (others => '1');
    signal BaudGen16        :   std_logic_vector(16 downto 0) := (others => '0');
    signal R_baudrate       :   std_logic_vector(15 downto 0) := C_Baud_Init;
    signal TrigTx           :   std_logic                       := '0';
    signal ByteTx           :   std_logic_vector(7 downto 0);
    signal BusyTx           :   std_logic;
    signal TrigRx           :   std_logic;
    signal ByteRx           :   std_logic_vector(7 downto 0);
    signal AvailableRx      :   std_logic := '0';
    -- Fifo Signals
    signal FifoFullRx       :   std_logic;
    signal FifoRdByteRx     :   std_logic_vector(7 downto 0);
    signal FifoWrEnTx       :   std_logic;
    signal FifoWrByteTx     :   std_logic_vector(7 downto 0);
    signal TxBusyFlag       :   std_logic;
begin
    data_DAT_O(31 downto 11) <= ByteRx & "-----------" & TrigRx & BaudClk;
    data_DAT_O(10) <= TxBusyFlag;
    data_DAT_O(9 downto 8) <= FifoFullRx & AvailableRx;
    data_DAT_O(7 downto 0) <= FifoRdByteRx;
    pWrite: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                FifoWrEnTx <= '0';
                FifoWrByteTx <= (others => '1');
                R_baudrate <= C_Baud_Init;
            else
                if Ce_I = '1' and data_WE_I = '1' and data_SEL_I(0) = '1' then -- Start Tx
                    FifoWrByteTx <= data_DAT_I(7 downto 0);
                    FifoWrEnTx <= '1';
                else
                    FifoWrEnTx <= '0';
                end if;
                if Ce_I = '1' and data_WE_I = '1' and data_SEL_I(2) = '1' then -- Set baudrate
                    R_baudrate <= data_DAT_I(31 downto 16);
                end if;
            end if;
        end if;
    end process pWrite;
    -- Generate Without Rx Fifo
    genWithoutRxFifo: if C_Rx_Fifo_Depth <= 1 generate
        FifoRdByteRx <= ByteRx;
        FifoFullRx <= AvailableRx;
        pAvailable: process(Clk)
        begin
            if rising_edge(Clk) then
                if Rst = '1' then
                    AvailableRx <= '0';
                else
                    if TrigRx = '1' then    -- Available flag
                        AvailableRx <= '1';
                    elsif Ce_I = '1' and data_WE_I = '0' and data_SEL_I(0) = '1' then
                        AvailableRx <= '0';
                    end if;
                end if;
            end if;
        end process pAvailable;
    end generate genWithoutRxFifo;
    -- Generate With Rx Fifo
    genWithRxFifo: if C_Rx_Fifo_Depth > 1 generate
        signal FifoRdEnRx       :   std_logic := '0';
        signal FifoEmptyFlagRx  :   std_logic;
    begin
        AvailableRx <= not FifoEmptyFlagRx;
        FifoRdEnRx <= '1' when Ce_I = '1' and data_WE_I = '0' and data_SEL_I(0) = '1' else '0';
        RxFifo : entity work.fifo
        generic map
        (
            C_Width =>  8,
            C_Depth =>  C_Rx_Fifo_Depth
        )
        port map
        (
            Rst         =>  Rst,
            Clk         =>  Clk,
            Wr_En       =>  TrigRx,
            Wr_Data     =>  ByteRx,
            Rd_En       =>  FifoRdEnRx,
            Rd_Data     =>  FifoRdByteRx,
            Empty_Flag  =>  FifoEmptyFlagRx,
            Full_Flag   =>  FifoFullRx
        );
    end generate genWithRxFifo;
    -- Generate without Tx Fifo
    genWithoutTxFifo: if C_Tx_Fifo_Depth <= 1 generate
        TrigTx <= FifoWrEnTx;
        ByteTx <= FifoWrByteTx;
        TxBusyFlag <= BusyTx;
    end generate genWithoutTxFifo;
    -- Generate with Tx Fifo
    genWithTxFifo: if C_Tx_Fifo_Depth > 1 generate
        signal EmptyTxFifo  :   std_logic := '0';
        signal TxEmptyFlag  :   std_logic;
    begin
        TxFifo : entity work.fifo
        generic map
        (
            C_Width =>  8,
            C_Depth =>  C_Tx_Fifo_Depth
        )
        port map
        (
            Rst         =>  Rst,
            Clk         =>  Clk,
            Wr_En       =>  FifoWrEnTx,
            Wr_Data     =>  FifoWrByteTx,
            Rd_En       =>  EmptyTxFifo,
            Rd_Data     =>  ByteTx,
            Empty_Flag  =>  TxEmptyFlag,
            Full_Flag   =>  TxBusyFlag
        );
        EmptyTxFifo <=  '1' when TxEmptyFlag = '0' and BusyTx = '0' and TrigTx = '0' else
                        '0';
        pTrigTx: process(Clk)
        begin
            if rising_edge(Clk) then
                if Rst = '1' then
                    TrigTx <= '0';
                else
                    TrigTx <= EmptyTxFifo;  -- delay TrigTx to have ByteTx on the same phase
                end if;
            end if;
        end process pTrigTx;
    end generate genWithTxFifo;
-- RTL 
    genBaud16: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                BaudGen16 <= (others => '0');
                BaudGen <= (others => '0');
                BaudClk <= '0';
            else
                BaudGen16 <= ('0' & BaudGen16(15 downto 0)) + ('0' & R_baudrate);
                if BaudGen16(16) = '1' then
                    BaudGen <= BaudGen + 1;
                end if;
                if BaudGen = 0 and BaudGen16(16) = '1' then
                    BaudClk <= '1';
                else 
                    BaudClk <= '0';
                end if;
            end if;
        end if;
    end process genBaud16;
    UartTx : entity work.UartTx
        generic map
        (
            C_WordWidth =>  8
        )
        port map
        (
            Rst         =>  Rst,
            Clk         =>  Clk,
            Baudrate    =>  BaudClk,
            Trig        =>  TrigTx,
            ByteTx      =>  ByteTx,
            BusyTx      =>  BusyTx,
            Tx          =>  Tx
        );

    UartRx : entity work.UartRx
        generic map
        (
            C_WordWidth =>  8
        )
        port map
        (
            Rst         =>  Rst,
            Clk         =>  Clk,
            BaudRate16  =>  BaudGen16(16),
            BaudRate    =>  BaudGen,
            TrigRx      =>  TrigRx,
            ByteRx      =>  ByteRx,
            Rx          =>  Rx
        );
end architecture rtl;