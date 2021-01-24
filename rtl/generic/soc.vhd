library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use IEEE.std_logic_unsigned.all;

entity soc is
	generic
	(
		FREQ_MHZ			:	integer;
		RAM_SIZE			:	integer := 8;
		INIT_FILE_FORMAT    :   string  := "hex";
		INIT_FILE_NAME      :   string  := "none";
		ALTERA_FAMILY		:	string	:= "NONE";
		LATTICE_FAMILY      :   string  := "NONE";
		GenJTAG             :   boolean	:=  false;

		C_Sio				:	integer	range 0 to 4 	:= 1;
		C_Sio_Rx_Fifo_Depth	: 	integer :=  16;
        C_Sio_Tx_Fifo_Depth : 	integer :=  16;
		C_Spi				:	integer range 0 to 4 	:= 1;
		C_i2c				:	integer range 0 to 4 	:= 1;
		C_simple_in			:	integer range 0 to 32 	:= 32;
		C_simple_out		:	integer range 0 to 32	:= 32;
		C_gpio				:	integer range 0	to 32	:= 32;
		C_timers			:	integer range 0 to 8	:= 0;
		C_BootTrap			:	boolean 				:= false;
		C_ProtectRam        :   integer 				:= 0
	);
	port
	(
		Rst  			: 	in 		std_logic;
		Clk        		: 	in 		std_logic;

		Ext_ADR_O  		:	out		std_logic_vector(31 downto 2);
		Ext_DAT_O  		:	out		std_logic_vector(31 downto 0);
		Ext_WE_O   		:	out 	std_logic;
		Ext_STB_O  		:	out 	std_logic;
		Ext_SEL_O  		:	out 	std_logic_vector(3 downto 0);
	
		Ext_DAT_I   	:	in 		std_logic_vector(31 downto 0)			:=	(others => '0');
		Ext_RSP_ACK_I  	:	in		std_logic								:=	'0';
		Ext_CMD_ACK_I  	:	in		std_logic								:=	'0';

		Ext_IRQv		:	in		std_logic_vector(31 downto 0)			:=	(others => '0');

		-- Jtag
		Jtag_tms		:   in  	std_logic								:=	'0';
        Jtag_tdi		:   in  	std_logic								:=	'0';
        Jtag_tdo		:   out 	std_logic;
        Jtag_tck      	:   in  	std_logic								:=	'0';

		--uart
		Sio_Rx			: 	in  	std_logic_vector(C_Sio - 1 downto 0) 	:= 	(others => '1');
		Sio_Tx 			: 	out 	std_logic_vector(C_Sio - 1 downto 0);

		-- SPI
		Spi_Sck			:	out		std_logic_vector(C_Sio - 1 downto 0);
		Spi_Miso		:	in		std_logic_vector(C_Spi - 1 downto 0)	:=	(others => '0');
		Spi_Mosi		:	out		std_logic_vector(C_Spi - 1 downto 0);
		Spi_Ce_N		:	out		std_logic_vector(C_Spi - 1 downto 0);

		-- I2C
		I2C_Scl			:	out		std_logic_vector(C_i2c - 1 downto 0);
		I2C_Sda			:	inout	std_logic_vector(C_i2c - 1 downto 0);

		Gpio			:	inout	std_logic_vector(C_gpio - 1 downto 0);

		-- Simple_IO
		Simple_in		:	in		std_logic_vector(C_simple_in - 1 downto 0) := (others => '0');
		Simple_out		:	out 	std_logic_vector(C_simple_out - 1 downto 0);

		Reset_Rqst		:	out		std_logic
  );
end entity soc;

