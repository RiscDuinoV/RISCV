library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.xtr_def.all;

entity vexriscv_wrapper is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        tck_i : in std_logic;
        tdi_i : in std_logic;
        tdo_o : out std_logic;
        tms_i : in std_logic;
        instr_xtr_cmd_o : out xtr_cmd_t;
        instr_xtr_rsp_i : in xtr_rsp_t;
        dat_xtr_cmd_o : out xtr_cmd_t;
        dat_xtr_rsp_i : in xtr_rsp_t;
        external_irq_i : in std_logic;
        timer_irq_i : in std_logic;
        software_irq_i : in std_logic
    );
end entity vexriscv_wrapper;

architecture rtl of vexriscv_wrapper is
    function get_data_sel(size : in std_logic_vector(1 downto 0); address : in std_logic_vector(1 downto 0))
        return std_logic_vector is
    begin
        case size is
            when b"00" =>
                case address(1 downto 0) is
                    when b"00" =>
                        return b"0001";
                    when b"01" =>
                        return b"0010";
                    when b"10" =>
                        return b"0100";
                    when b"11" =>
                        return b"1000";
                    when others =>
                        return b"0001";
                end case;
            when b"01" =>
                if address(1) = '0' then
                    return b"0011";
                else
                    return b"1100";
                end if;
            when others =>
                return b"1111";
        end case;
    end function get_data_sel;
    component VexRiscv is
        port (
            reset                       : in    std_logic;
            clk                         : in    std_logic;
            iBus_cmd_payload_pc         : out   std_logic_vector(31 downto 0);
            iBus_cmd_valid              : out   std_logic;
            iBus_cmd_ready              : in    std_logic;
            iBus_rsp_payload_inst       : in    std_logic_vector(31 downto 0);
            iBus_rsp_valid              : in    std_logic;
            iBus_rsp_payload_error      : in    std_logic;
            dBus_cmd_payload_address    : out   std_logic_vector(31 downto 0);
            dBus_cmd_valid              : out   std_logic;
            dBus_cmd_ready              : in    std_logic;
            dBus_cmd_payload_wr         : out   std_logic;
            dBus_cmd_payload_data       : out   std_logic_vector(31 downto 0);
            dBus_cmd_payload_size       : out   std_logic_vector(1 downto 0);
            dBus_rsp_ready              : in    std_logic;
            dBus_rsp_error              : in    std_logic;
            dBus_rsp_data               : in    std_logic_vector(31 downto 0);
            timerInterrupt              : in    std_logic;
            externalInterrupt           : in    std_logic;
            softwareInterrupt           : in    std_logic;
            debugReset                  : in    std_logic;
            debug_resetOut              : out   std_logic;
            jtag_tck                    : in    std_logic;
            jtag_tdo                    : out   std_logic;
            jtag_tdi                    : in    std_logic;
            jtag_tms                    : in    std_logic
        );
    end component;
    signal iBus_cmd_valid           : std_logic;
    signal iBus_cmd_ready           : std_logic;
    signal iBus_cmd_payload_pc      : std_logic_vector(31 downto 0);
    signal iBus_rsp_valid           : std_logic;
    signal iBus_rsp_payload_error   : std_logic;
    signal iBus_rsp_payload_inst    : std_logic_vector(31 downto 0);
    signal dBus_cmd_valid           : std_logic;
    signal dBus_cmd_ready           : std_logic;
    signal dBus_cmd_payload_wr      : std_logic;
    signal dBus_cmd_payload_address : std_logic_vector(31 downto 0);
    signal dBus_cmd_payload_data    : std_logic_vector(31 downto 0);
    signal dBus_cmd_payload_size    : std_logic_vector(1 downto 0);
    signal dBus_rsp_ready           : std_logic;
    signal dBus_rsp_error           : std_logic;
    signal dBus_rsp_data            : std_logic_vector(31 downto 0); 
    signal dBus_cmd_payload_sel     : std_logic_vector(3 downto 0);
    signal reset                    : std_logic;
    signal debug_resetOut           : std_logic;

