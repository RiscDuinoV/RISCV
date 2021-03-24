library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity i2c_master is
    port 
    (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        SclFreq : in    std_logic_vector(15 downto 0);
        En      : in    std_logic;
        WrEn    : in    std_logic;
        TxDat   : in    std_logic_vector(7 downto 0);
        RdEn    : in    std_logic;
        RxDat   : out   std_logic_vector(7 downto 0);
        BusyFlag: out   std_logic;
        AckErr  : out   std_logic;
        Scl     : out   std_logic;
        Sda     : inout std_logic
    );
end entity i2c_master;

architecture rtl of i2c_master is
    type I2C_ST is (ST_IDLE, ST_START, ST_WAIT, ST_WRITE, ST_ACK_WRITE, ST_READ, ST_ACK_READ, ST_STOP);
    signal CurrentST    : I2C_ST;
    signal SclEn        : std_logic;
    signal iScl         : std_logic;
    signal iSclRE       : std_logic;
    signal iSclFE       : std_logic;
    signal iSda         : std_logic;
    signal CptBit       : std_logic_vector(7 downto 0);
    signal LastBit      : std_logic;
    signal vTxDat       : std_logic_vector(7 downto 0);
    signal vRxDat       : std_logic_vector(7 downto 0);
    signal iSclReg      : std_logic_vector(16 downto 0);
begin
    
    pSampleSda: process(Clk)
    begin
        if rising_edge(Clk) then
            iSda <= Sda;
        end if;
    end process pSampleSda;

    pSclGen: process(Clk, ARst)
    begin
        if ARst = '1' then
            SclEn <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                SclEn <= '0';
            else
                if CurrentST = ST_IDLE or CurrentST = ST_WAIT then
                    iSclReg <= (others => '0');    
                else
                    iSclReg <= ('0' & iSclReg(15 downto 0)) + ('0' & SclFreq);
                end if;
                if CurrentST = ST_IDLE then
                    iScl <= '1';
                elsif iSclReg(16) = '1' then
                    iScl <= not iScl;
                end if;
                if CurrentST = ST_IDLE and En = '1' then
                    SclEn <= '1';
                elsif CurrentST = ST_STOP and iSclFE = '1' then
                    SclEn <= '0';
                end if;
            end if;
        end if;
    end process pSclGen;
    iSclRE  <=  not iScl and iSclReg(16);
    iSclFE  <=  iScl and iSclReg(16);
    Scl <= iScl when SclEn = '1' else '1';
    -- Fsm
    pFsmI2C: process(Clk, ARst)
    begin
        if ARst = '1' then
            CurrentST <= ST_IDLE;
        elsif rising_edge(Clk) then
            if SRst = '1' then
                CurrentST <= ST_IDLE;
            else
                case CurrentST is
                    when ST_IDLE =>
                        if En = '1' then
                            CurrentST <= ST_START;
                        end if;
                    when ST_START =>
                        if iSclFE = '1' then
                            CurrentST <= ST_WAIT;
                        end if;
                    when ST_WAIT =>
                        if WrEn = '1' then
                            CurrentST <= ST_WRITE;
                        elsif RdEn = '1' then
                            CurrentST <= ST_READ;
                        elsif En = '0' then
                            CurrentST <= ST_STOP;
                        end if;
                    when ST_WRITE =>
                        if LastBit = '1' then
                            CurrentST <= ST_ACK_WRITE;
                        end if;
                    when ST_ACK_WRITE =>
                        if iSclFE = '1' then
                           CurrentST <= ST_WAIT; 
                        end if;
                    when ST_READ =>
                        if LastBit = '1' then
                            CurrentST <= ST_ACK_READ;
                        end if;
                    when ST_ACK_READ =>
                        if iSclFE = '1' then
                            CurrentST <= ST_WAIT;
                        end if;
                    when ST_STOP =>
                        if iSclFE = '1' then
                            CurrentST <= ST_IDLE;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pFsmI2C;
    LastBit <= CptBit(7) and iSclFE;
    pFsmRTL: process(Clk)
    begin
        if rising_edge(Clk) then
            case CurrentST is
                when ST_IDLE =>
                    Sda <= 'Z';
                when ST_START =>
                    Sda <= '0';
                when ST_WAIT =>
                    Sda <= 'Z';
                    CptBit <= x"01";
                    vTxDat <= TxDat;
                    RxDat <= vRxDat;
                when ST_WRITE =>
                    Sda <= vTxDat(7);
                    if iSclFE = '1' then
                        vTxDat <= vTxDat(6 downto 0) & '0';
                        CptBit <= CptBit(6 downto 0) & CptBit(7);
                    end if;
                when ST_ACK_WRITE =>
                    Sda <= 'Z';
                    if iSclRE = '1' then
                        AckErr <= iSda;
                    end if;
                when ST_READ =>
                    if iSclRE = '1' then
                        vRxDat <= vRxDat(6 downto 0) & iSda;
                    end if;
                    if iSclFE = '1' then
                        CptBit <= CptBit(6 downto 0) & CptBit(7);
                    end if;
                when ST_ACK_READ =>
                    Sda <= '0';
                when ST_STOP =>
                    Sda <= '0';
                when others =>
            end case;
        end if;
    end process pFsmRTL;
    BusyFlag <= '0' when CurrentST = ST_IDLE or CurrentST = ST_WAIT else '1';
end architecture rtl;