library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library hwti_common_v1_00_a;
use hwti_common_v1_00_a.common.all;

entity command is
    generic
    (
        MTX_BITS : natural              := 6;
        TID_BITS : natural              := 8;
        CMD_BITS : natural              := 3;
        MTX_BASE : std_logic_vector     := x"75000000";
        CDV_BASE : std_logic_vector     := x"74000000";
        SCH_BASE : std_logic_vector     := x"61000000";
        MNG_BASE : std_logic_vector     := x"60000000";
        C_AWIDTH : integer              := 32;
        C_DWIDTH : integer              := 64
    );
    port
    (
        clk             :  in std_logic;
        rst             :  in std_logic;

        tid             :  in std_logic_vector(0 to TID_BITS-1);
        arg             :  in std_logic_vector(0 to 31);
        opcode_read     : out std_logic;
        opcode_data     :  in std_logic_vector(0 to 63);
        opcode_control  :  in std_logic;
        opcode_exists   :  in std_logic;

        result_write    : out std_logic;
        result_data     : out std_logic_vector(0 to 63);
        result_control  : out std_logic;
        result_full     :  in std_logic;

        memrd           :  in std_logic;
        memwr           :  in std_logic;
        memrdack        : out std_logic;
        memwrack        : out std_logic;

        command         :  in std_logic_vector(0 to 3);
        status          :  in std_logic_vector(0 to 7);

        setsta          : out std_logic;
        outsta          : out std_logic_vector(0 to 31);

        setres          : out std_logic;
        outres          : out std_logic_vector(0 to 31);

        rd              : out std_logic;
        wr              : out std_logic;
        addr            : out std_logic_vector(0 to C_AWIDTH-1);
        data            : out std_logic_vector(0 to C_DWIDTH-1);
        bytes           : out std_logic_vector(0 to 23);
        ack             :  in std_logic;
        last            :  in std_logic;
        err             :  in std_logic;
        results         :  in std_logic_vector(0 to C_DWIDTH-1)
    );
end entity;

architecture behavioral of command is

    type command_state is
    (
        START,
        WAKEUP,
        IDLE,
        READ,
        SEND,
        WRITE,
        RECV,
        HOLD,
        BLOCKED
    );

    alias opdev : std_logic_vector(0 to 3)  is opcode_data(0 to 3);
    alias opcmd : std_logic_vector(0 to 3)  is opcode_data(4 to 7);
    alias oparg : std_logic_vector(0 to 23) is opcode_data(8 to 31);
    alias operr : std_logic is result_control;
    alias opres : std_logic_vector(0 to 31) is result_data(32 to 63);

    alias memsize   : std_logic_vector(0 to 23) is opcode_data(8 to 31);
    alias memaddr   : std_logic_vector(0 to 31) is opcode_data(32 to 63);
    alias osta      : std_logic_vector(0 to 7)  is outsta(24 to 31);
    alias ores      : std_logic_vector(0 to 31) is outres(0 to 31);

    alias waketid   : std_logic_vector(0 to 7) is result_data(24 to 31);
    alias wakearg   : std_logic_vector(0 to 31) is result_data(32 to 63);

    signal cmd_cs  : command_state;
    signal cmd_ns  : command_state;
    --signal addr_cv : std_logic_vector(0 to C_AWIDTH-1);
    --signal addr_nv : std_logic_vector(0 to C_AWIDTH-1);
    --signal data_cv : std_logic_vector(0 to C_DWIDTH-1);
    --signal data_nv : std_logic_vector(0 to C_DWIDTH-1);
    --signal send_cv : std_logic_vector(0 to C_DWIDTH-1);
    --signal send_nv : std_logic_vector(0 to C_DWIDTH-1);
    --signal recv_cv : std_logic_vector(0 to C_DWIDTH-1);
    --signal recv_nv : std_logic_vector(0 to C_DWIDTH-1);
    --signal byte_cv : std_logic_vector(0 to 23);
    --signal byte_nv : std_logic_vector(0 to 23);
    --signal rd_cv   : std_logic;
    --signal rd_nv   : std_logic;
    --signal wr_cv   : std_logic;
    --signal wr_nv   : std_logic;
    signal last_nv : std_logic;
    signal last_cv : std_logic;

    --alias send_cv  : std_logic_vector(0 to 63) is data_cv;
    --alias send_nv  : std_logic_vector(0 to 63) is data_nv;
    --alias recv_cv  : std_logic_vector(0 to 63) is data_cv;
    --alias recv_nv  : std_logic_vector(0 to 63) is data_nv;

    alias opknd : std_logic_vector(0 to 1) is opcode_data(32-MTX_BITS-2 to 32-MTX_BITS-1);
    --alias data_knd  : std_logic_vector(0 to 1)  is data_nv(C_DWIDTH-2 to C_DWIDTH-1);
