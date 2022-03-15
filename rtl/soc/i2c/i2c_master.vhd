library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity i2c_master is
    port (
        arst_i : in std_logic := '0';
        clk_i : in std_logic;
        srst_i : in std_logic := '0';
        en_i : in std_logic;
        freq_i : in std_logic_vector(15 downto 0);
        trg_i : in std_logic;
        we_i : in std_logic;
        last_i : in std_logic;
        wdat_i : in std_logic_vector(7 downto 0);
        rdat_o : out std_logic_vector(7 downto 0);
        rvld_o : out std_logic;
        scl_io : inout std_logic;
        sda_io : inout std_logic;
        ack_err_o : out std_logic;
        busy_o : out std_logic
    );
end entity i2c_master;

architecture rtl of i2c_master is
    type i2c_master_st is (st_idle, st_wait, st_start, st_write, st_slave_ack, st_read, st_master_ack, st_stop);
    signal current_st : i2c_master_st;
    signal scl_cnt : unsigned(16 downto 0);
    signal scl_re, scl_fe : std_logic;
    signal d_scl_re, d_scl_fe : std_logic;
    signal sda_i, sda_o, sda_t : std_logic;
    signal scl_i, scl_o, scl_t : std_logic;
    signal wdat, rdat, bit_mask : std_logic_vector(7 downto 0);
    signal cool_down : std_logic;
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            scl_i <= to_UX01(scl_io);
            sda_i <= to_UX01(sda_io);
            d_scl_re <= scl_re;
            d_scl_fe <= scl_fe;
        end if;
    end process;
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if ((current_st /= st_idle) and current_st /= st_wait) or (current_st = st_idle and cool_down = '1') then
                scl_cnt <= ('0' & scl_cnt(15 downto 0)) + unsigned('0' & freq_i);
            else
                scl_cnt <= (others => '0');
            end if;
        end if;
    end process;
    scl_re <= '1' when scl_cnt(16) = '1' and scl_o = '0' else '0';
    scl_fe <= '1' when scl_cnt(16) = '1' and scl_o = '1' else '0';
    pFsm : process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            current_st <= st_idle;
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                current_st <= st_idle;
            else
                case current_st is
                    when st_idle =>
                        if en_i = '1' then
                            current_st <= st_start;
                        end if;
                    when st_start =>
                        if scl_re = '1' then
                            current_st <= st_write;
                        end if;
                    when st_wait =>
                        if en_i = '0' then
                            current_st <= st_stop;
                        else
                            if trg_i = '1' then
                                if we_i = '1' then
                                    current_st <= st_write;
                                else
                                    current_st <= st_read;
                                end if;
                            end if;
                        end if;
                    when st_write =>
                        if bit_mask(7) = '1' and scl_fe = '1' then
                            current_st <= st_slave_ack;
                        end if;
                    when st_slave_ack =>
                        if scl_fe = '1' then
                            current_st <= st_wait;
                        end if;
                    when st_read =>
                        if bit_mask(7) = '1' and scl_fe = '1' then
                            current_st <= st_master_ack;
                        end if;
                    when st_master_ack =>
                        if scl_fe = '1' then
                            current_st <= st_wait;
                        end if;
                    when st_stop =>
                        if scl_fe = '1' then
                            current_st <= st_idle;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process pFsm;

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if we_i = '1' then
                wdat <= wdat_i;
            end if;
            if scl_cnt(16) = '1' then
                scl_o <= not scl_o;
            end if;
            rvld_o <= '0';
            case current_st is
                when st_idle =>
                    scl_o <= '1';
                    sda_t <= '1';
                    sda_o <= '1';
                    ack_err_o <= '0';
                    bit_mask <= x"01";
                when st_wait =>
                    scl_o <= '0';
                    sda_t <= '1';
                    sda_o <= '1';
                    bit_mask <= x"01";
                when st_start =>
                    if scl_re = '1' then
                        scl_o <= '0';
                    end if;
                    sda_t <= '0';
                    sda_o <= '0';
                when st_write =>
                    sda_t <= '0';
                    sda_o <= wdat(7);
                    if scl_fe = '1' then
                        wdat <= wdat(6 downto 0) & '0';
                        bit_mask <= bit_mask(6 downto 0) & '0';
                    end if;
                when st_slave_ack =>
                    sda_o <= '1';
                    sda_t <= '1';
                    if d_scl_re = '1' then
                        ack_err_o <= sda_i;
                    end if;
                when st_read =>
                    sda_t <= '1';
                    if d_scl_re = '1' then
                        rdat <= rdat(6 downto 0) & sda_i;
                        if bit_mask(7) = '1' then
                            rvld_o <= '1';
                        end if;
                    else
                        rvld_o <= '0';
                    end if;
                    if scl_fe = '1' then
                        bit_mask <= bit_mask(6 downto 0) & '0';
                    end if;
                when st_master_ack =>
                    if last_i = '0' then
                        sda_t <= '0';
                        sda_o <= '0';
                    else
                        sda_t <= '1';
                        sda_o <= '1';
                    end if;
                when st_stop =>
                    if scl_fe = '1' then
                        scl_o <= '1';
                    end if;
                    sda_t <= '0';
                    sda_o <= '0';
                when others =>
            end case;
        end if;
    end process;
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            cool_down <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                cool_down <= '0';
            else
                if current_st = st_idle then
                    if scl_cnt(16) = '1' then
                        cool_down <= '0';
                    end if;
                else
                    cool_down <= '1';
                end if;
            end if;
        end if;
    end process;
    rdat_o <= rdat;
    scl_t  <= '0';
    scl_io <= scl_o when scl_t = '0' else 'Z';
    sda_io <= sda_o when sda_t = '0' else 'Z';
    busy_o <= '0' when (current_st = st_idle and cool_down = '0') or current_st = st_wait else '1';
end architecture rtl;