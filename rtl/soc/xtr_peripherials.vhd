library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;

entity xtr_peripherials is
    generic (
        C_FREQ_IN   : integer := 50e6;
        C_UART      : integer range 0 to 4 := 1;
        C_SPI       : integer range 0 to 4 := 1;
        C_I2C       : integer range 0 to 4 := 1;
        C_GPIO      : integer range 0 to 64 := 1;
        C_BOOTTRAP  : boolean := false
    );
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        uart_rx_i : in std_logic_vector(C_UART - 1 downto 0) := (others => '1');
        uart_tx_o : out std_logic_vector(C_UART - 1 downto 0);
        spi_sck_o : out std_logic_vector(C_SPI - 1 downto 0);
        spi_mosi_o : out std_logic_vector(C_SPI - 1 downto 0);
        spi_miso_i : in std_logic_vector(C_SPI - 1 downto 0) := (others => '0');
        spi_ss_o : out std_logic_vector(C_SPI - 1 downto 0);
        i2c_scl_io : inout std_logic_vector(C_I2C - 1 downto 0);
        i2c_sda_io : inout std_logic_vector(C_I2C - 1 downto 0);
        gpio_io : inout std_logic_vector(C_GPIO - 1 downto 0);
        rst_rqst_o : out std_logic;
        gpirq_i : in std_logic_vector(31 downto 0);
        external_irq_o : out std_logic;
        timer_irq_o : out std_logic
    );
end entity xtr_peripherials;

architecture rtl of xtr_peripherials is
    signal v_xtr_cmd_lyr3 : v_xtr_cmd_t(0 to 7);
    signal v_xtr_rsp_lyr3 : v_xtr_rsp_t(0 to 7);
    -- I2C
    signal v_i2c_xtr_cmd : v_xtr_cmd_t(0 to 3);
    signal v_i2c_xtr_rsp : v_xtr_rsp_t(0 to 3);
    -- UART
    signal v_uart_xtr_cmd : v_xtr_cmd_t(0 to 3);
    signal v_uart_xtr_rsp : v_xtr_rsp_t(0 to 3);
    signal uart_irq : std_logic_vector(3 downto 0);
    signal uart_status : std_logic_vector(4*2 - 1 downto 0);
    -- Spi
    signal v_spi_xtr_cmd : v_xtr_cmd_t(0 to 3);
    signal v_spi_xtr_rsp : v_xtr_rsp_t(0 to 3);
    -- Timers
    signal v_timer_xtr_cmd : v_xtr_cmd_t(0 to 7);
    signal v_timer_xtr_rsp : v_xtr_rsp_t(0 to 7);
    signal timer_irq :  std_logic_vector(7 downto 0);
    -- Gpio
    signal v_gpio_xtr_cmd : v_xtr_cmd_t(0 to 63);
    signal v_gpio_xtr_rsp : v_xtr_rsp_t(0 to 63);
    -- interrupt controller
    signal v_ictl_xtr_cmd : v_xtr_cmd_t(0 to 0);
    signal v_ictl_xtr_rsp : v_xtr_rsp_t(0 to 0);
    signal interrupt_src  : std_logic_vector(63 downto 0);
    -- Boot trap
    signal boot_trap_rst_rqst  : std_logic;
begin

