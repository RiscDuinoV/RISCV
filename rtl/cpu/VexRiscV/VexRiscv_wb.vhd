library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity VexRiscv_wb is
    generic
    (
        GenJTAG             :   boolean     :=  false
    );
    port 
    (
        Rst                 :   in std_logic;
        Clk                 :   in std_logic;

        data_ADR_O          :   out std_logic_vector(31 downto 0);
        data_DAT_I          :   in  std_logic_vector(31 downto 0);
        data_DAT_O          :   out std_logic_vector(31 downto 0);
        data_WE_O           :   out std_logic;
        data_SEL_O          :   out std_logic_vector(3 downto 0);
        data_STB_O          :   out std_logic;
        data_RSP_ACK_I      :   in  std_logic;
        data_CMD_ACK_I      :   in  std_logic;

        instr_ADR_O         :   out std_logic_vector(31 downto 0);
        instr_DAT_I         :   in  std_logic_vector(31 downto 0);
        instr_STB_O         :   out std_logic;
        instr_RSP_ACK_I     :   in  std_logic;
        instr_CMD_ACK_I     :   in  std_logic;

        Jtag_tms          :   in  std_logic;
        Jtag_tdi          :   in  std_logic;
        Jtag_tdo          :   out std_logic;
        Jtag_tck          :   in  std_logic;

        TimerInterrupt      :   in  std_logic;
        ExternalInterrupt   :   in  std_logic;
        SoftwareInterrupt   :   in  std_logic;

        DebugReset          :   out std_logic

    );
end entity VexRiscv_wb;


architecture rtl of VexRiscv_wb is
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
    signal iBus_cmd_valid           :   std_logic;
    signal iBus_cmd_ready           :   std_logic;
    signal iBus_cmd_payload_pc      :   std_logic_vector(31 downto 0);
    signal iBus_rsp_valid           :   std_logic;
    signal iBus_rsp_payload_error   :   std_logic;
    signal iBus_rsp_payload_inst    :   std_logic_vector(31 downto 0);
    signal dBus_cmd_valid           :   std_logic;
    signal dBus_cmd_ready           :   std_logic;
    signal dBus_cmd_payload_wr      :   std_logic;
    signal dBus_cmd_payload_address :   std_logic_vector(31 downto 0);
    signal dBus_cmd_payload_data    :   std_logic_vector(31 downto 0);
    signal dBus_cmd_payload_size    :   std_logic_vector(1 downto 0);
    signal dBus_rsp_ready           :   std_logic;
    signal dBus_rsp_error           :   std_logic;
    signal dBus_rsp_data            :   std_logic_vector(31 downto 0); 
