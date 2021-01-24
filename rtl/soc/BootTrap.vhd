library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity BootTrap is
    port 
    (
        ARst        :   in  std_logic;
        Clk         :   in  std_logic;
        Ce_I        :   in  std_logic;
        data_DAT_O  :   out std_logic_vector(31 downto 0);
        data_DAT_I  :   in  std_logic_vector(31 downto 0);
        data_WE_I   :   in  std_logic;
        data_SEL_I  :   in  std_logic_vector(3 downto 0);
        Baudrate    :   in  std_logic;
        TrigRx      :   in  std_logic;
        ByteRx      :   in  std_logic_vector(7 downto 0);
        Reset       :   out std_logic
    );
end entity BootTrap;

architecture rtl of BootTrap is
    type BootTrap_ST    is  (ST_IDLE, ST_SEQ, ST_GET_TYPE, ST_ROM, ST_RAM, ST_RESET);
    signal Present_ST           :   BootTrap_ST := ST_IDLE;
    signal CptSeq               :   std_logic_vector(1 downto 0);
    signal RqstCpuROM           :   std_logic := '0';
    signal RqstCpuRAM           :   std_logic := '0';
    signal Timeout              :   std_logic := '0';
    signal ResetCpu             :   std_logic := '0';
    signal CptTimeout           :   std_logic_vector(4 downto 0) := (others => '1');
    signal UserResetVector      :   std_logic_vector(29 downto 0) := (others => '0');
    signal ResetFromCpu         :   std_logic;
begin
    data_DAT_O(1 downto 0) <= RqstCpuRAM & RqstCpuROM;
    data_DAT_O(31 downto 2) <= UserResetVector;
    pWrite: process(Clk, ARst)
    begin
        if ARst = '1' then
            UserResetVector <= (others => '0');
            ResetFromCpu <= '0';
        elsif rising_edge(Clk) then
            if Ce_I = '1' and data_WE_I = '1' then
                UserResetVector <= data_DAT_I(31 downto 2);
                ResetFromCpu <= '1';
            else
                ResetFromCpu <= '0';
            end if;
        end if;
    end process pWrite;
    pRqstProgCpu: process(ARst, Clk)
    begin
        if ARst = '1' then
            RqstCpuROM <= '0';
            RqstCpuRAM <= '0';
        elsif rising_edge(Clk) then
            if Ce_I = '1' and data_WE_I = '0' then
                RqstCpuROM <= '0';
            elsif Present_ST = ST_ROM then
                RqstCpuROM <= '1';
            end if;
            if Ce_I = '1' and data_WE_I = '0' then
                RqstCpuRAM <= '0';
            elsif Present_ST = ST_RAM then
                RqstCpuRAM <= '1';
            end if;
        end if;
    end process pRqstProgCpu;
-- RTL
    pFSM: process(Clk, ARst)
    begin
        if ARst = '1' then
            Present_ST <= ST_IDLE;
        elsif rising_edge(Clk) then
            case Present_ST is
                when ST_IDLE =>
                    if CptSeq = 0 then
                        Present_ST <= ST_GET_TYPE;
                    end if;
                when ST_GET_TYPE =>
                    if TrigRx = '1' then
                        if ByteRx = x"30" then
                            Present_ST <= ST_RESET;
                        elsif ByteRx = x"31" then
                            Present_ST <= ST_ROM;
                        elsif ByteRx = x"32" then 
                            Present_ST <= ST_RAM;
                        else
                            Present_ST <= ST_IDLE;
                        end if;
                    elsif Timeout = '1' then
                        Present_ST <= ST_IDLE;
                    end if;
                when ST_ROM =>
                    Present_ST <= ST_IDLE;
                when ST_RAM =>
                    Present_ST <= ST_IDLE;
                when ST_RESET =>
                    Present_ST <= ST_IDLE;
                when others =>
            end case;
        end if;
    end process pFSM;
    
    pGenTimeout: process(Clk, ARst)
    begin
        if ARst = '1' then
            CptTimeout <= (others => '1');
            Timeout <= '0';
        elsif rising_edge(Clk) then
            if TrigRx = '1' then
                CptTimeout <= (others => '1');
            elsif Baudrate = '1' then
                CptTimeout <= CptTimeout - 1;
            end if;
            if CptTimeout = 0 then
                Timeout <= '1';
            else 
                Timeout <= '0';
            end if;
        end if;
    end process pGenTimeout;
    pCptSeq: process(Clk, ARst)
    begin
        if ARst = '1' then
            CptSeq <= (others => '1');
        elsif rising_edge(Clk) then
            if Present_ST = ST_IDLE and TrigRx = '1' and ByteRx = x"2B" then
                CptSeq <= CptSeq - 1;
            elsif Timeout = '1' or ByteRx /= x"2B" or Present_ST /= ST_IDLE then
                CptSeq <= (others => '1');
            end if;
        end if;
    end process pCptSeq;
    ResetCpu <= '1' when Present_ST = ST_ROM or Present_ST = ST_RAM or Present_ST = ST_RESET or ResetFromCpu = '1' else
                '0';
    Reset <= ResetCpu;
end architecture rtl;