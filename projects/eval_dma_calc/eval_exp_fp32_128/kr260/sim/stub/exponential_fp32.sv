

`timescale 1ns / 1ps
`default_nettype none


module exponential_fp32
        (
            input   var logic               aclk                 ,
            input   var logic               aclken               ,

            input   var logic   [31:0]      s_axis_a_tdata       ,
            input   var logic               s_axis_a_tvalid      ,

            output  var logic   [31:0]      m_axis_result_tdata  ,
            output  var logic               m_axis_result_tvalid 
        );

    assign m_axis_result_tdata  = s_axis_a_tdata;
    assign m_axis_result_tvalid = s_axis_a_tvalid;

endmodule


`default_nettype wire


// end of file
