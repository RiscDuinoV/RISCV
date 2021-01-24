library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

entity bram_cpu is
    generic
    (
        MEM_SIZE            : integer   := 4096;
        INIT_FILE_FORMAT    : string    := "hex";
        INIT_FILE_NAME      : string    := "NONE";
        LATTICE_FAMILY      : string    := "NONE";
        ALTERA_FAMILY       : string    := "NONE";
        C_ProtectRam        : integer   := 0
    );
    port 
    (
        Clk             : in    std_logic;
        instr_ADR_I     : in    std_logic_vector(31 downto 0);
        instr_DAT_O     : out   std_logic_vector(31 downto 0);
        instr_STB_I     : in    std_logic;
        instr_RSP_ACK_O : out   std_logic;
        instr_CMD_ACK_O : out   std_logic;


        data_ADR_I      : in    std_logic_vector(31 downto 0);
        data_DAT_O      : out   std_logic_vector(31 downto 0);
        data_DAT_I      : in    std_logic_vector(31 downto 0);
        data_WE_I       : in    std_logic;
        data_SEL_I      : in    std_logic_vector(3 downto 0);
        data_STB_I      : in    std_logic;
        data_RSP_ACK_O  : out   std_logic;
        data_CMD_ACK_O  : out   std_logic
    );
end entity bram_cpu;
architecture rtl of bram_cpu is
    constant MEM_ADDR_WIDTH :   integer := integer(ceil(log2(real(MEM_SIZE / 4))));
    signal imem_addr        :   std_logic_vector(MEM_ADDR_WIDTH - 1 downto 0);
    signal dmem_addr        :   std_logic_vector(MEM_ADDR_WIDTH - 1 downto 0);
    signal imem_addr_strobe :   std_logic;
    signal imem_data_out    :   std_logic_vector(31 downto 0);
    signal dmem_addr_strobe :   std_logic;
    signal dmem_write       :   std_logic;
    signal dmem_byte_sel    :   std_logic_vector(3 downto 0);
    signal dmem_data_in     :   std_logic_vector(31 downto 0);
    signal dmem_data_out    :   std_logic_vector(31 downto 0);
    signal write_enable     :   std_logic;
