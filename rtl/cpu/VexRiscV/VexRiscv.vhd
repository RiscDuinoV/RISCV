-- Generator : SpinalHDL v1.3.8    git head : 57d97088b91271a094cebad32ed86479199955df
-- Date      : 08/07/2020, 12:06:20
-- Component : VexRiscv

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

package pkg_enum is
  type BranchCtrlEnum is (INC,B,JAL,JALR);
  type AluCtrlEnum is (ADD_SUB,SLT_SLTU,BITWISE);
  type ShiftCtrlEnum is (DISABLE_1,SLL_1,SRL_1,SRA_1);
  type EnvCtrlEnum is (NONE,XRET,WFI,ECALL);
  type AluBitwiseCtrlEnum is (XOR_1,OR_1,AND_1);
  type Src2CtrlEnum is (RS,IMI,IMS,PC);
  type Src1CtrlEnum is (RS,IMU,PC_INCREMENT,URS1);

  function pkg_mux (sel : std_logic;one : BranchCtrlEnum;zero : BranchCtrlEnum) return BranchCtrlEnum;
  subtype BranchCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant BranchCtrlEnum_defaultEncoding_INC : BranchCtrlEnum_defaultEncoding_type := "00";
  constant BranchCtrlEnum_defaultEncoding_B : BranchCtrlEnum_defaultEncoding_type := "01";
  constant BranchCtrlEnum_defaultEncoding_JAL : BranchCtrlEnum_defaultEncoding_type := "10";
  constant BranchCtrlEnum_defaultEncoding_JALR : BranchCtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic;one : AluCtrlEnum;zero : AluCtrlEnum) return AluCtrlEnum;
  subtype AluCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant AluCtrlEnum_defaultEncoding_ADD_SUB : AluCtrlEnum_defaultEncoding_type := "00";
  constant AluCtrlEnum_defaultEncoding_SLT_SLTU : AluCtrlEnum_defaultEncoding_type := "01";
  constant AluCtrlEnum_defaultEncoding_BITWISE : AluCtrlEnum_defaultEncoding_type := "10";

  function pkg_mux (sel : std_logic;one : ShiftCtrlEnum;zero : ShiftCtrlEnum) return ShiftCtrlEnum;
  subtype ShiftCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant ShiftCtrlEnum_defaultEncoding_DISABLE_1 : ShiftCtrlEnum_defaultEncoding_type := "00";
  constant ShiftCtrlEnum_defaultEncoding_SLL_1 : ShiftCtrlEnum_defaultEncoding_type := "01";
  constant ShiftCtrlEnum_defaultEncoding_SRL_1 : ShiftCtrlEnum_defaultEncoding_type := "10";
  constant ShiftCtrlEnum_defaultEncoding_SRA_1 : ShiftCtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic;one : EnvCtrlEnum;zero : EnvCtrlEnum) return EnvCtrlEnum;
  subtype EnvCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant EnvCtrlEnum_defaultEncoding_NONE : EnvCtrlEnum_defaultEncoding_type := "00";
  constant EnvCtrlEnum_defaultEncoding_XRET : EnvCtrlEnum_defaultEncoding_type := "01";
  constant EnvCtrlEnum_defaultEncoding_WFI : EnvCtrlEnum_defaultEncoding_type := "10";
  constant EnvCtrlEnum_defaultEncoding_ECALL : EnvCtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic;one : AluBitwiseCtrlEnum;zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum;
  subtype AluBitwiseCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "00";
  constant AluBitwiseCtrlEnum_defaultEncoding_OR_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "01";
  constant AluBitwiseCtrlEnum_defaultEncoding_AND_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "10";

  function pkg_mux (sel : std_logic;one : Src2CtrlEnum;zero : Src2CtrlEnum) return Src2CtrlEnum;
  subtype Src2CtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant Src2CtrlEnum_defaultEncoding_RS : Src2CtrlEnum_defaultEncoding_type := "00";
  constant Src2CtrlEnum_defaultEncoding_IMI : Src2CtrlEnum_defaultEncoding_type := "01";
  constant Src2CtrlEnum_defaultEncoding_IMS : Src2CtrlEnum_defaultEncoding_type := "10";
  constant Src2CtrlEnum_defaultEncoding_PC : Src2CtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic;one : Src1CtrlEnum;zero : Src1CtrlEnum) return Src1CtrlEnum;
  subtype Src1CtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant Src1CtrlEnum_defaultEncoding_RS : Src1CtrlEnum_defaultEncoding_type := "00";
  constant Src1CtrlEnum_defaultEncoding_IMU : Src1CtrlEnum_defaultEncoding_type := "01";
  constant Src1CtrlEnum_defaultEncoding_PC_INCREMENT : Src1CtrlEnum_defaultEncoding_type := "10";
  constant Src1CtrlEnum_defaultEncoding_URS1 : Src1CtrlEnum_defaultEncoding_type := "11";

end pkg_enum;

package body pkg_enum is
  function pkg_mux (sel : std_logic;one : BranchCtrlEnum;zero : BranchCtrlEnum) return BranchCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : AluCtrlEnum;zero : AluCtrlEnum) return AluCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : ShiftCtrlEnum;zero : ShiftCtrlEnum) return ShiftCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : EnvCtrlEnum;zero : EnvCtrlEnum) return EnvCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : AluBitwiseCtrlEnum;zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : Src2CtrlEnum;zero : Src2CtrlEnum) return Src2CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : Src1CtrlEnum;zero : Src1CtrlEnum) return Src1CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

end pkg_enum;


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic;
  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector;
  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector;
  function pkg_not (value : std_logic_vector) return std_logic_vector;
  function pkg_extract (that : unsigned; bitId : integer) return std_logic;
  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned;
  function pkg_cat (a : unsigned; b : unsigned) return unsigned;
  function pkg_not (value : unsigned) return unsigned;
  function pkg_extract (that : signed; bitId : integer) return std_logic;
  function pkg_extract (that : signed; base : unsigned; size : integer) return signed;
  function pkg_cat (a : signed; b : signed) return signed;
  function pkg_not (value : signed) return signed;


  function pkg_mux (sel : std_logic;one : std_logic;zero : std_logic) return std_logic;
  function pkg_mux (sel : std_logic;one : std_logic_vector;zero : std_logic_vector) return std_logic_vector;
  function pkg_mux (sel : std_logic;one : unsigned;zero : unsigned) return unsigned;
  function pkg_mux (sel : std_logic;one : signed;zero : signed) return signed;


  function pkg_toStdLogic (value : boolean) return std_logic;
  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector;
  function pkg_toUnsigned(value : std_logic) return unsigned;
  function pkg_toSigned (value : std_logic) return signed;
  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector;
  function pkg_unsigned (lit : unsigned) return unsigned;
  function pkg_signed (lit : signed) return signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector;
  function pkg_resize (that : unsigned; width : integer) return unsigned;
  function pkg_resize (that : signed; width : integer) return signed;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector;
  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned;
  function pkg_extract (that : signed; high : integer; low : integer) return signed;

  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;

  function pkg_shiftRight (that : unsigned; size : natural) return unsigned;
  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned;

  function pkg_shiftRight (that : signed; size : natural) return signed;
  function pkg_shiftRight (that : signed; size : unsigned) return signed;
  function pkg_shiftLeft (that : signed; size : natural) return signed;
  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;
end  pkg_scala2hdl;

