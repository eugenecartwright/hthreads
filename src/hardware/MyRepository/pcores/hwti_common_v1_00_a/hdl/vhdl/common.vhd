library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

package common is
    constant HTHREAD_MTX_LOCK    : std_logic_vector(0 to 7) := x"00";
    constant HTHREAD_MTX_UNLOCK  : std_logic_vector(0 to 7) := x"01";
    constant HTHREAD_MTX_TRYLOCK : std_logic_vector(0 to 7) := x"02";
    constant HTHREAD_MTX_OWNER   : std_logic_vector(0 to 7) := x"03";
    constant HTHREAD_MTX_KIND    : std_logic_vector(0 to 7) := x"04";
    constant HTHREAD_MTX_COUNT   : std_logic_vector(0 to 7) := x"05";
    constant HTHREAD_MTX_SETKIND : std_logic_vector(0 to 7) := x"06";

    constant HTHREAD_MTX_FAST    : std_logic_vector(0 to 1) := "00";
    constant HTHREAD_MTX_RECURS  : std_logic_vector(0 to 1) := "01";
    constant HTHREAD_MTX_ERROR   : std_logic_vector(0 to 1) := "10";

    constant HTHREAD_CDV_OWNER   : std_logic_vector(0 to 7) := x"10";
    --constant HTHREAD_CDV_REQUEST : std_logic_vector(0 to 7) := x"12";
    --constant HTHREAD_CDV_RELEASE : std_logic_vector(0 to 7) := x"11";
    --constant HTHREAD_CDV_TRYLOCK : std_logic_vector(0 to 7) := x"13";
    --constant HTHREAD_CDV_COUNT   : std_logic_vector(0 to 7) := x"10";
    constant HTHREAD_CDV_WAIT    : std_logic_vector(0 to 7) := x"12";
    --constant HTHREAD_CDV_POST    : std_logic_vector(0 to 7) := x"13";
    constant HTHREAD_CDV_SIGNAL  : std_logic_vector(0 to 7) := x"11";
    --constant HTHREAD_CDV_CWAIT   : std_logic_vector(0 to 7) := x"12";
    constant HTHREAD_CDV_BROAD   : std_logic_vector(0 to 7) := x"13";

    constant HTHREAD_THR_CLEAR   : std_logic_vector(0 to 7) := x"20";
    constant HTHREAD_THR_JOIN    : std_logic_vector(0 to 7) := x"21";
    constant HTHREAD_THR_DETACH  : std_logic_vector(0 to 7) := x"22";
    constant HTHREAD_THR_ADD     : std_logic_vector(0 to 7) := x"24";
    constant HTHREAD_THR_EXIT    : std_logic_vector(0 to 7) := x"27";
    --constant HTHREAD_THR_YIELD   : std_logic_vector(0 to 7) := x"29";
    --constant HTHREAD_THR_CREATEJ : std_logic_vector(0 to 7) := x"25";
    --constant HTHREAD_THR_CREATED : std_logic_vector(0 to 7) := x"26";

    constant HTHREAD_MEM_READ    : std_logic_vector(0 to 7) := x"30";
    constant HTHREAD_MEM_WRITE   : std_logic_vector(0 to 7) := x"31";

    constant STATUS_NOT_USED     : std_logic_vector(0 to 7) := x"00";
    constant STATUS_USED         : std_logic_vector(0 to 7) := x"01";
    constant STATUS_RUNNING      : std_logic_vector(0 to 7) := x"02";
    constant STATUS_BLOCKED      : std_logic_vector(0 to 7) := x"04";
    constant STATUS_EXITED       : std_logic_vector(0 to 7) := x"08";
    constant STATUS_ERROR        : std_logic_vector(0 to 7) := x"20";

    constant COMMAND_INIT        : std_logic_vector(0 to 3) := x"0";
    constant COMMAND_RUN         : std_logic_vector(0 to 3) := x"1";
    constant COMMAND_RESET       : std_logic_vector(0 to 3) := x"2";
    constant COMMAND_COLDBOOT    : std_logic_vector(0 to 3) := x"4";
    constant COMMAND_NOTUSED     : std_logic_vector(0 to 3) := x"8";

    subtype tfsl  is std_logic_vector(0 to 63);
    subtype tcmd  is std_logic_vector(0 to 7);
    subtype ttid  is std_logic_vector(0 to 7);
    subtype tmid  is std_logic_vector(0 to 5);
    subtype tcid  is std_logic_vector(0 to 5);
    subtype tknd  is std_logic_vector(0 to 1);
    subtype tbyt  is std_logic_vector(0 to 23);
    subtype targ  is std_logic_vector(0 to 31);
    subtype taddr is std_logic_vector(0 to 31);

    function hwti_mtx_cmd( cmd : tcmd; mtx : tmid; knd : tknd ) return tfsl;
    function hwti_mtx_lock( mtx : tmid ) return tfsl;
    function hwti_mtx_unlock( mtx : tmid ) return tfsl;
    function hwti_mtx_trylock( mtx : tmid ) return tfsl;
    function hwti_mtx_owner( mtx : tmid ) return tfsl;
    function hwti_mtx_kind( mtx : tmid ) return tfsl;
    function hwti_mtx_setkind( mtx : tmid; knd : tknd ) return tfsl;
    function hwti_mtx_count( mtx : tmid ) return tfsl;

    function hwti_cdv_cmd( cmd : tcmd; cdv : tcid ) return tfsl;
    function hwti_cdv_owner( cdv : tcid ) return tfsl;
    function hwti_cdv_wait( cdv : tcid ) return tfsl;
    function hwti_cdv_signal( cdv : tcid ) return tfsl;
    function hwti_cdv_broadcast( cdv : tcid ) return tfsl;

    function hwti_mem_cmd( cmd:tcmd; addr:taddr; bytes:tbyt ) return tfsl;
    function hwti_mem_read( addr : taddr; bytes : tbyt ) return tfsl;
    function hwti_mem_write( addr : taddr; bytes : tbyt ) return tfsl;

    function hwti_thr_cmd( cmd:tcmd; arg:targ ) return tfsl;
    function hwti_thr_join( tid:ttid ) return tfsl;
    function hwti_thr_exit( arg:targ ) return tfsl;
    function hwti_thr_clear( tid:ttid ) return tfsl;
    function hwti_thr_detach return tfsl;
    function hwti_thr_add( tid:ttid ) return tfsl;

    procedure hwti_wake( signal result :  in tfsl;
                         signal tid    : out ttid;
                         signal arg    : out targ );
