library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity SpiMaster is
    port (
        ARst    : in    std_logic := '0';
        Clk     : in    std_logic;
        SRst    : in    std_logic := '0';
        Freq    : in    std_logic_vector(15 downto 0);
        Mode    : in    std_logic_vector(1 downto 0);
        En      : in    std_logic;
        Trg     : in    std_logic;
        TxDat   : in    std_logic_vector(7 downto 0);
        RxDat   : out   std_logic_vector(7 downto 0);
        RxVld   : out   std_logic;
        BusyFlag: out   std_logic;
        Sck     : out   std_logic;
        Mosi    : out   std_logic;
        Miso    : in    std_logic;
        Ss      : out   std_logic
    );
end entity SpiMaster;

architecture rtl of SpiMaster is
    type SPI_ST             is (ST_IDLE, ST_DATA);
    signal sSckCnt          : std_logic_vector(16 downto 0);
    signal CurrentST        : SPI_ST;
    signal sBitCnt          : std_logic_vector(7 downto 0);
    signal dBitCnt          : std_logic;
    signal sSck             : std_logic;
    signal sSckRE, sSckFE   : std_logic_vector(1 downto 0);
    signal sMosi            : std_logic;
    signal sMiso            : std_logic;
    signal sSs              : std_logic;
    signal sTxDat           : std_logic_vector(7 downto 0);
    signal sRxDat           : std_logic_vector(7 downto 0);
    signal sRxVld           : std_logic;
    signal ShiftEn          : std_logic;
begin
    process (Clk)
    begin
        if rising_edge(Clk) then
            sMiso <= Miso;
        end if;
    end process;
    pGenFreq: process(Clk, ARst)
    begin
        if ARst = '1' then
            sSck <= '0';
        elsif rising_edge(Clk) then
            if SRst = '1' then
                sSck <= '0';
            else
                if CurrentST /= ST_IDLE then
                    sSckCnt <= ('0' & sSckCnt(15 downto 0)) + ('0' & Freq);
                else
                    sSckCnt <= (others => '0');
                end if;
                if sSckCnt(16) = '1' then
                    sSck <= not sSck;
                elsif CurrentST = ST_IDLE then
                    if Mode(1) = '1' then
                        sSck <= '1';
                    else
                        sSck <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process pGenFreq;
    sSckRE(0) <= '1' when sSckCnt(16) = '1' and sSck = '0' else '0';
    sSckFE(0) <= '1' when sSckCnt(16) = '1' and sSck = '1' else '0';
    process (Clk)
    begin
        if rising_edge(Clk) then
            sSckRE(1) <= sSckRE(0);
            sSckFE(1) <= sSckFE(0);
            dBitCnt <= sBitCnt(7);
        end if;
    end process;
    process (Clk, ARst)
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
                            if Trg = '1' then
                                CurrentST <= ST_DATA;
                            end if;
                        end if;
                    when ST_DATA =>
                        if sBitCnt(7) = '1' and ((sSckFE(0) = '1' and Mode(1) = '0') or (sSckRE(0) = '1' and Mode(1) = '1')) then
                            CurrentST <= ST_IDLE;
                        end if;
                    when others =>
                        CurrentST <= ST_IDLE;
                end case;
            end if;
        end if;
    end process;

    process (Clk)
        variable vTxDat : std_logic_vector(7 downto 0);
    begin
        if rising_edge(Clk) then
            if Trg = '1' then
                sTxDat <= TxDat;
            end if;
            if CurrentST = ST_IDLE then
                sBitCnt <= x"01";
                if En = '1' then
                    sSs <= '1';
                else
                    sSs <= '0';
                end if;
                ShiftEn <= '0';
            end if;
            if Mode(1) = '0' then
                if sSckRE(0) = '1' then
                    ShiftEn <= '1';
                end if;
            else
                if sSckFE(0) = '1' then
                    ShiftEn <= '1';
                end if;
            end if;
            if Mode(0) = '0' then
                if sSckRE(1) = '1' then
                    sRxDat <= sRxDat(6 downto 0) & sMiso;
                    if dBitCnt = '1' then
                        sRxVld <= '1';
                    end if;
                else
                    sRxVld <= '0';
                end if;
                if sSckFE(0) = '1' and ShiftEn = '1' then
                    sTxDat <= sTxDat(6 downto 0) & '0';
                    sBitCnt <= sBitCnt(6 downto 0) & sBitCnt(7);
                end if;
            else
                if sSckRE(0) = '1' and ShiftEn = '1' then
                    sTxDat <= sTxDat(6 downto 0) & '0';
                    sBitCnt <= sBitCnt(6 downto 0) & sBitCnt(7);
                end if;
                if sSckFE(1) = '1' then
                    sRxDat <= sRxDat(6 downto 0) & sMiso;
                    if dBitCnt = '1' then
                        sRxVld <= '1';
                    end if;
                else
                    sRxVld <= '0';
                end if;
            end if;
        end if;
    end process;
    sMosi <= sTxDat(7);
    BusyFlag <= '1' when CurrentST = ST_DATA else '0';
    Sck  <= sSck;
    Mosi <= sMosi when CurrentST = ST_DATA else '1';
    Ss   <= sSs;
    RxDat <= sRxDat;
    RxVld <= sRxVld;
end architecture rtl;