begin
    genWithoutJTAG: if GenJTAG = false generate
        core : entity work.VexRiscv 
        port map
        (
            iBus_cmd_valid          =>  iBus_cmd_valid,
            iBus_cmd_ready          =>  iBus_cmd_ready,
            iBus_cmd_payload_pc     =>  iBus_cmd_payload_pc,
            iBus_rsp_valid          =>  iBus_rsp_valid,
            iBus_rsp_payload_error  =>  iBus_rsp_payload_error,
            iBus_rsp_payload_inst   =>  iBus_rsp_payload_inst,
            timerInterrupt          =>  timerInterrupt,
            externalInterrupt       =>  externalInterrupt,
            softwareInterrupt       =>  softwareInterrupt,
            dBus_cmd_valid          =>  dBus_cmd_valid,
            dBus_cmd_ready          =>  dBus_cmd_ready,
            dBus_cmd_payload_wr     =>  dBus_cmd_payload_wr,
            dBus_cmd_payload_address => dBus_cmd_payload_address,
            dBus_cmd_payload_data   =>  dBus_cmd_payload_data,
            dBus_cmd_payload_size   =>  dBus_cmd_payload_size,
            dBus_rsp_ready          =>  dBus_rsp_ready,
            dBus_rsp_error          =>  dBus_rsp_error,
            dBus_rsp_data           =>  dBus_rsp_data,
            clk                     =>  Clk,
            reset                   =>  Rst
        );
        Jtag_tdo  <=  '0';
        DebugReset <= '0';
    end generate genWithoutJTAG;
    genWithJTAG: if GenJTAG = true generate
        component VexRiscVJTAG is
            port(
              iBus_cmd_valid : out std_logic;
              iBus_cmd_ready : in std_logic;
              iBus_cmd_payload_pc : out std_logic_vector(31 downto 0);
              iBus_rsp_valid : in std_logic;
              iBus_rsp_payload_error : in std_logic;
              iBus_rsp_payload_inst : in std_logic_vector(31 downto 0);
              timerInterrupt : in std_logic;
              externalInterrupt : in std_logic;
              softwareInterrupt : in std_logic;
              debug_resetOut : out std_logic;
              dBus_cmd_valid : out std_logic;
              dBus_cmd_ready : in std_logic;
              dBus_cmd_payload_wr : out std_logic;
              dBus_cmd_payload_address : out std_logic_vector(31 downto 0);
              dBus_cmd_payload_data : out std_logic_vector(31 downto 0);
              dBus_cmd_payload_size : out std_logic_vector(1 downto 0);
              dBus_rsp_ready : in std_logic;
              dBus_rsp_error : in std_logic;
              dBus_rsp_data : in std_logic_vector(31 downto 0);
              jtag_tms : in std_logic;
              jtag_tdi : in std_logic;
              jtag_tdo : out std_logic;
              jtag_tck : in std_logic;
              clk : in std_logic;
              reset : in std_logic;
              debugReset : in std_logic
            );
          end component;
    begin
        core : VexRiscvJTAG
        port map
        (
            iBus_cmd_valid          =>  iBus_cmd_valid,
            iBus_cmd_ready          =>  iBus_cmd_ready,
            iBus_cmd_payload_pc     =>  iBus_cmd_payload_pc,
            iBus_rsp_valid          =>  iBus_rsp_valid,
            iBus_rsp_payload_error  =>  iBus_rsp_payload_error,
            iBus_rsp_payload_inst   =>  iBus_rsp_payload_inst,
            timerInterrupt          =>  timerInterrupt,
            externalInterrupt       =>  externalInterrupt,
            softwareInterrupt       =>  softwareInterrupt,
            dBus_cmd_valid          =>  dBus_cmd_valid,
            dBus_cmd_ready          =>  dBus_cmd_ready,
            dBus_cmd_payload_wr     =>  dBus_cmd_payload_wr,
            dBus_cmd_payload_address => dBus_cmd_payload_address,
            dBus_cmd_payload_data   =>  dBus_cmd_payload_data,
            dBus_cmd_payload_size   =>  dBus_cmd_payload_size,
            dBus_rsp_ready          =>  dBus_rsp_ready,
            dBus_rsp_error          =>  dBus_rsp_error,
            dBus_rsp_data           =>  dBus_rsp_data,
            jtag_tms                =>  Jtag_tms,
            jtag_tdi                =>  Jtag_tdi,
            jtag_tdo                =>  Jtag_tdo,
            jtag_tck                =>  Jtag_tck,
            clk                     =>  Clk,
            reset                   =>  Rst,
            debug_resetOut          =>  DebugReset,
            debugReset              =>  Rst
        );
    end generate genWithJTAG;
        instr_ADR_O             <= iBus_cmd_payload_pc;
        instr_STB_O             <= iBus_cmd_valid;
        iBus_rsp_payload_inst   <= instr_DAT_I;
        iBus_rsp_valid          <= instr_RSP_ACK_I;
        iBus_cmd_ready          <= instr_CMD_ACK_I;
        data_ADR_O      <= dBus_cmd_payload_address;
        data_DAT_O      <= dBus_cmd_payload_data;
        data_WE_O       <= dBus_cmd_payload_wr and dBus_cmd_valid;
        data_SEL_O      <= wb_get_data_sel(dBus_cmd_payload_size, dBus_cmd_payload_address);
        data_STB_O      <= dBus_cmd_valid;
        dBus_rsp_data   <= data_DAT_I;
        dBus_rsp_ready  <= data_RSP_ACK_I;
        dBus_cmd_ready  <= data_CMD_ACK_I;
end architecture rtl;