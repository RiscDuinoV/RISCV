library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity pll_wrapper is
    generic (
        C_CLK_IN_PER : real := 10.0;
        C_PLL_MULT : integer range 2 to 64 := 5;
        C_PLL_DIV : integer range 1 to 56 := 5;
        C_CLK0_DIV : integer range 1 to 128 := 1
    );
    port (
        rst_i : in std_logic;
        clk_i : in std_logic;
        clk0_o : out std_logic;
        lock_o : out std_logic     
    );
end entity pll_wrapper;

architecture rtl of pll_wrapper is
    signal clk_feed_back : std_logic;
begin
    
    u_PLLE2_BASE : PLLE2_BASE
        generic map (
            BANDWIDTH => "OPTIMIZED",  -- OPTIMIZED, HIGH, LOW
            CLKFBOUT_MULT => C_PLL_MULT,        -- Multiply value for all CLKOUT, (2-64)
            CLKFBOUT_PHASE => 0.0,     -- Phase offset in degrees of CLKFB, (-360.000-360.000).
            CLKIN1_PERIOD => C_CLK_IN_PER,      -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            -- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
            CLKOUT0_DIVIDE => C_CLK0_DIV,
            CLKOUT1_DIVIDE => 1,
            CLKOUT2_DIVIDE => 1,
            CLKOUT3_DIVIDE => 1,
            CLKOUT4_DIVIDE => 1,
            CLKOUT5_DIVIDE => 1,
            -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
            CLKOUT0_DUTY_CYCLE => 0.5,
            CLKOUT1_DUTY_CYCLE => 0.5,
            CLKOUT2_DUTY_CYCLE => 0.5,
            CLKOUT3_DUTY_CYCLE => 0.5,
            CLKOUT4_DUTY_CYCLE => 0.5,
            CLKOUT5_DUTY_CYCLE => 0.5,
            -- CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
            CLKOUT0_PHASE => 0.0,
            CLKOUT1_PHASE => 0.0,
            CLKOUT2_PHASE => 0.0,
            CLKOUT3_PHASE => 0.0,
            CLKOUT4_PHASE => 0.0,
            CLKOUT5_PHASE => 0.0,
            DIVCLK_DIVIDE => C_PLL_DIV,        -- Master division value, (1-56)
            REF_JITTER1 => 0.0,        -- Reference input jitter in UI, (0.000-0.999).
            STARTUP_WAIT => "FALSE"    -- Delay DONE until PLL Locks, ("TRUE"/"FALSE")
        )
        port map (
            -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
            CLKOUT0 => clk0_o,   -- 1-bit output: CLKOUT0
            CLKOUT1 => open,   -- 1-bit output: CLKOUT1
            CLKOUT2 => open,   -- 1-bit output: CLKOUT2
            CLKOUT3 => open,   -- 1-bit output: CLKOUT3
            CLKOUT4 => open,   -- 1-bit output: CLKOUT4
            CLKOUT5 => open,   -- 1-bit output: CLKOUT5
            -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
            CLKFBOUT => clk_feed_back, -- 1-bit output: Feedback clock
            LOCKED => lock_o,     -- 1-bit output: LOCK
            CLKIN1 => clk_i,     -- 1-bit input: Input clock
            -- Control Ports: 1-bit (each) input: PLL control ports
            PWRDWN => '0',     -- 1-bit input: Power-down
            RST => rst_i,           -- 1-bit input: Reset
            -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
            CLKFBIN => clk_feed_back    -- 1-bit input: Feedback clock
        );

    
end architecture rtl;