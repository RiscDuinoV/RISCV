library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity top is
    port (
        pin_arst_n_i : in std_logic;
        pin_clk_i : in std_logic;
        pin_uart_rx_i : in std_logic;
        pin_uart_tx_o : out std_logic;
--        pin_spi_sck_o : out std_logic;
        pin_spi_mosi_o : out std_logic;
        pin_spi_miso_i : in std_logic;
        pin_spi_ss_o : out std_logic;
        pin_i2c_scl_io : inout std_logic;
        pin_i2c_sda_io : inout std_logic;
        pin_btn_n_i : inout std_logic_vector(3 downto 0);
        pin_sw_i : inout std_logic_vector(3 downto 0);
        pin_led_o : out std_logic_vector(9 downto 0)
    );
end entity top;

architecture rtl of top is
    constant C_FREQ : integer := 50e6;
    constant C_UART : integer := 1;
    constant C_SPI : integer := 1;
    constant C_I2C : integer := 1;
    constant C_GPIO : integer := 18;
    signal arst, arst_n : std_logic;
    signal clk : std_logic;
    signal pll_lock : std_logic_vector(0 downto 0);
    signal uart_rx, uart_tx : std_logic_vector(C_UART - 1 downto 0);
    signal spi_sck, spi_mosi, spi_miso, spi_ss : std_logic_vector(C_SPI - 1 downto 0);
    signal i2c_scl, i2c_sda : std_logic_vector(C_I2C - 1 downto 0);
    signal gpio : std_logic_vector(C_GPIO - 1 downto 0);
    signal xtr_cmd : xtr_cmd_t;
    signal xtr_rsp : xtr_rsp_t;
begin

    u_pll_wrapper : entity work.pll_wrapper
        generic map (
            C_CLK_IN_PER => 10.0, C_PLL_MULT => 10, C_PLL_DIV => 1, C_CLK0_DIV => 20)
        port map (
            rst_i => '0', clk_i => pin_clk_i, clk0_o => clk, lock_o => pll_lock(0));

    arst_n <= pin_arst_n_i and pll_lock(0);
    arst <= not arst_n;


    u_xtr_soc : entity work.soc
        generic map (
            C_FREQ_IN => C_FREQ, C_RAM_SIZE => 32*1024, C_INIT_FILE => "E:/Dev/XtrRiscv-VexRiscv/soft/HAL/projects/bootloader/bin/bootloader.mem",
            C_UART => C_UART, C_SPI => C_SPI, C_I2C => C_I2C, C_GPIO => C_GPIO, C_BOOT_TRAP => TRUE)
        port map (
            arst_i => arst, clk_i => clk,
            tck_i => '0', tdi_i => '0', tdo_o => open, tms_i => '0',
            uart_rx_i => uart_rx, uart_tx_o => uart_tx,
            spi_sck_o => spi_sck, spi_mosi_o => spi_mosi, spi_miso_i => spi_miso, spi_ss_o => spi_ss,
            i2c_scl_io => i2c_scl, i2c_sda_io => i2c_sda,
            gpio_io => gpio,
            xtr_cmd_o => xtr_cmd, xtr_rsp_i => xtr_rsp);

    pin_uart_tx_o <= uart_tx(0);
    uart_rx(0) <= pin_uart_rx_i;

--    pin_spi_sck_o <= spi_sck(0);
    pin_spi_mosi_o <= spi_mosi(0);
    spi_miso(0) <= pin_spi_miso_i;
    pin_spi_ss_o <= spi_ss(0);

    pin_i2c_scl_io <= i2c_scl(0);
    pin_i2c_sda_io <= i2c_sda(0);
    i2c_sda(0) <= pin_i2c_sda_io;

    gpio(3 downto 0) <= pin_btn_n_i;
    pin_btn_n_i <= gpio(3 downto 0);
    gpio(7 downto 4) <= pin_sw_i;
    pin_sw_i <= gpio(7 downto 4);
    pin_led_o <= gpio(17 downto 8);

    -- 
    u_STARTUPE2 : STARTUPE2
    generic map (
       PROG_USR => "FALSE",  -- Activate program event security feature. Requires encrypted bitstreams.
       SIM_CCLK_FREQ => 0.0  -- Set the Configuration Clock Frequency(ns) for simulation.
    )
    port map (
       CFGCLK => open,       -- 1-bit output: Configuration main clock output
       CFGMCLK => open,     -- 1-bit output: Configuration internal oscillator clock output
       EOS => open,             -- 1-bit output: Active high output signal indicating the End Of Startup.
       PREQ => open,           -- 1-bit output: PROGRAM request to fabric output
       CLK => '0',             -- 1-bit input: User start-up clock input
       GSR => '0',             -- 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
       GTS => '0',             -- 1-bit input: Global 3-state input (GTS cannot be used for the port name)
       KEYCLEARB => '0', -- 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
       PACK => '0',           -- 1-bit input: PROGRAM acknowledge input
       USRCCLKO => spi_sck(0),   -- 1-bit input: User CCLK input
                               -- For Zynq-7000 devices, this input must be tied to GND
       USRCCLKTS => '0', -- 1-bit input: User CCLK 3-state enable input
                               -- For Zynq-7000 devices, this input must be tied to VCC
       USRDONEO => '0',   -- 1-bit input: User DONE pin output control
       USRDONETS => '0'  -- 1-bit input: User DONE 3-state enable output
    );
    
    
end architecture rtl;