architecture rtl of soc is
	--	CPU Signals
	signal Reset_MCU		: 	std_logic;

	signal data_ADR_O  		: 	std_logic_vector(31 downto 0);
	signal data_DAT_O  		: 	std_logic_vector(31 downto 0);
	signal data_WE_O   		: 	std_logic;
	signal data_STB_O  		: 	std_logic;
	signal data_SEL_O  		: 	std_logic_vector(3 downto 0);

	signal data_DAT_I   	: 	std_logic_vector(31 downto 0);
	signal data_RSP_ACK_I  	: 	std_logic;
	signal data_CMD_ACK_I  	: 	std_logic;

	signal instr_ADR_O  	: 	std_logic_vector(31 downto 0);
	signal instr_DAT_O  	: 	std_logic_vector(31 downto 0);
	signal instr_STB_O  	: 	std_logic;

	signal instr_DAT_I   	: 	std_logic_vector(31 downto 0);
	signal instr_RSP_ACK_I  : 	std_logic;
	signal instr_CMD_ACK_I  : 	std_logic;

	signal TimerInterrupt	: 	std_logic;
	signal DebugReset		:	std_logic;

	-- RAM
	signal from_ram			:	std_logic_vector(31 downto 0);
	signal dmem_enable		:	std_logic;
	signal ram_RSP_ACK		:	std_logic;
	signal ram_CMD_ACK		:	std_logic;
	-- END RAM
	signal io_addr_strobe	:	std_logic;
	signal R_io_addr		:	std_logic_vector(11 downto 2);
	signal R_io_to_cpu		:	std_logic_vector(31 downto 0);
	signal io_RSP_ACK		:	std_logic;
	signal io_CMD_ACK		:	std_logic;
	-- GPIO
	type 	from_gpio_t		is array (0 to C_gpio - 1) of std_logic_vector(31 downto 0);
	signal 	from_gpio		:	from_gpio_t;
	signal 	gpio_ce			:	std_logic_vector(C_gpio - 1 downto 0);
	-- END GPIO
	-- I2C
	type   from_i2c_t		is array (0 to C_Sio - 1) of std_logic_vector(31 downto 0);
	signal from_i2c			:	from_i2c_t;
	signal i2c_ce			:	std_logic_vector(C_Sio - 1 downto 0);
	-- END I2C
	-- SIO
	type   from_sio_t		is array (0 to C_Sio - 1) of std_logic_vector(31 downto 0);
	signal from_sio			:	from_sio_t;
	signal Sio_ce			:	std_logic_vector(C_Sio - 1 downto 0);
	-- END SIO
	-- SPI
	type   from_spi_t		is array (0 to C_Spi - 1) of std_logic_vector(31 downto 0);
	signal from_spi			:	from_spi_t;
	signal Spi_Ce			:	std_logic_vector(C_Spi - 1 downto 0);
	-- END SPI
	-- Simple IO
	signal R_simple_in		:	std_logic_vector(31 downto 0);
	signal R_simple_out 	: 	std_logic_vector(31 downto 0);
	-- End simple IO
	-- Timers
	type   from_timer_t		is array (0 to C_Timers - 1) of std_logic_vector(31 downto 0);
	signal from_timer				: from_timer_t;
	signal timer_CmpOverflow_intr	: std_logic_vector(C_Timers - 1 downto 0);
	signal timer_EqZero_intr		: std_logic_vector(C_Timers - 1 downto 0);
	signal timer_ce					: std_logic_vector(C_Timers - 1 downto 0);
	-- End Timers
	-- MTIME
	signal MTIME_Ce			:	std_logic;
	signal From_MTIME		:	std_logic_vector(31 downto 0);
	signal MTIME_CmpOverflow:	std_logic;
	-- END MTIME
	-- Boot trap
	signal ResetRqst		:	std_logic;
	signal boot_trap_ce		:	std_logic;
	signal from_boot_trap	:	std_logic_vector(31 downto 0);
	-- End Boot trap
	-- Interrupt Controller
	signal Ext_Intr_Ctrl_Vector	:	std_logic_vector(63 downto 0) := (others => '0');
	signal from_Ext_IRQ			:	std_logic_vector(31 downto 0);
	signal Ext_IRQ				:	std_logic;
	signal Ext_IRQ_Ce			:	std_logic;
	signal Ext_IRQ_CPU			:	std_logic;
	-- End Interrupt Controller

	attribute mark_debug : string;
	attribute mark_debug of instr_ADR_O: signal is "true";
	attribute mark_debug of data_ADR_O: signal is "true";
	attribute mark_debug of data_DAT_O: signal is "true";
	attribute mark_debug of data_DAT_I: signal is "true";
	attribute mark_debug of data_WE_O: signal is "true";
	attribute mark_debug of data_STB_O: signal is "true";
