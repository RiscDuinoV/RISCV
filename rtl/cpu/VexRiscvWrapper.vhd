library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.XtrDef.all;

entity VexRiscvWrapper is
    port 
    (
        Clk         : in    std_logic;
        SRst        : in    std_logic;
        Tck         : in    std_logic;
        Tdi         : in    std_logic;
        Tdo         : out   std_logic;
        Tms         : in    std_logic;
        InstrXtrCmd : out   XtrCmd_t;
        InstrXtrRsp : in    XtrRsp_t;
        DatXtrCmd   : out   XtrCmd_t;
        DatXtrRsp   : in    XtrRsp_t;
        ExternalIrq : in    std_logic;
        TimerIrq    : in    std_logic;
        SoftwareIrq : in    std_logic
    );
end entity VexRiscvWrapper;

architecture rtl of VexRiscvWrapper is
    function wb_get_data_sel(size : in std_logic_vector(1 downto 0); address : in std_logic_vector)
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
    end function wb_get_data_sel;
    component VexRiscv is
        port
        (
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

    attribute mark_debug : string;
    attribute keep : string;
    attribute mark_debug of iBus_cmd_payload_pc : signal is "true";
    attribute mark_debug of iBus_rsp_payload_inst : signal is "true";
    attribute mark_debug of iBus_cmd_valid : signal is "true";
    attribute mark_debug of iBus_cmd_ready : signal is "true";
    attribute mark_debug of iBus_rsp_valid : signal is "true";
    attribute mark_debug of dBus_cmd_payload_address : signal is "true";
    attribute mark_debug of dBus_cmd_payload_data : signal is "true";
    attribute mark_debug of dBus_cmd_valid : signal is "true";
    attribute mark_debug of dBus_cmd_ready : signal is "true";
    attribute mark_debug of dBus_cmd_payload_wr : signal is "true";
    attribute mark_debug of dBus_cmd_payload_sel : signal is "true";
    attribute mark_debug of dBus_rsp_data : signal is "true";
    attribute mark_debug of dBus_rsp_ready : signal is "true";
    
begin
    reset <= SRst or debug_resetOut;
    core : VexRiscv 
        port map
        (
            reset                       => reset,
            clk                         => Clk,
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
            timerInterrupt              => TimerIrq,
            externalInterrupt           => ExternalIrq,
            softwareInterrupt           => SoftwareIrq,
            debugReset                  => '0',
            debug_resetOut              => debug_resetOut,
            jtag_tck                    => Tck,
            jtag_tdo                    => Tdo,
            jtag_tdi                    => Tdi,
            jtag_tms                    => Tms
        );
    dBus_cmd_payload_sel    <= wb_get_data_sel(dBus_cmd_payload_size, dBus_cmd_payload_address(1 downto 0));
    
    
    InstrXtrCmd.ADR         <= iBus_cmd_payload_pc;
    InstrXtrCmd.STB         <= iBus_cmd_valid;
    InstrXtrCmd.WE          <= '0';
    iBus_cmd_ready          <= InstrXtrRsp.CRDY;
    iBus_rsp_valid          <= InstrXtrRsp.RRDY;
    iBus_rsp_payload_inst   <= InstrXtrRsp.DAT;
    iBus_rsp_payload_error  <= '0';

    DatXtrCmd.ADR           <= dBus_cmd_payload_address;
    DatXtrCmd.DAT           <= dBus_cmd_payload_data;
    DatXtrCmd.STB           <= dBus_cmd_valid;
    DatXtrCmd.WE            <= dBus_cmd_payload_wr and dBus_cmd_valid;
    DatXtrCmd.SEL           <= dBus_cmd_payload_sel;
    
    dBus_cmd_ready          <= DatXtrRsp.CRDY;
    dBus_rsp_ready          <= DatXtrRsp.RRDY;
    dBus_rsp_data           <= DatXtrRsp.DAT;
    dBus_rsp_error          <= '0';
    
end architecture rtl;