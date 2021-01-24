library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
entity fifo is
    generic 
    (
        C_Width :   integer;
        C_Depth :   integer
    );
    port 
    (
        Rst         :   in  std_logic;
        Clk         :   in  std_logic;
        Wr_En       :   in  std_logic;
        Wr_Data     :   in  std_logic_vector(C_Width - 1 downto 0);
        Rd_En       :   in  std_logic;
        Rd_Data     :   out std_logic_vector(C_Width - 1 downto 0);
        Empty_Flag  :   out std_logic;
        Full_Flag   :   out std_logic
    );
end entity fifo;

architecture rtl of fifo is
    type   fifo_t       is array (0 to C_Depth - 1) of std_logic_vector(C_Width - 1 downto 0);
    signal fifo_array   :   fifo_t := (others => (others => '0'));
    signal Wr_Ptr       :   std_logic_vector(integer(ceil(log2(real(C_Depth)))) - 1 downto 0);
    signal Rd_Ptr       :   std_logic_vector(integer(ceil(log2(real(C_Depth)))) - 1 downto 0);
    signal Fifo_Count   :   std_logic_vector(integer(ceil(log2(real(C_Depth)))) - 1 downto 0);
    signal R_Empty_Flag :   std_logic := '0';
    signal R_Full_Flag  :   std_logic := '0';
begin
    
    pFifo: process(Clk)
    begin
        if rising_edge(Clk) then
            if Rst = '1' then
                Wr_Ptr <= (others => '0');
                Rd_Ptr <= (others => '0');
                Fifo_Count <= (others => '0');
                Rd_Data <= (others => '0');
            else
                if Wr_En = '1' and Rd_En = '0' and R_Full_Flag = '0' then
                    Fifo_Count <= Fifo_Count + 1;
                elsif Wr_En = '0' and Rd_En = '1' and R_Empty_Flag = '0' then
                    Fifo_Count <= Fifo_Count - 1;
                end if;
                Rd_Data <= fifo_array(to_integer(unsigned(Rd_Ptr)));
                if Rd_En = '1' and R_Empty_Flag = '0' then
                    if Rd_Ptr = C_Depth - 1 then
                        Rd_Ptr <= (others => '0');
                    else
                        Rd_Ptr  <= Rd_Ptr + 1;
                    end if;
                end if;
                if Wr_En = '1' and R_Full_Flag = '0' then
                    fifo_array(to_integer(unsigned(Wr_Ptr))) <= Wr_Data;
                    if Wr_Ptr = C_Depth - 1 then
                        Wr_Ptr <= (others => '0');
                    else
                        Wr_Ptr <= Wr_Ptr + 1;
                    end if;
                end if;
            end if;
        end if;
    end process pFifo;

    R_Empty_Flag <= '1' when Fifo_Count = 0 else '0';
    R_Full_Flag <= '1' when Fifo_Count = C_Depth - 1 else '0';
    Empty_Flag <= R_Empty_Flag;
    Full_Flag <= R_Full_Flag;
end architecture rtl;