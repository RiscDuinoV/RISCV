library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Spi is
    generic
    (
        C_Freq_MHz  :   integer;
        C_Freq_SPI  :   integer := 100_000
    );
    port 
    (
        ARst        : in    std_logic := '0';
        Clk         : in    std_logic;
        SRst        : in    std_logic := '0';
        Ce          : in    std_logic;
        Data_DAT_O  : out   std_logic_vector(31 downto 0);
        Data_DAT_I  : in    std_logic_vector(31 downto 0);
        Data_WE     : in    std_logic;
        Data_SEL    : in    std_logic_vector(3 downto 0);
        Sck         : out   std_logic;
        Mosi        : out   std_logic;
        Miso        : in    std_logic;
        Ss          : out   std_logic
    );
end entity Spi;

architecture rtl of Spi is
    constant C_SPI_Init :   std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned((C_Freq_SPI * 2**8)/1000 *  2**9 / (C_Freq_MHz * 1000), 16));
    signal En       : std_logic;
    signal Trig     : std_logic;
    signal TxDat    : std_logic_vector(7 downto 0);
    signal RxDat    : std_logic_vector(7 downto 0);
    signal SckFreq  : std_logic_vector(15 downto 0);
    signal BusyFlag : std_logic;
begin
    Data_DAT_O(31 downto 9) <= (others => '-'); 
    Data_DAT_O(8 downto 0)  <= BusyFlag & RxDat; 
    pVWrite: process(Clk, ARst)
    begin
        if ARst = '1' then
            Trig <= '0';
            En <= '0';
            SckFreq <= C_SPI_Init;
        elsif rising_edge(Clk) then
            if SRst = '1' then
                Trig <= '0';
                En <= '0';
                SckFreq <= C_SPI_Init;
            else
                if Ce = '1' and Data_WE = '1' then
                    if Data_SEL(0) = '1' then
                        TxDat <= Data_DAT_I(7 downto 0);
                        Trig  <= '1';
                    end if;
                    if Data_SEL(1) = '1' then
                        En <= Data_DAT_I(8);
                    end if;
                    if Data_SEL(2) = '1' then
                        SckFreq <= Data_DAT_I(31 downto 16);
                    end if;
                else
                    Trig <= '0';
                end if;
            end if;
        end if;
    end process pVWrite;
    
    SpiMaster_inst : entity work.SpiMaster
        port map 
		(
            ARst        => ARst,
            Clk         => Clk,
            SRst        => SRst,
            SckFreq     => SckFreq,
            En          => En,
            Trig        => Trig,
            TxDat       => TxDat,
            RxDat       => RxDat,
            BusyFlag    => BusyFlag,
            Sck         => Sck,
            Mosi        => Mosi,
            Miso        => Miso,
            Ss          => Ss
        );

end architecture rtl;