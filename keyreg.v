module keyreg(reset,
              clock,
              shift,
              key,
              key_buffer_ls_min,
              key_buffer_ms_min,
              key_buffer_ls_hr,
              key_buffer_ms_hr);
// Define input and output port direction
input reset,clock,shift;
input [3:0]key;
output reg [3:0]key_buffer_ls_min;
 output reg [3:0]key_buffer_ms_min;
              output reg [3:0]key_buffer_ls_hr;
              output reg [3:0]key_buffer_ms_hr;




///////////////////////////////////////////////////////////////////
// This procedure stores the last 4 keys pressed. The FSM block
// detects the new key value and triggers the shift pulse to shift
// in the new key value.
///////////////////////////////////////////////////////////////////


always @(posedge clock or posedge reset)
begin
    
    if(reset) begin
      key_buffer_ls_min<=0;
      key_buffer_ms_min<=0;
      key_buffer_ls_hr<=0;
      key_buffer_ms_hr<=0;
    end
    else if(shift)
      begin
        
      key_buffer_ls_min<=key;
      key_buffer_ms_min<=key_buffer_ls_min;
      key_buffer_ls_hr<=key_buffer_ms_min;
      key_buffer_ms_hr<=key_buffer_ls_hr;
        end
        
        
end
//initial
//$monitor($time,"key=%d  ms_hr=%d  ls_hr=%d  ms_min=%d  ls_min=%d  ",key,key_buffer_ms_hr,key_buffer_ls_hr,key_buffer_ms_min,key_buffer_ls_min);
endmodule
