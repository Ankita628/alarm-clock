module fsm (clock,
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


input clock,reset,one_second,alarm_button,time_button;
input [3:0]key;
output reset_count,load_new_c,show_new_time,show_a,load_new_a,shift;


 
reg [2:0] ps,ns;
// Define internal signal for timeout logic
wire time_out;
// Define registers for counting 10 secs in KEY_ENTRY and KEY_WAITED state
reg [3:0] count1,count2;

//states definition
parameter SHOW_TIME         = 3'b000;
parameter KEY_ENTRY         = 3'b001;
parameter KEY_STORED        = 3'b010; 
parameter SHOW_ALARM        = 3'b011;
parameter SET_ALARM_TIME    = 3'b100;
parameter SET_CURRENT_TIME  = 3'b101;
parameter KEY_WAITED        = 3'b110;
parameter NOKEY             = 10;

//Counts 10 seconds pulses for KEY_ENTRY state
always @ (posedge clock or posedge reset)
begin
  if(reset) 
    count1=0;
  else if(ps!=KEY_ENTRY)
    count1=0;
    else if(count1=='d9)
      count1=0;
      else
        count1=count1+1;
end

//Counts 10 seconds pulses for KEY_WAITED state
always @ (posedge clock or posedge reset)
begin
  if(reset)
    count2=0;
  else if(ps!=KEY_WAITED)
    count2=0;
    else if(count2=='d9)
      count2=0;
      else count2=count2+1;
end

//Time out logic  // Assert time_out signal whenever the count1 or count2 reaches 'd9
assign time_out=(count1=='d9)||(count2=='d9);

//Present state logic 
always @ (posedge clock or posedge reset) 
begin
    if(reset) ps<=0;
    else ps<=ns;
end

//Next state logic 
// Whenever there is a change in input, check for present_state and assign next_state with approriate state
always @ (ps or key or alarm_button or time_button or time_out)
begin
  case(ps)
       // State transition from SHOW_TIME to other state
       SHOW_TIME  : begin
							         if(alarm_button)  ns<=SHOW_ALARM;
							           else if(key!=NOKEY)
							             ns<=KEY_STORED;
							             else
							               ns<=SHOW_TIME;
                    end
       // In KEY_STORED state assign next_state as KEY_WAITED 
       KEY_STORED : ns<=KEY_WAITED;
       // State transition from KEY_WAITED state
       KEY_WAITED : begin
                    if(time_out==1)
                      ns<=SHOW_TIME;
                    else if(key==10)  ns<=KEY_ENTRY;
                      else ns<=KEY_WAITED;
                   
	           end
       // State transition from KEY_ENTRY state
       KEY_ENTRY  : begin
                        if(time_out==1) ns<=SHOW_TIME;
                          else if(key!=10)  ns<=  KEY_STORED;
                            else if(alarm_button) ns<=SET_ALARM_TIME;
                            else if(time_button)  ns<=SET_CURRENT_TIME;
                            else ns<=KEY_ENTRY;
                
                    end
      // State transition from SHOW_ALARM state
      SHOW_ALARM  : begin
                      if(!alarm_button) ns<=SHOW_TIME;
                      else ns<=SHOW_ALARM;  	  
                    end
   // In SET_ALARM_TIME state assign next_state as SHOW_TIME
   SET_ALARM_TIME :  ns<=SHOW_TIME;
   // In SET_ALARM_TIME state assign next_state as SHOW_TIME
   SET_CURRENT_TIME : ns<=SHOW_TIME;
   // Set default state as SHOW_TIME state
          default : ns = SHOW_TIME;

  endcase
end
       
//Moore FSM outputs 
assign reset_count=(ps==SET_CURRENT_TIME)?1:0;
assign load_new_c=(ps==SET_CURRENT_TIME)?1:0;
assign show_new_time=(ps==KEY_ENTRY || ps==KEY_STORED || ps==KEY_WAITED)?1:0;
assign show_a=(ps==SHOW_ALARM)?1:0;
assign load_new_a=(ps==SET_ALARM_TIME)?1:0;
assign shift=(ps==KEY_STORED)?1:0;

endmodule
