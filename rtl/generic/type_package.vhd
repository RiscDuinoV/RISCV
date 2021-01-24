library ieee;
use ieee.std_logic_1164.all;
use IEEE.math_real.all;

package type_package is
    type bus_cmd_t is record
        ADR     :	std_logic_vector(31 downto 2);
        DAT     :	std_logic_vector(31 downto 0);
        WE      :	std_logic;
        STB     :	std_logic;
        SEL     :	std_logic_vector(3 downto 0);
    end record bus_cmd_t;  

    type bus_rsp_t is record
        DAT     :	std_logic_vector(31 downto 0);
        RSP_ACK :	std_logic;
        CMD_ACK :	std_logic;
    end record bus_rsp_t;
   
    type bus_rsp_array_t is array(natural range <>) of bus_rsp_t;
end package type_package;