begin
    assert not (ALTERA_FAMILY /= "NONE" and LATTICE_FAMILY /= "NONE") report "Only one family must be enabled, if you don't know what device you're using set 'ALTERA_FAMILY' and 'LATTICE_FAMILY' to 'NONE'" severity failure;
    assert C_ProtectRam <= 2 report "C_ProtectRam must be <= 2K" severity failure;
    imem_addr           <= instr_ADR_I(imem_addr'left + 2 downto 2);
    instr_DAT_O         <= imem_data_out;
    imem_addr_strobe    <= instr_STB_I;

    dmem_addr           <= data_ADR_I(dmem_addr'left + 2 downto 2);
    data_DAT_O          <= dmem_data_out;
    dmem_data_in        <= data_DAT_I;
    genNoProtection : if C_ProtectRam = 0 generate
        write_enable <= data_WE_I and data_STB_I;
    end generate genNoProtection;
    genProtect1k: if C_ProtectRam = 1 generate
        write_enable <= data_WE_I and data_STB_I when instr_ADR_I(dmem_addr'left + 2 downto 10) = 0 else 
                        data_WE_I and data_STB_I when data_ADR_I(dmem_addr'left + 2 downto 10) /= 0 else 
                        '0'; -- Protect 1k of RAM for the bootloader
    end generate genProtect1k;
    genProtect2k : if C_ProtectRam = 2 generate
        write_enable <= data_WE_I and data_STB_I when instr_ADR_I(dmem_addr'left + 2 downto 11) = 0 else 
                        data_WE_I and data_STB_I when data_ADR_I(dmem_addr'left + 2 downto 11) /= 0 else 
                        '0'; -- Protect 2k of RAM for the bootloader
    end generate genProtect2k;
    dmem_byte_sel       <= data_SEL_I;
    dmem_addr_strobe    <= data_STB_I;
    genLatticeBram: if LATTICE_FAMILY /= "NONE" generate
        component pmi_ram_dp_true_be is
            generic 
            (
                pmi_addr_depth_a : integer := 512; 
                pmi_addr_width_a : integer := 9; 
                pmi_data_width_a : integer := 18; 
                pmi_addr_depth_b : integer := 512; 
                pmi_addr_width_b : integer := 9; 
                pmi_data_width_b : integer := 18; 
                pmi_regmode_a : string := "reg"; 
                pmi_regmode_b : string := "reg"; 
                pmi_gsr : string := "disable"; 
                pmi_resetmode : string := "sync"; 
                pmi_optimization : string := "speed";
                pmi_init_file : string := "none"; 
                pmi_init_file_format : string := "binary"; 
                pmi_write_mode_a : string := "normal"; 
                pmi_write_mode_b : string := "normal"; 
                pmi_byte_size : integer := 9;
                pmi_family : string := "ECP2"; 
                module_type : string := "pmi_ram_dp_true_be" 
            );
            port 
            (
                DataInA : in std_logic_vector((pmi_data_width_a-1) downto 0);
                DataInB : in std_logic_vector((pmi_data_width_b-1) downto 0);
                AddressA : in std_logic_vector((pmi_addr_width_a-1) downto 0);
                AddressB : in std_logic_vector((pmi_addr_width_b-1) downto 0);
                ClockA: in std_logic;
                ClockB: in std_logic;
                ClockEnA: in std_logic;
                ClockEnB: in std_logic;
                WrA: in std_logic;
                WrB: in std_logic;
                ResetA: in std_logic;
                ResetB: in std_logic;
                ByteEnA : in std_logic_vector(((pmi_data_width_a+pmi_byte_size-1)/pmi_byte_size-1) downto 0);
                ByteEnB : in std_logic_vector(((pmi_data_width_b+pmi_byte_size-1)/pmi_byte_size-1) downto 0);
                QA : out std_logic_vector((pmi_data_width_a-1) downto 0);
                QB : out std_logic_vector((pmi_data_width_b-1) downto 0)
            );
        end component pmi_ram_dp_true_be;
    begin
        ram : pmi_ram_dp_true_be
        generic map
        (
            pmi_addr_depth_a        => MEM_SIZE/4,
            pmi_addr_width_a        => MEM_ADDR_WIDTH,
            pmi_data_width_a        => 32,
            pmi_addr_depth_b        => MEM_SIZE/4,
            pmi_addr_width_b        => MEM_ADDR_WIDTH,
            pmi_data_width_b        => 32,
            pmi_regmode_a           => "noreg",
            pmi_regmode_b           => "noreg", 
            pmi_init_file           => INIT_FILE_NAME,
            pmi_init_file_format    => INIT_FILE_FORMAT,
            pmi_byte_size           => 8,
            pmi_family              => LATTICE_FAMILY 
        )
        port map
        (
            DataInA     => (others => '0'),
            DataInB     => dmem_data_in,
            AddressA    => imem_addr,
            AddressB    => dmem_addr,
            ClockA      => Clk,
            ClockB      => Clk,
            ClockEnA    => '1',
            ClockEnB    => '1',
            WrA         => '0',
            WrB         => write_enable,
            ResetA      => '0',
            ResetB      => '0',
            ByteEnA     => (others => '1'),
            ByteEnB     => dmem_byte_sel,
            QA          => imem_data_out,
            QB          => dmem_data_out
        );
    end generate genLatticeBram;

    genAlteraBram: if ALTERA_FAMILY /= "NONE" generate
        component altsyncram
        generic 
        (
            address_aclr_a                      :       string := "UNUSED";
            address_aclr_b                      :       string := "NONE";
            address_reg_b                       :       string := "CLOCK1";
            byte_size                           :       natural := 8;
            byteena_aclr_a                      :       string := "UNUSED";
            byteena_aclr_b                      :       string := "NONE";
            byteena_reg_b                       :       string := "CLOCK1";
            clock_enable_core_a                 :       string := "USE_INPUT_CLKEN";
            clock_enable_core_b                 :       string := "USE_INPUT_CLKEN";
            clock_enable_input_a                :       string := "NORMAL";
            clock_enable_input_b                :       string := "NORMAL";
            clock_enable_output_a               :       string := "NORMAL";
            clock_enable_output_b               :       string := "NORMAL";
            intended_device_family              :       string := "unused";
            enable_ecc                          :       string := "FALSE";
            implement_in_les                    :       string := "OFF";
            indata_aclr_a                       :       string := "UNUSED";
            indata_aclr_b                       :       string := "NONE";
            indata_reg_b                        :       string := "CLOCK1";
            init_file                           :       string := "UNUSED";
            init_file_layout                    :       string := "PORT_A";
            maximum_depth                       :       natural := 0;
            numwords_a                          :       natural := 0;
            numwords_b                          :       natural := 0;
            operation_mode                      :       string := "BIDIR_DUAL_PORT";
            outdata_aclr_a                      :       string := "NONE";
            outdata_aclr_b                      :       string := "NONE";
            outdata_reg_a                       :       string := "UNREGISTERED";
            outdata_reg_b                       :       string := "UNREGISTERED";
            power_up_uninitialized              :       string := "FALSE";
            ram_block_type                      :       string := "AUTO";
            rdcontrol_aclr_b                    :       string := "NONE";
            rdcontrol_reg_b                     :       string := "CLOCK1";
            read_during_write_mode_mixed_ports  :       string := "DONT_CARE";
            read_during_write_mode_port_a       :       string := "NEW_DATA_NO_NBE_READ";
            read_during_write_mode_port_b       :       string := "NEW_DATA_NO_NBE_READ";
            width_a                             :       natural;
            width_b                             :       natural := 1;
            width_byteena_a                     :       natural := 1;
            width_byteena_b                     :       natural := 1;
            widthad_a                           :       natural;
            widthad_b                           :       natural := 1;
            wrcontrol_aclr_a                    :       string := "UNUSED";
            wrcontrol_aclr_b                    :       string := "NONE";
            wrcontrol_wraddress_reg_b           :       string := "CLOCK1";
            lpm_hint                            :       string := "UNUSED";
            lpm_type                            :       string := "altsyncram"
        );
        port
        (
            aclr0           :       in  std_logic := '0';
            aclr1           :       in  std_logic := '0';
            address_a       :       in  std_logic_vector(widthad_a-1 downto 0);
            address_b       :       in  std_logic_vector(widthad_b-1 downto 0) := (others => '1');
            addressstall_a  :       in  std_logic := '0';
            addressstall_b  :       in  std_logic := '0';
            byteena_a       :       in  std_logic_vector(width_byteena_a-1 downto 0) := (others => '1');
            byteena_b       :       in  std_logic_vector(width_byteena_b-1 downto 0) := (others => '1');
            clock0          :       in  std_logic := '1';
            clock1          :       in  std_logic := '1';
            clocken0        :       in  std_logic := '1';
            clocken1        :       in  std_logic := '1';
            clocken2        :       in  std_logic := '1';
            clocken3        :       in  std_logic := '1';
            data_a          :       in  std_logic_vector(width_a-1 downto 0) := (others => '1');
            data_b          :       in  std_logic_vector(width_b-1 downto 0) := (others => '1');
            eccstatus       :       out std_logic_vector(2 downto 0);
            q_a             :       out std_logic_vector(width_a-1 downto 0);
            q_b             :       out std_logic_vector(width_b-1 downto 0);
            rden_a          :       in  std_logic := '1';
            rden_b          :       in  std_logic := '1';
            wren_a          :       in  std_logic := '0';
            wren_b          :       in  std_logic := '0'
        );
		end component;
    begin
        altsyncram_component : altsyncram
        GENERIC MAP (
            address_reg_b => "CLOCK0",
            byteena_reg_b => "CLOCK0",
            byte_size => 8,
            clock_enable_input_a => "BYPASS",
            clock_enable_input_b => "BYPASS",
            clock_enable_output_a => "BYPASS",
            clock_enable_output_b => "BYPASS",
            indata_reg_b => "CLOCK0",
            init_file => INIT_FILE_NAME,
            intended_device_family => "Cyclone IV E",
            lpm_type => "altsyncram",
            numwords_a => MEM_SIZE/4,
            numwords_b => MEM_SIZE/4,
            operation_mode => "BIDIR_DUAL_PORT",
            outdata_aclr_a => "NONE",
            outdata_aclr_b => "NONE",
            outdata_reg_a => "UNREGISTERED",
            outdata_reg_b => "UNREGISTERED",
            power_up_uninitialized => "FALSE",
            read_during_write_mode_mixed_ports => "DONT_CARE",
            read_during_write_mode_port_a => "NEW_DATA_WITH_NBE_READ",
            read_during_write_mode_port_b => "NEW_DATA_WITH_NBE_READ",
            widthad_a => MEM_ADDR_WIDTH,
            widthad_b => MEM_ADDR_WIDTH,
            width_a => 32,
            width_b => 32,
            width_byteena_a => 4,
            width_byteena_b => 4,
            wrcontrol_wraddress_reg_b => "CLOCK0"
        )
        PORT MAP (
            address_a => imem_addr,
            address_b => dmem_addr,
            byteena_a => (others => '1'),
            byteena_b => dmem_byte_sel,
            clock0 => Clk,
            data_a => (others => '0'),
            data_b => dmem_data_in,
            wren_a => '0',
            wren_b => write_enable,
            q_a => imem_data_out,
            q_b => dmem_data_out
        );
    end generate genAlteraBram;

    genGenericBram: if LATTICE_FAMILY = "NONE" and ALTERA_FAMILY = "NONE" generate
    begin
        bram    :   entity work.bram
        generic map
        (
            addr_width          =>  MEM_ADDR_WIDTH,
            init_file           =>  INIT_FILE_NAME
        )
        port map
        (
            ClockA      => Clk,
            ClockB      => Clk,
            AddressA    => imem_addr,
            AddressB    => dmem_addr,
            DataInA     => (others => '0'),
            DataInB     => dmem_data_in,
            WrA         => '0',
            WrB         => write_enable,
            ClockEnA    => '1',
            ClockEnB    => '1',
            ByteEnA     => (others => '1'),
            ByteEnB     => dmem_byte_sel,
            QA          => imem_data_out,
            QB          => dmem_data_out
        );
    end generate genGenericBram;


    process(Clk)
    begin
    if rising_edge(Clk) then
        instr_RSP_ACK_O <= instr_STB_I;
        data_RSP_ACK_O  <= data_STB_I;
    end if;
    end process;
    instr_CMD_ACK_O     <= instr_STB_I;
    data_CMD_ACK_O      <= data_STB_I;
end architecture rtl;