-- Peripherials
    -- CXXX XXXX XXXX F000
    -- FXXX XXXX XXXX FFFF
    u_xtr_abr_lyr3 : entity work.xtr_abr
        generic map (
            C_MMSB => 11, C_MLSB => 12, C_MASK => x"FFFFF000", C_SLAVES  => 8)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => xtr_cmd_i, xtr_rsp_o => xtr_rsp_o,
            v_xtr_cmd_o => v_xtr_cmd_lyr3, v_xtr_rsp_i => v_xtr_rsp_lyr3);
    -- I2C
    -- CXXX XXXX XXXX F000
    -- FXXX XXXX XXXX F0FF
    u_xtr_abr_i2c : entity work.xtr_abr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF000", C_SLAVES  => 4)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => v_xtr_cmd_lyr3(0), xtr_rsp_o => v_xtr_rsp_lyr3(0),
            v_xtr_cmd_o => v_i2c_xtr_cmd, v_xtr_rsp_i => v_i2c_xtr_rsp);
    gen_i2c: for i in 1 to C_I2C generate        
        uXtrI2C : entity work.xtr_i2c
            generic map (
                C_FREQ_IN => C_FREQ_IN, C_FREQ_SCL => 100_000)
            port map (
                arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
                xtr_cmd_i => v_i2c_xtr_cmd(i - 1), xtr_rsp_o => v_i2c_xtr_rsp(i - 1),
                scl_io => i2c_scl_io(i - 1), sda_io => i2c_sda_io(i - 1));
    end generate gen_i2c;
    -- UART
    -- CXXX XXXX XXXX FB00
    -- FXXX XXXX XXXX FBFF
    u_xtr_abr_uart : entity work.xtr_abr
        generic map (
            C_MMSB => 9, C_MLSB => 8,  C_MASK => x"FFFFFB00", C_SLAVES  => 4)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => v_xtr_cmd_lyr3(5), xtr_rsp_o  => v_xtr_rsp_lyr3(5),
            v_xtr_cmd_o => v_uart_xtr_cmd, v_xtr_rsp_i => v_uart_xtr_rsp);
    gen_uart: for i in 1 to C_UART generate        
        uXtrUart : entity work.xtr_uart
            generic map (
                C_FREQ_IN => C_FREQ_IN, C_BAUD => 115_200)
            port map (
                arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
                xtr_cmd_i => v_uart_xtr_cmd(i - 1), xtr_rsp_o  => v_uart_xtr_rsp(i - 1),
                status_o => uart_status(2*(i-1) + 1 downto 2*(i-1)),
                rx_i => uart_rx_i(i - 1), tx_o => uart_tx_o(i - 1), irq_o => uart_irq(i - 1));
    end generate gen_uart;
    -- SPI
    -- CXXX XXXX XXXX F200
    -- FXXX XXXX XXXX F2FF
    u_xtr_abr_spi : entity work.xtr_abr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF200", C_SLAVES  => 4)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => v_xtr_cmd_lyr3(1), xtr_rsp_o => v_xtr_rsp_lyr3(1),
            v_xtr_cmd_o => v_spi_xtr_cmd, v_xtr_rsp_i => v_spi_xtr_rsp);
    gen_spi: for i in 1 to C_SPI generate        
        uXtrSpi : entity work.xtr_spi_master
            generic map (
                C_FREQ_IN => C_FREQ_IN, C_FREQ_SCK => 100e3)
            port map (
                arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
                xtr_cmd_i => v_spi_xtr_cmd(i - 1), xtr_rsp_o => v_spi_xtr_rsp(i - 1),
                sck_o => spi_sck_o(i - 1), mosi_o => spi_mosi_o(i - 1), miso_i => spi_miso_i(i - 1), ss_o => spi_ss_o(i - 1));
    end generate gen_spi;
    -- Timers
    -- CXXX XXXX XXXX F400
    -- FXXX XXXX XXXX F5FF 
    u_xtr_abr_timer : entity work.xtr_abr
        generic map (
            C_MMSB => 9, C_MLSB => 8, C_MASK => x"FFFFF400", C_SLAVES  => 8)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => v_xtr_cmd_lyr3(2), xtr_rsp_o => v_xtr_rsp_lyr3(2),
            v_xtr_cmd_o => v_timer_xtr_cmd, v_xtr_rsp_i => v_timer_xtr_rsp);

    u_mtime : entity work.xtr_mtime
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            xtr_cmd_i => v_timer_xtr_cmd(0), xtr_rsp_o => v_timer_xtr_rsp(0),
            irq_o => timer_irq(0));

    -- GPIOs
    -- CXXX XXXX XXXX F600
    -- FXXX XXXX XXXX F7FF 
    u_xtr_abr_gpio : entity work.xtr_abr
        generic map (
            C_MMSB => 8, C_MLSB => 9, C_SLAVES  => 64)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i, 
            xtr_cmd_i => v_xtr_cmd_lyr3(3), xtr_rsp_o => v_xtr_rsp_lyr3(3),
            v_xtr_cmd_o => v_gpio_xtr_cmd, v_xtr_rsp_i => v_gpio_xtr_rsp);

    gen_gpio: for i in 1 to C_GPIO generate
        u_xtr_gpio : entity work.xtr_gpio
            port map (
                arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
                xtr_cmd_i => v_gpio_xtr_cmd(i - 1), xtr_rsp_o => v_gpio_xtr_rsp(i - 1),
                gpio_io => gpio_io(i - 1));
    end generate gen_gpio;

    -- interrupt controllers
    -- CXXX XXXX XXXX FC00
    -- FXXX XXXX XXXX FDFF
    v_ictl_xtr_cmd(0) <= v_xtr_cmd_lyr3(6);
    v_xtr_rsp_lyr3(6) <= v_ictl_xtr_rsp(0);
    u_xtr_interrupt_controller : entity work.xtr_interrupt_controller
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            xtr_cmd_i => v_ictl_xtr_cmd(0), xtr_rsp_o => v_ictl_xtr_rsp(0),
            src_i => interrupt_src, irq_o => external_irq_o);
    interrupt_src(63 downto 32) <= gpirq_i;
    interrupt_src(31 downto 0) <= x"0000000" & uart_irq;
    timer_irq_o <= timer_irq(0);
    
    gen_boot_trap: if C_BOOTTRAP = TRUE and C_UART >= 1 generate
        -- Boot trap
        -- CXXX XXXX XXXX FE00
        -- FXXX XXXX XXXX FFFF 
        u_xtr_boot_trap : entity work.xtr_boot_trap
            port map (
                arst_i => arst_i, clk_i => clk_i, srst_i => '0',
                xtr_cmd_i => v_xtr_cmd_lyr3(7), xtr_rsp_o => v_xtr_rsp_lyr3(7),
                baud_en_i => uart_status(1), rx_vld_i => uart_status(0), rx_dat_i => v_uart_xtr_rsp(0).dat(7 downto 0),
                trap_o => boot_trap_rst_rqst);
    end generate gen_boot_trap;
    
rst_rqst_o <= boot_trap_rst_rqst;
    
end architecture rtl;
