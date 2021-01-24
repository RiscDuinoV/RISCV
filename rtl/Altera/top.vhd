library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.type_package.all;

entity top is
    generic
    (
        FREQ_MHZ            :   integer := 50;
        RAM_SIZE            :   integer := 32;
        INIT_FILE_FORMAT    :   string  := "hex";
        INIT_FILE_NAME      :   string  := "../../../../../RiscV_Projects/bootloader/bin/Sortie.mif";
        ALTERA_FAMILY       :   string  := "Cyclone IV E";
        GenJTAG             :   boolean := false;

        C_Sio				:	integer := 1;
        C_Sio_Rx_Fifo_Depth	: 	integer := 16;
        C_Sio_Tx_Fifo_Depth : 	integer := 16;
        C_Spi				:	integer := 1;
        C_i2c				:	integer := 0;
        C_simple_in			:	integer := 0;
        C_simple_out		:	integer := 8;
        C_gpio				:	integer := 0;
        C_timers			:	integer := 0;
        C_BootTrap          :   boolean := true;
        C_ProtectRam        :   integer := 0
    );
    port 
    (
        ARst_N      :   in  std_logic;
        Clk         :   in  std_logic;

        Jtag_tms    :   in  std_logic;
        Jtag_tdi    :   in  std_logic;
        Jtag_tdo    :   out  std_logic;
        Jtag_tck    :   in  std_logic;

        Sio_Rx      :   in  std_logic;
        Sio_Tx      :   out std_logic;

        Leds        :   out std_logic_vector(7 downto 0)
    );
end entity top;

architecture rtl of top is
    signal MCU_RST              :   std_logic;
    signal Clk_MCU              :   std_logic;

    signal Simple_Out_O         :   std_logic_vector(7 downto 0);

    signal R_Sio_Rx             :   std_logic;
    signal R_Sio_Tx             :   std_logic;
     
    signal User_Bus_cmd_io      :   user_bus_cmd_t;
    signal User_Bus_cmd_io_ce   :   std_logic_vector(7 downto 0);
    signal User_Bus_rsp_io      :   user_bus_rsp_array_t(0 to 7);

    signal IRQ                  :   std_logic;
    signal User_Ext_IRQ         :   std_logic_vector(31 downto 0);
begin
    MCU_RST <= not ARst_N;
    Clk_MCU <= Clk;
    SocAddressDecoder : entity work.SocAddressDecoder
        generic map
        (
            FREQ_MHZ            =>  FREQ_MHZ,
            RAM_SIZE            =>  RAM_SIZE,
            INIT_FILE_FORMAT    =>  INIT_FILE_FORMAT,
            INIT_FILE_NAME      =>  INIT_FILE_NAME,
            ALTERA_FAMILY       =>  ALTERA_FAMILY,
            GenJTAG             =>  GenJTAG,
    
            C_Sio				=>  C_Sio,
            C_Sio_Rx_Fifo_Depth	=>  C_Sio_Rx_Fifo_Depth,
            C_Sio_Tx_Fifo_Depth =>  C_Sio_Tx_Fifo_Depth,
            C_Spi				=>  C_Spi,
            C_i2c				=>  C_i2c,
            C_simple_in			=>  C_simple_in,
            C_simple_out		=>  C_simple_out,
            C_gpio				=>  C_gpio,
            C_timers			=>  C_timers,
            C_BootTrap          =>  C_BootTrap
        )
        port map
        (
            ARst             	=> MCU_RST,
            Clk        	        => Clk_MCU,

            -- Jtag
            Jtag_tms            => Jtag_tms,
            Jtag_tdi            => Jtag_tdi,
            Jtag_tdo            => Jtag_tdo,
            Jtag_tck            => Jtag_tck,

            --uart
            Sio_Rx(0)		    => R_Sio_Rx,
            Sio_Tx(0)           => R_Sio_Tx,
    
            -- Simple_IO
            Simple_Out	        => Simple_Out_O,
            
            User_Bus_cmd_io     => User_Bus_cmd_io,
            User_Bus_cmd_io_ce  => User_Bus_cmd_io_ce,
            User_Bus_rsp_io     => User_Bus_rsp_io,

            User_Ext_IRQ        => User_Ext_IRQ 
        );
    genSlaves: for i in 0 to 7 generate
        User_Bus_rsp_io(i).User_DAT        <=  (others => '-');   	
        User_Bus_rsp_io(i).User_RSP_ACK    <=  '0';
        User_Bus_rsp_io(i).User_CMD_ACK    <=  '0';
    end generate genSlaves;
    Leds <= Simple_Out_O(7 downto 0);

    Sio_Tx    <=  R_Sio_Tx;
    R_Sio_Rx    <=  Sio_Rx;
end architecture rtl;