--    attribute mark_debug : string;
--    attribute keep : string;
--    attribute mark_debug of iBus_cmd_payload_pc : signal is "true";
--    attribute mark_debug of iBus_rsp_payload_inst : signal is "true";
--    attribute mark_debug of iBus_cmd_valid : signal is "true";
--    attribute mark_debug of iBus_cmd_ready : signal is "true";
--    attribute mark_debug of iBus_rsp_valid : signal is "true";
--    attribute mark_debug of dBus_cmd_payload_address : signal is "true";
--    attribute mark_debug of dBus_cmd_payload_data : signal is "true";
--    attribute mark_debug of dBus_cmd_valid : signal is "true";
--    attribute mark_debug of dBus_cmd_ready : signal is "true";
--    attribute mark_debug of dBus_cmd_payload_wr : signal is "true";
--    attribute mark_debug of dBus_cmd_payload_sel : signal is "true";
--    attribute mark_debug of dBus_rsp_data : signal is "true";
--    attribute mark_debug of dBus_rsp_ready : signal is "true";
    
begin
    reset <= srst_i or debug_resetOut;
    u_core : component vexriscv 
        port map (
            reset                       => reset,
            clk                         => clk_i,
            iBus_cmd_payload_pc         => iBus_cmd_payload_pc,
            iBus_cmd_valid              => iBus_cmd_valid,
            iBus_cmd_ready              => iBus_cmd_ready,
            iBus_rsp_payload_inst       => iBus_rsp_payload_inst,
            iBus_rsp_valid              => iBus_rsp_valid,
            iBus_rsp_payload_error      => iBus_rsp_payload_error,
            dBus_cmd_payload_address    => dBus_cmd_payload_address,
            dBus_cmd_valid              => dBus_cmd_valid,
            dBus_cmd_ready              => dBus_cmd_ready,
            dBus_cmd_payload_wr         => dBus_cmd_payload_wr,
            dBus_cmd_payload_data       => dBus_cmd_payload_data,
            dBus_cmd_payload_size       => dBus_cmd_payload_size,
            dBus_rsp_ready              => dBus_rsp_ready,
            dBus_rsp_error              => dBus_rsp_error,
            dBus_rsp_data               => dBus_rsp_data,
            timerInterrupt              => timer_irq_i,
            externalInterrupt           => external_irq_i,
            softwareInterrupt           => software_irq_i,
            debugReset                  => arst_i,
            debug_resetOut              => debug_resetOut,
            jtag_tck                    => tck_i,
            jtag_tdo                    => tdo_o,
            jtag_tdi                    => tdi_i,
            jtag_tms                    => tms_i
        );
    dBus_cmd_payload_sel <= get_data_sel(dBus_cmd_payload_size, dBus_cmd_payload_address(1 downto 0));
    
    
    instr_xtr_cmd_o.adr <= iBus_cmd_payload_pc;
    instr_xtr_cmd_o.vld <= iBus_cmd_valid;
    instr_xtr_cmd_o.we <= '0';
    iBus_cmd_ready <= instr_xtr_rsp_i.rdy;
    iBus_rsp_valid <= instr_xtr_rsp_i.vld;
    iBus_rsp_payload_inst <= instr_xtr_rsp_i.dat;
    iBus_rsp_payload_error <= '0';

    dat_xtr_cmd_o.adr <= dBus_cmd_payload_address;
    dat_xtr_cmd_o.dat <= dBus_cmd_payload_data;
    dat_xtr_cmd_o.vld <= dBus_cmd_valid;
    dat_xtr_cmd_o.we <= dBus_cmd_payload_wr and dBus_cmd_valid;
    dat_xtr_cmd_o.sel <= dBus_cmd_payload_sel;
    
    dBus_cmd_ready <= dat_xtr_rsp_i.rdy;
    dBus_rsp_ready <= dat_xtr_rsp_i.vld;
    dBus_rsp_data <= dat_xtr_rsp_i.dat;
    dBus_rsp_error <= '0';
    
end architecture rtl;