package body pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;


  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of std_logic_vector(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;


  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector is
    variable cat : std_logic_vector(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;


  function pkg_not (value : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(value'high downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  function pkg_extract (that : unsigned; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;


  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of unsigned(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;


  function pkg_cat (a : unsigned; b : unsigned) return unsigned is
    variable cat : unsigned(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;


  function pkg_not (value : unsigned) return unsigned is
    variable ret : unsigned(value'high downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  function pkg_extract (that : signed; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;


  function pkg_extract (that : signed; base : unsigned; size : integer) return signed is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of signed(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;


  function pkg_cat (a : signed; b : signed) return signed is
    variable cat : signed(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;


  function pkg_not (value : signed) return signed is
    variable ret : signed(value'high downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;



  -- unsigned shifts
  function pkg_shiftRight (that : unsigned; size : natural) return unsigned is
  begin
    if size >= that'length then
      return "";
    else
      return shift_right(that,size)(that'high-size downto 0);
    end if;
  end pkg_shiftRight;

  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned is
  begin
    return shift_left(resize(that,that'length + size),size);
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_left(resize(that,that'length + 2**size'length - 1),to_integer(size));
  end pkg_shiftLeft;


  -- std_logic_vector shifts
  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  -- signed shifts
  function pkg_shiftRight (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : signed; size : unsigned) return signed is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed is
  begin
    return shift_left(resize(that,w),to_integer(size));
  end pkg_shiftLeft;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(rotate_left(unsigned(that),to_integer(size)));
  end pkg_rotateLeft;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector is
    variable temp : std_logic_vector(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned is
    variable temp : unsigned(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_extract (that : signed; high : integer; low : integer) return signed is
    variable temp : signed(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_mux (sel : std_logic;one : std_logic;zero : std_logic) return std_logic is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic;one : std_logic_vector;zero : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(zero'range);  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;  end pkg_mux;

  function pkg_mux (sel : std_logic;one : unsigned;zero : unsigned) return unsigned is
    variable ret : unsigned(zero'range);  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;  end pkg_mux;

  function pkg_mux (sel : std_logic;one : signed;zero : signed) return signed is
    variable ret : signed(zero'range);  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;  end pkg_mux;

  function pkg_toStdLogic (value : boolean) return std_logic is
  begin
    if value = true then
      return '1';
    else
      return '0';
    end if;
  end pkg_toStdLogic;

  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toStdLogicVector;

  function pkg_toUnsigned (value : std_logic) return unsigned is
    variable ret : unsigned(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toUnsigned;

  function pkg_toSigned (value : std_logic) return signed is
    variable ret : signed(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toSigned;

  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(lit'length-1 downto 0);
  begin
    ret := lit;    return ret;
  end pkg_stdLogicVector;

  function pkg_unsigned (lit : unsigned) return unsigned is
    variable ret : unsigned(lit'length-1 downto 0);
  begin
    ret := lit;    return ret;
  end pkg_unsigned;

  function pkg_signed (lit : signed) return signed is
    variable ret : signed(lit'length-1 downto 0);
  begin
    ret := lit;    return ret;
  end pkg_signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(that),width));
  end pkg_resize;


  function pkg_resize (that : unsigned; width : integer) return unsigned is
	  variable ret : unsigned(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    else
       ret := resize(that,width);
    end if;
		return ret;
  end pkg_resize;
 
  function pkg_resize (that : signed; width : integer) return signed is
	  variable ret : signed(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    elsif that'length >= width then
       ret := that(width-1 downto 0);
    else
       ret := resize(that,width);
    end if;
		return ret;
  end pkg_resize;
 end pkg_scala2hdl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity StreamFifoLowLatency is
  port(
    io_push_valid : in std_logic;
    io_push_ready : out std_logic;
    io_push_payload_error : in std_logic;
    io_push_payload_inst : in std_logic_vector(31 downto 0);
    io_pop_valid : out std_logic;
    io_pop_ready : in std_logic;
    io_pop_payload_error : out std_logic;
    io_pop_payload_inst : out std_logic_vector(31 downto 0);
    io_flush : in std_logic;
    io_occupancy : out unsigned(0 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end StreamFifoLowLatency;

architecture arch of StreamFifoLowLatency is
  signal zz_4 : std_logic;
  signal zz_5 : std_logic;
  signal zz_6 : std_logic;

  signal zz_1 : std_logic;
  signal pushPtr_willIncrement : std_logic;
  signal pushPtr_willClear : std_logic;
  signal pushPtr_willOverflowIfInc : std_logic;
  signal pushPtr_willOverflow : std_logic;
  signal popPtr_willIncrement : std_logic;
  signal popPtr_willClear : std_logic;
  signal popPtr_willOverflowIfInc : std_logic;
  signal popPtr_willOverflow : std_logic;
  signal ptrMatch : std_logic;
  signal risingOccupancy : std_logic;
  signal empty : std_logic;
  signal full : std_logic;
  signal pushing : std_logic;
  signal popping : std_logic;
  signal zz_2 : std_logic_vector(32 downto 0);
  signal zz_3 : std_logic_vector(32 downto 0);
begin
  io_push_ready <= zz_4;
  io_pop_valid <= zz_5;
  zz_6 <= (not empty);
  process(pushing)
  begin
    zz_1 <= pkg_toStdLogic(false);
    if pushing = '1' then
      zz_1 <= pkg_toStdLogic(true);
    end if;
  end process;

  process(pushing)
  begin
    pushPtr_willIncrement <= pkg_toStdLogic(false);
    if pushing = '1' then
      pushPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    pushPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      pushPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  pushPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  pushPtr_willOverflow <= (pushPtr_willOverflowIfInc and pushPtr_willIncrement);
  process(popping)
  begin
    popPtr_willIncrement <= pkg_toStdLogic(false);
    if popping = '1' then
      popPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    popPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      popPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  popPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  popPtr_willOverflow <= (popPtr_willOverflowIfInc and popPtr_willIncrement);
  ptrMatch <= pkg_toStdLogic(true);
  empty <= (ptrMatch and (not risingOccupancy));
  full <= (ptrMatch and risingOccupancy);
  pushing <= (io_push_valid and zz_4);
  popping <= (zz_5 and io_pop_ready);
  zz_4 <= (not full);
  process(zz_6,io_push_valid)
  begin
    if zz_6 = '1' then
      zz_5 <= pkg_toStdLogic(true);
    else
      zz_5 <= io_push_valid;
    end if;
  end process;

  zz_2 <= zz_3;
  process(zz_6,zz_2,io_push_payload_error)
  begin
    if zz_6 = '1' then
      io_pop_payload_error <= pkg_extract(pkg_extract(zz_2,0,0),0);
    else
      io_pop_payload_error <= io_push_payload_error;
    end if;
  end process;

  process(zz_6,zz_2,io_push_payload_inst)
  begin
    if zz_6 = '1' then
      io_pop_payload_inst <= pkg_extract(zz_2,32,1);
    else
      io_pop_payload_inst <= io_push_payload_inst;
    end if;
  end process;

  io_occupancy <= unsigned(pkg_toStdLogicVector((risingOccupancy and ptrMatch)));
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
      risingOccupancy <= pkg_toStdLogic(false);
      else
        if pkg_toStdLogic(pushing /= popping) = '1' then
          risingOccupancy <= pushing;
        end if;
        if io_flush = '1' then
          risingOccupancy <= pkg_toStdLogic(false);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_1 = '1' then
        zz_3 <= pkg_cat(io_push_payload_inst,pkg_toStdLogicVector(io_push_payload_error));
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity VexRiscv is
  port(
    iBus_cmd_valid : out std_logic;
    iBus_cmd_ready : in std_logic;
    iBus_rsp_valid : in std_logic;
    iBus_rsp_payload_error : in std_logic;
    iBus_rsp_payload_inst : in std_logic_vector(31 downto 0);
    timerInterrupt : in std_logic;
    externalInterrupt : in std_logic;
    softwareInterrupt : in std_logic;
    dBus_cmd_valid : out std_logic;
    dBus_cmd_ready : in std_logic;
    dBus_cmd_payload_wr : out std_logic;
    dBus_cmd_payload_data : out std_logic_vector(31 downto 0);
    dBus_rsp_ready : in std_logic;
    dBus_rsp_error : in std_logic;
    dBus_rsp_data : in std_logic_vector(31 downto 0);
    iBus_cmd_payload_pc : out std_logic_vector(31 downto 0);
    dBus_cmd_payload_address : out std_logic_vector(31 downto 0);
    dBus_cmd_payload_size : out std_logic_vector(1 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end VexRiscv;

architecture arch of VexRiscv is
  signal zz_110 : std_logic_vector(31 downto 0);
  signal zz_111 : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy : unsigned(0 downto 0);
  signal zz_112 : std_logic;
  signal zz_113 : std_logic;
  signal zz_114 : std_logic;
  signal zz_115 : std_logic;
  signal zz_116 : std_logic_vector(1 downto 0);
  signal zz_117 : std_logic;
  signal zz_118 : std_logic;
  signal zz_119 : std_logic;
  signal zz_120 : std_logic;
  signal zz_121 : std_logic;
  signal zz_122 : std_logic;
  signal zz_123 : std_logic;
  signal zz_124 : std_logic;
  signal zz_125 : std_logic;
  signal zz_126 : std_logic;
  signal zz_127 : std_logic;
  signal zz_128 : std_logic;
  signal zz_129 : std_logic_vector(1 downto 0);
  signal zz_130 : std_logic;
  signal zz_131 : std_logic;
  signal zz_132 : std_logic;
  signal zz_133 : std_logic_vector(31 downto 0);
  signal zz_134 : std_logic;
  signal zz_135 : std_logic_vector(0 downto 0);
  signal zz_136 : std_logic_vector(1 downto 0);
  signal zz_137 : std_logic_vector(0 downto 0);
  signal zz_138 : std_logic_vector(0 downto 0);
  signal zz_139 : std_logic_vector(1 downto 0);
  signal zz_140 : std_logic_vector(1 downto 0);
  signal zz_141 : std_logic;
  signal zz_142 : std_logic_vector(0 downto 0);
  signal zz_143 : std_logic_vector(19 downto 0);
  signal zz_144 : std_logic_vector(31 downto 0);
  signal zz_145 : std_logic_vector(31 downto 0);
  signal zz_146 : std_logic_vector(31 downto 0);
  signal zz_147 : std_logic;
  signal zz_148 : std_logic;
  signal zz_149 : std_logic_vector(31 downto 0);
  signal zz_150 : std_logic_vector(31 downto 0);
  signal zz_151 : std_logic_vector(31 downto 0);
  signal zz_152 : std_logic_vector(31 downto 0);
  signal zz_153 : std_logic;
  signal zz_154 : std_logic_vector(0 downto 0);
  signal zz_155 : std_logic_vector(0 downto 0);
  signal zz_156 : std_logic_vector(0 downto 0);
  signal zz_157 : std_logic_vector(0 downto 0);
  signal zz_158 : std_logic;
  signal zz_159 : std_logic_vector(0 downto 0);
  signal zz_160 : std_logic_vector(17 downto 0);
  signal zz_161 : std_logic_vector(31 downto 0);
  signal zz_162 : std_logic_vector(31 downto 0);
  signal zz_163 : std_logic_vector(31 downto 0);
  signal zz_164 : std_logic_vector(31 downto 0);
  signal zz_165 : std_logic;
  signal zz_166 : std_logic_vector(1 downto 0);
  signal zz_167 : std_logic_vector(1 downto 0);
  signal zz_168 : std_logic;
  signal zz_169 : std_logic_vector(0 downto 0);
  signal zz_170 : std_logic_vector(14 downto 0);
  signal zz_171 : std_logic_vector(31 downto 0);
  signal zz_172 : std_logic_vector(31 downto 0);
  signal zz_173 : std_logic_vector(31 downto 0);
  signal zz_174 : std_logic_vector(31 downto 0);
  signal zz_175 : std_logic_vector(31 downto 0);
  signal zz_176 : std_logic_vector(31 downto 0);
  signal zz_177 : std_logic_vector(0 downto 0);
  signal zz_178 : std_logic_vector(0 downto 0);
  signal zz_179 : std_logic_vector(1 downto 0);
  signal zz_180 : std_logic_vector(1 downto 0);
  signal zz_181 : std_logic;
  signal zz_182 : std_logic_vector(0 downto 0);
  signal zz_183 : std_logic_vector(11 downto 0);
  signal zz_184 : std_logic_vector(31 downto 0);
  signal zz_185 : std_logic_vector(31 downto 0);
  signal zz_186 : std_logic_vector(31 downto 0);
  signal zz_187 : std_logic_vector(31 downto 0);
  signal zz_188 : std_logic_vector(31 downto 0);
  signal zz_189 : std_logic;
  signal zz_190 : std_logic_vector(0 downto 0);
  signal zz_191 : std_logic_vector(0 downto 0);
  signal zz_192 : std_logic;
  signal zz_193 : std_logic_vector(0 downto 0);
  signal zz_194 : std_logic_vector(8 downto 0);
  signal zz_195 : std_logic_vector(31 downto 0);
  signal zz_196 : std_logic_vector(31 downto 0);
  signal zz_197 : std_logic;
  signal zz_198 : std_logic;
  signal zz_199 : std_logic_vector(31 downto 0);
  signal zz_200 : std_logic_vector(31 downto 0);
  signal zz_201 : std_logic_vector(0 downto 0);
  signal zz_202 : std_logic_vector(0 downto 0);
  signal zz_203 : std_logic_vector(1 downto 0);
  signal zz_204 : std_logic_vector(1 downto 0);
  signal zz_205 : std_logic;
  signal zz_206 : std_logic_vector(0 downto 0);
  signal zz_207 : std_logic_vector(4 downto 0);
  signal zz_208 : std_logic_vector(31 downto 0);
  signal zz_209 : std_logic_vector(31 downto 0);
  signal zz_210 : std_logic_vector(31 downto 0);
  signal zz_211 : std_logic_vector(31 downto 0);
  signal zz_212 : std_logic_vector(31 downto 0);
  signal zz_213 : std_logic_vector(31 downto 0);
  signal zz_214 : std_logic_vector(31 downto 0);
  signal zz_215 : std_logic_vector(31 downto 0);
  signal zz_216 : std_logic_vector(2 downto 0);
  signal zz_217 : std_logic_vector(2 downto 0);
  signal zz_218 : std_logic;
  signal zz_219 : std_logic_vector(0 downto 0);
  signal zz_220 : std_logic_vector(1 downto 0);
  signal zz_221 : std_logic_vector(31 downto 0);
  signal zz_222 : std_logic_vector(31 downto 0);
  signal zz_223 : std_logic_vector(31 downto 0);
  signal zz_224 : std_logic_vector(31 downto 0);
  signal zz_225 : std_logic_vector(31 downto 0);
  signal zz_226 : std_logic_vector(31 downto 0);
  signal zz_227 : std_logic_vector(31 downto 0);
  signal zz_228 : std_logic_vector(31 downto 0);
  signal zz_229 : std_logic_vector(0 downto 0);
  signal zz_230 : std_logic_vector(4 downto 0);
  signal zz_231 : std_logic_vector(0 downto 0);
  signal zz_232 : std_logic_vector(2 downto 0);
  signal zz_233 : std_logic_vector(31 downto 0);
  signal zz_234 : std_logic_vector(31 downto 0);
  signal zz_235 : std_logic_vector(31 downto 0);
  signal zz_236 : std_logic;
  signal zz_237 : std_logic_vector(0 downto 0);
  signal zz_238 : std_logic_vector(0 downto 0);
  signal zz_239 : std_logic_vector(31 downto 0);
  signal zz_240 : std_logic_vector(31 downto 0);
  signal zz_241 : std_logic_vector(31 downto 0);

  signal decode_CSR_READ_OPCODE : std_logic;
  signal decode_SRC2_FORCE_ZERO : std_logic;
  signal decode_RS2 : std_logic_vector(31 downto 0);
  signal decode_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal zz_1 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_2 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_3 : BranchCtrlEnum_defaultEncoding_type;
  signal memory_PC : unsigned(31 downto 0);
  signal decode_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal zz_4 : AluCtrlEnum_defaultEncoding_type;
  signal zz_5 : AluCtrlEnum_defaultEncoding_type;
  signal zz_6 : AluCtrlEnum_defaultEncoding_type;
  signal decode_MEMORY_ENABLE : std_logic;
  signal decode_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal execute_BRANCH_CALC : unsigned(31 downto 0);
  signal execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_SRC2 : std_logic_vector(31 downto 0);
  signal writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_BRANCH_DO : std_logic;
  signal decode_MEMORY_STORE : std_logic;
  signal decode_IS_CSR : std_logic;
  signal zz_7 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_8 : ShiftCtrlEnum_defaultEncoding_type;
  signal decode_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_9 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_10 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_11 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_12 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_13 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_14 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_15 : EnvCtrlEnum_defaultEncoding_type;
  signal decode_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_16 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_17 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_18 : EnvCtrlEnum_defaultEncoding_type;
  signal decode_SRC_LESS_UNSIGNED : std_logic;
  signal memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal execute_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal decode_CSR_WRITE_OPCODE : std_logic;
  signal decode_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_19 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_20 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_21 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal decode_SRC1 : std_logic_vector(31 downto 0);
  signal decode_RS1 : std_logic_vector(31 downto 0);
  signal execute_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal memory_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal memory_BRANCH_CALC : unsigned(31 downto 0);
  signal memory_BRANCH_DO : std_logic;
  signal execute_PC : unsigned(31 downto 0);
  signal execute_RS1 : std_logic_vector(31 downto 0);
  signal execute_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal zz_22 : BranchCtrlEnum_defaultEncoding_type;
  signal decode_RS2_USE : std_logic;
  signal decode_RS1_USE : std_logic;
  signal execute_REGFILE_WRITE_VALID : std_logic;
  signal execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal memory_REGFILE_WRITE_VALID : std_logic;
  signal memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal writeBack_REGFILE_WRITE_VALID : std_logic;
  signal memory_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal zz_23 : std_logic_vector(31 downto 0);
  signal memory_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_24 : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_25 : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_SRC_LESS_UNSIGNED : std_logic;
  signal execute_SRC2_FORCE_ZERO : std_logic;
  signal execute_SRC_USE_SUB_LESS : std_logic;
  signal zz_26 : unsigned(31 downto 0);
  signal zz_27 : std_logic_vector(31 downto 0);
  signal decode_SRC2_CTRL : Src2CtrlEnum_defaultEncoding_type;
  signal zz_28 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_29 : std_logic_vector(31 downto 0);
  signal decode_SRC1_CTRL : Src1CtrlEnum_defaultEncoding_type;
  signal zz_30 : Src1CtrlEnum_defaultEncoding_type;
  signal decode_SRC_USE_SUB_LESS : std_logic;
  signal decode_SRC_ADD_ZERO : std_logic;
  signal execute_SRC_ADD_SUB : std_logic_vector(31 downto 0);
  signal execute_SRC_LESS : std_logic;
  signal execute_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal zz_31 : AluCtrlEnum_defaultEncoding_type;
  signal execute_SRC2 : std_logic_vector(31 downto 0);
  signal execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_32 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_33 : std_logic_vector(31 downto 0);
  signal zz_34 : std_logic;
  signal zz_35 : std_logic;
  signal decode_INSTRUCTION_ANTICIPATED : std_logic_vector(31 downto 0);
  signal decode_REGFILE_WRITE_VALID : std_logic;
  signal zz_36 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_37 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_38 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_39 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_40 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_41 : AluCtrlEnum_defaultEncoding_type;
  signal zz_42 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_43 : std_logic_vector(31 downto 0);
  signal execute_SRC1 : std_logic_vector(31 downto 0);
  signal execute_CSR_READ_OPCODE : std_logic;
  signal execute_CSR_WRITE_OPCODE : std_logic;
  signal execute_IS_CSR : std_logic;
  signal memory_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_44 : EnvCtrlEnum_defaultEncoding_type;
  signal execute_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_45 : EnvCtrlEnum_defaultEncoding_type;
  signal writeBack_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_46 : EnvCtrlEnum_defaultEncoding_type;
  signal writeBack_MEMORY_STORE : std_logic;
  signal zz_47 : std_logic_vector(31 downto 0);
  signal writeBack_MEMORY_ENABLE : std_logic;
  signal writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal memory_MEMORY_STORE : std_logic;
  signal memory_MEMORY_ENABLE : std_logic;
  signal execute_SRC_ADD : std_logic_vector(31 downto 0);
  signal execute_RS2 : std_logic_vector(31 downto 0);
  signal execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal execute_MEMORY_STORE : std_logic;
  signal execute_MEMORY_ENABLE : std_logic;
  signal execute_ALIGNEMENT_FAULT : std_logic;
  signal zz_48 : unsigned(31 downto 0);
  signal decode_PC : unsigned(31 downto 0);
  signal decode_INSTRUCTION : std_logic_vector(31 downto 0);
  signal writeBack_PC : unsigned(31 downto 0);
  signal writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal decode_arbitration_haltItself : std_logic;
  signal decode_arbitration_haltByOther : std_logic;
  signal decode_arbitration_removeIt : std_logic;
  signal decode_arbitration_flushIt : std_logic;
  signal decode_arbitration_flushNext : std_logic;
  signal decode_arbitration_isValid : std_logic;
  signal decode_arbitration_isStuck : std_logic;
  signal decode_arbitration_isStuckByOthers : std_logic;
  signal decode_arbitration_isFlushed : std_logic;
  signal decode_arbitration_isMoving : std_logic;
  signal decode_arbitration_isFiring : std_logic;
  signal execute_arbitration_haltItself : std_logic;
  signal execute_arbitration_haltByOther : std_logic;
  signal execute_arbitration_removeIt : std_logic;
  signal execute_arbitration_flushIt : std_logic;
  signal execute_arbitration_flushNext : std_logic;
  signal execute_arbitration_isValid : std_logic;
  signal execute_arbitration_isStuck : std_logic;
  signal execute_arbitration_isStuckByOthers : std_logic;
  signal execute_arbitration_isFlushed : std_logic;
  signal execute_arbitration_isMoving : std_logic;
  signal execute_arbitration_isFiring : std_logic;
  signal memory_arbitration_haltItself : std_logic;
  signal memory_arbitration_haltByOther : std_logic;
  signal memory_arbitration_removeIt : std_logic;
  signal memory_arbitration_flushIt : std_logic;
  signal memory_arbitration_flushNext : std_logic;
  signal memory_arbitration_isValid : std_logic;
  signal memory_arbitration_isStuck : std_logic;
  signal memory_arbitration_isStuckByOthers : std_logic;
  signal memory_arbitration_isFlushed : std_logic;
  signal memory_arbitration_isMoving : std_logic;
  signal memory_arbitration_isFiring : std_logic;
  signal writeBack_arbitration_haltItself : std_logic;
  signal writeBack_arbitration_haltByOther : std_logic;
  signal writeBack_arbitration_removeIt : std_logic;
  signal writeBack_arbitration_flushIt : std_logic;
  signal writeBack_arbitration_flushNext : std_logic;
  signal writeBack_arbitration_isValid : std_logic;
  signal writeBack_arbitration_isStuck : std_logic;
  signal writeBack_arbitration_isStuckByOthers : std_logic;
  signal writeBack_arbitration_isFlushed : std_logic;
  signal writeBack_arbitration_isMoving : std_logic;
  signal writeBack_arbitration_isFiring : std_logic;
  signal lastStageInstruction : std_logic_vector(31 downto 0);
  signal lastStagePc : unsigned(31 downto 0);
  signal lastStageIsValid : std_logic;
  signal lastStageIsFiring : std_logic;
  signal IBusSimplePlugin_fetcherHalt : std_logic;
  signal IBusSimplePlugin_fetcherflushIt : std_logic;
  signal IBusSimplePlugin_incomingInstruction : std_logic;
  signal IBusSimplePlugin_pcValids_0 : std_logic;
  signal IBusSimplePlugin_pcValids_1 : std_logic;
  signal IBusSimplePlugin_pcValids_2 : std_logic;
  signal IBusSimplePlugin_pcValids_3 : std_logic;
  signal zz_49 : unsigned(31 downto 0);
  signal CsrPlugin_inWfi : std_logic;
  signal CsrPlugin_thirdPartyWake : std_logic;
  signal CsrPlugin_jumpInterface_valid : std_logic;
  signal CsrPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal CsrPlugin_exceptionPendings_0 : std_logic;
  signal CsrPlugin_exceptionPendings_1 : std_logic;
  signal CsrPlugin_exceptionPendings_2 : std_logic;
  signal CsrPlugin_exceptionPendings_3 : std_logic;
  signal contextSwitching : std_logic;
  signal CsrPlugin_privilege : unsigned(1 downto 0);
  signal CsrPlugin_forceMachineWire : std_logic;
  signal CsrPlugin_selfException_valid : std_logic;
  signal CsrPlugin_selfException_payload_code : unsigned(3 downto 0);
  signal CsrPlugin_selfException_payload_badAddr : unsigned(31 downto 0);
  signal CsrPlugin_allowInterrupts : std_logic;
  signal CsrPlugin_allowException : std_logic;
  signal BranchPlugin_jumpInterface_valid : std_logic;
  signal BranchPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_jump_pcLoad_valid : std_logic;
  signal IBusSimplePlugin_jump_pcLoad_payload : unsigned(31 downto 0);
  signal zz_50 : unsigned(1 downto 0);
  signal IBusSimplePlugin_fetchPc_output_valid : std_logic;
  signal IBusSimplePlugin_fetchPc_output_ready : std_logic;
  signal IBusSimplePlugin_fetchPc_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_pcReg : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_corrected : std_logic;
  signal IBusSimplePlugin_fetchPc_pcRegPropagate : std_logic;
  signal IBusSimplePlugin_fetchPc_booted : std_logic;
  signal IBusSimplePlugin_fetchPc_inc : std_logic;
  signal IBusSimplePlugin_fetchPc_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_inputSample : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_inputSample : std_logic;
  signal zz_51 : std_logic;
  signal zz_52 : std_logic;
  signal zz_53 : std_logic;
  signal zz_54 : std_logic;
  signal zz_55 : std_logic;
  signal IBusSimplePlugin_iBusRsp_readyForError : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_isRvc : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_valid : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_ready : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_isRvc : std_logic;
  signal zz_56 : std_logic;
  signal zz_57 : unsigned(31 downto 0);
  signal zz_58 : std_logic;
  signal zz_59 : std_logic_vector(31 downto 0);
  signal zz_60 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_0 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_1 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_2 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_3 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_4 : std_logic;
  signal IBusSimplePlugin_injector_decodeRemoved : std_logic;
  signal IBusSimplePlugin_injector_formal_rawInDecode : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_cmd_valid : std_logic;
  signal IBusSimplePlugin_cmd_ready : std_logic;
  signal IBusSimplePlugin_cmd_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_pendingCmd : unsigned(2 downto 0);
  signal IBusSimplePlugin_pendingCmdNext : unsigned(2 downto 0);
  signal IBusSimplePlugin_rspJoin_discardCounter : unsigned(2 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBufferOutput_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBufferOutput_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst : std_logic_vector(31 downto 0);
  signal iBus_rsp_takeWhen_valid : std_logic;
  signal iBus_rsp_takeWhen_payload_error : std_logic;
  signal iBus_rsp_takeWhen_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_isRvc : std_logic;
  signal IBusSimplePlugin_rspJoin_join_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_join_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_isRvc : std_logic;
  signal IBusSimplePlugin_rspJoin_exceptionDetected : std_logic;
  signal IBusSimplePlugin_rspJoin_redoRequired : std_logic;
  signal zz_61 : std_logic;
  signal zz_62 : unsigned(31 downto 0);
  signal zz_63 : unsigned(1 downto 0);
  signal zz_64 : std_logic;
  signal execute_DBusSimplePlugin_skipCmd : std_logic;
  signal zz_65 : std_logic_vector(31 downto 0);
  signal zz_66 : std_logic_vector(3 downto 0);
  signal execute_DBusSimplePlugin_formalMask : std_logic_vector(3 downto 0);
  signal writeBack_DBusSimplePlugin_rspShifted : std_logic_vector(31 downto 0);
  signal zz_67 : std_logic;
  signal zz_68 : std_logic_vector(31 downto 0);
  signal zz_69 : std_logic;
  signal zz_70 : std_logic_vector(31 downto 0);
  signal writeBack_DBusSimplePlugin_rspFormated : std_logic_vector(31 downto 0);
  signal CsrPlugin_misa_base : unsigned(1 downto 0);
  signal CsrPlugin_misa_extensions : std_logic_vector(25 downto 0);
  signal CsrPlugin_mtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_mtvec_base : unsigned(29 downto 0);
  signal CsrPlugin_mepc : unsigned(31 downto 0);
  signal CsrPlugin_mstatus_MIE : std_logic;
  signal CsrPlugin_mstatus_MPIE : std_logic;
  signal CsrPlugin_mstatus_MPP : unsigned(1 downto 0);
  signal CsrPlugin_mip_MEIP : std_logic;
  signal CsrPlugin_mip_MTIP : std_logic;
  signal CsrPlugin_mip_MSIP : std_logic;
  signal CsrPlugin_mie_MEIE : std_logic;
  signal CsrPlugin_mie_MTIE : std_logic;
  signal CsrPlugin_mie_MSIE : std_logic;
  signal CsrPlugin_mscratch : std_logic_vector(31 downto 0);
  signal CsrPlugin_mcause_interrupt : std_logic;
  signal CsrPlugin_mcause_exceptionCode : unsigned(3 downto 0);
  signal CsrPlugin_mtval : unsigned(31 downto 0);
  signal CsrPlugin_mcycle : unsigned(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
  signal CsrPlugin_minstret : unsigned(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
  signal zz_71 : std_logic;
  signal zz_72 : std_logic;
  signal zz_73 : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_decode : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_execute : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_memory : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionContext_code : unsigned(3 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr : unsigned(31 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : unsigned(1 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_interrupt_valid : std_logic;
  signal CsrPlugin_interrupt_code : unsigned(3 downto 0);
  signal CsrPlugin_interrupt_targetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_exception : std_logic;
  signal CsrPlugin_lastStageWasWfi : std_logic;
  signal CsrPlugin_pipelineLiberator_done : std_logic;
  signal CsrPlugin_interruptJump : std_logic;
  signal CsrPlugin_hadException : std_logic;
  signal CsrPlugin_targetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_trapCause : unsigned(3 downto 0);
  signal CsrPlugin_xtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_xtvec_base : unsigned(29 downto 0);
  signal execute_CsrPlugin_wfiWake : std_logic;
  signal execute_CsrPlugin_blockedBySideEffects : std_logic;
  signal execute_CsrPlugin_illegalAccess : std_logic;
  signal execute_CsrPlugin_illegalInstruction : std_logic;
  signal execute_CsrPlugin_readData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_writeInstruction : std_logic;
  signal execute_CsrPlugin_readInstruction : std_logic;
  signal execute_CsrPlugin_writeEnable : std_logic;
  signal execute_CsrPlugin_readEnable : std_logic;
  signal execute_CsrPlugin_readToWriteData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_writeData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_csrAddress : std_logic_vector(11 downto 0);
  signal zz_74 : std_logic_vector(25 downto 0);
  signal zz_75 : std_logic;
  signal zz_76 : std_logic;
  signal zz_77 : std_logic;
  signal zz_78 : std_logic;
  signal zz_79 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_80 : AluCtrlEnum_defaultEncoding_type;
  signal zz_81 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_82 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_83 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_84 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_85 : Src2CtrlEnum_defaultEncoding_type;
  signal decode_RegFilePlugin_regFileReadAddress1 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_regFileReadAddress2 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_rs1Data : std_logic_vector(31 downto 0);
  signal decode_RegFilePlugin_rs2Data : std_logic_vector(31 downto 0);
  signal lastStageRegFileWrite_valid : std_logic;
  signal lastStageRegFileWrite_payload_address : unsigned(4 downto 0);
  signal lastStageRegFileWrite_payload_data : std_logic_vector(31 downto 0);
  signal zz_86 : std_logic;
  signal execute_IntAluPlugin_bitwise : std_logic_vector(31 downto 0);
  signal zz_87 : std_logic_vector(31 downto 0);
  signal zz_88 : std_logic_vector(31 downto 0);
  signal zz_89 : std_logic;
  signal zz_90 : std_logic_vector(19 downto 0);
  signal zz_91 : std_logic;
  signal zz_92 : std_logic_vector(19 downto 0);
  signal zz_93 : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_addSub : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_less : std_logic;
  signal execute_FullBarrelShifterPlugin_amplitude : unsigned(4 downto 0);
  signal zz_94 : std_logic_vector(31 downto 0);
  signal execute_FullBarrelShifterPlugin_reversed : std_logic_vector(31 downto 0);
  signal zz_95 : std_logic_vector(31 downto 0);
  signal zz_96 : std_logic;
  signal zz_97 : std_logic;
  signal zz_98 : std_logic;
  signal zz_99 : std_logic_vector(4 downto 0);
  signal execute_BranchPlugin_eq : std_logic;
  signal zz_100 : std_logic_vector(2 downto 0);
  signal zz_101 : std_logic;
  signal zz_102 : std_logic;
  signal execute_BranchPlugin_branch_src1 : unsigned(31 downto 0);
  signal zz_103 : std_logic;
  signal zz_104 : std_logic_vector(10 downto 0);
  signal zz_105 : std_logic;
  signal zz_106 : std_logic_vector(19 downto 0);
  signal zz_107 : std_logic;
  signal zz_108 : std_logic_vector(18 downto 0);
  signal zz_109 : std_logic_vector(31 downto 0);
  signal execute_BranchPlugin_branch_src2 : unsigned(31 downto 0);
  signal execute_BranchPlugin_branchAdder : unsigned(31 downto 0);
  signal memory_to_writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal execute_to_memory_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal decode_to_execute_RS1 : std_logic_vector(31 downto 0);
  signal decode_to_execute_SRC1 : std_logic_vector(31 downto 0);
  signal decode_to_execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_CSR_WRITE_OPCODE : std_logic;
  signal execute_to_memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal memory_to_writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal decode_to_execute_SRC_LESS_UNSIGNED : std_logic;
  signal decode_to_execute_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal execute_to_memory_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal memory_to_writeBack_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_REGFILE_WRITE_VALID : std_logic;
  signal execute_to_memory_REGFILE_WRITE_VALID : std_logic;
  signal memory_to_writeBack_REGFILE_WRITE_VALID : std_logic;
  signal decode_to_execute_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_to_memory_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal execute_to_memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal memory_to_writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal decode_to_execute_IS_CSR : std_logic;
  signal decode_to_execute_MEMORY_STORE : std_logic;
  signal execute_to_memory_MEMORY_STORE : std_logic;
  signal memory_to_writeBack_MEMORY_STORE : std_logic;
  signal execute_to_memory_BRANCH_DO : std_logic;
  signal execute_to_memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_to_writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal decode_to_execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal execute_to_memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_to_writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_to_execute_SRC2 : std_logic_vector(31 downto 0);
  signal decode_to_execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal execute_to_memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal execute_to_memory_BRANCH_CALC : unsigned(31 downto 0);
  signal decode_to_execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal decode_to_execute_MEMORY_ENABLE : std_logic;
  signal execute_to_memory_MEMORY_ENABLE : std_logic;
  signal memory_to_writeBack_MEMORY_ENABLE : std_logic;
  signal decode_to_execute_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_PC : unsigned(31 downto 0);
  signal execute_to_memory_PC : unsigned(31 downto 0);
  signal memory_to_writeBack_PC : unsigned(31 downto 0);
  signal decode_to_execute_SRC_USE_SUB_LESS : std_logic;
  signal decode_to_execute_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_RS2 : std_logic_vector(31 downto 0);
  signal decode_to_execute_SRC2_FORCE_ZERO : std_logic;
  signal decode_to_execute_CSR_READ_OPCODE : std_logic;
  type RegFilePlugin_regFile_type is array (0 to 31) of std_logic_vector(31 downto 0);
  signal RegFilePlugin_regFile : RegFilePlugin_regFile_type;
begin
  zz_112 <= (execute_arbitration_isValid and execute_IS_CSR);
  zz_113 <= (execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_WFI));
  zz_114 <= (CsrPlugin_hadException or CsrPlugin_interruptJump);
  zz_115 <= (writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET));
  zz_116 <= pkg_extract(writeBack_INSTRUCTION,29,28);
  zz_117 <= (execute_CsrPlugin_illegalAccess or execute_CsrPlugin_illegalInstruction);
  zz_118 <= (execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_ECALL));
  zz_119 <= (writeBack_arbitration_isValid and writeBack_REGFILE_WRITE_VALID);
  zz_120 <= (pkg_toStdLogic(true) or (not pkg_toStdLogic(true)));
  zz_121 <= (memory_arbitration_isValid and memory_REGFILE_WRITE_VALID);
  zz_122 <= (pkg_toStdLogic(true) or (not memory_BYPASSABLE_MEMORY_STAGE));
  zz_123 <= (execute_arbitration_isValid and execute_REGFILE_WRITE_VALID);
  zz_124 <= (pkg_toStdLogic(true) or (not execute_BYPASSABLE_EXECUTE_STAGE));
  zz_125 <= (CsrPlugin_mstatus_MIE or pkg_toStdLogic(CsrPlugin_privilege < pkg_unsigned("11")));
  zz_126 <= ((zz_71 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_127 <= ((zz_72 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_128 <= ((zz_73 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_129 <= pkg_extract(writeBack_INSTRUCTION,13,12);
  zz_130 <= pkg_extract(execute_INSTRUCTION,13);
  zz_131 <= pkg_toStdLogic(true);
  zz_132 <= pkg_toStdLogic(true);
  zz_133 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_134 <= pkg_toStdLogic((decode_INSTRUCTION and zz_144) = pkg_stdLogicVector("00000000000000000010000001000000"));
  zz_135 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_145 = zz_146));
  zz_136 <= pkg_cat(pkg_toStdLogicVector(zz_147),pkg_toStdLogicVector(zz_148));
  zz_137 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_149 = zz_150));
  zz_138 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_151 = zz_152));
  zz_139 <= pkg_cat(pkg_toStdLogicVector(zz_77),pkg_toStdLogicVector(zz_153));
  zz_140 <= pkg_stdLogicVector("00");
  zz_141 <= pkg_toStdLogic(pkg_cat(zz_154,zz_155) /= pkg_stdLogicVector("00"));
  zz_142 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_156 /= zz_157));
  zz_143 <= pkg_cat(pkg_toStdLogicVector(zz_158),pkg_cat(zz_159,zz_160));
  zz_144 <= pkg_stdLogicVector("00000000000000000010000001000000");
  zz_145 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000001000000"));
  zz_146 <= pkg_stdLogicVector("00000000000000000001000001000000");
  zz_147 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_148 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000010000000000000001000000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_149 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_150 <= pkg_stdLogicVector("00000000000000000010000000000000");
  zz_151 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000101000000000000"));
  zz_152 <= pkg_stdLogicVector("00000000000000000001000000000000");
  zz_153 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001110000")) = pkg_stdLogicVector("00000000000000000000000000100000"));
  zz_154 <= pkg_toStdLogicVector(zz_77);
  zz_155 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_161) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_156 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_162) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_157 <= pkg_stdLogicVector("0");
  zz_158 <= pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_163 = zz_164)) /= pkg_stdLogicVector("0"));
  zz_159 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_165) /= pkg_stdLogicVector("0")));
  zz_160 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_166 /= zz_167)),pkg_cat(pkg_toStdLogicVector(zz_168),pkg_cat(zz_169,zz_170)));
  zz_161 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_162 <= pkg_stdLogicVector("00000000000000000000000001011000");
  zz_163 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000000000000"));
  zz_164 <= pkg_stdLogicVector("00000000000000000001000000000000");
  zz_165 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000011000000000000")) = pkg_stdLogicVector("00000000000000000010000000000000"));
  zz_166 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_171 = zz_172)),pkg_toStdLogicVector(pkg_toStdLogic(zz_173 = zz_174)));
  zz_167 <= pkg_stdLogicVector("00");
  zz_168 <= pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_175 = zz_176)) /= pkg_stdLogicVector("0"));
  zz_169 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_177,zz_178) /= pkg_stdLogicVector("00")));
  zz_170 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_179 /= zz_180)),pkg_cat(pkg_toStdLogicVector(zz_181),pkg_cat(zz_182,zz_183)));
  zz_171 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000110100"));
  zz_172 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_173 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100"));
  zz_174 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_175 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100"));
  zz_176 <= pkg_stdLogicVector("00000000000000000000000000100100");
  zz_177 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_184) = pkg_stdLogicVector("00000000000000000000000000000100")));
  zz_178 <= pkg_toStdLogicVector(zz_78);
  zz_179 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_185 = zz_186)),pkg_toStdLogicVector(zz_78));
  zz_180 <= pkg_stdLogicVector("00");
  zz_181 <= pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_187 = zz_188)) /= pkg_stdLogicVector("0"));
  zz_182 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_189) /= pkg_stdLogicVector("0")));
  zz_183 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_190 /= zz_191)),pkg_cat(pkg_toStdLogicVector(zz_192),pkg_cat(zz_193,zz_194)));
  zz_184 <= pkg_stdLogicVector("00000000000000000000000000010100");
  zz_185 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100"));
  zz_186 <= pkg_stdLogicVector("00000000000000000000000000000100");
  zz_187 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000010000"));
  zz_188 <= pkg_stdLogicVector("00000000000000000000000000010000");
  zz_189 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000001000000011000001010000")) = pkg_stdLogicVector("00000000000000000000000001010000"));
  zz_190 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000010000000011000001010000")) = pkg_stdLogicVector("00000000000000000000000001010000")));
  zz_191 <= pkg_stdLogicVector("0");
  zz_192 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_195 = zz_196)),pkg_cat(pkg_toStdLogicVector(zz_197),pkg_toStdLogicVector(zz_198))) /= pkg_stdLogicVector("000"));
  zz_193 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_199 = zz_200)) /= pkg_stdLogicVector("0")));
  zz_194 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_201,zz_202) /= pkg_stdLogicVector("00"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_203 /= zz_204)),pkg_cat(pkg_toStdLogicVector(zz_205),pkg_cat(zz_206,zz_207))));
  zz_195 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100"));
  zz_196 <= pkg_stdLogicVector("00000000000000000000000001000000");
  zz_197 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010100")) = pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_198 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("01000000000000000000000000110100")) = pkg_stdLogicVector("01000000000000000000000000110000"));
  zz_199 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000111000001010100"));
  zz_200 <= pkg_stdLogicVector("00000000000000000101000000010000");
  zz_201 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_208) = pkg_stdLogicVector("01000000000000000001000000010000")));
  zz_202 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_209) = pkg_stdLogicVector("00000000000000000001000000010000")));
  zz_203 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_210 = zz_211)),pkg_toStdLogicVector(pkg_toStdLogic(zz_212 = zz_213)));
  zz_204 <= pkg_stdLogicVector("00");
  zz_205 <= pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_214 = zz_215)) /= pkg_stdLogicVector("0"));
  zz_206 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_75) /= pkg_stdLogicVector("0")));
  zz_207 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_216 /= zz_217)),pkg_cat(pkg_toStdLogicVector(zz_218),pkg_cat(zz_219,zz_220)));
  zz_208 <= pkg_stdLogicVector("01000000000000000011000001010100");
  zz_209 <= pkg_stdLogicVector("00000000000000000111000001010100");
  zz_210 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000001010000"));
  zz_211 <= pkg_stdLogicVector("00000000000000000001000001010000");
  zz_212 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000001010000"));
  zz_213 <= pkg_stdLogicVector("00000000000000000010000001010000");
  zz_214 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000100000000000100"));
  zz_215 <= pkg_stdLogicVector("00000000000000000100000000000000");
  zz_216 <= pkg_cat(pkg_toStdLogicVector(zz_77),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_221 = zz_222)),pkg_toStdLogicVector(pkg_toStdLogic(zz_223 = zz_224))));
  zz_217 <= pkg_stdLogicVector("000");
  zz_218 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_76),pkg_toStdLogicVector(pkg_toStdLogic(zz_225 = zz_226))) /= pkg_stdLogicVector("00"));
  zz_219 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_227 = zz_228)) /= pkg_stdLogicVector("0")));
  zz_220 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_229,zz_230) /= pkg_stdLogicVector("000000"))),pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_231,zz_232) /= pkg_stdLogicVector("0000"))));
  zz_221 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000001010000"));
  zz_222 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_223 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000001010000"));
  zz_224 <= pkg_stdLogicVector("00000000000000000000000000010000");
  zz_225 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000011100"));
  zz_226 <= pkg_stdLogicVector("00000000000000000000000000000100");
  zz_227 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001011000"));
  zz_228 <= pkg_stdLogicVector("00000000000000000000000001000000");
  zz_229 <= pkg_toStdLogicVector(zz_76);
  zz_230 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_233) = pkg_stdLogicVector("00000000000000000001000000010000"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_234 = zz_235)),pkg_cat(pkg_toStdLogicVector(zz_236),pkg_cat(zz_237,zz_238))));
  zz_231 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100")) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_232 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_239) = pkg_stdLogicVector("00000000000000000000000000000000"))),pkg_cat(pkg_toStdLogicVector(zz_75),pkg_toStdLogicVector(pkg_toStdLogic(zz_240 = zz_241))));
  zz_233 <= pkg_stdLogicVector("00000000000000000001000000010000");
  zz_234 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_235 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_236 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000")) = pkg_stdLogicVector("00000000000000000000000000010000"));
  zz_237 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000001100")) = pkg_stdLogicVector("00000000000000000000000000000100")));
  zz_238 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000101000")) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_239 <= pkg_stdLogicVector("00000000000000000000000000011000");
  zz_240 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000101000000000100"));
  zz_241 <= pkg_stdLogicVector("00000000000000000001000000000000");
  process(clk)
  begin
    if rising_edge(clk) then
      if zz_131 = '1' then
        zz_110 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress1));
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_132 = '1' then
        zz_111 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress2));
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_35 = '1' then
        RegFilePlugin_regFile(to_integer(lastStageRegFileWrite_payload_address)) <= lastStageRegFileWrite_payload_data;
      end if;
    end if;
  end process;

  IBusSimplePlugin_rspJoin_rspBuffer_c : entity work.StreamFifoLowLatency
    port map ( 
      io_push_valid => iBus_rsp_takeWhen_valid,
      io_push_ready => IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready,
      io_push_payload_error => iBus_rsp_takeWhen_payload_error,
      io_push_payload_inst => iBus_rsp_takeWhen_payload_inst,
      io_pop_valid => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid,
      io_pop_ready => IBusSimplePlugin_rspJoin_rspBufferOutput_ready,
      io_pop_payload_error => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error,
      io_pop_payload_inst => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst,
      io_flush => IBusSimplePlugin_fetcherflushIt,
      io_occupancy => IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy,
      clk => clk,
      reset => reset 
    );
  decode_CSR_READ_OPCODE <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,13,7) /= pkg_stdLogicVector("0100000"));
  decode_SRC2_FORCE_ZERO <= (decode_SRC_ADD_ZERO and (not decode_SRC_USE_SUB_LESS));
  decode_RS2 <= decode_RegFilePlugin_rs2Data;
  decode_BRANCH_CTRL <= zz_1;
  zz_2 <= zz_3;
  memory_PC <= execute_to_memory_PC;
  decode_ALU_CTRL <= zz_4;
  zz_5 <= zz_6;
  decode_MEMORY_ENABLE <= pkg_extract(pkg_extract(zz_74,20,20),0);
  decode_BYPASSABLE_EXECUTE_STAGE <= pkg_extract(pkg_extract(zz_74,4,4),0);
  execute_BRANCH_CALC <= unsigned(pkg_cat(std_logic_vector(pkg_extract(execute_BranchPlugin_branchAdder,31,1)),std_logic_vector(pkg_unsigned("0"))));
  execute_BYPASSABLE_MEMORY_STAGE <= decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  decode_BYPASSABLE_MEMORY_STAGE <= pkg_extract(pkg_extract(zz_74,13,13),0);
  decode_SRC2 <= zz_93;
  writeBack_FORMAL_PC_NEXT <= memory_to_writeBack_FORMAL_PC_NEXT;
  memory_FORMAL_PC_NEXT <= execute_to_memory_FORMAL_PC_NEXT;
  execute_FORMAL_PC_NEXT <= decode_to_execute_FORMAL_PC_NEXT;
  decode_FORMAL_PC_NEXT <= (decode_PC + pkg_unsigned("00000000000000000000000000000100"));
  writeBack_REGFILE_WRITE_DATA <= memory_to_writeBack_REGFILE_WRITE_DATA;
  memory_REGFILE_WRITE_DATA <= execute_to_memory_REGFILE_WRITE_DATA;
  execute_REGFILE_WRITE_DATA <= zz_87;
  execute_BRANCH_DO <= zz_102;
  decode_MEMORY_STORE <= pkg_extract(pkg_extract(zz_74,25,25),0);
  decode_IS_CSR <= pkg_extract(pkg_extract(zz_74,7,7),0);
  zz_7 <= zz_8;
  decode_SHIFT_CTRL <= zz_9;
  zz_10 <= zz_11;
  zz_12 <= zz_13;
  zz_14 <= zz_15;
  decode_ENV_CTRL <= zz_16;
  zz_17 <= zz_18;
  decode_SRC_LESS_UNSIGNED <= pkg_extract(pkg_extract(zz_74,23,23),0);
  memory_MEMORY_ADDRESS_LOW <= execute_to_memory_MEMORY_ADDRESS_LOW;
  execute_MEMORY_ADDRESS_LOW <= pkg_extract(zz_62,1,0);
  decode_CSR_WRITE_OPCODE <= (not ((pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("01")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000"))) or (pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("11")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000")))));
  decode_ALU_BITWISE_CTRL <= zz_19;
  zz_20 <= zz_21;
  decode_SRC1 <= zz_88;
  decode_RS1 <= decode_RegFilePlugin_rs1Data;
  execute_SHIFT_RIGHT <= std_logic_vector(pkg_extract(pkg_shiftRight(signed(pkg_cat(pkg_toStdLogicVector((pkg_toStdLogic(execute_SHIFT_CTRL = ShiftCtrlEnum_defaultEncoding_SRA_1) and pkg_extract(execute_FullBarrelShifterPlugin_reversed,31))),execute_FullBarrelShifterPlugin_reversed)),execute_FullBarrelShifterPlugin_amplitude),31,0));
  memory_MEMORY_READ_DATA <= dBus_rsp_data;
  memory_BRANCH_CALC <= execute_to_memory_BRANCH_CALC;
  memory_BRANCH_DO <= execute_to_memory_BRANCH_DO;
  execute_PC <= decode_to_execute_PC;
  execute_RS1 <= decode_to_execute_RS1;
  execute_BRANCH_CTRL <= zz_22;
  decode_RS2_USE <= pkg_extract(pkg_extract(zz_74,17,17),0);
  decode_RS1_USE <= pkg_extract(pkg_extract(zz_74,0,0),0);
  execute_REGFILE_WRITE_VALID <= decode_to_execute_REGFILE_WRITE_VALID;
  execute_BYPASSABLE_EXECUTE_STAGE <= decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  memory_REGFILE_WRITE_VALID <= execute_to_memory_REGFILE_WRITE_VALID;
  memory_INSTRUCTION <= execute_to_memory_INSTRUCTION;
  memory_BYPASSABLE_MEMORY_STAGE <= execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  writeBack_REGFILE_WRITE_VALID <= memory_to_writeBack_REGFILE_WRITE_VALID;
  memory_SHIFT_RIGHT <= execute_to_memory_SHIFT_RIGHT;
  process(memory_REGFILE_WRITE_DATA,memory_arbitration_isValid,memory_SHIFT_CTRL,zz_95,memory_SHIFT_RIGHT)
  begin
    zz_23 <= memory_REGFILE_WRITE_DATA;
    if memory_arbitration_isValid = '1' then
      case memory_SHIFT_CTRL is
        when ShiftCtrlEnum_defaultEncoding_SLL_1 =>
          zz_23 <= zz_95;
        when ShiftCtrlEnum_defaultEncoding_SRL_1 | ShiftCtrlEnum_defaultEncoding_SRA_1 =>
          zz_23 <= memory_SHIFT_RIGHT;
        when others =>
      end case;
    end if;
  end process;

  memory_SHIFT_CTRL <= zz_24;
  execute_SHIFT_CTRL <= zz_25;
  execute_SRC_LESS_UNSIGNED <= decode_to_execute_SRC_LESS_UNSIGNED;
  execute_SRC2_FORCE_ZERO <= decode_to_execute_SRC2_FORCE_ZERO;
  execute_SRC_USE_SUB_LESS <= decode_to_execute_SRC_USE_SUB_LESS;
  zz_26 <= decode_PC;
  zz_27 <= decode_RS2;
  decode_SRC2_CTRL <= zz_28;
  zz_29 <= decode_RS1;
  decode_SRC1_CTRL <= zz_30;
  decode_SRC_USE_SUB_LESS <= pkg_extract(pkg_extract(zz_74,10,10),0);
  decode_SRC_ADD_ZERO <= pkg_extract(pkg_extract(zz_74,16,16),0);
  execute_SRC_ADD_SUB <= execute_SrcPlugin_addSub;
  execute_SRC_LESS <= execute_SrcPlugin_less;
  execute_ALU_CTRL <= zz_31;
  execute_SRC2 <= decode_to_execute_SRC2;
  execute_ALU_BITWISE_CTRL <= zz_32;
  zz_33 <= writeBack_INSTRUCTION;
  zz_34 <= writeBack_REGFILE_WRITE_VALID;
  process(lastStageRegFileWrite_valid)
  begin
    zz_35 <= pkg_toStdLogic(false);
    if lastStageRegFileWrite_valid = '1' then
      zz_35 <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_INSTRUCTION_ANTICIPATED <= pkg_mux(decode_arbitration_isStuck,decode_INSTRUCTION,IBusSimplePlugin_iBusRsp_output_payload_rsp_inst);
  process(zz_74,decode_INSTRUCTION)
  begin
    decode_REGFILE_WRITE_VALID <= pkg_extract(pkg_extract(zz_74,1,1),0);
    if pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,11,7) = pkg_stdLogicVector("00000")) = '1' then
      decode_REGFILE_WRITE_VALID <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_REGFILE_WRITE_DATA,zz_112,execute_CsrPlugin_readData)
  begin
    zz_43 <= execute_REGFILE_WRITE_DATA;
    if zz_112 = '1' then
      zz_43 <= execute_CsrPlugin_readData;
    end if;
  end process;

  execute_SRC1 <= decode_to_execute_SRC1;
  execute_CSR_READ_OPCODE <= decode_to_execute_CSR_READ_OPCODE;
  execute_CSR_WRITE_OPCODE <= decode_to_execute_CSR_WRITE_OPCODE;
  execute_IS_CSR <= decode_to_execute_IS_CSR;
  memory_ENV_CTRL <= zz_44;
  execute_ENV_CTRL <= zz_45;
  writeBack_ENV_CTRL <= zz_46;
  writeBack_MEMORY_STORE <= memory_to_writeBack_MEMORY_STORE;
  process(writeBack_REGFILE_WRITE_DATA,writeBack_arbitration_isValid,writeBack_MEMORY_ENABLE,writeBack_DBusSimplePlugin_rspFormated)
  begin
    zz_47 <= writeBack_REGFILE_WRITE_DATA;
    if (writeBack_arbitration_isValid and writeBack_MEMORY_ENABLE) = '1' then
      zz_47 <= writeBack_DBusSimplePlugin_rspFormated;
    end if;
  end process;

  writeBack_MEMORY_ENABLE <= memory_to_writeBack_MEMORY_ENABLE;
  writeBack_MEMORY_ADDRESS_LOW <= memory_to_writeBack_MEMORY_ADDRESS_LOW;
  writeBack_MEMORY_READ_DATA <= memory_to_writeBack_MEMORY_READ_DATA;
  memory_MEMORY_STORE <= execute_to_memory_MEMORY_STORE;
  memory_MEMORY_ENABLE <= execute_to_memory_MEMORY_ENABLE;
  execute_SRC_ADD <= execute_SrcPlugin_addSub;
  execute_RS2 <= decode_to_execute_RS2;
  execute_INSTRUCTION <= decode_to_execute_INSTRUCTION;
  execute_MEMORY_STORE <= decode_to_execute_MEMORY_STORE;
  execute_MEMORY_ENABLE <= decode_to_execute_MEMORY_ENABLE;
  execute_ALIGNEMENT_FAULT <= pkg_toStdLogic(false);
  process(memory_FORMAL_PC_NEXT,BranchPlugin_jumpInterface_valid,BranchPlugin_jumpInterface_payload)
  begin
    zz_48 <= memory_FORMAL_PC_NEXT;
    if BranchPlugin_jumpInterface_valid = '1' then
      zz_48 <= BranchPlugin_jumpInterface_payload;
    end if;
  end process;

  decode_PC <= IBusSimplePlugin_injector_decodeInput_payload_pc;
  decode_INSTRUCTION <= IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  writeBack_PC <= memory_to_writeBack_PC;
  writeBack_INSTRUCTION <= memory_to_writeBack_INSTRUCTION;
  decode_arbitration_haltItself <= pkg_toStdLogic(false);
  process(CsrPlugin_interrupt_valid,CsrPlugin_allowInterrupts,decode_arbitration_isValid,writeBack_arbitration_isValid,writeBack_ENV_CTRL,memory_arbitration_isValid,memory_ENV_CTRL,execute_arbitration_isValid,execute_ENV_CTRL,zz_96,zz_97)
  begin
    decode_arbitration_haltByOther <= pkg_toStdLogic(false);
    if (CsrPlugin_interrupt_valid and CsrPlugin_allowInterrupts) = '1' then
      decode_arbitration_haltByOther <= decode_arbitration_isValid;
    end if;
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector((writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))),pkg_cat(pkg_toStdLogicVector((memory_arbitration_isValid and pkg_toStdLogic(memory_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))),pkg_toStdLogicVector((execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))))) /= pkg_stdLogicVector("000")) = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
    if (decode_arbitration_isValid and (zz_96 or zz_97)) = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
  end process;

  process(decode_arbitration_isFlushed)
  begin
    decode_arbitration_removeIt <= pkg_toStdLogic(false);
    if decode_arbitration_isFlushed = '1' then
      decode_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_arbitration_flushIt <= pkg_toStdLogic(false);
  decode_arbitration_flushNext <= pkg_toStdLogic(false);
  process(execute_arbitration_isValid,execute_MEMORY_ENABLE,dBus_cmd_ready,execute_DBusSimplePlugin_skipCmd,zz_64,zz_113,execute_CsrPlugin_wfiWake,zz_112,execute_CsrPlugin_blockedBySideEffects)
  begin
    execute_arbitration_haltItself <= pkg_toStdLogic(false);
    if ((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not dBus_cmd_ready)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_64)) = '1' then
      execute_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
    if zz_113 = '1' then
      if (not execute_CsrPlugin_wfiWake) = '1' then
        execute_arbitration_haltItself <= pkg_toStdLogic(true);
      end if;
    end if;
    if zz_112 = '1' then
      if execute_CsrPlugin_blockedBySideEffects = '1' then
        execute_arbitration_haltItself <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  execute_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(CsrPlugin_selfException_valid,execute_arbitration_isFlushed)
  begin
    execute_arbitration_removeIt <= pkg_toStdLogic(false);
    if CsrPlugin_selfException_valid = '1' then
      execute_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
    if execute_arbitration_isFlushed = '1' then
      execute_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  execute_arbitration_flushIt <= pkg_toStdLogic(false);
  process(CsrPlugin_selfException_valid)
  begin
    execute_arbitration_flushNext <= pkg_toStdLogic(false);
    if CsrPlugin_selfException_valid = '1' then
      execute_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  process(memory_arbitration_isValid,memory_MEMORY_ENABLE,memory_MEMORY_STORE,dBus_rsp_ready)
  begin
    memory_arbitration_haltItself <= pkg_toStdLogic(false);
    if (((memory_arbitration_isValid and memory_MEMORY_ENABLE) and (not memory_MEMORY_STORE)) and ((not dBus_rsp_ready) or pkg_toStdLogic(false))) = '1' then
      memory_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(memory_arbitration_isFlushed)
  begin
    memory_arbitration_removeIt <= pkg_toStdLogic(false);
    if memory_arbitration_isFlushed = '1' then
      memory_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_flushIt <= pkg_toStdLogic(false);
  process(BranchPlugin_jumpInterface_valid)
  begin
    memory_arbitration_flushNext <= pkg_toStdLogic(false);
    if BranchPlugin_jumpInterface_valid = '1' then
      memory_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_haltItself <= pkg_toStdLogic(false);
  writeBack_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(writeBack_arbitration_isFlushed)
  begin
    writeBack_arbitration_removeIt <= pkg_toStdLogic(false);
    if writeBack_arbitration_isFlushed = '1' then
      writeBack_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_flushIt <= pkg_toStdLogic(false);
  process(zz_114,zz_115)
  begin
    writeBack_arbitration_flushNext <= pkg_toStdLogic(false);
    if zz_114 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
    if zz_115 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  lastStageInstruction <= writeBack_INSTRUCTION;
  lastStagePc <= writeBack_PC;
  lastStageIsValid <= writeBack_arbitration_isValid;
  lastStageIsFiring <= writeBack_arbitration_isFiring;
  process(CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,CsrPlugin_exceptionPortCtrl_exceptionValids_memory,CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode,zz_114,zz_115)
  begin
    IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(false);
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_memory),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_execute),pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_decode)))) /= pkg_stdLogicVector("0000")) = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_114 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_115 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(writeBack_arbitration_flushNext,memory_arbitration_flushNext,execute_arbitration_flushNext,decode_arbitration_flushNext)
  begin
    IBusSimplePlugin_fetcherflushIt <= pkg_toStdLogic(false);
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushNext),pkg_toStdLogicVector(decode_arbitration_flushNext)))) /= pkg_stdLogicVector("0000")) = '1' then
      IBusSimplePlugin_fetcherflushIt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(IBusSimplePlugin_iBusRsp_stages_1_input_valid,IBusSimplePlugin_injector_decodeInput_valid)
  begin
    IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(false);
    if IBusSimplePlugin_iBusRsp_stages_1_input_valid = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_113)
  begin
    CsrPlugin_inWfi <= pkg_toStdLogic(false);
    if zz_113 = '1' then
      CsrPlugin_inWfi <= pkg_toStdLogic(true);
    end if;
  end process;

  CsrPlugin_thirdPartyWake <= pkg_toStdLogic(false);
  process(zz_114,zz_115)
  begin
    CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(false);
    if zz_114 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
    if zz_115 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_114,CsrPlugin_xtvec_base,zz_115,zz_116,CsrPlugin_mepc)
  begin
    CsrPlugin_jumpInterface_payload <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    if zz_114 = '1' then
      CsrPlugin_jumpInterface_payload <= unsigned(pkg_cat(std_logic_vector(CsrPlugin_xtvec_base),std_logic_vector(pkg_unsigned("00"))));
    end if;
    if zz_115 = '1' then
      case zz_116 is
        when "11" =>
          CsrPlugin_jumpInterface_payload <= CsrPlugin_mepc;
        when others =>
      end case;
    end if;
  end process;

  CsrPlugin_forceMachineWire <= pkg_toStdLogic(false);
  CsrPlugin_allowInterrupts <= pkg_toStdLogic(true);
  CsrPlugin_allowException <= pkg_toStdLogic(true);
  IBusSimplePlugin_jump_pcLoad_valid <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid)) /= pkg_stdLogicVector("00"));
  zz_50 <= unsigned(pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid)));
  IBusSimplePlugin_jump_pcLoad_payload <= pkg_mux(pkg_extract(std_logic_vector((zz_50 and pkg_not((zz_50 - pkg_unsigned("01"))))),0),CsrPlugin_jumpInterface_payload,BranchPlugin_jumpInterface_payload);
  process(IBusSimplePlugin_jump_pcLoad_valid)
  begin
    IBusSimplePlugin_fetchPc_corrected <= pkg_toStdLogic(false);
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_corrected <= pkg_toStdLogic(true);
    end if;
  end process;

  process(IBusSimplePlugin_iBusRsp_stages_1_input_ready)
  begin
    IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(false);
    if IBusSimplePlugin_iBusRsp_stages_1_input_ready = '1' then
      IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(true);
    end if;
  end process;

  process(IBusSimplePlugin_fetchPc_pcReg,IBusSimplePlugin_fetchPc_inc,IBusSimplePlugin_jump_pcLoad_valid,IBusSimplePlugin_jump_pcLoad_payload)
  begin
    IBusSimplePlugin_fetchPc_pc <= (IBusSimplePlugin_fetchPc_pcReg + pkg_resize(unsigned(pkg_cat(pkg_toStdLogicVector(IBusSimplePlugin_fetchPc_inc),pkg_stdLogicVector("00"))),32));
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_pc <= IBusSimplePlugin_jump_pcLoad_payload;
    end if;
    IBusSimplePlugin_fetchPc_pc(0) <= pkg_toStdLogic(false);
    IBusSimplePlugin_fetchPc_pc(1) <= pkg_toStdLogic(false);
  end process;

  IBusSimplePlugin_fetchPc_output_valid <= ((not IBusSimplePlugin_fetcherHalt) and IBusSimplePlugin_fetchPc_booted);
  IBusSimplePlugin_fetchPc_output_payload <= IBusSimplePlugin_fetchPc_pc;
  IBusSimplePlugin_iBusRsp_stages_0_input_valid <= IBusSimplePlugin_fetchPc_output_valid;
  IBusSimplePlugin_fetchPc_output_ready <= IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  IBusSimplePlugin_iBusRsp_stages_0_input_payload <= IBusSimplePlugin_fetchPc_output_payload;
  IBusSimplePlugin_iBusRsp_stages_0_inputSample <= pkg_toStdLogic(true);
  process(IBusSimplePlugin_iBusRsp_stages_0_input_valid,IBusSimplePlugin_cmd_valid,IBusSimplePlugin_cmd_ready)
  begin
    IBusSimplePlugin_iBusRsp_stages_0_halt <= pkg_toStdLogic(false);
    if (IBusSimplePlugin_iBusRsp_stages_0_input_valid and ((not IBusSimplePlugin_cmd_valid) or (not IBusSimplePlugin_cmd_ready))) = '1' then
      IBusSimplePlugin_iBusRsp_stages_0_halt <= pkg_toStdLogic(true);
    end if;
  end process;

  zz_51 <= (not IBusSimplePlugin_iBusRsp_stages_0_halt);
  IBusSimplePlugin_iBusRsp_stages_0_input_ready <= (IBusSimplePlugin_iBusRsp_stages_0_output_ready and zz_51);
  IBusSimplePlugin_iBusRsp_stages_0_output_valid <= (IBusSimplePlugin_iBusRsp_stages_0_input_valid and zz_51);
  IBusSimplePlugin_iBusRsp_stages_0_output_payload <= IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  IBusSimplePlugin_iBusRsp_stages_1_halt <= pkg_toStdLogic(false);
  zz_52 <= (not IBusSimplePlugin_iBusRsp_stages_1_halt);
  IBusSimplePlugin_iBusRsp_stages_1_input_ready <= (IBusSimplePlugin_iBusRsp_stages_1_output_ready and zz_52);
  IBusSimplePlugin_iBusRsp_stages_1_output_valid <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and zz_52);
  IBusSimplePlugin_iBusRsp_stages_1_output_payload <= IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  IBusSimplePlugin_iBusRsp_stages_0_output_ready <= zz_53;
  zz_53 <= ((pkg_toStdLogic(false) and (not zz_54)) or IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  zz_54 <= zz_55;
  IBusSimplePlugin_iBusRsp_stages_1_input_valid <= zz_54;
  IBusSimplePlugin_iBusRsp_stages_1_input_payload <= IBusSimplePlugin_fetchPc_pcReg;
  process(IBusSimplePlugin_injector_decodeInput_valid,IBusSimplePlugin_pcValids_0)
  begin
    IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(true);
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
    if (not IBusSimplePlugin_pcValids_0) = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_iBusRsp_output_ready <= ((pkg_toStdLogic(false) and (not IBusSimplePlugin_injector_decodeInput_valid)) or IBusSimplePlugin_injector_decodeInput_ready);
  IBusSimplePlugin_injector_decodeInput_valid <= zz_56;
  IBusSimplePlugin_injector_decodeInput_payload_pc <= zz_57;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_error <= zz_58;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_inst <= zz_59;
  IBusSimplePlugin_injector_decodeInput_payload_isRvc <= zz_60;
  IBusSimplePlugin_pcValids_0 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
  IBusSimplePlugin_pcValids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
  IBusSimplePlugin_pcValids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
  IBusSimplePlugin_pcValids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_4;
  IBusSimplePlugin_injector_decodeInput_ready <= (not decode_arbitration_isStuck);
  decode_arbitration_isValid <= (IBusSimplePlugin_injector_decodeInput_valid and (not IBusSimplePlugin_injector_decodeRemoved));
  iBus_cmd_valid <= IBusSimplePlugin_cmd_valid;
  IBusSimplePlugin_cmd_ready <= iBus_cmd_ready;
  zz_49 <= IBusSimplePlugin_cmd_payload_pc;
  IBusSimplePlugin_pendingCmdNext <= ((IBusSimplePlugin_pendingCmd + pkg_resize(unsigned(pkg_toStdLogicVector((IBusSimplePlugin_cmd_valid and IBusSimplePlugin_cmd_ready))),3)) - pkg_resize(unsigned(pkg_toStdLogicVector(iBus_rsp_valid)),3));
  IBusSimplePlugin_cmd_valid <= ((IBusSimplePlugin_iBusRsp_stages_0_input_valid and IBusSimplePlugin_iBusRsp_stages_0_output_ready) and pkg_toStdLogic(IBusSimplePlugin_pendingCmd /= pkg_unsigned("111")));
  IBusSimplePlugin_cmd_payload_pc <= unsigned(pkg_cat(std_logic_vector(pkg_extract(IBusSimplePlugin_iBusRsp_stages_0_input_payload,31,2)),std_logic_vector(pkg_unsigned("00"))));
  iBus_rsp_takeWhen_valid <= (iBus_rsp_valid and (not pkg_toStdLogic(IBusSimplePlugin_rspJoin_discardCounter /= pkg_unsigned("000"))));
  iBus_rsp_takeWhen_payload_error <= iBus_rsp_payload_error;
  iBus_rsp_takeWhen_payload_inst <= iBus_rsp_payload_inst;
  IBusSimplePlugin_rspJoin_rspBufferOutput_valid <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid;
  IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  IBusSimplePlugin_rspJoin_fetchRsp_pc <= IBusSimplePlugin_iBusRsp_stages_1_output_payload;
  process(IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error,IBusSimplePlugin_rspJoin_rspBufferOutput_valid)
  begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= IBusSimplePlugin_rspJoin_rspBufferOutput_payload_error;
    if (not IBusSimplePlugin_rspJoin_rspBufferOutput_valid) = '1' then
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst <= IBusSimplePlugin_rspJoin_rspBufferOutput_payload_inst;
  IBusSimplePlugin_rspJoin_exceptionDetected <= pkg_toStdLogic(false);
  IBusSimplePlugin_rspJoin_redoRequired <= pkg_toStdLogic(false);
  IBusSimplePlugin_rspJoin_join_valid <= (IBusSimplePlugin_iBusRsp_stages_1_output_valid and IBusSimplePlugin_rspJoin_rspBufferOutput_valid);
  IBusSimplePlugin_rspJoin_join_payload_pc <= IBusSimplePlugin_rspJoin_fetchRsp_pc;
  IBusSimplePlugin_rspJoin_join_payload_rsp_error <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  IBusSimplePlugin_rspJoin_join_payload_rsp_inst <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  IBusSimplePlugin_rspJoin_join_payload_isRvc <= IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  IBusSimplePlugin_iBusRsp_stages_1_output_ready <= pkg_mux(IBusSimplePlugin_iBusRsp_stages_1_output_valid,(IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready),IBusSimplePlugin_rspJoin_join_ready);
  IBusSimplePlugin_rspJoin_rspBufferOutput_ready <= (IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready);
  zz_61 <= (not (IBusSimplePlugin_rspJoin_exceptionDetected or IBusSimplePlugin_rspJoin_redoRequired));
  IBusSimplePlugin_rspJoin_join_ready <= (IBusSimplePlugin_iBusRsp_output_ready and zz_61);
  IBusSimplePlugin_iBusRsp_output_valid <= (IBusSimplePlugin_rspJoin_join_valid and zz_61);
  IBusSimplePlugin_iBusRsp_output_payload_pc <= IBusSimplePlugin_rspJoin_join_payload_pc;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_error <= IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_inst <= IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  IBusSimplePlugin_iBusRsp_output_payload_isRvc <= IBusSimplePlugin_rspJoin_join_payload_isRvc;
  zz_64 <= pkg_toStdLogic(false);
  process(execute_ALIGNEMENT_FAULT)
  begin
    execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(false);
    if execute_ALIGNEMENT_FAULT = '1' then
      execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(true);
    end if;
  end process;

  dBus_cmd_valid <= (((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not execute_arbitration_isStuckByOthers)) and (not execute_arbitration_isFlushed)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_64));
  dBus_cmd_payload_wr <= execute_MEMORY_STORE;
  zz_63 <= unsigned(pkg_extract(execute_INSTRUCTION,13,12));
  process(zz_63,execute_RS2)
  begin
    case zz_63 is
      when "00" =>
        zz_65 <= pkg_cat(pkg_cat(pkg_cat(pkg_extract(execute_RS2,7,0),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0));
      when "01" =>
        zz_65 <= pkg_cat(pkg_extract(execute_RS2,15,0),pkg_extract(execute_RS2,15,0));
      when others =>
        zz_65 <= pkg_extract(execute_RS2,31,0);
    end case;
  end process;

  dBus_cmd_payload_data <= zz_65;
  process(zz_63)
  begin
    case zz_63 is
      when "00" =>
        zz_66 <= pkg_stdLogicVector("0001");
      when "01" =>
        zz_66 <= pkg_stdLogicVector("0011");
      when others =>
        zz_66 <= pkg_stdLogicVector("1111");
    end case;
  end process;

  execute_DBusSimplePlugin_formalMask <= std_logic_vector(shift_left(unsigned(zz_66),to_integer(pkg_extract(zz_62,1,0))));
  zz_62 <= unsigned(execute_SRC_ADD);
  process(writeBack_MEMORY_READ_DATA,writeBack_MEMORY_ADDRESS_LOW)
  begin
    writeBack_DBusSimplePlugin_rspShifted <= writeBack_MEMORY_READ_DATA;
    case writeBack_MEMORY_ADDRESS_LOW is
      when "01" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,15,8);
      when "10" =>
        writeBack_DBusSimplePlugin_rspShifted(15 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,16);
      when "11" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,24);
      when others =>
    end case;
  end process;

  zz_67 <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_67,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_68(31) <= zz_67;
    zz_68(30) <= zz_67;
    zz_68(29) <= zz_67;
    zz_68(28) <= zz_67;
    zz_68(27) <= zz_67;
    zz_68(26) <= zz_67;
    zz_68(25) <= zz_67;
    zz_68(24) <= zz_67;
    zz_68(23) <= zz_67;
    zz_68(22) <= zz_67;
    zz_68(21) <= zz_67;
    zz_68(20) <= zz_67;
    zz_68(19) <= zz_67;
    zz_68(18) <= zz_67;
    zz_68(17) <= zz_67;
    zz_68(16) <= zz_67;
    zz_68(15) <= zz_67;
    zz_68(14) <= zz_67;
    zz_68(13) <= zz_67;
    zz_68(12) <= zz_67;
    zz_68(11) <= zz_67;
    zz_68(10) <= zz_67;
    zz_68(9) <= zz_67;
    zz_68(8) <= zz_67;
    zz_68(7 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7,0);
  end process;

  zz_69 <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_69,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_70(31) <= zz_69;
    zz_70(30) <= zz_69;
    zz_70(29) <= zz_69;
    zz_70(28) <= zz_69;
    zz_70(27) <= zz_69;
    zz_70(26) <= zz_69;
    zz_70(25) <= zz_69;
    zz_70(24) <= zz_69;
    zz_70(23) <= zz_69;
    zz_70(22) <= zz_69;
    zz_70(21) <= zz_69;
    zz_70(20) <= zz_69;
    zz_70(19) <= zz_69;
    zz_70(18) <= zz_69;
    zz_70(17) <= zz_69;
    zz_70(16) <= zz_69;
    zz_70(15 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15,0);
  end process;

  process(zz_129,zz_68,zz_70,writeBack_DBusSimplePlugin_rspShifted)
  begin
    case zz_129 is
      when "00" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_68;
      when "01" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_70;
      when others =>
        writeBack_DBusSimplePlugin_rspFormated <= writeBack_DBusSimplePlugin_rspShifted;
    end case;
  end process;

  process(CsrPlugin_forceMachineWire)
  begin
    CsrPlugin_privilege <= pkg_unsigned("11");
    if CsrPlugin_forceMachineWire = '1' then
      CsrPlugin_privilege <= pkg_unsigned("11");
    end if;
  end process;

  zz_71 <= (CsrPlugin_mip_MTIP and CsrPlugin_mie_MTIE);
  zz_72 <= (CsrPlugin_mip_MSIP and CsrPlugin_mie_MSIE);
  zz_73 <= (CsrPlugin_mip_MEIP and CsrPlugin_mie_MEIE);
  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= pkg_toStdLogic(false);
  CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped <= pkg_unsigned("11");
  CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege <= pkg_mux(pkg_toStdLogic(CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped),CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped,CsrPlugin_privilege);
  CsrPlugin_exceptionPortCtrl_exceptionValids_decode <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute,CsrPlugin_selfException_valid,execute_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if CsrPlugin_selfException_valid = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= pkg_toStdLogic(true);
    end if;
    if execute_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= pkg_toStdLogic(false);
    end if;
  end process;

  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,memory_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if memory_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory <= pkg_toStdLogic(false);
    end if;
  end process;

  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,writeBack_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if writeBack_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack <= pkg_toStdLogic(false);
    end if;
  end process;

  CsrPlugin_exceptionPendings_0 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  CsrPlugin_exceptionPendings_1 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  CsrPlugin_exceptionPendings_2 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  CsrPlugin_exceptionPendings_3 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  CsrPlugin_exception <= (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack and CsrPlugin_allowException);
  process(writeBack_arbitration_isValid,memory_arbitration_isValid,execute_arbitration_isValid,IBusSimplePlugin_pcValids_3,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute,CsrPlugin_hadException)
  begin
    CsrPlugin_pipelineLiberator_done <= ((not pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_cat(pkg_toStdLogicVector(memory_arbitration_isValid),pkg_toStdLogicVector(execute_arbitration_isValid))) /= pkg_stdLogicVector("000"))) and IBusSimplePlugin_pcValids_3);
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory),pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute))) /= pkg_stdLogicVector("000")) = '1' then
      CsrPlugin_pipelineLiberator_done <= pkg_toStdLogic(false);
    end if;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_pipelineLiberator_done <= pkg_toStdLogic(false);
    end if;
  end process;

  CsrPlugin_interruptJump <= ((CsrPlugin_interrupt_valid and CsrPlugin_pipelineLiberator_done) and CsrPlugin_allowInterrupts);
  process(CsrPlugin_interrupt_targetPrivilege,CsrPlugin_hadException,CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege)
  begin
    CsrPlugin_targetPrivilege <= CsrPlugin_interrupt_targetPrivilege;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_targetPrivilege <= CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end if;
  end process;

  process(CsrPlugin_interrupt_code,CsrPlugin_hadException,CsrPlugin_exceptionPortCtrl_exceptionContext_code)
  begin
    CsrPlugin_trapCause <= CsrPlugin_interrupt_code;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_trapCause <= CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end if;
  end process;

  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_mode)
  begin
    CsrPlugin_xtvec_mode <= pkg_stdLogicVector("XX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_mode <= CsrPlugin_mtvec_mode;
      when others =>
    end case;
  end process;

  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_base)
  begin
    CsrPlugin_xtvec_base <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_base <= CsrPlugin_mtvec_base;
      when others =>
    end case;
  end process;

  contextSwitching <= CsrPlugin_jumpInterface_valid;
  execute_CsrPlugin_blockedBySideEffects <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_toStdLogicVector(memory_arbitration_isValid)) /= pkg_stdLogicVector("00"));
  process(execute_CsrPlugin_csrAddress,execute_CSR_READ_OPCODE,CsrPlugin_privilege,execute_arbitration_isValid,execute_IS_CSR)
  begin
    execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    case execute_CsrPlugin_csrAddress is
      when "001100000000" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "111100010001" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "111100010100" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "001101000001" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "101100000000" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "101110000000" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "001101000100" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "001100000101" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "101100000010" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "111100010011" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "001101000011" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "110000000000" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "001100000001" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "001101000000" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "111100010010" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "001100000100" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "101110000010" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when "110010000000" =>
        if execute_CSR_READ_OPCODE = '1' then
          execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
        end if;
      when "001101000010" =>
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      when others =>
    end case;
    if pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_CsrPlugin_csrAddress,9,8))) = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    end if;
    if ((not execute_arbitration_isValid) or (not execute_IS_CSR)) = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_arbitration_isValid,execute_ENV_CTRL,CsrPlugin_privilege,execute_INSTRUCTION)
  begin
    execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(false);
    if (execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET)) = '1' then
      if pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_INSTRUCTION,29,28))) = '1' then
        execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(zz_117,zz_118)
  begin
    CsrPlugin_selfException_valid <= pkg_toStdLogic(false);
    if zz_117 = '1' then
      CsrPlugin_selfException_valid <= pkg_toStdLogic(true);
    end if;
    if zz_118 = '1' then
      CsrPlugin_selfException_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_117,zz_118,CsrPlugin_privilege)
  begin
    CsrPlugin_selfException_payload_code <= pkg_unsigned("XXXX");
    if zz_117 = '1' then
      CsrPlugin_selfException_payload_code <= pkg_unsigned("0010");
    end if;
    if zz_118 = '1' then
      case CsrPlugin_privilege is
        when "00" =>
          CsrPlugin_selfException_payload_code <= pkg_unsigned("1000");
        when others =>
          CsrPlugin_selfException_payload_code <= pkg_unsigned("1011");
      end case;
    end if;
  end process;

  CsrPlugin_selfException_payload_badAddr <= unsigned(execute_INSTRUCTION);
  process(execute_CsrPlugin_csrAddress,CsrPlugin_mstatus_MPP,CsrPlugin_mstatus_MPIE,CsrPlugin_mstatus_MIE,CsrPlugin_mepc,CsrPlugin_mcycle,CsrPlugin_mip_MEIP,CsrPlugin_mip_MTIP,CsrPlugin_mip_MSIP,CsrPlugin_mtvec_base,CsrPlugin_mtvec_mode,CsrPlugin_minstret,CsrPlugin_mtval,CsrPlugin_misa_base,CsrPlugin_misa_extensions,CsrPlugin_mscratch,CsrPlugin_mie_MEIE,CsrPlugin_mie_MTIE,CsrPlugin_mie_MSIE,CsrPlugin_mcause_interrupt,CsrPlugin_mcause_exceptionCode)
  begin
    execute_CsrPlugin_readData <= pkg_stdLogicVector("00000000000000000000000000000000");
    case execute_CsrPlugin_csrAddress is
      when "001100000000" =>
        execute_CsrPlugin_readData(12 downto 11) <= std_logic_vector(CsrPlugin_mstatus_MPP);
        execute_CsrPlugin_readData(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MPIE);
        execute_CsrPlugin_readData(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MIE);
      when "111100010001" =>
        execute_CsrPlugin_readData(3 downto 0) <= std_logic_vector(pkg_unsigned("1011"));
      when "111100010100" =>
      when "001101000001" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(CsrPlugin_mepc);
      when "101100000000" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,31,0));
      when "101110000000" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,63,32));
      when "001101000100" =>
        execute_CsrPlugin_readData(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mip_MEIP);
        execute_CsrPlugin_readData(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mip_MTIP);
        execute_CsrPlugin_readData(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mip_MSIP);
      when "001100000101" =>
        execute_CsrPlugin_readData(31 downto 2) <= std_logic_vector(CsrPlugin_mtvec_base);
        execute_CsrPlugin_readData(1 downto 0) <= CsrPlugin_mtvec_mode;
      when "101100000010" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_minstret,31,0));
      when "111100010011" =>
        execute_CsrPlugin_readData(5 downto 0) <= std_logic_vector(pkg_unsigned("100001"));
      when "001101000011" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(CsrPlugin_mtval);
      when "110000000000" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,31,0));
      when "001100000001" =>
        execute_CsrPlugin_readData(31 downto 30) <= std_logic_vector(CsrPlugin_misa_base);
        execute_CsrPlugin_readData(25 downto 0) <= CsrPlugin_misa_extensions;
      when "001101000000" =>
        execute_CsrPlugin_readData(31 downto 0) <= CsrPlugin_mscratch;
      when "111100010010" =>
        execute_CsrPlugin_readData(4 downto 0) <= std_logic_vector(pkg_unsigned("10110"));
      when "001100000100" =>
        execute_CsrPlugin_readData(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mie_MEIE);
        execute_CsrPlugin_readData(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mie_MTIE);
        execute_CsrPlugin_readData(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mie_MSIE);
      when "101110000010" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_minstret,63,32));
      when "110010000000" =>
        execute_CsrPlugin_readData(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,63,32));
      when "001101000010" =>
        execute_CsrPlugin_readData(31 downto 31) <= pkg_toStdLogicVector(CsrPlugin_mcause_interrupt);
        execute_CsrPlugin_readData(3 downto 0) <= std_logic_vector(CsrPlugin_mcause_exceptionCode);
      when others =>
    end case;
  end process;

  execute_CsrPlugin_writeInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_WRITE_OPCODE);
  execute_CsrPlugin_readInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_READ_OPCODE);
  execute_CsrPlugin_writeEnable <= ((execute_CsrPlugin_writeInstruction and (not execute_CsrPlugin_blockedBySideEffects)) and (not execute_arbitration_isStuckByOthers));
  execute_CsrPlugin_readEnable <= ((execute_CsrPlugin_readInstruction and (not execute_CsrPlugin_blockedBySideEffects)) and (not execute_arbitration_isStuckByOthers));
  execute_CsrPlugin_readToWriteData <= execute_CsrPlugin_readData;
  process(zz_130,execute_SRC1,execute_INSTRUCTION,execute_CsrPlugin_readToWriteData)
  begin
    case zz_130 is
      when '0' =>
        execute_CsrPlugin_writeData <= execute_SRC1;
      when others =>
        execute_CsrPlugin_writeData <= pkg_mux(pkg_extract(execute_INSTRUCTION,12),(execute_CsrPlugin_readToWriteData and pkg_not(execute_SRC1)),(execute_CsrPlugin_readToWriteData or execute_SRC1));
    end case;
  end process;

  execute_CsrPlugin_csrAddress <= pkg_extract(execute_INSTRUCTION,31,20);
  zz_75 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000110000000000100")) = pkg_stdLogicVector("00000000000000000010000000000000"));
  zz_76 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001001000")) = pkg_stdLogicVector("00000000000000000000000001001000"));
  zz_77 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000000100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_78 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000100000001010000")) = pkg_stdLogicVector("00000000000000000100000001010000"));
  zz_74 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_133) = pkg_stdLogicVector("00000000000000000000000000100000"))) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_134),pkg_cat(zz_135,zz_136)) /= pkg_stdLogicVector("0000"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_137,zz_138) /= pkg_stdLogicVector("00"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_139 /= zz_140)),pkg_cat(pkg_toStdLogicVector(zz_141),pkg_cat(zz_142,zz_143))))));
  zz_79 <= pkg_extract(zz_74,3,2);
  zz_42 <= zz_79;
  zz_80 <= pkg_extract(zz_74,6,5);
  zz_41 <= zz_80;
  zz_81 <= pkg_extract(zz_74,9,8);
  zz_40 <= zz_81;
  zz_82 <= pkg_extract(zz_74,12,11);
  zz_39 <= zz_82;
  zz_83 <= pkg_extract(zz_74,15,14);
  zz_38 <= zz_83;
  zz_84 <= pkg_extract(zz_74,19,18);
  zz_37 <= zz_84;
  zz_85 <= pkg_extract(zz_74,22,21);
  zz_36 <= zz_85;
  decode_RegFilePlugin_regFileReadAddress1 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,19,15));
  decode_RegFilePlugin_regFileReadAddress2 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,24,20));
  decode_RegFilePlugin_rs1Data <= zz_110;
  decode_RegFilePlugin_rs2Data <= zz_111;
  process(zz_34,writeBack_arbitration_isFiring,zz_86)
  begin
    lastStageRegFileWrite_valid <= (zz_34 and writeBack_arbitration_isFiring);
    if zz_86 = '1' then
      lastStageRegFileWrite_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  lastStageRegFileWrite_payload_address <= unsigned(pkg_extract(zz_33,11,7));
  lastStageRegFileWrite_payload_data <= zz_47;
  process(execute_ALU_BITWISE_CTRL,execute_SRC1,execute_SRC2)
  begin
    case execute_ALU_BITWISE_CTRL is
      when AluBitwiseCtrlEnum_defaultEncoding_AND_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 and execute_SRC2);
      when AluBitwiseCtrlEnum_defaultEncoding_OR_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 or execute_SRC2);
      when others =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 xor execute_SRC2);
    end case;
  end process;

  process(execute_ALU_CTRL,execute_IntAluPlugin_bitwise,execute_SRC_LESS,execute_SRC_ADD_SUB)
  begin
    case execute_ALU_CTRL is
      when AluCtrlEnum_defaultEncoding_BITWISE =>
        zz_87 <= execute_IntAluPlugin_bitwise;
      when AluCtrlEnum_defaultEncoding_SLT_SLTU =>
        zz_87 <= pkg_resize(pkg_toStdLogicVector(execute_SRC_LESS),32);
      when others =>
        zz_87 <= execute_SRC_ADD_SUB;
    end case;
  end process;

  process(decode_SRC1_CTRL,zz_29,decode_INSTRUCTION)
  begin
    case decode_SRC1_CTRL is
      when Src1CtrlEnum_defaultEncoding_RS =>
        zz_88 <= zz_29;
      when Src1CtrlEnum_defaultEncoding_PC_INCREMENT =>
        zz_88 <= pkg_resize(pkg_stdLogicVector("100"),32);
      when Src1CtrlEnum_defaultEncoding_IMU =>
        zz_88 <= pkg_cat(pkg_extract(decode_INSTRUCTION,31,12),std_logic_vector(pkg_unsigned("000000000000")));
      when others =>
        zz_88 <= pkg_resize(pkg_extract(decode_INSTRUCTION,19,15),32);
    end case;
  end process;

  zz_89 <= pkg_extract(pkg_extract(decode_INSTRUCTION,31,20),11);
  process(zz_89)
  begin
    zz_90(19) <= zz_89;
    zz_90(18) <= zz_89;
    zz_90(17) <= zz_89;
    zz_90(16) <= zz_89;
    zz_90(15) <= zz_89;
    zz_90(14) <= zz_89;
    zz_90(13) <= zz_89;
    zz_90(12) <= zz_89;
    zz_90(11) <= zz_89;
    zz_90(10) <= zz_89;
    zz_90(9) <= zz_89;
    zz_90(8) <= zz_89;
    zz_90(7) <= zz_89;
    zz_90(6) <= zz_89;
    zz_90(5) <= zz_89;
    zz_90(4) <= zz_89;
    zz_90(3) <= zz_89;
    zz_90(2) <= zz_89;
    zz_90(1) <= zz_89;
    zz_90(0) <= zz_89;
  end process;

  zz_91 <= pkg_extract(pkg_cat(pkg_extract(decode_INSTRUCTION,31,25),pkg_extract(decode_INSTRUCTION,11,7)),11);
  process(zz_91)
  begin
    zz_92(19) <= zz_91;
    zz_92(18) <= zz_91;
    zz_92(17) <= zz_91;
    zz_92(16) <= zz_91;
    zz_92(15) <= zz_91;
    zz_92(14) <= zz_91;
    zz_92(13) <= zz_91;
    zz_92(12) <= zz_91;
    zz_92(11) <= zz_91;
    zz_92(10) <= zz_91;
    zz_92(9) <= zz_91;
    zz_92(8) <= zz_91;
    zz_92(7) <= zz_91;
    zz_92(6) <= zz_91;
    zz_92(5) <= zz_91;
    zz_92(4) <= zz_91;
    zz_92(3) <= zz_91;
    zz_92(2) <= zz_91;
    zz_92(1) <= zz_91;
    zz_92(0) <= zz_91;
  end process;

  process(decode_SRC2_CTRL,zz_27,zz_90,decode_INSTRUCTION,zz_92,zz_26)
  begin
    case decode_SRC2_CTRL is
      when Src2CtrlEnum_defaultEncoding_RS =>
        zz_93 <= zz_27;
      when Src2CtrlEnum_defaultEncoding_IMI =>
        zz_93 <= pkg_cat(zz_90,pkg_extract(decode_INSTRUCTION,31,20));
      when Src2CtrlEnum_defaultEncoding_IMS =>
        zz_93 <= pkg_cat(zz_92,pkg_cat(pkg_extract(decode_INSTRUCTION,31,25),pkg_extract(decode_INSTRUCTION,11,7)));
      when others =>
        zz_93 <= std_logic_vector(zz_26);
    end case;
  end process;

  process(execute_SRC1,execute_SRC_USE_SUB_LESS,execute_SRC2,execute_SRC2_FORCE_ZERO)
  begin
    execute_SrcPlugin_addSub <= std_logic_vector(((signed(execute_SRC1) + signed(pkg_mux(execute_SRC_USE_SUB_LESS,pkg_not(execute_SRC2),execute_SRC2))) + pkg_mux(execute_SRC_USE_SUB_LESS,pkg_signed("00000000000000000000000000000001"),pkg_signed("00000000000000000000000000000000"))));
    if execute_SRC2_FORCE_ZERO = '1' then
      execute_SrcPlugin_addSub <= execute_SRC1;
    end if;
  end process;

  execute_SrcPlugin_less <= pkg_mux(pkg_toStdLogic(pkg_extract(execute_SRC1,31) = pkg_extract(execute_SRC2,31)),pkg_extract(execute_SrcPlugin_addSub,31),pkg_mux(execute_SRC_LESS_UNSIGNED,pkg_extract(execute_SRC2,31),pkg_extract(execute_SRC1,31)));
  execute_FullBarrelShifterPlugin_amplitude <= unsigned(pkg_extract(execute_SRC2,4,0));
  process(execute_SRC1)
  begin
    zz_94(0) <= pkg_extract(execute_SRC1,31);
    zz_94(1) <= pkg_extract(execute_SRC1,30);
    zz_94(2) <= pkg_extract(execute_SRC1,29);
    zz_94(3) <= pkg_extract(execute_SRC1,28);
    zz_94(4) <= pkg_extract(execute_SRC1,27);
    zz_94(5) <= pkg_extract(execute_SRC1,26);
    zz_94(6) <= pkg_extract(execute_SRC1,25);
    zz_94(7) <= pkg_extract(execute_SRC1,24);
    zz_94(8) <= pkg_extract(execute_SRC1,23);
    zz_94(9) <= pkg_extract(execute_SRC1,22);
    zz_94(10) <= pkg_extract(execute_SRC1,21);
    zz_94(11) <= pkg_extract(execute_SRC1,20);
    zz_94(12) <= pkg_extract(execute_SRC1,19);
    zz_94(13) <= pkg_extract(execute_SRC1,18);
    zz_94(14) <= pkg_extract(execute_SRC1,17);
    zz_94(15) <= pkg_extract(execute_SRC1,16);
    zz_94(16) <= pkg_extract(execute_SRC1,15);
    zz_94(17) <= pkg_extract(execute_SRC1,14);
    zz_94(18) <= pkg_extract(execute_SRC1,13);
    zz_94(19) <= pkg_extract(execute_SRC1,12);
    zz_94(20) <= pkg_extract(execute_SRC1,11);
    zz_94(21) <= pkg_extract(execute_SRC1,10);
    zz_94(22) <= pkg_extract(execute_SRC1,9);
    zz_94(23) <= pkg_extract(execute_SRC1,8);
    zz_94(24) <= pkg_extract(execute_SRC1,7);
    zz_94(25) <= pkg_extract(execute_SRC1,6);
    zz_94(26) <= pkg_extract(execute_SRC1,5);
    zz_94(27) <= pkg_extract(execute_SRC1,4);
    zz_94(28) <= pkg_extract(execute_SRC1,3);
    zz_94(29) <= pkg_extract(execute_SRC1,2);
    zz_94(30) <= pkg_extract(execute_SRC1,1);
    zz_94(31) <= pkg_extract(execute_SRC1,0);
  end process;

  execute_FullBarrelShifterPlugin_reversed <= pkg_mux(pkg_toStdLogic(execute_SHIFT_CTRL = ShiftCtrlEnum_defaultEncoding_SLL_1),zz_94,execute_SRC1);
  process(memory_SHIFT_RIGHT)
  begin
    zz_95(0) <= pkg_extract(memory_SHIFT_RIGHT,31);
    zz_95(1) <= pkg_extract(memory_SHIFT_RIGHT,30);
    zz_95(2) <= pkg_extract(memory_SHIFT_RIGHT,29);
    zz_95(3) <= pkg_extract(memory_SHIFT_RIGHT,28);
    zz_95(4) <= pkg_extract(memory_SHIFT_RIGHT,27);
    zz_95(5) <= pkg_extract(memory_SHIFT_RIGHT,26);
    zz_95(6) <= pkg_extract(memory_SHIFT_RIGHT,25);
    zz_95(7) <= pkg_extract(memory_SHIFT_RIGHT,24);
    zz_95(8) <= pkg_extract(memory_SHIFT_RIGHT,23);
    zz_95(9) <= pkg_extract(memory_SHIFT_RIGHT,22);
    zz_95(10) <= pkg_extract(memory_SHIFT_RIGHT,21);
    zz_95(11) <= pkg_extract(memory_SHIFT_RIGHT,20);
    zz_95(12) <= pkg_extract(memory_SHIFT_RIGHT,19);
    zz_95(13) <= pkg_extract(memory_SHIFT_RIGHT,18);
    zz_95(14) <= pkg_extract(memory_SHIFT_RIGHT,17);
    zz_95(15) <= pkg_extract(memory_SHIFT_RIGHT,16);
    zz_95(16) <= pkg_extract(memory_SHIFT_RIGHT,15);
    zz_95(17) <= pkg_extract(memory_SHIFT_RIGHT,14);
    zz_95(18) <= pkg_extract(memory_SHIFT_RIGHT,13);
    zz_95(19) <= pkg_extract(memory_SHIFT_RIGHT,12);
    zz_95(20) <= pkg_extract(memory_SHIFT_RIGHT,11);
    zz_95(21) <= pkg_extract(memory_SHIFT_RIGHT,10);
    zz_95(22) <= pkg_extract(memory_SHIFT_RIGHT,9);
    zz_95(23) <= pkg_extract(memory_SHIFT_RIGHT,8);
    zz_95(24) <= pkg_extract(memory_SHIFT_RIGHT,7);
    zz_95(25) <= pkg_extract(memory_SHIFT_RIGHT,6);
    zz_95(26) <= pkg_extract(memory_SHIFT_RIGHT,5);
    zz_95(27) <= pkg_extract(memory_SHIFT_RIGHT,4);
    zz_95(28) <= pkg_extract(memory_SHIFT_RIGHT,3);
    zz_95(29) <= pkg_extract(memory_SHIFT_RIGHT,2);
    zz_95(30) <= pkg_extract(memory_SHIFT_RIGHT,1);
    zz_95(31) <= pkg_extract(memory_SHIFT_RIGHT,0);
  end process;

  process(zz_98,zz_99,decode_INSTRUCTION,zz_119,zz_120,writeBack_INSTRUCTION,zz_121,zz_122,memory_INSTRUCTION,zz_123,zz_124,execute_INSTRUCTION,decode_RS1_USE)
  begin
    zz_96 <= pkg_toStdLogic(false);
    if zz_98 = '1' then
      if pkg_toStdLogic(zz_99 = pkg_extract(decode_INSTRUCTION,19,15)) = '1' then
        zz_96 <= pkg_toStdLogic(true);
      end if;
    end if;
    if zz_119 = '1' then
      if zz_120 = '1' then
        if pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15)) = '1' then
          zz_96 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_121 = '1' then
      if zz_122 = '1' then
        if pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15)) = '1' then
          zz_96 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_123 = '1' then
      if zz_124 = '1' then
        if pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15)) = '1' then
          zz_96 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if (not decode_RS1_USE) = '1' then
      zz_96 <= pkg_toStdLogic(false);
    end if;
  end process;

  process(zz_98,zz_99,decode_INSTRUCTION,zz_119,zz_120,writeBack_INSTRUCTION,zz_121,zz_122,memory_INSTRUCTION,zz_123,zz_124,execute_INSTRUCTION,decode_RS2_USE)
  begin
    zz_97 <= pkg_toStdLogic(false);
    if zz_98 = '1' then
      if pkg_toStdLogic(zz_99 = pkg_extract(decode_INSTRUCTION,24,20)) = '1' then
        zz_97 <= pkg_toStdLogic(true);
      end if;
    end if;
    if zz_119 = '1' then
      if zz_120 = '1' then
        if pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20)) = '1' then
          zz_97 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_121 = '1' then
      if zz_122 = '1' then
        if pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20)) = '1' then
          zz_97 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_123 = '1' then
      if zz_124 = '1' then
        if pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20)) = '1' then
          zz_97 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if (not decode_RS2_USE) = '1' then
      zz_97 <= pkg_toStdLogic(false);
    end if;
  end process;

  execute_BranchPlugin_eq <= pkg_toStdLogic(execute_SRC1 = execute_SRC2);
  zz_100 <= pkg_extract(execute_INSTRUCTION,14,12);
  process(zz_100,execute_BranchPlugin_eq,execute_SRC_LESS)
  begin
    if (zz_100 = pkg_stdLogicVector("000")) then
        zz_101 <= execute_BranchPlugin_eq;
    elsif (zz_100 = pkg_stdLogicVector("001")) then
        zz_101 <= (not execute_BranchPlugin_eq);
    elsif (pkg_toStdLogic((zz_100 and pkg_stdLogicVector("101")) = pkg_stdLogicVector("101")) = '1') then
        zz_101 <= (not execute_SRC_LESS);
    else
        zz_101 <= execute_SRC_LESS;
    end if;
  end process;

  process(execute_BRANCH_CTRL,zz_101)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_INC =>
        zz_102 <= pkg_toStdLogic(false);
      when BranchCtrlEnum_defaultEncoding_JAL =>
        zz_102 <= pkg_toStdLogic(true);
      when BranchCtrlEnum_defaultEncoding_JALR =>
        zz_102 <= pkg_toStdLogic(true);
      when others =>
        zz_102 <= zz_101;
    end case;
  end process;

  execute_BranchPlugin_branch_src1 <= pkg_mux(pkg_toStdLogic(execute_BRANCH_CTRL = BranchCtrlEnum_defaultEncoding_JALR),unsigned(execute_RS1),execute_PC);
  zz_103 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21)),19);
  process(zz_103)
  begin
    zz_104(10) <= zz_103;
    zz_104(9) <= zz_103;
    zz_104(8) <= zz_103;
    zz_104(7) <= zz_103;
    zz_104(6) <= zz_103;
    zz_104(5) <= zz_103;
    zz_104(4) <= zz_103;
    zz_104(3) <= zz_103;
    zz_104(2) <= zz_103;
    zz_104(1) <= zz_103;
    zz_104(0) <= zz_103;
  end process;

  zz_105 <= pkg_extract(pkg_extract(execute_INSTRUCTION,31,20),11);
  process(zz_105)
  begin
    zz_106(19) <= zz_105;
    zz_106(18) <= zz_105;
    zz_106(17) <= zz_105;
    zz_106(16) <= zz_105;
    zz_106(15) <= zz_105;
    zz_106(14) <= zz_105;
    zz_106(13) <= zz_105;
    zz_106(12) <= zz_105;
    zz_106(11) <= zz_105;
    zz_106(10) <= zz_105;
    zz_106(9) <= zz_105;
    zz_106(8) <= zz_105;
    zz_106(7) <= zz_105;
    zz_106(6) <= zz_105;
    zz_106(5) <= zz_105;
    zz_106(4) <= zz_105;
    zz_106(3) <= zz_105;
    zz_106(2) <= zz_105;
    zz_106(1) <= zz_105;
    zz_106(0) <= zz_105;
  end process;

  zz_107 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8)),11);
  process(zz_107)
  begin
    zz_108(18) <= zz_107;
    zz_108(17) <= zz_107;
    zz_108(16) <= zz_107;
    zz_108(15) <= zz_107;
    zz_108(14) <= zz_107;
    zz_108(13) <= zz_107;
    zz_108(12) <= zz_107;
    zz_108(11) <= zz_107;
    zz_108(10) <= zz_107;
    zz_108(9) <= zz_107;
    zz_108(8) <= zz_107;
    zz_108(7) <= zz_107;
    zz_108(6) <= zz_107;
    zz_108(5) <= zz_107;
    zz_108(4) <= zz_107;
    zz_108(3) <= zz_107;
    zz_108(2) <= zz_107;
    zz_108(1) <= zz_107;
    zz_108(0) <= zz_107;
  end process;

  process(execute_BRANCH_CTRL,zz_104,execute_INSTRUCTION,zz_106,zz_108)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_JAL =>
        zz_109 <= pkg_cat(pkg_cat(zz_104,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false)));
      when BranchCtrlEnum_defaultEncoding_JALR =>
        zz_109 <= pkg_cat(zz_106,pkg_extract(execute_INSTRUCTION,31,20));
      when others =>
        zz_109 <= pkg_cat(pkg_cat(zz_108,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false)));
    end case;
  end process;

  execute_BranchPlugin_branch_src2 <= unsigned(zz_109);
  execute_BranchPlugin_branchAdder <= (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  BranchPlugin_jumpInterface_valid <= ((memory_arbitration_isValid and memory_BRANCH_DO) and (not pkg_toStdLogic(false)));
  BranchPlugin_jumpInterface_payload <= memory_BRANCH_CALC;
  zz_21 <= decode_ALU_BITWISE_CTRL;
  zz_19 <= zz_37;
  zz_32 <= decode_to_execute_ALU_BITWISE_CTRL;
  zz_28 <= zz_36;
  zz_18 <= decode_ENV_CTRL;
  zz_15 <= execute_ENV_CTRL;
  zz_13 <= memory_ENV_CTRL;
  zz_16 <= zz_39;
  zz_45 <= decode_to_execute_ENV_CTRL;
  zz_44 <= execute_to_memory_ENV_CTRL;
  zz_46 <= memory_to_writeBack_ENV_CTRL;
  zz_11 <= decode_SHIFT_CTRL;
  zz_8 <= execute_SHIFT_CTRL;
  zz_9 <= zz_40;
  zz_25 <= decode_to_execute_SHIFT_CTRL;
  zz_24 <= execute_to_memory_SHIFT_CTRL;
  zz_30 <= zz_38;
  zz_6 <= decode_ALU_CTRL;
  zz_4 <= zz_41;
  zz_31 <= decode_to_execute_ALU_CTRL;
  zz_3 <= decode_BRANCH_CTRL;
  zz_1 <= zz_42;
  zz_22 <= decode_to_execute_BRANCH_CTRL;
  decode_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_toStdLogicVector(execute_arbitration_flushNext))) /= pkg_stdLogicVector("000")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushIt),pkg_toStdLogicVector(decode_arbitration_flushIt)))) /= pkg_stdLogicVector("0000")));
  execute_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_toStdLogicVector(memory_arbitration_flushNext)) /= pkg_stdLogicVector("00")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_toStdLogicVector(execute_arbitration_flushIt))) /= pkg_stdLogicVector("000")));
  memory_arbitration_isFlushed <= (pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushNext) /= pkg_stdLogicVector("0")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_toStdLogicVector(memory_arbitration_flushIt)) /= pkg_stdLogicVector("00")));
  writeBack_arbitration_isFlushed <= (pkg_toStdLogic(false) or pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushIt) /= pkg_stdLogicVector("0")));
  decode_arbitration_isStuckByOthers <= (decode_arbitration_haltByOther or (((pkg_toStdLogic(false) or execute_arbitration_isStuck) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  decode_arbitration_isStuck <= (decode_arbitration_haltItself or decode_arbitration_isStuckByOthers);
  decode_arbitration_isMoving <= ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt));
  decode_arbitration_isFiring <= ((decode_arbitration_isValid and (not decode_arbitration_isStuck)) and (not decode_arbitration_removeIt));
  execute_arbitration_isStuckByOthers <= (execute_arbitration_haltByOther or ((pkg_toStdLogic(false) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  execute_arbitration_isStuck <= (execute_arbitration_haltItself or execute_arbitration_isStuckByOthers);
  execute_arbitration_isMoving <= ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt));
  execute_arbitration_isFiring <= ((execute_arbitration_isValid and (not execute_arbitration_isStuck)) and (not execute_arbitration_removeIt));
  memory_arbitration_isStuckByOthers <= (memory_arbitration_haltByOther or (pkg_toStdLogic(false) or writeBack_arbitration_isStuck));
  memory_arbitration_isStuck <= (memory_arbitration_haltItself or memory_arbitration_isStuckByOthers);
  memory_arbitration_isMoving <= ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt));
  memory_arbitration_isFiring <= ((memory_arbitration_isValid and (not memory_arbitration_isStuck)) and (not memory_arbitration_removeIt));
  writeBack_arbitration_isStuckByOthers <= (writeBack_arbitration_haltByOther or pkg_toStdLogic(false));
  writeBack_arbitration_isStuck <= (writeBack_arbitration_haltItself or writeBack_arbitration_isStuckByOthers);
  writeBack_arbitration_isMoving <= ((not writeBack_arbitration_isStuck) and (not writeBack_arbitration_removeIt));
  writeBack_arbitration_isFiring <= ((writeBack_arbitration_isValid and (not writeBack_arbitration_isStuck)) and (not writeBack_arbitration_removeIt));
  iBus_cmd_payload_pc <= std_logic_vector(zz_49);
  dBus_cmd_payload_address <= std_logic_vector(zz_62);
  dBus_cmd_payload_size <= std_logic_vector(zz_63);
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
      IBusSimplePlugin_fetchPc_pcReg <= pkg_unsigned("00000000000000000000000000000000");
      IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(false);
      IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      zz_55 <= pkg_toStdLogic(false);
      zz_56 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_decodeRemoved <= pkg_toStdLogic(false);
      IBusSimplePlugin_pendingCmd <= pkg_unsigned("000");
      IBusSimplePlugin_rspJoin_discardCounter <= pkg_unsigned("000");
      CsrPlugin_misa_base <= pkg_unsigned("01");
      CsrPlugin_misa_extensions <= pkg_stdLogicVector("00000000000000000001000010");
      CsrPlugin_mtvec_mode <= pkg_stdLogicVector("00");
      CsrPlugin_mtvec_base <= pkg_unsigned("000000000000000000000000000000");
      CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPP <= pkg_unsigned("11");
      CsrPlugin_mie_MEIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MTIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MSIE <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= pkg_toStdLogic(false);
      CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      CsrPlugin_lastStageWasWfi <= pkg_toStdLogic(false);
      CsrPlugin_hadException <= pkg_toStdLogic(false);
      execute_CsrPlugin_wfiWake <= pkg_toStdLogic(false);
      zz_86 <= pkg_toStdLogic(true);
      zz_98 <= pkg_toStdLogic(false);
      execute_arbitration_isValid <= pkg_toStdLogic(false);
      memory_arbitration_isValid <= pkg_toStdLogic(false);
      writeBack_arbitration_isValid <= pkg_toStdLogic(false);
      memory_to_writeBack_REGFILE_WRITE_DATA <= pkg_stdLogicVector("00000000000000000000000000000000");
      memory_to_writeBack_INSTRUCTION <= pkg_stdLogicVector("00000000000000000000000000000000");
      else
        IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(true);
        if (IBusSimplePlugin_fetchPc_corrected or IBusSimplePlugin_fetchPc_pcRegPropagate) = '1' then
          IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
        end if;
        if (IBusSimplePlugin_fetchPc_output_valid and IBusSimplePlugin_fetchPc_output_ready) = '1' then
          IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(true);
        end if;
        if ((not IBusSimplePlugin_fetchPc_output_valid) and IBusSimplePlugin_fetchPc_output_ready) = '1' then
          IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
        end if;
        if (IBusSimplePlugin_fetchPc_booted and ((IBusSimplePlugin_fetchPc_output_ready or IBusSimplePlugin_fetcherflushIt) or IBusSimplePlugin_fetchPc_pcRegPropagate)) = '1' then
          IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          zz_55 <= pkg_toStdLogic(false);
        end if;
        if zz_53 = '1' then
          zz_55 <= IBusSimplePlugin_iBusRsp_stages_0_output_valid;
        end if;
        if IBusSimplePlugin_iBusRsp_output_ready = '1' then
          zz_56 <= IBusSimplePlugin_iBusRsp_output_valid;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          zz_56 <= pkg_toStdLogic(false);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
        end if;
        if (not (not IBusSimplePlugin_iBusRsp_stages_1_input_ready)) = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(true);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
        end if;
        if (not (not IBusSimplePlugin_injector_decodeInput_ready)) = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
        end if;
        if (not execute_arbitration_isStuck) = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
        end if;
        if (not memory_arbitration_isStuck) = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
        end if;
        if (not writeBack_arbitration_isStuck) = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_4 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
        end if;
        if decode_arbitration_removeIt = '1' then
          IBusSimplePlugin_injector_decodeRemoved <= pkg_toStdLogic(true);
        end if;
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_injector_decodeRemoved <= pkg_toStdLogic(false);
        end if;
        IBusSimplePlugin_pendingCmd <= IBusSimplePlugin_pendingCmdNext;
        IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_rspJoin_discardCounter - pkg_resize(unsigned(pkg_toStdLogicVector((iBus_rsp_valid and pkg_toStdLogic(IBusSimplePlugin_rspJoin_discardCounter /= pkg_unsigned("000"))))),3));
        if IBusSimplePlugin_fetcherflushIt = '1' then
          IBusSimplePlugin_rspJoin_discardCounter <= (IBusSimplePlugin_pendingCmd - pkg_resize(unsigned(pkg_toStdLogicVector(iBus_rsp_valid)),3));
        end if;
        if (not execute_arbitration_isStuck) = '1' then
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= pkg_toStdLogic(false);
        else
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
        end if;
        if (not memory_arbitration_isStuck) = '1' then
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute and (not execute_arbitration_isStuck));
        else
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
        end if;
        if (not writeBack_arbitration_isStuck) = '1' then
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory and (not memory_arbitration_isStuck));
        else
          CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= pkg_toStdLogic(false);
        end if;
        CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
        if zz_125 = '1' then
          if zz_126 = '1' then
            CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
          end if;
          if zz_127 = '1' then
            CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
          end if;
          if zz_128 = '1' then
            CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
          end if;
        end if;
        CsrPlugin_lastStageWasWfi <= (writeBack_arbitration_isFiring and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_defaultEncoding_WFI));
        CsrPlugin_hadException <= CsrPlugin_exception;
        if zz_114 = '1' then
          case CsrPlugin_targetPrivilege is
            when "11" =>
              CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
              CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
              CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
            when others =>
          end case;
        end if;
        if zz_115 = '1' then
          case zz_116 is
            when "11" =>
              CsrPlugin_mstatus_MPP <= pkg_unsigned("00");
              CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
              CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(true);
            when others =>
          end case;
        end if;
        execute_CsrPlugin_wfiWake <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_73),pkg_cat(pkg_toStdLogicVector(zz_72),pkg_toStdLogicVector(zz_71))) /= pkg_stdLogicVector("000")) or CsrPlugin_thirdPartyWake);
        zz_86 <= pkg_toStdLogic(false);
        zz_98 <= (zz_34 and writeBack_arbitration_isFiring);
        if (not writeBack_arbitration_isStuck) = '1' then
          memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
        end if;
        if (not writeBack_arbitration_isStuck) = '1' then
          memory_to_writeBack_REGFILE_WRITE_DATA <= zz_23;
        end if;
        if ((not execute_arbitration_isStuck) or execute_arbitration_removeIt) = '1' then
          execute_arbitration_isValid <= pkg_toStdLogic(false);
        end if;
        if ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt)) = '1' then
          execute_arbitration_isValid <= decode_arbitration_isValid;
        end if;
        if ((not memory_arbitration_isStuck) or memory_arbitration_removeIt) = '1' then
          memory_arbitration_isValid <= pkg_toStdLogic(false);
        end if;
        if ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt)) = '1' then
          memory_arbitration_isValid <= execute_arbitration_isValid;
        end if;
        if ((not writeBack_arbitration_isStuck) or writeBack_arbitration_removeIt) = '1' then
          writeBack_arbitration_isValid <= pkg_toStdLogic(false);
        end if;
        if ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt)) = '1' then
          writeBack_arbitration_isValid <= memory_arbitration_isValid;
        end if;
        case execute_CsrPlugin_csrAddress is
          when "001100000000" =>
            if execute_CsrPlugin_writeEnable = '1' then
              CsrPlugin_mstatus_MPP <= unsigned(pkg_extract(execute_CsrPlugin_writeData,12,11));
              CsrPlugin_mstatus_MPIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,7,7),0);
              CsrPlugin_mstatus_MIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
            end if;
          when "111100010001" =>
          when "111100010100" =>
          when "001101000001" =>
          when "101100000000" =>
          when "101110000000" =>
          when "001101000100" =>
          when "001100000101" =>
            if execute_CsrPlugin_writeEnable = '1' then
              CsrPlugin_mtvec_base <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,2));
              CsrPlugin_mtvec_mode <= pkg_extract(execute_CsrPlugin_writeData,1,0);
            end if;
          when "101100000010" =>
          when "111100010011" =>
          when "001101000011" =>
          when "110000000000" =>
          when "001100000001" =>
            if execute_CsrPlugin_writeEnable = '1' then
              CsrPlugin_misa_base <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,30));
              CsrPlugin_misa_extensions <= pkg_extract(execute_CsrPlugin_writeData,25,0);
            end if;
          when "001101000000" =>
          when "111100010010" =>
          when "001100000100" =>
            if execute_CsrPlugin_writeEnable = '1' then
              CsrPlugin_mie_MEIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,11,11),0);
              CsrPlugin_mie_MTIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,7,7),0);
              CsrPlugin_mie_MSIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
            end if;
          when "101110000010" =>
          when "110010000000" =>
          when "001101000010" =>
          when others =>
        end case;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if IBusSimplePlugin_iBusRsp_output_ready = '1' then
        zz_57 <= IBusSimplePlugin_iBusRsp_output_payload_pc;
        zz_58 <= IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
        zz_59 <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
        zz_60 <= IBusSimplePlugin_iBusRsp_output_payload_isRvc;
      end if;
      if IBusSimplePlugin_injector_decodeInput_ready = '1' then
        IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
      end if;
      assert (not (((dBus_rsp_ready and memory_MEMORY_ENABLE) and memory_arbitration_isValid) and memory_arbitration_isStuck)) = '1' report "DBusSimplePlugin doesn't allow memory stage stall when read happend"  severity ERROR;
      assert (not (((writeBack_arbitration_isValid and writeBack_MEMORY_ENABLE) and (not writeBack_MEMORY_STORE)) and writeBack_arbitration_isStuck)) = '1' report "DBusSimplePlugin doesn't allow writeback stage stall when read happend"  severity ERROR;
      CsrPlugin_mip_MEIP <= externalInterrupt;
      CsrPlugin_mip_MTIP <= timerInterrupt;
      CsrPlugin_mip_MSIP <= softwareInterrupt;
      CsrPlugin_mcycle <= (CsrPlugin_mcycle + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      if writeBack_arbitration_isFiring = '1' then
        CsrPlugin_minstret <= (CsrPlugin_minstret + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      end if;
      if CsrPlugin_selfException_valid = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionContext_code <= CsrPlugin_selfException_payload_code;
        CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= CsrPlugin_selfException_payload_badAddr;
      end if;
      if zz_125 = '1' then
        if zz_126 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0111");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if zz_127 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if zz_128 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("1011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
      end if;
      if zz_114 = '1' then
        case CsrPlugin_targetPrivilege is
          when "11" =>
            CsrPlugin_mcause_interrupt <= (not CsrPlugin_hadException);
            CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
            CsrPlugin_mepc <= writeBack_PC;
            if CsrPlugin_hadException = '1' then
              CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
            end if;
          when others =>
        end case;
      end if;
      zz_99 <= pkg_extract(zz_33,11,7);
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_RS1 <= zz_29;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC1 <= decode_SRC1;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ALU_BITWISE_CTRL <= zz_20;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ENV_CTRL <= zz_17;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_ENV_CTRL <= zz_14;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_ENV_CTRL <= zz_12;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SHIFT_CTRL <= zz_10;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_SHIFT_CTRL <= zz_7;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_IS_CSR <= decode_IS_CSR;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_STORE <= memory_MEMORY_STORE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_REGFILE_WRITE_DATA <= zz_43;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_FORMAL_PC_NEXT <= decode_FORMAL_PC_NEXT;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_FORMAL_PC_NEXT <= zz_48;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC2 <= decode_SRC2;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ALU_CTRL <= zz_5;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_PC <= zz_26;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_PC <= execute_PC;
      end if;
      if ((not writeBack_arbitration_isStuck) and (not CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)) = '1' then
        memory_to_writeBack_PC <= memory_PC;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BRANCH_CTRL <= zz_2;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_RS2 <= zz_27;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
      end if;
      case execute_CsrPlugin_csrAddress is
        when "001100000000" =>
        when "111100010001" =>
        when "111100010100" =>
        when "001101000001" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mepc <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "101100000000" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mcycle(31 downto 0) <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "101110000000" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mcycle(63 downto 32) <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "001101000100" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mip_MSIP <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
          end if;
        when "001100000101" =>
        when "101100000010" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_minstret(31 downto 0) <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "111100010011" =>
        when "001101000011" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mtval <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "110000000000" =>
        when "001100000001" =>
        when "001101000000" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mscratch <= pkg_extract(execute_CsrPlugin_writeData,31,0);
          end if;
        when "111100010010" =>
        when "001100000100" =>
        when "101110000010" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_minstret(63 downto 32) <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
          end if;
        when "110010000000" =>
        when "001101000010" =>
          if execute_CsrPlugin_writeEnable = '1' then
            CsrPlugin_mcause_interrupt <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,31,31),0);
            CsrPlugin_mcause_exceptionCode <= unsigned(pkg_extract(execute_CsrPlugin_writeData,3,0));
          end if;
        when others =>
      end case;
    end if;
  end process;

end arch;