begin
    --rd              <= rd_cv;
    --wr              <= wr_cv;
    --addr            <= addr_cv;
    --data            <= data_cv;
    --bytes           <= byte_cv;
    --outsta(0 to 55) <= (others => '0');
    --outres(0 to 31) <= (others => '0');
    outsta(0 to 23)   <= (others => '0');

    update : process(clk,rst,cmd_ns) is
    begin
        if( rising_edge(clk) ) then
            if( rst = '1' ) then
                cmd_cs  <= START;
                --addr_cv <= (others => '0');
                --data_cv <= (others => '0');
                --byte_cv <= (others => '0');
                last_cv <= '0';
                --send_cv <= (others => '0');
                --recv_cv <= (others => '0');
                --rd_cv   <= '0';
                --wr_cv   <= '0';
            else
                cmd_cs  <= cmd_ns;
                --addr_cv <= addr_nv;
                --data_cv <= data_nv;
                --byte_cv <= byte_nv;
                last_cv <= last_nv;
                --send_cv <= send_nv;
                --recv_cv <= recv_nv;
                --rd_cv   <= rd_nv;
                --wr_cv   <= wr_nv;
            end if;
        end if;
    end process;

    controller : process(results,cmd_cs,opdev,opcmd,
                         ack,command,opcode_exists, opcode_data, tid,
                         oparg, result_full, arg,
                         last,memwr,last_cv,memrd) is
        function mutex_cmd( tid : in std_logic_vector;
                            arg : in std_logic_vector;
                            cmd : in std_logic_vector )
                            return std_logic_vector is
            constant AW : integer := C_AWIDTH;
            constant MB : integer := MTX_BITS;
            constant TB : integer := TID_BITS;
            constant CB : integer := CMD_BITS;
            variable addr : std_logic_vector(0 to AW-1);
        begin
            addr                              := MTX_BASE;
            addr(AW-MB-2 to AW-3)             := arg(24-MB to 23);
            addr(AW-MB-TB-2 to AW-MB-3)       := tid;
            addr(AW-MB-TB-CB-3 to AW-MB-TB-3) := cmd;
            return addr;
        end function;

        function condv_cmd( tid : in std_logic_vector;
                            arg : in std_logic_vector;
                            cmd : in std_logic_vector )
                            return std_logic_vector is
            constant AW : integer := C_AWIDTH;
            constant MB : integer := MTX_BITS;
            constant TB : integer := TID_BITS;
            constant CB : integer := CMD_BITS;
            variable addr : std_logic_vector(0 to AW-1);
        begin
            addr                              := CDV_BASE;
            addr(AW-MB-2 to AW-3)             := arg(24-MB to 23);
            addr(AW-MB-TB-2 to AW-MB-3)       := tid;
            addr(AW-MB-TB-CB-4 to AW-MB-TB-4) := cmd;
            return addr;
        end function;

        function manag_cmd( tid : in std_logic_vector;
                            arg : in std_logic_vector;
                            cmd : in std_logic_vector )
                            return std_logic_vector is
            constant AW : integer := C_AWIDTH;
            constant MB : integer := MTX_BITS;
            constant TB : integer := TID_BITS;
            constant CB : integer := CMD_BITS;
            variable addr : std_logic_vector(0 to AW-1);
        begin
            addr                              := MNG_BASE;
            addr(AW-TB-2 to AW-3)             := tid;
            addr(AW-TB-CB-3 to AW-TB-3)       := cmd;
            return addr;
        end function;
    begin
        result_data    <= (others => '0');
        result_control <= '0';
        result_write   <= '0';
        opcode_read    <= '0';
        data           <= (others => '0');
        last_nv  <= '0';
        --addr_nv  <= (others => '0');
        --data_nv  <= (others => '0');
        --send_nv  <= (others => '0');
        --recv_nv  <= (others => '0');
        --byte_nv  <= (others => '0');
        cmd_ns   <= cmd_cs;
        memrdack <= '0';
        memwrack <= '0';
        --rd_nv    <= '0';
        --wr_nv    <= '0';
        setsta   <= '0';
        setres   <= '0';
        osta     <= (others => '0');
        ores     <= (others => '0');
        rd       <= '0';
        wr       <= '0';
        addr     <= (others => '0');
        bytes    <= (others => '0');

        case cmd_cs is
        when START =>
            if( command = COMMAND_RUN ) then
                setsta <= '1';
                osta   <= STATUS_RUNNING;
                cmd_ns <= WAKEUP;
            end if;

        when WAKEUP =>
            if( result_full = '0' ) then
                result_write   <= '1';
                result_control <= '1';
                cmd_ns         <= IDLE;
                waketid        <= tid;
                wakearg        <= arg;
            end if;

        when IDLE =>
            if( opcode_exists = '1' and result_full = '0' ) then
                case opdev is
                when x"0" =>
                    if( opcmd = x"6" ) then
                        wr       <= '1';
                        bytes    <= x"000004";
                        addr     <= mutex_cmd(tid,oparg,x"4");
                        data     <= x"0000000" & "00" & opknd;
                        cmd_ns   <= HOLD;
                    else
                        rd      <= '1';
                        bytes   <= x"000004";
                        addr    <= mutex_cmd(tid,oparg,opcmd);
                        cmd_ns  <= HOLD;
                    end if;

                when x"1" =>
                    rd     <= '1';
                    bytes  <= x"000004";
                    addr   <= condv_cmd(tid,oparg,opcmd);
                    cmd_ns <= HOLD;

                when x"2" =>
                    rd     <= '1';
                    bytes  <= x"000004";
                    cmd_ns <= HOLD;
                    if( opcmd = x"7" or opcmd = x"2") then
                        addr   <= manag_cmd(tid,oparg,opcmd);
                    else
                        addr   <= manag_cmd(oparg(16 to 23),oparg,opcmd);
                    end if;

                when x"3" =>
                    addr  <= memaddr;
                    bytes <= memsize;
                    cmd_ns  <= HOLD;
                    if( opcmd = x"0" ) then
                        rd     <= '1';
                        cmd_ns <= READ;
                    else
                        wr     <= '1';
                        cmd_ns <= RECV;
                    end if;

                when others => 
                    result_control <= '1';
                    result_write   <= '1';
                end case;
            end if;

        when READ =>
            result_data  <= results;
            if( last = '1' ) then
                opcode_read <= '1';
                cmd_ns       <= IDLE;
            elsif( memwr = '1' ) then
                if( result_full = '0' ) then
                    memwrack     <= '1';
                    result_write <= '1';
                else
                    cmd_ns  <= SEND;
                end if;
            end if;

        when SEND =>
            last_nv <= last_cv;
            if( result_full = '0' ) then
                memwrack     <= '1';
                result_write <= '1';
                result_data  <= results;
                if( last_cv = '1' ) then
                    cmd_ns   <= IDLE;
                else
                    cmd_ns   <= READ;
                end if;
            end if;

        when WRITE =>
            if( last = '1' ) then
                cmd_ns  <= IDLE;
            elsif( memrd = '1' ) then
                if( opcode_exists = '1' ) then
                    opcode_read <= '1';
                    memrdack    <= '1';
                else
                    cmd_ns  <= RECV;
                end if;
            end if;

        when RECV =>
            if( opcode_exists = '1' ) then
                opcode_read <= '1';
                memrdack    <= '1';
                cmd_ns      <= WRITE;
            end if;

        when HOLD =>
            memwrack <= memrd;
            memrdack <= memwr;
            data     <= x"000000000000000" & "00" & opknd;
            if( ack = '1' ) then
                opcode_read <= '1';
                case opdev is
                when x"0" =>
                    if( results(1) = '1' and opcmd /= x"2" ) then
                        setsta       <= '1';
                        osta         <= STATUS_BLOCKED;
                        cmd_ns       <= BLOCKED;
                    else
                        result_write <= '1';
                        cmd_ns       <= IDLE;
                    end if;

                when x"1" =>
                    if( results(C_DWIDTH-4 to C_DWIDTH-1) /= x"E" ) then
                        if( opcmd = x"2" ) then
                            setsta <= '1';
                            osta   <= STATUS_BLOCKED;
                            cmd_ns <= BLOCKED;
                        else
                            result_write <= '1';
                            cmd_ns       <= IDLE;
                        end if;
                    end if;

                when x"2" =>
                    if( results(C_DWIDTH-4 to C_DWIDTH-1) = "0011" ) then
                        setsta <= '1';
                        osta   <= STATUS_BLOCKED;
                        cmd_ns <= BLOCKED;
                    elsif( opcmd = x"7" ) then
                        setsta       <= '1';
                        osta         <= STATUS_EXITED;
                        setres       <= '1';
                        ores         <= opcode_data(32 to 63);
                        cmd_ns       <= START;
                    else
                        result_write <= '1';
                        cmd_ns       <= IDLE;
                    end if;

                when others =>
                    result_write <= '1';
                    cmd_ns       <= IDLE;
                end case;
            end if;

        when BLOCKED =>
            if( command = COMMAND_RUN ) then
                result_write <= '1';
                setsta       <= '1';
                osta         <= STATUS_RUNNING;
                cmd_ns       <= IDLE;
            end if;
        end case;
    end process controller;
end architecture;
