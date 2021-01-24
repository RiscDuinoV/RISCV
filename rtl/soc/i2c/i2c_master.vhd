library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity i2c_master is
    port 
    (
        ARst                :   in      std_logic   :=  '0';
        Clk                 :   in      std_logic;
        SRst                :   in      std_logic   :=  '0';
        
        SclFreq             :   in      std_logic_vector(15 downto 0);
        
        StartTransmission   :   in      std_logic;
        EndTransmission     :   in      std_logic;

        TrigWrite           :   in      std_logic;
        DataTx              :   in      std_logic_vector(7 downto 0);

        TrigRead            :   in      std_logic;
        DataRx              :   out     std_logic_vector(7 downto 0);

        BusyFlag            :   out     std_logic;
        AckErrFlag          :   out     std_logic;

        Scl                 :   out     std_logic;
        Sda                 :   inout   std_logic
    );
end entity i2c_master;

architecture rtl of i2c_master is
    type I2C_ST         is (ST_IDLE, ST_START, ST_ACTION, ST_WRITE, ST_READ_ACK, ST_READ, ST_WRITE_ACK, ST_STOP);
    signal Present_ST   :   I2C_ST := ST_IDLE;

    signal iSclReg      :   std_logic_vector(16 downto 0) := (others => '0');
    signal iScl         :   std_logic;
    signal iSclRE       :   std_logic;
    signal iSclFE       :   std_logic;

    signal iSda         :   std_logic;

    signal CptBit       :   std_logic_vector(2 downto 0) := (others => '1');

    signal AckErr       :   std_logic;

--    attribute mark_debug : string;
--    attribute mark_debug of Present_ST: signal is "true";
--    attribute mark_debug of iScl: signal is "true";
--    attribute mark_debug of iSda: signal is "true";
--    attribute mark_debug of CptBit: signal is "true";
--    attribute mark_debug of DataRx: signal is "true";
--    attribute mark_debug of DataTx: signal is "true";
--    attribute mark_debug of TrigWrite: signal is "true";
--    attribute mark_debug of TrigRead: signal is "true";
--    attribute mark_debug of BusyFlag: signal is "true";
--    attribute mark_debug of StartTransmission: signal is "true";
--    attribute mark_debug of EndTransmission: signal is "true";
begin
    
    pSdaSample: process(Clk)
    begin
        if rising_edge(Clk) then
            iSda <= Sda;
        end if;
    end process pSdaSample;

    pSclGen: process(Clk, ARst)
    begin
        if rising_edge(Clk) then
            if Present_ST = ST_IDLE or Present_ST = ST_ACTION then
                iSclReg <= (others => '0');    
            else
                iSclReg <= ('0' & iSclReg(15 downto 0)) + ('0' & SclFreq);
            end if;
            if Present_ST = ST_IDLE then
                iScl <= '1';
            elsif iSclReg(16) = '1' then
                iScl <= not iScl;
            end if;
        end if;
    end process pSclGen;
    iSclRE  <=  not iScl and iSclReg(16);
    iSclFE  <=  iScl and iSclReg(16);
    Scl     <=  iScl; 
    pFSM: process(Clk, ARst)
    begin
        if ARst = '1' then
            Present_ST <= ST_IDLE;
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Present_ST <= ST_IDLE;
            else
                case Present_ST is
                    when ST_IDLE =>
                        if StartTransmission = '1' then
                            Present_ST <= ST_START;
                        end if;
                    when ST_START =>
                        if iSclFE = '1' then
                            Present_ST <= ST_ACTION;
                        end if;
                    when ST_ACTION =>
                        if TrigWrite = '1' then
                            Present_ST <= ST_WRITE;
                        elsif TrigRead = '1' then
                            Present_ST <= ST_READ;
                        elsif EndTransmission = '1' or AckErr = '1' then
                            Present_ST <= ST_STOP;
                        end if;
                    when ST_WRITE =>
                        if CptBit = 0 and iSclFE = '1' then
                            Present_ST <= ST_READ_ACK;
                        end if;
                    when ST_READ_ACK =>
                        if iSclFE = '1' then
                            Present_ST <= ST_ACTION;
                        end if;
                    when ST_READ =>
                        if CptBit = 0 and iSclFE = '1' then
                            Present_ST <= ST_WRITE_ACK;
                        end if;
                    when ST_WRITE_ACK =>
                        if iSclFE = '1' then
                            Present_ST <= ST_ACTION;
                        end if;
                    when ST_STOP =>
                        if iSclFE = '1' then
                            Present_ST <= ST_IDLE;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pFSM;

    pAction: process(Clk, ARst)
        variable vDataRx    :   std_logic_vector(7 downto 0);
        variable vDataTx    :   std_logic_vector(7 downto 0);
    begin
        if rising_edge(Clk) then
            case Present_ST is
                when ST_IDLE =>
                    CptBit <= (others => '1');
                    Sda <= 'Z';
                when ST_START =>
                    Sda <= '0';
                    AckErr <= '0';
                when ST_ACTION =>
                    Sda <= 'Z';
                    CptBit <= (others => '1');
                    DataRx <= vDataRx;
                    vDataTx := DataTx;
                when ST_WRITE =>
                    Sda <= vDataTx(7);
                    if iSclFE = '1' then
                        vDataTx := vDataTx(6 downto 0) & '0';
                        CptBit <= CptBit - 1;
                    end if;
                when ST_READ_ACK =>
                    Sda <= 'Z';
                    if iSclRE = '1' then
                        AckErr <= iSda;
                    end if;
                when ST_READ =>
                    if iSclRE = '1' then
                        vDataRx := vDataRx(6 downto 0) & iSda;
                    end if;
                    if iSclFE = '1' then
                        CptBit <= CptBit - 1;
                    end if;
                when ST_WRITE_ACK =>
                    Sda <= '0';
                when others =>
            end case;
        end if;
    end process pAction;
    BusyFlag    <=  '0' when Present_ST = ST_IDLE or Present_ST = ST_ACTION else '1';
    AckErrFlag  <=  AckErr;
end architecture rtl;