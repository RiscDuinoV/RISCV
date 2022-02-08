library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.TEXTIO.all;
use ieee.std_logic_textio.all;
entity ram_1x2 is
    generic (
        C_RAM_SIZE : integer := 1024;
        C_ADDR_WIDTH : integer := 10;
        C_BYTE_WIDTH : integer := 9;
        C_NB_BYTE : integer := 4;
        C_INIT_FILE : string  := "none"
    );
    port (
        clk_i : in std_logic;
        we_i : in std_logic_vector(C_NB_BYTE - 1 downto 0);
        addr_i : in std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        dat_i : in std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        addr_a_i : in std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        dat_a_o : out std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        addr_b_i : in std_logic_vector(C_ADDR_WIDTH - 1 downto 0);
        dat_b_o : out std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0)
    );
end entity ram_1x2;

architecture rtl of ram_1x2 is
    type ram_t is array (0 to C_RAM_SIZE - 1) of std_logic_vector(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
    impure function read_mem_file(FileName : STRING) return ram_t is
        file file_handle : TEXT;
        variable current_line : LINE;
        variable temp_word : STD_LOGIC_VECTOR(C_NB_BYTE * C_BYTE_WIDTH - 1 downto 0);
        variable result : ram_t := (others => (others => '0'));
    begin
        if FileName /= "none" then
            file_open(file_handle, FileName,  read_mode);
            for i in 0 to C_RAM_SIZE - 1 loop
                exit when endfile(file_handle);
                readline(file_handle, current_line);
                hread(current_line, temp_word);
                result(i) := temp_word;
            end loop;
        end if;
        return result;
    end function;
    signal ram : ram_t := read_mem_file(C_INIT_FILE);
begin
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            dat_a_o <= ram(to_integer(unsigned(addr_a_i)));
            dat_b_o <= ram(to_integer(unsigned(addr_b_i)));
            for i in 0 to C_NB_BYTE - 1 loop
                if we_i(i) = '1' then
                    ram(to_integer(unsigned(addr_i)))((i + 1) * C_BYTE_WIDTH - 1 downto i * C_BYTE_WIDTH) <= dat_i((i + 1) * C_BYTE_WIDTH - 1 downto i * C_BYTE_WIDTH);
                end if;
            end loop;
        end if;
    end process;
    
end architecture rtl;
