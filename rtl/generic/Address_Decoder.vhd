library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

library work;
use work.type_package.all;

entity Address_Decoder is
    generic 
    (
        C_Slaves        :   integer;
        C_Registers     :   integer
    );
    port 
    (
        ARst            :   in  std_logic;
        Clk             :   in  std_logic;

		ADR_I  	        :	in	std_logic_vector(31 downto 2);
		DAT_I  	        :	in	std_logic_vector(31 downto 0);
		WE_I  	        :	in 	std_logic;
		STB_I  	        :	in 	std_logic;
		SEL_I  	        :	in 	std_logic_vector(3 downto 0);
	
		DAT_O           :	out	std_logic_vector(31 downto 0)			:=	(others => '0');
		RSP_ACK_O       :	out	std_logic								:=	'0';
        CMD_ACK_O       :	out	std_logic								:=	'0';
        
        Bus_cmd_io      :   out bus_cmd_t;
        Bus_cmd_io_ce   :   out std_logic_vector(C_Slaves - 1 downto 0);
        Bus_rsp_io      :   in  bus_rsp_array_t(0 to C_Slaves - 1)
    );
end entity Address_Decoder;

architecture rtl of Address_Decoder is
    constant C_SLAVES_N     :   integer := integer(ceil(log2(real(C_Slaves))));
    constant C_REG_N        :   integer := integer(ceil(log2(real(C_Registers)))) + 2;
    signal  LastAddr        :   std_logic_vector(31 downto 2); 
    signal  LastAddrMem     :   std_logic_vector(31 downto 2);
begin
    Bus_cmd_io.ADR    <=  ADR_I;
    Bus_cmd_io.DAT    <=  DAT_I;  	    
    Bus_cmd_io.WE     <=  WE_I; 	    
    Bus_cmd_io.STB    <=  STB_I;
    Bus_cmd_io.SEL    <=  SEL_I;	
    pIO_CPU_READ: process(Clk, ARst)
    begin
        if ARst = '1' then
            RSP_ACK_O <= '0';
        elsif rising_edge(Clk) then
            LastAddrMem <=  LastAddr;
            DAT_O       <=  Bus_rsp_io(to_integer(unsigned(LastAddr(C_SLAVES_N + C_REG_N - 1 downto C_REG_N)))).DAT;
            RSP_ACK_O   <=  Bus_rsp_io(to_integer(unsigned(LastAddr(C_SLAVES_N + C_REG_N - 1 downto C_REG_N)))).RSP_ACK;
        end if;
    end process pIO_CPU_READ;
    LastAddr <= ADR_I when STB_I = '1' else LastAddrMem;
    CMD_ACK_O <=  Bus_rsp_io(to_integer(unsigned(LastAddr(C_SLAVES_N + C_REG_N - 1 downto C_REG_N)))).CMD_ACK;
    genCe: for i in 0 to C_Slaves - 1 generate
        Bus_cmd_io_ce(i) <= STB_I when to_integer(unsigned(LastAddr(C_SLAVES_N + C_REG_N - 1 downto C_REG_N))) = i else '0';
    end generate genCe;
    
end architecture rtl;