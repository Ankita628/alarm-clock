module alarm_clock_top(clock,
	               key,
		       reset,
		       time_button,
		       alarm_button,
		       fastwatch,
		       ms_hr,
		       ls_hr,
		       ms_min,
		       ls_min,
		       alarm_sound);


input [3:0]key;
input clock,reset,time_button,alarm_button,fastwatch;
output [7:0]ms_hr,ls_hr,ms_min,ls_min;
output alarm_sound;

wire one_minute,one_second,reset_count,load_new_a,show_a,show_new_time,load_new_c,shift;
wire [3:0]key_buffer_ls_min,key_buffer_ms_min,key_buffer_ls_hr,key_buffer_ms_hr,key;
wire [3:0]alarm_time_ms_hr,alarm_time_ls_hr,alarm_time_ms_min,alarm_time_ls_min;
wire [3:0]current_time_ms_hr,current_time_ls_hr,current_time_ms_min,current_time_ls_min;

time_generator tim_gen(clock,reset,reset_count,fastwatch,one_minute,one_second);

fsm fsm_dut(clock,
            reset,
            one_second,
            time_button,
            alarm_button,
            key,
            reset_count,
            load_new_a,
            show_a,
            show_new_time,              
            load_new_c,              
            shift);
counter counter_dut(clock,
	        reset,
		one_minute,
		load_new_c,
		key_buffer_ms_hr,
		key_buffer_ms_min,
		key_buffer_ls_hr,
		key_buffer_ls_min,
		current_time_ms_hr,
		current_time_ms_min,
		current_time_ls_hr,
		current_time_ls_min);

keyreg key_dut(reset,
              clock,
              shift,
              key,
              key_buffer_ls_min,
              key_buffer_ms_min,
              key_buffer_ls_hr,
              key_buffer_ms_hr);
              
alarm_reg alarm_dut(key_buffer_ms_hr,
              key_buffer_ls_hr,
              key_buffer_ms_min,
              key_buffer_ls_min,
              load_new_a,
              clock,
              reset,
              alarm_time_ms_hr,
              alarm_time_ls_hr,
              alarm_time_ms_min,
              alarm_time_ls_min );

lcd_driver_4 lcd( alarm_time_ms_hr,
                      alarm_time_ls_hr,
                      alarm_time_ms_min,
                      alarm_time_ls_min,
                      current_time_ms_hr,
                      current_time_ls_hr,
                      current_time_ms_min,
                      current_time_ls_min,
                      key_buffer_ms_hr,
                      key_buffer_ls_hr,
                      key_buffer_ms_min,
                      key_buffer_ls_min,
                      show_a,
                      show_new_time,
                      ms_hr,
                      ls_hr,
                      ms_min,
                      ls_min,
                      alarm_sound);
endmodule


		   

