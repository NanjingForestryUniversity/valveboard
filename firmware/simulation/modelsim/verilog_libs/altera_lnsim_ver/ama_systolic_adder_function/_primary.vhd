library verilog;
use verilog.vl_types.all;
entity ama_systolic_adder_function is
    generic(
        width_data_in   : integer := 1;
        width_chainin   : integer := 1;
        width_data_out  : integer := 1;
        number_of_adder_input: integer := 1;
        systolic_delay1 : string  := "UNREGISTERED";
        systolic_aclr1  : string  := "UNUSED";
        systolic_delay3 : string  := "UNREGISTERED";
        systolic_aclr3  : string  := "UNUSED";
        adder1_direction: string  := "UNUSED";
        adder3_direction: string  := "UNUSED";
        width_data_in_msb: vl_notype;
        width_data_out_msb: vl_notype;
        width_chainin_msb: vl_notype;
        width_systolic_ext: vl_notype;
        width_systolic_ext_msb: vl_notype;
        input_ext_width : vl_notype
    );
    port(
        data_in_0       : in     vl_logic_vector;
        data_in_1       : in     vl_logic_vector;
        data_in_2       : in     vl_logic_vector;
        data_in_3       : in     vl_logic_vector;
        chainin         : in     vl_logic_vector;
        clock           : in     vl_logic_vector(3 downto 0);
        aclr            : in     vl_logic_vector(3 downto 0);
        ena             : in     vl_logic_vector(3 downto 0);
        data_out        : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width_data_in : constant is 1;
    attribute mti_svvh_generic_type of width_chainin : constant is 1;
    attribute mti_svvh_generic_type of width_data_out : constant is 1;
    attribute mti_svvh_generic_type of number_of_adder_input : constant is 1;
    attribute mti_svvh_generic_type of systolic_delay1 : constant is 1;
    attribute mti_svvh_generic_type of systolic_aclr1 : constant is 1;
    attribute mti_svvh_generic_type of systolic_delay3 : constant is 1;
    attribute mti_svvh_generic_type of systolic_aclr3 : constant is 1;
    attribute mti_svvh_generic_type of adder1_direction : constant is 1;
    attribute mti_svvh_generic_type of adder3_direction : constant is 1;
    attribute mti_svvh_generic_type of width_data_in_msb : constant is 3;
    attribute mti_svvh_generic_type of width_data_out_msb : constant is 3;
    attribute mti_svvh_generic_type of width_chainin_msb : constant is 3;
    attribute mti_svvh_generic_type of width_systolic_ext : constant is 3;
    attribute mti_svvh_generic_type of width_systolic_ext_msb : constant is 3;
    attribute mti_svvh_generic_type of input_ext_width : constant is 3;
end ama_systolic_adder_function;
