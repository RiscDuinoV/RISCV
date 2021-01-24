library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.type_package.all;

entity SocAddressDecoder is
    generic 
    (
        FREQ_MHZ            :	integer;
        RAM_SIZE            :	integer                 := 8;
        INIT_FILE_FORMAT    :   string                  := "hex";
        INIT_FILE_NAME      :   string                  := "none";
        ALTERA_FAMILY       :	string	                := "NONE";
        LATTICE_FAMILY      :   string                  := "NONE";
        GenJTAG             :   boolean	                :=  false;

        C_Sio               :	integer	range 0 to 4    := 1;
        C_Sio_Rx_Fifo_Depth : 	integer                 := 16;
        C_Sio_Tx_Fifo_Depth : 	integer                 := 16;
        C_Spi               :	integer range 0 to 4    := 1;
        C_i2c               :	integer range 0 to 4    := 1;
        C_simple_in         :	integer range 0 to 32   := 32;
        C_simple_out        :	integer range 0 to 32   := 32;
        C_gpio              :	integer range 0	to 32   := 32;
        C_timers            :	integer range 0 to 8    := 0;
        C_BootTrap          :   boolean                 := false;
        C_ProtectRam        :   integer                 :=  0;
        C_Slaves            :   integer;
        C_Registers         :   integer
    );
    port 
    (
        ARst                :   in  std_logic;
        Clk                 :   in  std_logic;

        -- Jtag
        Jtag_tms            :   in  std_logic                                       :=  '0';
        Jtag_tdi            :   in  std_logic                                       :=  '0';
        Jtag_tdo            :   out std_logic;
        Jtag_tck            :   in  std_logic                                       :=  '0';

        --uart
        Sio_Rx              :   in  std_logic_vector(C_Sio - 1 downto 0)            :=  (others => '1');
        Sio_Tx              :   out std_logic_vector(C_Sio - 1 downto 0);

        -- SPI
        Spi_Sck             :   out std_logic_vector(C_Sio - 1 downto 0);
        Spi_Miso            :   in  std_logic_vector(C_Spi - 1 downto 0)            :=  (others => '0');
        Spi_Mosi            :   out std_logic_vector(C_Spi - 1 downto 0);
        Spi_Ce_N            :   out std_logic_vector(C_Spi - 1 downto 0);
        
        -- I2C
        I2C_Scl	            :   out     std_logic_vector(C_i2c - 1 downto 0)        := 	(others => '0');
        I2C_Sda	            :   inout   std_logic_vector(C_i2c - 1 downto 0);
        
        Gpio                :   inout   std_logic_vector(C_gpio - 1 downto 0);

        -- Simple_IO
        Simple_in           :   in  std_logic_vector(C_simple_in - 1 downto 0)      := (others => '0');
        Simple_out	        :   out std_logic_vector(C_simple_out - 1 downto 0);

        Bus_cmd_io          :   out bus_cmd_t;
        Bus_cmd_io_ce       :   out std_logic_vector(C_Slaves - 1 downto 0);
        Bus_rsp_io          :   in  bus_rsp_array_t(0 to C_Slaves - 1);

        Ext_IRQ             :   in  std_logic_vector(31 downto 0)                   := (others => '0');

        Reset_Rqst          :   out std_logic
    );
end entity SocAddressDecoder;

architecture rtl of SocAddressDecoder is
    signal Bus_cmd_cpu      :   bus_cmd_t;
    signal Bus_rsp_cpu      :   bus_rsp_t;

    signal ADR_O            :   std_logic_vector(31 downto 2);
    signal DAT_O            :   std_logic_vector(31 downto 0);
    signal WE_O             :   std_logic;
    signal STB_O            :   std_logic;
    signal SEL_O            :   std_logic_vector(3 downto 0);

    signal DAT_I            :   std_logic_vector(31 downto 0);
    signal RSP_ACK_I        :   std_logic;
    signal CMD_ACK_I        :   std_logic;
begin
    
    Address_Decoder : entity work.Address_Decoder
        generic map
        (
            C_Slaves        =>  C_Slaves,
            C_Registers     =>  C_Registers
        )
        port map
        (
            ARst            =>  ARst,
            Clk             =>  Clk,
    
            ADR_I           =>  ADR_O,
            DAT_I           =>  DAT_O,
            WE_I            =>  WE_O,
            STB_I           =>  STB_O,
            SEL_I           =>  SEL_O,
        
            DAT_O           =>  DAT_I,
            RSP_ACK_O       =>  RSP_ACK_I,
            CMD_ACK_O       =>  CMD_ACK_I,
            
            Bus_cmd_io      =>  Bus_cmd_io,
            Bus_cmd_io_ce   =>  Bus_cmd_io_ce,
            Bus_rsp_io      =>  Bus_rsp_io
        );

    soc : entity work.soc
        generic map
        (
            FREQ_MHZ            =>  FREQ_MHZ,
            RAM_SIZE            =>  RAM_SIZE,
            INIT_FILE_FORMAT    =>  INIT_FILE_FORMAT,
            INIT_FILE_NAME      =>  INIT_FILE_NAME,
            ALTERA_FAMILY       =>  ALTERA_FAMILY,
            LATTICE_FAMILY      =>  LATTICE_FAMILY,
            GenJTAG             =>  GenJTAG,

            C_Sio               =>  C_Sio,
            C_Sio_Rx_Fifo_Depth =>  C_Sio_Rx_Fifo_Depth,
            C_Sio_Tx_Fifo_Depth =>  C_Sio_Tx_Fifo_Depth,
            C_Spi               =>  C_Spi,
            C_i2c               =>  C_i2c,
            C_simple_in         =>  C_simple_in,
            C_simple_out        =>  C_simple_out,
            C_gpio              =>  C_gpio,
            C_timers            =>  C_timers,
            C_BootTrap          =>  C_BootTrap,
            C_ProtectRam        =>  C_ProtectRam
        )
        port map
        (
            Rst             =>  ARst,
            Clk             =>  Clk,
    
            Ext_ADR_O       =>  ADR_O,
            Ext_DAT_O       =>  DAT_O,
            Ext_WE_O        =>  WE_O,
            Ext_STB_O       =>  STB_O,
            Ext_SEL_O       =>  SEL_O,
        
            Ext_DAT_I       =>  DAT_I,
            Ext_RSP_ACK_I   =>  RSP_ACK_I,
            Ext_CMD_ACK_I   =>  CMD_ACK_I,

            Ext_IRQv        =>  Ext_IRQ,
    
            -- Jtag
            Jtag_tms        =>  Jtag_tms,
            Jtag_tdi        =>  Jtag_tdi,
            Jtag_tdo        =>  Jtag_tdo,
            Jtag_tck        =>  Jtag_tck,
    
            --uart
            Sio_Rx          =>  Sio_Rx,
            Sio_Tx          =>  Sio_Tx,
    
            -- SPI
            Spi_Sck         =>  Spi_Sck,
            Spi_Miso        =>  Spi_Miso,
            Spi_Mosi        =>  Spi_Mosi,
            Spi_Ce_N        =>  Spi_Ce_N,
            
            -- I2C
            I2C_Scl         =>  I2C_Scl,
            I2C_Sda         =>  I2C_Sda,
            
            -- GPIO
            Gpio            =>  Gpio,
    
            -- Simple_IO
            Simple_in       =>  Simple_in,
            Simple_out      =>  Simple_out,

            Reset_Rqst      =>  Reset_Rqst
      );
end architecture rtl;