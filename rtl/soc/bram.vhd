library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
use STD.TEXTIO.all;
use ieee.std_logic_textio.all;

entity bram is
    generic
    (
        addr_width      : integer := 9; 
        data_width_a    : integer := 32;
        data_width_b    : integer := 32;
        byte_size       : integer := 8;
        init_file       : string  := "NONE"
    );
    port 
    (
        DataInA     : in  std_logic_vector((data_width_a-1) downto 0);
        DataInB     : in  std_logic_vector((data_width_b-1) downto 0);
        AddressA    : in  std_logic_vector((addr_width-1) downto 0);
        AddressB    : in  std_logic_vector((addr_width-1) downto 0);
        ClockA      : in  std_logic;
        ClockB      : in  std_logic;
        ClockEnA    : in  std_logic;
        ClockEnB    : in  std_logic;
        WrA         : in  std_logic;
        WrB         : in  std_logic;
        ByteEnA     : in  std_logic_vector(((data_width_a+byte_size-1)/byte_size-1) downto 0);
        ByteEnB     : in  std_logic_vector(((data_width_b+byte_size-1)/byte_size-1) downto 0);
        QA          : out std_logic_vector((data_width_a-1) downto 0);
        QB          : out std_logic_vector((data_width_b-1) downto 0)
    );
end entity bram;
architecture rtl of bram is
    constant MEM_SIZE   : integer := 2**addr_width;
    constant NB_COL_A   : integer := ((data_width_a+byte_size-1)/byte_size-1);
    constant NB_COL_B   : integer := ((data_width_b+byte_size-1)/byte_size-1);
    type ram_type is array (MEM_SIZE - 1 downto 0) of std_logic_vector(31 downto 0);
    impure function ocram_ReadMemFile(FileName : STRING) return ram_type is
        file FileHandle       : TEXT open READ_MODE is FileName;
        variable CurrentLine  : LINE;
        variable TempWord     : STD_LOGIC_VECTOR(31 downto 0);
        variable Result       : ram_type    := (others => (others => '0'));
    begin
        for i in 0 to MEM_SIZE - 1 loop
            exit when endfile(FileHandle);
            readline(FileHandle, CurrentLine);
			hread(CurrentLine, TempWord);
            Result(i)    := TempWord;
        end loop;
        return Result;
    end function;
    shared variable RAM : ram_type := ocram_ReadMemFile(init_file);
begin
    process(ClockA)
    begin
        if ClockA'event and ClockA = '1' then
            if ClockEnA = '1' then
                QA <= RAM(conv_integer(AddressA));
                for i in 0 to NB_COL_A loop
                    if ByteEnA(i) = '1' and WrA = '1' then
                        RAM(conv_integer(AddressA))((i + 1) * byte_size - 1 downto i * byte_size) := DataInA((i + 1) * byte_size - 1 downto i * byte_size);
                    end if;
                end loop;
            end if;
        end if;
    end process;
    process(ClockB)
    begin
        if ClockB'event and ClockB = '1' then
            if ClockEnB = '1' then
                QB <= RAM(conv_integer(AddressB));
                for i in 0 to NB_COL_B loop
                    if ByteEnB(i) = '1' and WrB = '1' then
                        RAM(conv_integer(AddressB))((i + 1) * byte_size - 1 downto i * byte_size) := DataInB((i + 1) * byte_size - 1 downto i * byte_size);
                    end if;
                end loop;
            end if;
        end if;
    end process;
end rtl;