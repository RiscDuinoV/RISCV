library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.xtr_def.all;

entity soc is
    generic (
        C_FREQ_IN : integer := 50_000_000;
        C_RAM_SIZE : integer := 8192;
        C_INIT_FILE : string  := "none";
        C_UART : integer range 0 to 4 := 1;
        C_SPI : integer range 0 to 4 := 1;
        C_I2C : integer range 0 to 4 := 1;
        C_GPIO : integer range 0 to 64 := 1;
        C_BOOT_TRAP : boolean := false
    );
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        tck_i : in std_logic := '0';
        tdi_i : in std_logic := '0';
        tdo_o : out std_logic;
        tms_i : in std_logic := '0';
        uart_rx_i : in std_logic_vector(C_UART - 1 downto 0) := (others => '1');
        uart_tx_o : out std_logic_vector(C_UART - 1 downto 0);
        spi_sck_o : out std_logic_vector(C_SPI - 1 downto 0);
        spi_mosi_o : out std_logic_vector(C_SPI - 1 downto 0);
        spi_miso_i : in std_logic_vector(C_SPI - 1 downto 0) := (others => '0');
        spi_ss_o : out std_logic_vector(C_SPI - 1 downto 0);
        i2c_scl_io : out std_logic_vector(C_I2C - 1 downto 0);
        i2c_sda_io : inout std_logic_vector(C_I2C - 1 downto 0);
        gpio_io : inout std_logic_vector(C_GPIO - 1 downto 0);
        xtr_cmd_o : out xtr_cmd_t;
        xtr_rsp_i : in xtr_rsp_t;
        gpirq_i : in std_logic_vector(31 downto 0) := (others => '0')
    );
end entity soc;

architecture rtl of soc is
    -- Infra
    signal sys_rst : std_logic;
    signal rst_hold : std_logic_vector(3 downto 0);
    -- Root of Xtr bus
    signal instr_xtr_cmd, dat_xtr_cmd : xtr_cmd_t;
    signal instr_xtr_rsp, dat_xtr_rsp : xtr_rsp_t;
    -- Layer
    signal v_xtr_cmd_lyr1 : v_xtr_cmd_t(0 to 1);
    signal v_xtr_rsp_lyr1 : v_xtr_rsp_t(0 to 1);
    signal v_xtr_cmd_lyr2 : v_xtr_cmd_t(0 to 1);
    signal v_xtr_rsp_lyr2 : v_xtr_rsp_t(0 to 1);
    
    -- Bram
    signal bram_instr_xtr_cmd : xtr_cmd_t;
    signal bram_instr_xtr_rsp : xtr_rsp_t;
    signal bram_dat_xtr_cmd : xtr_cmd_t;
    signal bram_dat_xtr_rsp : xtr_rsp_t;

    signal boot_trap_rst_rqst : std_logic;
    signal external_irq, timer_irq : std_logic;

begin
    -- Hold reset for at least 4 clock cycles
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if arst_i = '1' or boot_trap_rst_rqst = '1' then
                rst_hold <= (others => '1');
            elsif rst_hold(3) = '1' then
                rst_hold <= rst_hold(2 downto 0) & '0';
            end if;
        end if;
    end process;
    sys_rst <= rst_hold(rst_hold'left);
    
    u_cpu : entity work.vexriscv_wrapper
        port map (
            clk_i => clk_i, srst_i => sys_rst,
            tck_i => tck_i, tdi_i => tdi_i, tdo_o => tdo_o, tms_i => tms_i,
            instr_xtr_cmd_o => instr_xtr_cmd, instr_xtr_rsp_i => instr_xtr_rsp,
            dat_xtr_cmd_o => dat_xtr_cmd, dat_xtr_rsp_i => dat_xtr_rsp,
            external_irq_i => external_irq, timer_irq_i => timer_irq, software_irq_i => '0');

    u_xtr_abr_lyr1 : entity work.xtr_abr
        generic map (
            C_MMSB => 31, C_MLSB => 32, C_SLAVES => 2)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => sys_rst, 
            xtr_cmd_i => dat_xtr_cmd, xtr_rsp_o => dat_xtr_rsp,
            v_xtr_cmd_o => v_xtr_cmd_lyr1, v_xtr_rsp_i => v_xtr_rsp_lyr1);
    
    bram_instr_xtr_cmd <= instr_xtr_cmd;
    instr_xtr_rsp <= bram_instr_xtr_rsp;
    bram_dat_xtr_cmd <= v_xtr_cmd_lyr1(0);
    v_xtr_rsp_lyr1(0) <= bram_dat_xtr_rsp;

    uBram : entity work.xtr_ram
        generic map (
            C_RAM_SIZE => C_RAM_SIZE, C_INIT_FILE => C_INIT_FILE)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => sys_rst,
            instr_xtr_cmd_i => bram_instr_xtr_cmd, instr_xtr_rsp_o => bram_instr_xtr_rsp,
            dat_xtr_cmd_i => bram_dat_xtr_cmd, dat_xtr_rsp_o => bram_dat_xtr_rsp);

    -- 8000 0000 0000 0000
    -- FFFF FFFF FFFF FFFF
    uXtrAbrLyr2 : entity work.xtr_abr
        generic map (
            C_MMSB => 31, C_MLSB => 31, C_MASK => x"80000000", C_SLAVES => 2)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => '0', 
            xtr_cmd_i => v_xtr_cmd_lyr1(1), xtr_rsp_o  => v_xtr_rsp_lyr1(1),
            v_xtr_cmd_o => v_xtr_cmd_lyr2, v_xtr_rsp_i => v_xtr_rsp_lyr2);

    xtr_cmd_o <= v_xtr_cmd_lyr2(0);
    v_xtr_rsp_lyr2(0) <= xtr_rsp_i;

    u_xtr_periph : entity work.xtr_peripherials
        generic map (
            C_FREQ_IN => C_FREQ_IN, C_UART => C_UART, C_SPI => C_SPI, C_I2C => C_I2C, C_GPIO => C_GPIO, C_BOOTTRAP => C_BOOT_TRAP)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => sys_rst,
            xtr_cmd_i => v_xtr_cmd_lyr2(1), xtr_rsp_o => v_xtr_rsp_lyr2(1),
            uart_rx_i => uart_rx_i, uart_tx_o => uart_tx_o,
            spi_sck_o => spi_sck_o, spi_mosi_o => spi_mosi_o, spi_miso_i => spi_miso_i, spi_ss_o => spi_ss_o,
            i2c_scl_io => i2c_scl_io, i2c_sda_io => i2c_sda_io,
            gpio_io => gpio_io,
            rst_rqst_o => boot_trap_rst_rqst,
            gpirq_i => gpirq_i, external_irq_o => external_irq, timer_irq_o => timer_irq);

              
end architecture rtl;
