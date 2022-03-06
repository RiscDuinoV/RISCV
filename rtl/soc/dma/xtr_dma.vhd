library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.xtr_def.all;

entity xtr_dma is
    port (
        arst_i : in std_logic;
        clk_i : in std_logic;
        srst_i : in std_logic;
        xtr_cmd_i : in xtr_cmd_t;
        xtr_rsp_o : out xtr_rsp_t;
        xtr_cmd_o : out xtr_cmd_t;
        xtr_rsp_i : in xtr_rsp_t
    );
end entity xtr_dma;

architecture rtl of xtr_dma is
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
    type dma_st is (st_idle, st_transfer);
    signal current_st : dma_st;
    signal wr_fifo_wdat, wr_fifo_rdat : std_logic_vector(31 downto 0);
    signal wr_fifo_we, wr_fifo_re, d_wr_fifo_re : std_logic;
    signal wr_fifo_ef, wr_fifo_ff : std_logic;
    signal rd_fifo_wdat, rd_fifo_rdat : std_logic_vector(31 downto 0);
    signal rd_fifo_we, rd_fifo_re, d_rd_fifo_re : std_logic;
    signal rd_fifo_ef, rd_fifo_ff : std_logic;
    signal start : std_logic;
    signal count, length : unsigned(31 downto 0);
    signal incr : std_logic;
    signal xtr_cmd : xtr_cmd_t;
    signal d_dma_rsp_rdy : std_logic;
    signal address : std_logic_vector(31 downto 0);
    signal write_transfer : std_logic;
    signal word_size : std_logic_vector(1 downto 0);
begin
    
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            current_st <= st_idle;
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                current_st <= st_idle;
            else
                case current_st is
                    when st_idle =>
                        if start = '1' then
                            current_st <= st_transfer;
                        end if;
                    when st_transfer =>
                        if count >= length then
                            current_st <= st_idle;
                        end if;
                    when others =>
                end case;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            xtr_cmd.vld <= '0';
            xtr_cmd.we <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                xtr_cmd.vld <= '0';
                xtr_cmd.we <= '0';
            else
                if start = '1' then
                    count <= (others => '0');
                    xtr_cmd.adr <= address;
                end if;
                if current_st = st_transfer and xtr_rsp_i.rdy = '1' then
                    if incr = '1' and xtr_cmd.vld = '1' then
                        case word_size is
                            when "00" =>
                                xtr_cmd.adr <= std_logic_vector(unsigned(xtr_cmd.adr) + 1);
                            when "01" =>
                                xtr_cmd.adr <= std_logic_vector(unsigned(xtr_cmd.adr) + 2);
                            when others =>
                                xtr_cmd.adr <= std_logic_vector(unsigned(xtr_cmd.adr) + 4);
                        end case;
                    end if;
                    if write_transfer = '1' then
                        xtr_cmd.vld <= d_wr_fifo_re;
                        if xtr_rsp_i.rdy = '1' and d_dma_rsp_rdy = '0' then
                            xtr_cmd.vld <= '1';
                        end if;
                    else
                        xtr_cmd.vld <= '1';
                    end if;
                    xtr_cmd.we <= write_transfer;
                    xtr_cmd.dat <= wr_fifo_rdat;
                    if write_transfer = '1' then
                        if d_wr_fifo_re = '1' then
                            count <= count + 1;
                        end if;
                    else  
                        count <= count + 1;
                    end if;
                elsif current_st = st_idle then
                    xtr_cmd.vld <= '0';
                    xtr_cmd.we <= '0';
                end if;
            end if;
        end if;
    end process;
    xtr_cmd.sel <= get_data_sel(word_size, xtr_cmd.adr(1 downto 0));

    start <= '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.adr(4 downto 2) = "000" else '0';

    u_fifo_write : entity work.fifo
        generic map (
            C_DEPTH => 16, C_WIDTH => 32)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            we_i => wr_fifo_we, wdat_i => wr_fifo_wdat, full_o => wr_fifo_ff,
            re_i => wr_fifo_re, rdat_o => wr_fifo_rdat, empty_o => wr_fifo_ef);
    
    wr_fifo_we <= '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' and xtr_cmd_i.adr(4 downto 2) = "100" else '0';
    wr_fifo_wdat <= xtr_cmd_i.dat;

    wr_fifo_re <= 
        '1' when current_st = st_transfer and write_transfer = '1' and xtr_rsp_i.rdy = '1' and wr_fifo_ef = '0' else 
        --'1' when current_st = st_idle and start = '1' and wr_fifo_ef = '0' else
        '0';
    
    u_fifo_read : entity work.fifo
        generic map (
            C_DEPTH => 16, C_WIDTH => 32)
        port map (
            arst_i => arst_i, clk_i => clk_i, srst_i => srst_i,
            we_i => rd_fifo_we, wdat_i => rd_fifo_wdat, full_o => rd_fifo_ff,
            re_i => rd_fifo_re, rdat_o => rd_fifo_rdat, empty_o => rd_fifo_ef);

    rd_fifo_we <= '1' when xtr_rsp_i.vld = '1' and write_transfer = '0' and rd_fifo_ff = '0' else '0';
    rd_fifo_wdat <= xtr_rsp_i.dat;

    rd_fifo_re <= '1' when xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '0' and unsigned(xtr_cmd_i.adr(4 downto 2)) = "100" else '0';

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            d_wr_fifo_re <= '0';
            d_dma_rsp_rdy <= '0';
        elsif rising_edge(clk_i) then
            d_wr_fifo_re <= wr_fifo_re;
            d_dma_rsp_rdy <= xtr_rsp_i.rdy;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            write_transfer <= '0';
        elsif rising_edge(clk_i) then
            if srst_i = '1' then
                write_transfer <= '0';
            else
                if xtr_cmd_i.vld = '1' and xtr_cmd_i.we = '1' then
                    case to_integer(unsigned(xtr_cmd_i.adr(4 downto 2))) is
                        when 0 =>
                            write_transfer <= xtr_cmd_i.dat(0);
                            incr <= xtr_cmd_i.dat(16);
                            word_size <= xtr_cmd_i.dat(9 downto 8);
                        when 1 =>
                            address <= xtr_cmd_i.dat;
                        when 2 =>
                            length <= unsigned(xtr_cmd_i.dat);
                        when others =>
                            
                    
                    end case;
                end if;
            end if;
        end if;
    end process;

    xtr_cmd_o <= xtr_cmd;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            xtr_rsp_o.vld <= '0';
        elsif rising_edge(clk_i) then
            if xtr_cmd_i.adr(4 downto 2) = "100" then
                xtr_rsp_o.vld <= xtr_cmd_i.vld;
            else
                xtr_rsp_o.vld <= '0';
            end if;
        end if;
    end process;
    xtr_rsp_o.dat <= rd_fifo_rdat;
    xtr_rsp_o.rdy <= '1';

    
end architecture rtl;