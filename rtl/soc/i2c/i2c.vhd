library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        En      : in    std_logic;
        Freq    : in    std_logic_vector(15 downto 0);
        Trg     : in    std_logic;
        We      : in    std_logic;
        Last    : in    std_logic;
        WDat    : in    std_logic_vector(7 downto 0);
        RDat    : out   std_logic_vector(7 downto 0);
        RVld    : out   std_logic;
        Scl     : out   std_logic;
        Sda     : inout std_logic;
        AckErr  : out   std_logic;
        Busy    : out   std_logic
    );
end entity i2c;

architecture rtl of i2c is
    type I2C_ST is (ST_IDLE, ST_WAIT, ST_START, ST_WRITE, ST_SLV_ACK, ST_READ, ST_MST_ACK, ST_STOP);
    signal CurrentST    : I2C_ST;
    signal SclReg       : std_logic_vector(16 downto 0);
    signal SclEn        : std_logic;
    signal iScl         : std_logic;
    signal iSclRE       : std_logic;
    signal iSclFE       : std_logic;
    signal BitCnt       : std_logic_vector(7 downto 0);
    signal Sda_i        : std_logic;
    signal Sda_o        : std_logic;
    signal Sda_t        : std_logic;
    signal Scl_i        : std_logic;
    signal Scl_o        : std_logic;
    signal Scl_t        : std_logic;
    signal iWDat        : std_logic_vector(7 downto 0);
    signal iRDat        : std_logic_vector(7 downto 0);

    attribute mark_debug : string;
    attribute keep : string;
    attribute mark_debug of CurrentST   : signal is "true";
    attribute mark_debug of BitCnt      : signal is "true";
    attribute mark_debug of Scl_o       : signal is "true";
    attribute mark_debug of Sda_i       : signal is "true";
    attribute mark_debug of Sda_o       : signal is "true";
    attribute mark_debug of Sda_t       : signal is "true";
    attribute mark_debug of iWDat       : signal is "true";
    attribute mark_debug of iRDat       : signal is "true";
    attribute mark_debug of RVld        : signal is "true";
    attribute mark_debug of En          : signal is "true";
    attribute mark_debug of Trg         : signal is "true";
    attribute mark_debug of We          : signal is "true";
    attribute mark_debug of Last        : signal is "true";
    attribute mark_debug of AckErr      : signal is "true";
    attribute mark_debug of Busy        : signal is "true";
begin
    process (Clk)
    begin
        if rising_edge(Clk) then
            Sda_i <= Sda;
        end if;
    end process;
    process (Clk)
    begin
        if rising_edge(Clk) then
            if CurrentST /= ST_IDLE and CurrentST /= ST_WAIT then
                SclReg <= std_logic_vector(unsigned('0' & SclReg(15 downto 0)) + unsigned('0' & Freq));
            else
                SclReg <= (others => '0');
            end if;
            if CurrentST /= ST_IDLE and CurrentST /= ST_WAIT then
                if SclReg(16) = '1' then
                    iScl <= not iScl;
                end if;
            else
                iScl <= '1';
            end if;
        end if;
    end process;
    iSclRE <= '1' when SclReg(16) = '1' and Scl_o = '0' else '0';
    iSclFE <= '1' when SclReg(16) = '1' and Scl_o = '1' else '0';
    pFsm: process(Clk, ARst)
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
                        if iSclRE = '1' then
                            CurrentST <= ST_WRITE;
                        end if;
                    when ST_WAIT =>
                        if En = '0' then
                            CurrentST <= ST_STOP;
                        else
                            if Trg = '1' then
                                if We = '1' then
                                    CurrentST <= ST_WRITE;
                                else
                                    CurrentST <= ST_READ;
                                end if;
                            end if;
                        end if;
                    when ST_WRITE =>
                        if BitCnt(7) = '1' and iSclFE = '1' then
                            CurrentST <= ST_SLV_ACK;
                        end if;
                    when ST_SLV_ACK =>
                        if iSclFE = '1' then
                            CurrentST <= ST_WAIT;
                        end if;
                    when ST_READ =>
                        if BitCnt(7) = '1' and iSclFE = '1' then
                            CurrentST <= ST_MST_ACK;
                        end if;
                    when ST_MST_ACK =>
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
    end process pFsm;

    process (Clk)
    begin
        if rising_edge(Clk) then
            if We = '1' then
                iWDat <= WDat;
            end if;
            if SclReg(16) = '1' then
                Scl_o <= not Scl_o;
            end if;
            RVld <= '0';
            case CurrentST is
                when ST_IDLE =>
                    Scl_o <= '1';
                    Sda_t <= '1';
                    Sda_o <= '1';
                    AckErr <= '0';
                    BitCnt <= x"01";
                when ST_WAIT => 
                    Scl_o <= '0';
                    Sda_t <= '1';
                    Sda_o <= '1';
                    BitCnt <= x"01";
                when ST_START => 
                    if iSclRE = '1' then
                        Scl_o <= '0';
                    end if;
                    Sda_t <= '0';
                    Sda_o <= '0';
                when ST_WRITE =>
--                    Scl_o <= not iScl;
                    Sda_t <= '0';
                    Sda_o <= iWDat(7);
                    if iSclFE = '1' then
                        iWDat <= iWDat(6 downto 0) & '0';
                        BitCnt <= BitCnt(6 downto 0) & '0';
                    end if;
                when ST_SLV_ACK =>
--                    Scl_o <= not iScl;
                    Sda_o <= '1';
                    Sda_t <= '1';
                    if iSclRE = '1' then
                        AckErr <= Sda_i;
                    end if;
                when ST_READ => 
--                    Scl_o <= iScl;
                    Sda_t <= '1';
                    if iSclRE = '1' then
                        iRDat <= iRDat(6 downto 0) & Sda_i;
                        if BitCnt(7) = '1' then
                            RVld <= '1';
                        end if;
                    else
                        RVld <= '0';
                    end if;
                    if iSclFE = '1' then
                        BitCnt <= BitCnt(6 downto 0) & '0';
                    end if;
                when ST_MST_ACK =>
--                    Scl_o <= iScl;
                    if Last = '0' then
                        Sda_t <= '0';
                        Sda_o <= '0';
                    else
                        Sda_t <= '1';
                        Sda_o <= '1';
                    end if;
                when ST_STOP => 
--                    Scl_o <= iScl;
                    if iSclFE = '1' then
                        Scl_o <= '1';
                    end if;
                    Sda_t <= '0';
                    Sda_o <= '0';
            
                when others =>
                    
            
            end case;
        end if;
    end process;
    RDat <= iRDat;
    Scl_t <= '0';
    Scl <= Scl_o;
    Sda <= Sda_o when Sda_t = '0' else 'Z';
    Busy <= '0' when CurrentST = ST_IDLE or CurrentST = ST_WAIT else '1';
end architecture rtl;