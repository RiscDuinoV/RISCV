library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.type_package.all;

entity Top is
    generic
    (  
		FREQ_MHZ            :   integer := 100;
        RAM_SIZE            :   integer := 64;
        INIT_FILE_FORMAT    :   string  := "hex";
        INIT_FILE_NAME      :   string  := "../../../software/projects/bootloader/bin/Sortie.mem";
        GenJTAG             :   boolean := false;

        C_Sio				:	integer := 1;
        C_Sio_Rx_Fifo_Depth	: 	integer := 16;
        C_Sio_Tx_Fifo_Depth : 	integer := 16;
		C_Spi				:	integer := 0;
		C_i2c				:	integer := 0;
		C_simple_in			:	integer := 0;
		C_simple_out		:	integer := 8;
		C_gpio				:	integer := 0;
        C_timers			:	integer := 0;
        C_BootTrap          :   boolean := true;
        C_ProtectRam        :   integer := 0;
        C_Slaves            :   integer := 1;
        C_Registers         :   integer := 256
    );
    port
    (
        ARst_N      :   in  std_logic;
        Clk         :   in  std_logic;
        
        Sio_Rx      :   in  std_logic;
        Sio_Tx      :   out std_logic;

        Spi_Sck     :   out std_logic;
        Spi_Miso    :   in  std_logic;
        Spi_Mosi    :   out std_logic;
        Spi_Ce_N    :   out std_logic;

--        I2C_Scl     :   out std_logic;
--        I2C_Sda     :   inout   std_logic;     

        Leds        :   out std_logic_vector(3 downto 0)         
    );
end entity Top;

architecture rtl of Top is
    signal ARst                 :   std_logic;
    signal MCU_RST              :   std_logic;
    signal iClk                 :   std_logic;

    signal Simple_Out           :   std_logic_vector(7 downto 0);

    signal R_Spi_Sck            :   std_logic;
    signal R_Spi_Miso           :   std_logic;
    signal R_Spi_Mosi           :   std_logic;
    signal R_Spi_Ce_N           :   std_logic;

    signal R_Sio_Rx             :   std_logic;
    signal R_Sio_Tx             :   std_logic;

    signal Bus_cmd_io           :   bus_cmd_t;
    signal Bus_cmd_io_ce        :   std_logic_vector(C_Slaves - 1 downto 0);
    signal Bus_rsp_io           :   bus_rsp_array_t(0 to C_Slaves - 1);

    signal Jtag_tms             :    std_logic;
    signal Jtag_tdi             :    std_logic;
    signal Jtag_tdo             :    std_logic;
    signal Jtag_tck             :    std_logic;
    
begin
    ARst <= not ARst_N;
    MCU_RST <= ARst;
    iClk <= Clk;
    SocAddressDecoder : entity work.SocAddressDecoder
    generic map
    (
        FREQ_MHZ            => FREQ_MHZ,
        RAM_SIZE	        => RAM_SIZE,
        INIT_FILE_FORMAT    => INIT_FILE_FORMAT,
        INIT_FILE_NAME      => INIT_FILE_NAME,
        GenJTAG             => GenJTAG,

        C_Sio				=>  C_Sio,
        C_Sio_Rx_Fifo_Depth	=>  C_Sio_Rx_Fifo_Depth,
        C_Sio_Tx_Fifo_Depth =>  C_Sio_Tx_Fifo_Depth,
        C_Spi				=>  C_Spi,
        C_i2c				=>  C_i2c,
        C_simple_in			=>  C_simple_in,
        C_simple_out		=>  C_simple_out,
        C_gpio				=>  C_gpio,
        C_timers			=>  C_timers,
        C_BootTrap          =>  C_BootTrap,
        C_ProtectRam        =>  C_ProtectRam,
        C_Slaves            =>  C_Slaves,
        C_Registers         =>  C_Registers
    )
    port map
    (
        ARst             	=> MCU_RST,
        Clk        	        => iClk,

        -- Jtag
        Jtag_tms            => Jtag_tms,
        Jtag_tdi            => Jtag_tdi,
        Jtag_tdo            => Jtag_tdo,
        Jtag_tck            => Jtag_tck,

        --uart
        Sio_Rx(0)		    => R_Sio_Rx,
        Sio_Tx(0)           => R_Sio_Tx,

        -- SPI
        Spi_Sck(0)          => R_Spi_Sck,
        Spi_Miso(0)         => R_Spi_Miso,
        Spi_Mosi(0)         => R_Spi_Mosi,
        Spi_Ce_N(0)         => R_Spi_Ce_N,

--      I2C_Scl(0)          => I2C_Scl,
--		I2C_Sda(0)	        => I2C_Sda,

        -- Simple_IO
        Simple_Out	        => Simple_Out,
        
        Bus_cmd_io          => Bus_cmd_io,
        Bus_cmd_io_ce       => Bus_cmd_io_ce,
        Bus_rsp_io          => Bus_rsp_io
    );

    R_Sio_Rx    <=  Sio_Rx;
    Sio_Tx      <=  R_Sio_Tx;

    Spi_Sck         <=  R_Spi_Sck;
    R_Spi_Miso      <=  Spi_Miso;
    Spi_Mosi        <=  R_Spi_Mosi;
    Spi_Ce_N        <=  R_Spi_Ce_N;

    Leds        <=  Simple_Out(7 downto 6) & Simple_Out(1 downto 0);

    genSlaves: for i in 1 to C_Slaves - 1 generate
        Bus_rsp_io(i).DAT        <=  (others => '-');   	
        Bus_rsp_io(i).RSP_ACK    <=  '0';
        Bus_rsp_io(i).CMD_ACK    <=  '0';
    end generate genSlaves;
    Example : entity work.Example
        port map
        (
            Rst     =>  '0',
            Clk     =>  iClk,
            Ce      =>  Bus_cmd_io_ce(0),
            
            Bp      =>  '0',
    
            Cmd     =>  Bus_cmd_io,
            Rsp     =>  Bus_rsp_io(0),
    
            IRQ     =>  open
        );
    
end architecture rtl;