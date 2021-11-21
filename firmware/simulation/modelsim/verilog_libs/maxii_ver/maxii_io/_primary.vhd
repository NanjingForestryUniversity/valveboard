library verilog;
use verilog.vl_types.all;
entity maxii_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        lpm_type        : string  := "maxii_io"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of operation_mode : constant is 1;
    attribute mti_svvh_generic_type of bus_hold : constant is 1;
    attribute mti_svvh_generic_type of open_drain_output : constant is 1;
    attribute mti_svvh_generic_type of lpm_type : constant is 1;
end maxii_io;
