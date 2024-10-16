

`timescale 1ns / 1ps
`default_nettype none


module eval_exp_fp32_128_kv260
        #(
            parameter               DEVICE      = "ULTRASCALE_PLUS"            ,
            parameter               SIMULATION  = "false"                      ,
            parameter               DEBUG       = "false"                       
        )
        (
            output var logic fan_en 
        );
    
    eval_exp_fp32_128_main
            #(
                .DEVICE         (DEVICE     ),
                .SIMULATION     (SIMULATION ),
                .DEBUG          (DEBUG      ) 
            )
        u_main
            (
                .fan_en         (fan_en    )
            );

endmodule


`default_nettype wire


// end of file
