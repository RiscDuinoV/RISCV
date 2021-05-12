library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity SpiMaster is
    port 
    (
        ARst        : in    std_logic := '0';
        Clk         : in    std_logic;
        SRst        : in    std_logic := '0';
        SckFreq     : in    std_logic_vector(15 downto 0);
        En          : in    std_logic;
        Trig        : in    std_logic;
        TxDat       : in    std_logic_vector(7 downto 0);
        RxDat       : out   std_logic_vector(7 downto 0);
        BusyFlag    : out   std_logic;
        Sck         : out   std_logic;
        Mosi        : out   std_logic;
        Miso        : in    std_logic;
        Ss          : out   std_logic
    );
end entity SpiMaster;

architecture rtl of SpiMaster is
    type SPI_ST         is (ST_IDLE, ST_WAIT, ST_DATA);
    signal CurrentST    : SPI_ST;
    signal CptBit       : std_logic_vector(7 downto 0);
    signal LastBit      : std_logic;
    signal iSckReg      : std_logic_vector(16 downto 0);
    signal iSck         : std_logic;
    signal iSckRE       : std_logic;
    signal iSckFE       : std_logic;
    signal vTxDat       : std_logic_vector(7 downto 0);
    signal vRxDat       : std_logic_vector(7 downto 0);
    signal iMiso        : std_logic;
begin
    pSckGen: process(Clk, ARst)
    begin
        if rising_edge(Clk) then
            if CurrentST = ST_IDLE or CurrentST = ST_WAIT then
                iSckReg <= (others => '0');    
            else
                iSckReg <= ('0' & iSckReg(15 downto 0)) + ('0' & SckFreq);
            end if;
            if CurrentST = ST_IDLE then
                iSck <= '0';
            elsif iSckReg(16) = '1' then
                iSck <= not iSck;
            end if;
        end if;
    end process pSckGen;
    iSckRE  <=  not iSck and iSckReg(16);
    iSckFE  <=  iSck and iSckReg(16);
    pSampleMiso: process(Clk)
    begin
        if rising_edge(Clk) then
            iMiso <= Miso;
        end if;
    end process pSampleMiso;
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
                            CurrentST <= ST_WAIT;
                        end if;
                    when ST_WAIT =>
                        if Trig = '1' then
                            CurrentST <= ST_DATA;
                        elsif En = '0' then
                            CurrentST <= ST_IDLE;
                        end if;
                    when ST_DATA =>
                        if LastBit = '1' then
                            CurrentST <= ST_WAIT;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pFsm;
    LastBit <= CptBit(7) and iSckFE;
    pFsmRTL: process(Clk)
    begin
        if rising_edge(Clk) then
            if CurrentST = ST_DATA then
                Mosi <= vTxDat(7);
                if iSckFE = '1' then
                    CptBit <= CptBit(6 downto 0) & CptBit(7);
                    vTxDat <= vTxDat(6 downto 0) & '0';
                end if;
                if iSckRE = '1' then
                    vRxDat <= vRxDat(6 downto 0) & iMiso;
                end if;
            else
                vTxDat <= TxDat;
                RxDat <= vRxDat;
                CptBit <= x"01";
                Mosi <= 'Z';
            end if;
        end if;
    end process pFsmRTL;
    Sck <= iSck;-- when CurrentST /= ST_IDLE else 'Z';
    Ss  <= '1' when CurrentST /= ST_IDLE else '0';
    BusyFlag <= '1' when CurrentST = ST_DATA else '0';
end architecture rtl;