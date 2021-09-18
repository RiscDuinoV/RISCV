library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

package utils is


    function bitWidth(value : in integer) return integer;
    function freq2reg(freq : real; sys_freq : real; N : integer) return std_logic_vector;
    function freq2reg(freq : integer; sys_freq : integer; N : integer) return std_logic_vector;
    
    
end package utils;

package body utils is
    function bitWidth(value : in integer) return integer is
        variable ret : integer;
    begin
        if value = 0 then
            ret := -1;
        elsif value = 1 then
            ret := 1;
        else
            ret := integer(ceil(log2(real(value))));
        end if;
        return ret;
    end function;  
    
    function freq2reg(freq : real; sys_freq : real; N : integer) return std_logic_vector is
        variable ret : std_logic_vector(N - 1 downto 0);
    begin
        ret := std_logic_vector(to_unsigned(integer(freq * (2.0**N) / sys_freq), N));
        return ret;
    end function;
    function freq2reg(freq : integer; sys_freq : integer; N : integer) return std_logic_vector is
    begin
        return freq2reg(real(freq), real(sys_freq), N);
    end function;
end package body;