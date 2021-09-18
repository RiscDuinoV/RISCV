library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.TEXTIO.all;
use ieee.std_logic_textio.all;
entity ram_1x2 is
    generic (
        C_RAM_SIZE      : integer := 1024;
        C_ADDR_WIDTH    : integer := 10;
        C_BYTE_WIDTH    : integer := 9;
        C_NB_BYTE       : integer := 4;
        C_INIT_FILE     : string  := "none"
    );
    port (
        Clk     : in    std_logic;
        En      : in    std_logic;
        We      : in    std_logic_vector(C_NB_BYTE - 1 downto 0);
        Addr    : in    std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        Di      : in    std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        AddrA   : in    std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        DoA     : out   std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        AddrB   : in    std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        DoB     : out   std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0)
    );
end entity ram_1x2;

architecture rtl of ram_1x2 is
    type ram_type is array (0 to C_RAM_SIZE - 1) of std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
    impure function ocram_ReadMemFile(FileName : STRING) return ram_type is
        file FileHandle       : TEXT;
        variable CurrentLine  : LINE;
        variable TempWord     : STD_LOGIC_VECTOR(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        variable Result       : ram_type    := (others => (others => '0'));
    begin
        if FileName /= "none" then
            file_open(FileHandle, FileName,  read_mode);
            for i in 0 to C_RAM_SIZE - 1 loop
                exit when endfile(FileHandle);
                readline(FileHandle, CurrentLine);
                hread(CurrentLine, TempWord);
                Result(i)    := TempWord;
            end loop;
        end if;
        return Result;
    end function;
    signal RAM : ram_type := ocram_ReadMemFile(C_INIT_FILE);
begin
    
    process(Clk)
    begin
        if rising_edge(Clk) then
            if En = '1' then
                DoA <= RAM(to_integer(unsigned(AddrA)));
                DoB <= RAM(to_integer(unsigned(AddrB)));
                for i in 0 to C_NB_BYTE - 1 loop
                    if We(i) = '1' then
                        RAM(to_integer(unsigned(Addr)))((i + 1) * C_BYTE_WIDTH - 1 downto i * C_BYTE_WIDTH) <= Di((i+ 1) * C_BYTE_WIDTH - 1 downto i * C_BYTE_WIDTH);
                    end if;
                end loop;
            end if;
        end if;
    end process;
    
end architecture rtl;