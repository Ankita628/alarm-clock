module time_generator(clk,reset,reset_count,fastwatch,one_minute,one_second);
  input clk,reset,fastwatch,reset_count;
  output reg one_minute,one_second;
  integer count1,count2;
  reg one_min_reg;
  always@(posedge clk or posedge reset)  //one second pulse
  begin
    if(reset)
      begin
        count1<=0;
        one_second<=0;
    end
  else if(reset_count)
    begin
      
        count1<=0;
        one_second<=0;
    end
    else if(count1=='d255)
      begin 
      one_second<=1;
      count1<=0;
      end
    else begin
      count1<=count1+1;
      one_second<=0;
    end
  end
  

always@(posedge clk or posedge reset)  //one minute pulse
  begin
    if(reset)
      begin
        one_min_reg<=0;
      count2<=0;
   end
  else if(reset_count)
    begin
      
        count2<=0;
        one_min_reg<=0;
    end
    else if(count2=='d15359)
      begin
        count2<=0;
      one_min_reg<=1;
    end
    else 
      begin
      one_min_reg<=0;
      count2<=count2+1;
    end
  end
  
  always@(*)  //fastwatch pulse
  begin
    if(fastwatch) one_minute=one_second;
  else one_minute=one_min_reg;    
  end
 
  
endmodule