begin
	pCpuSoftReset: process(Clk, Rst)
		variable CptSoftReset   :   std_logic_vector(3 downto 0);
	begin
		if Rst = '1' then
			CptSoftReset := (others => '1');
			Reset_MCU <= '1';
		elsif rising_edge(Clk) then
			if ResetRqst = '1' or DebugReset = '1' then
				Reset_MCU <= '1';
			elsif CptSoftReset = 0 then
				Reset_MCU <= '0';
			end if;
			if Reset_MCU = '1' and (ResetRqst = '0' or DebugReset = '0') then
				CptSoftReset := CptSoftReset - 1;
			else
				CptSoftReset := (others => '1');
			end if;
		end if;
	end process pCpuSoftReset;
	Reset_Rqst <= Reset_MCU;
	cpu : entity work.VexRiscv_wb
	generic map
	(
		GenJTAG             =>	GenJTAG
	)
    port map
    (
        Rst           		=> 	Reset_MCU,
        Clk           		=> 	Clk,
	
        data_ADR_O      	=> 	data_ADR_O,
        data_DAT_I      	=> 	data_DAT_I,
        data_DAT_O      	=> 	data_DAT_O,
        data_WE_O       	=> 	data_WE_O,
        data_SEL_O      	=> 	data_SEL_O,
        data_STB_O      	=> 	data_STB_O,
        data_RSP_ACK_I  	=>	data_RSP_ACK_I,
        data_CMD_ACK_I  	=>	data_CMD_ACK_I,

        instr_ADR_O     	=>	instr_ADR_O,
        instr_DAT_I     	=>	instr_DAT_I,
        instr_STB_O     	=>	instr_STB_O,
        instr_RSP_ACK_I 	=>	instr_RSP_ACK_I,
		instr_CMD_ACK_I 	=>	instr_CMD_ACK_I,
		
		Jtag_tms			=>	Jtag_tms,
        Jtag_tdi			=> 	Jtag_tdi,
        Jtag_tdo			=> 	Jtag_tdo,
        Jtag_tck			=> 	Jtag_tck,
		
		TimerInterrupt      =>	TimerInterrupt,
		ExternalInterrupt   =>	Ext_IRQ,
		SoftwareInterrupt   =>	'0',
		DebugReset			=>	DebugReset
	);
	bram	:	entity work.bram_cpu
	generic map
	(
		MEM_SIZE        	=> RAM_SIZE * 1024,
		INIT_FILE_FORMAT	=> INIT_FILE_FORMAT,
		INIT_FILE_NAME  	=> INIT_FILE_NAME,
		LATTICE_FAMILY  	=> LATTICE_FAMILY,
		ALTERA_FAMILY		=> ALTERA_FAMILY,
		C_ProtectRam		=> C_ProtectRam
	)
	port map
	(
		Clk           		=>	Clk,
		instr_ADR_I     	=>	instr_ADR_O,
		instr_DAT_O     	=>	instr_DAT_I,
		instr_STB_I     	=>	instr_STB_O,
		instr_RSP_ACK_O 	=>	instr_RSP_ACK_I,	
		instr_CMD_ACK_O 	=>	instr_CMD_ACK_I,

		data_ADR_I      	=>	data_ADR_O,
		data_DAT_O      	=>	from_ram,
		data_DAT_I      	=>	data_DAT_O,
		data_WE_I       	=>	data_WE_O,
		data_SEL_I      	=>	data_SEL_O,
		data_STB_I      	=>	dmem_enable,
		data_RSP_ACK_O  	=>	ram_RSP_ACK,
		data_CMD_ACK_O  	=>	ram_CMD_ACK
	);
	TimerInterrupt 	<= 	MTIME_CmpOverflow;
	dmem_enable 	<= 	data_STB_O when data_ADR_O(31) /= '1' else '0';
	data_DAT_I 		<= 	from_ram 	when ram_RSP_ACK = '1' else
						R_io_to_cpu when io_RSP_ACK = '1'  else
						Ext_DAT_I;
	data_RSP_ACK_I 	<= 	ram_RSP_ACK or io_RSP_ACK or Ext_RSP_ACK_I;
	data_CMD_ACK_I	<= 	ram_CMD_ACK or io_CMD_ACK or Ext_CMD_ACK_I;
	R_io_addr 		<= 	data_ADR_O(11 downto 2);
	io_addr_strobe 	<= 	data_STB_O when data_ADR_O(31 downto 30) = "11" else '0';
	-- Ext logic
	Ext_STB_O		<=	data_STB_O when data_ADR_O(31 downto 30) = "10" else '0';
	Ext_ADR_O		<=	data_ADR_O(31 downto 2);
	Ext_DAT_O 		<= 	data_DAT_O;
	Ext_WE_O		<=	data_WE_O;
	Ext_SEL_O		<=	data_SEL_O;
	-- End Ext Logic
	pIO_CPU_READ: process(Clk, io_addr_strobe)
	begin
		io_CMD_ACK	<= io_addr_strobe;
		if rising_edge(Clk) then
			R_io_to_cpu <= (others => '-');
			io_RSP_ACK	<= io_addr_strobe;
			case to_integer(unsigned(R_io_addr(11 downto 4))) is
				when 16#80# to 16#87# =>
					for i in 0 to C_gpio - 1 loop
						R_io_to_cpu <= from_gpio(i);
					end loop;
				when 16#88# =>
					R_io_to_cpu(C_simple_in - 1 downto 0) <= R_simple_in(C_simple_in - 1 downto 0);
				when 16#89# =>
					R_io_to_cpu(C_simple_out - 1 downto 0) <= R_simple_out(C_simple_out - 1 downto 0);
				when 16#A0# to 16#A3# =>
				for i in 0 to C_i2c - 1 loop
					if to_integer(unsigned(R_io_addr(5 downto 4))) = i then
						R_io_to_cpu <= from_i2c(i);
					end if;
				end loop;
				when 16#B0# to 16#B3# =>
					for i in 0 to C_sio - 1 loop
						if to_integer(unsigned(R_io_addr(5 downto 4))) = i then
							R_io_to_cpu <= from_sio(i);
						end if;
					end loop;
				when 16#B4# to 16#B7# =>
					for i in 0 to C_Spi - 1 loop
						if to_integer(unsigned(R_io_addr(5 downto 4))) = i then
							R_io_to_cpu <= from_spi(i);
						end if;
					end loop;
				when 16#B8# =>
					R_io_to_cpu <= From_MTIME;
				when 16#FE# =>
						R_io_to_cpu <= from_Ext_IRQ;
				when 16#FF# =>
					if R_io_addr(3 downto 2) = "11" then
						R_io_to_cpu <= from_boot_trap;
					end if;
				when others =>
					R_io_to_cpu <= (others => '-');
		end case;
		end if;
	end process pIO_CPU_READ;
	-- Simple Out
	pSimple_IO : process(Clk)
	begin
		if rising_edge(Clk) then
			if Reset_MCU = '1' then
				R_simple_out <= (others => '0');
				Simple_out <= (others => '0');
			else
				Simple_out <= R_simple_out(C_simple_out - 1 downto 0);
				R_simple_in(C_simple_in - 1 downto 0) <= Simple_in;
				if R_io_addr(11 downto 4) = x"89" and io_addr_strobe = '1' and data_WE_O = '1' then
					if data_SEL_O(0) = '1' then
						R_simple_out(7 downto 0) <= data_DAT_O(7 downto 0);
					end if;
					if data_SEL_O(1) = '1' then
						R_simple_out(15 downto 8) <= data_DAT_O(15 downto 8);
					end if;
					if data_SEL_O(2) = '1' then
						R_simple_out(23 downto 16) <= data_DAT_O(23 downto 16);
					end if;
					if data_SEL_O(3) = '1' then
						R_simple_out(31 downto 24) <= data_DAT_O(31 downto 24);
					end if;
				end if;
			end if;
		end if;
	end process pSimple_IO;
	genGPIO: for i in 0 to C_gpio - 1 generate
		signal Gpio_Irq	:	std_logic;
	begin
		gpio_inst : entity work.gpio
			generic map
			(
				PWM_Support =>	false,
				IRQ_Support =>	false
			)
			port map
			(
				Rst         =>	Rst,
				Clk         =>	Clk,
				Ce_I        =>	gpio_ce(i),
				data_DAT_O  =>	from_gpio(i),
				data_DAT_I  =>	Data_DAT_O,
				data_WE_I   =>	data_WE_O,
				data_SEL_I  =>	data_SEL_O,
				Pin         =>	Gpio(i),
				Irq         =>	Gpio_Irq
			);
		gpio_ce(i) <= io_addr_strobe when R_io_addr(11 downto 7) = x"8" & '0' and to_integer(unsigned(R_io_addr(6 downto 2))) = i else '0';
		genGpioIRQ: if i < 8 generate
			Ext_Intr_Ctrl_Vector(i + 8) <= Gpio_Irq;
		end generate genGpioIRQ;
	end generate genGPIO;
	genI2C: for i in 0 to C_i2c - 1 generate
		i2c : entity work.i2c
			generic map
			(
				C_Freq_MHz  =>	FREQ_MHZ,
				C_Freq_I2C  =>	100000
			)
			port map
			(
				Rst         =>	Reset_MCU,
				Clk         =>	Clk,
				Ce_I        =>	i2c_ce(i),
				data_DAT_O  =>	from_i2c(i),
				data_DAT_I  =>	Data_DAT_O,
				data_WE_I   =>	data_WE_O,
				data_SEL_I  =>	data_SEL_O,
				Scl         =>	I2C_Scl(i),
				Sda         =>	I2C_Sda(i)
			);
			i2c_ce(i) <= io_addr_strobe when R_io_addr(11 downto 6) = x"A" & "00" and to_integer(unsigned(R_io_addr(5 downto 4))) = i else '0';
	end generate genI2C;
	genSio: for i in 0 to C_Sio - 1 generate
		Uart : entity work.Uart
			generic map
			(
				C_Freq_MHz  	=> FREQ_MHZ,
				C_init_baud 	=> 115200,
				C_Rx_Fifo_Depth => C_Sio_Rx_Fifo_Depth,
				C_Tx_Fifo_Depth => C_Sio_Tx_Fifo_Depth
			)
			port map 
			(
				Rst            	=> Reset_MCU,
				Clk             => Clk,
				Ce_I            => sio_ce(i),
				data_DAT_O      => from_sio(i),
				data_DAT_I      => data_DAT_O,
				data_WE_I       => data_WE_O,
				data_SEL_I      => data_SEL_O,
				Rx              => Sio_Rx(i),
				Tx              => Sio_Tx(i)
			);
		sio_ce(i) <= io_addr_strobe when R_io_addr(11 downto 6) = x"B" & "00" and to_integer(unsigned(R_io_addr(5 downto 4))) = i else '0';
		Ext_Intr_Ctrl_Vector(i) <= from_sio(i)(8);
	end generate genSio;
	genSpi: for i in 0 to C_Spi - 1 generate
		spi	:	entity work.spi
		generic map
		(
			C_fixed_speed	=> false
		)
		port map
		(
			Rst			=> Reset_MCU,
			ce			=> Spi_Ce(i), 
			clk			=> Clk,
			bus_write	=> data_WE_O,
			byte_sel	=> data_SEL_O,
			bus_in		=> data_DAT_O,
			bus_out		=> from_spi(i),
			spi_sck		=> Spi_Sck(i), 
			spi_mosi	=> Spi_Mosi(i), 
			spi_cen		=> Spi_Ce_N(i),
			spi_miso	=> Spi_Miso(i)
		);
		Spi_Ce(i) <= io_addr_strobe when R_io_addr(11 downto 6) = x"B" & "01" and to_integer(unsigned(R_io_addr(5 downto 4))) = i else '0';
	end generate genSpi;
	mtime : entity work.mtime
		port map
		(
			Rst           	=> Reset_MCU,
			Clk           	=> Clk,
	
			CE_I            => MTIME_Ce,
			Data_WE_I       => data_WE_O,
			Data_ADR_I      => R_io_addr(3 downto 2),
			data_SEL_I      => data_SEL_O,
			data_DAT_I      => data_DAT_O,
			data_DAT_O      => From_MTIME,
			MTIMECMP_INTR   => MTIME_CmpOverflow
		);
	MTIME_Ce <= io_addr_strobe when R_io_addr(11 downto 4) = x"B8" else '0';
	genTimers: for i in 0 to C_Timers - 1 generate
		timer : entity work.timerbus
		port map
		(
			Rst           	=> Reset_MCU,
			Clk           	=> Clk,
	
			CE_I            => timer_ce(i),
			Data_WE_I       => Data_WE_O,
			Data_ADR_I      => Data_ADR_O,
			data_SEL_I      => data_SEL_O,
			data_DAT_I      => data_DAT_O,
			data_DAT_O      => from_timer(i),
			Overflow_O      => open,
			CmpOverflow_O   => timer_CmpOverflow_intr(i),
			EqZero_O        => timer_EqZero_intr(i)
		);
		timer_ce(i) <= io_addr_strobe when R_io_addr(11 downto 7) = x"C" & '0' and to_integer(unsigned(R_io_addr(6 downto 4))) = i else '0';
		Ext_Intr_Ctrl_Vector(2*i + 16) 		<= timer_CmpOverflow_intr(i);
		Ext_Intr_Ctrl_Vector(2*i + 1 + 16) 	<= timer_EqZero_intr(i);
	end generate genTimers;
	Ext_IRQ_CTRL : entity work.Interrupt_Controller
		port map
		(
			Rst    		=>	Reset_MCU,
			Clk     	=>	Clk,

			Intr_I      =>	Ext_Intr_Ctrl_Vector,

			CE_I        =>	Ext_IRQ_Ce,
			Data_WE_I   =>	data_WE_O,
			Data_SEL_I  =>	data_SEL_O,
			Data_ADR_I  =>	R_io_addr(3 downto 2),
			Data_DAT_I  =>	Data_DAT_O,
			Data_DAT_O  =>	from_Ext_IRQ,
	
			Intr_O      =>	Ext_IRQ
		);
	Ext_IRQ_Ce				<=	io_addr_strobe	when R_io_addr(11 downto 4) = x"FE" else '0';
	Ext_Intr_Ctrl_Vector(63 downto 32) <= Ext_IRQv;
	genBootTrap: if C_BootTrap = true generate
		boot_trap : entity work.BootTrap
		port map
		(
			ARst        =>	Rst,
			Clk         =>	Clk,
			Ce_I        =>	boot_trap_ce,
			data_DAT_O  =>	from_boot_trap,
			data_DAT_I  =>	data_DAT_O,
			data_WE_I   =>	data_WE_O,
			data_SEL_I  =>	data_SEL_O,
			Baudrate    =>	from_sio(0)(11),
			TrigRx      =>	from_sio(0)(12),
			ByteRx      =>	from_sio(0)(31 downto 24),
			Reset       =>	ResetRqst
		);
		boot_trap_ce <= io_addr_strobe when R_io_addr(11 downto 4) = x"FF" and R_io_addr(3 downto 2) = "11" else '0';
	end generate genBootTrap;
end architecture rtl;