end package;

package body common is
    function hwti_mtx_cmd( cmd : tcmd; mtx : tmid; knd : tknd ) return tfsl is
    begin
        return cmd & x"0000" & knd & mtx & x"00000000";
    end function;

    function hwti_mtx_lock( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_LOCK, mtx, "00" );
    end function;

    function hwti_mtx_unlock( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_UNLOCK, mtx, "00" );
    end function;

    function hwti_mtx_trylock( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_TRYLOCK, mtx, "00" );
    end function;

    function hwti_mtx_owner( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_OWNER, mtx, "00" );
    end function;

    function hwti_mtx_kind( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_KIND, mtx, "00" );
    end function;

    function hwti_mtx_setkind( mtx : tmid; knd : tknd ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_SETKIND, mtx, knd );
    end function;

    function hwti_mtx_count( mtx : tmid ) return tfsl is
    begin
        return hwti_mtx_cmd( HTHREAD_MTX_COUNT, mtx, "00" );
    end function;

    function hwti_cdv_cmd( cmd : tcmd; cdv : tcid ) return tfsl is
    begin
        return cmd & x"0000" & "00" & cdv & x"00000000";
    end function;

    function hwti_cdv_owner( cdv : tcid ) return tfsl is
    begin
        return hwti_cdv_cmd( HTHREAD_CDV_OWNER, cdv );
    end function;

    function hwti_cdv_wait( cdv : tcid ) return tfsl is
    begin
        return hwti_cdv_cmd( HTHREAD_CDV_WAIT, cdv );
    end function;

    function hwti_cdv_signal( cdv : tcid ) return tfsl is
    begin
        return hwti_cdv_cmd( HTHREAD_CDV_SIGNAL, cdv );
    end function;

    function hwti_cdv_broadcast( cdv : tcid ) return tfsl is
    begin
        return hwti_cdv_cmd( HTHREAD_CDV_BROAD, cdv );
    end function;

    function hwti_mem_cmd( cmd:tcmd; addr:taddr; bytes:tbyt ) return tfsl is
    begin
        return cmd & bytes & addr;
    end function;

    function hwti_mem_read( addr : taddr; bytes : tbyt ) return tfsl is
    begin
        return hwti_mem_cmd( HTHREAD_MEM_READ, addr, bytes );
    end function;

    function hwti_mem_write( addr : taddr; bytes : tbyt ) return tfsl is
    begin
        return hwti_mem_cmd( HTHREAD_MEM_WRITE, addr, bytes );
    end function;

    function hwti_thr_cmd( cmd : tcmd; arg : targ ) return tfsl is
    begin
        return cmd & x"000000" & arg;
    end function;

    function hwti_thr_join( tid : ttid ) return tfsl is
    begin
        return hwti_thr_cmd( HTHREAD_THR_EXIT, x"000000" & tid );
    end function;

    function hwti_thr_exit( arg : targ ) return tfsl is
    begin
        return hwti_thr_cmd( HTHREAD_THR_EXIT, arg );
    end function;

    function hwti_thr_clear( tid:ttid ) return tfsl is
    begin
        return hwti_thr_cmd( HTHREAD_THR_CLEAR, x"000000" & tid );
    end function;

    function hwti_thr_detach return tfsl is
    begin
        return hwti_thr_cmd( HTHREAD_THR_DETACH, x"00000000" );
    end function;

    function hwti_thr_add( tid:ttid ) return tfsl is
    begin
        return hwti_thr_cmd( HTHREAD_THR_ADD, x"000000" & tid );
    end function;

    procedure hwti_wake( signal result :  in tfsl;
                         signal tid    : out ttid;
                         signal arg    : out targ ) is
    begin
        tid <= result(24 to 31);
        arg <= result(32 to 63);
    end procedure;
end package body;
