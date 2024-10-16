

`timescale 1ns / 1ps
`default_nettype none


module calc_exp_f32
        #(
            parameter               DEVICE      = "RTL"                        ,
            parameter               SIMULATION  = "false"                      ,
            parameter               DEBUG       = "false"                       
        )
        (
            jelly3_axi4s_if.s    s_axi4s,
            jelly3_axi4s_if.m    m_axi4s
        );

    logic  aclken    ;
    assign aclken = !m_axi4s.tvalid || m_axi4s.tready;

    logic [3:0]  tvalid;
    for ( genvar i = 0; i < 4; i++ ) begin : exp
        exponential_fp32
            u_exponential_fp32_0
                (
                    .aclk                   (m_axi4s.aclk               ),
                    .aclken                 (aclken                     ),

                    .s_axis_a_tdata         (s_axi4s.tdata[32*i +: 32]  ),
                    .s_axis_a_tvalid        (s_axi4s.tvalid             ),
                    
                    .m_axis_result_tdata    (m_axi4s.tdata[32*i +: 32]  ),
                    .m_axis_result_tvalid   (tvalid[i]                  )
                );
    end

    assign s_axi4s.tready = aclken;
    assign m_axi4s.tvalid = tvalid[0];

endmodule


`default_nettype wire


// end of file
