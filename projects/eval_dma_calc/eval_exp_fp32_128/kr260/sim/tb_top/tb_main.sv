

`timescale 1ns / 1ps
`default_nettype none


// 以降は Verilator で C++ のテストドライバも使えるように時間待ちを書かない
module tb_main
        #(
            parameter   int     AXI4L_PERI_ADDR_WIDTH = 40                          ,
            parameter   int     AXI4L_PERI_DATA_WIDTH = 64                          ,
            parameter   int     AXI4L_PERI_STRB_WIDTH = AXI4L_PERI_DATA_WIDTH / 8   ,
            parameter           DEVICE      = "ULTRASCALE_PLUS"                     ,
            parameter           SIMULATION  = "false"                               ,
            parameter           DEBUG       = "false"                                
 
        )
        (
            input   var logic                                   reset                   ,
            input   var logic                                   clk                     ,

            output  var logic                                   s_axi4l_peri_aresetn    ,
            output  var logic                                   s_axi4l_peri_aclk       ,
            input   var logic   [AXI4L_PERI_ADDR_WIDTH-1:0]     s_axi4l_peri_awaddr     ,
            input   var logic   [2:0]                           s_axi4l_peri_awprot     ,
            input   var logic                                   s_axi4l_peri_awvalid    ,
            output  var logic                                   s_axi4l_peri_awready    ,
            input   var logic   [AXI4L_PERI_DATA_WIDTH-1:0]     s_axi4l_peri_wdata      ,
            input   var logic   [AXI4L_PERI_STRB_WIDTH-1:0]     s_axi4l_peri_wstrb      ,
            input   var logic                                   s_axi4l_peri_wvalid     ,
            output  var logic                                   s_axi4l_peri_wready     ,
            output  var logic   [1:0]                           s_axi4l_peri_bresp      ,
            output  var logic                                   s_axi4l_peri_bvalid     ,
            input   var logic                                   s_axi4l_peri_bready     ,
            input   var logic   [AXI4L_PERI_ADDR_WIDTH-1:0]     s_axi4l_peri_araddr     ,
            input   var logic   [2:0]                           s_axi4l_peri_arprot     ,
            input   var logic                                   s_axi4l_peri_arvalid    ,
            output  var logic                                   s_axi4l_peri_arready    ,
            output  var logic   [AXI4L_PERI_DATA_WIDTH-1:0]     s_axi4l_peri_rdata      ,
            output  var logic   [1:0]                           s_axi4l_peri_rresp      ,
            output  var logic                                   s_axi4l_peri_rvalid     ,
            input   var logic                                   s_axi4l_peri_rready     
        );

    // -----------------------------------------
    //  top
    // -----------------------------------------
    
    eval_exp_fp32_128_kr260
        u_top
            (
                .fan_en     ()
            );
    
    // Zynq のスタブの中にクロックとバスアクセスを接続 (Verilator 対策で always_comb)
    always_comb force u_top.u_main.u_design_1.reset  = reset   ;
    always_comb force u_top.u_main.u_design_1.clk    = clk     ;

    always_comb force u_top.u_main.u_design_1.axi4l_peri_awaddr  = s_axi4l_peri_awaddr   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_awprot  = s_axi4l_peri_awprot   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_awvalid = s_axi4l_peri_awvalid  ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_wdata   = s_axi4l_peri_wdata    ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_wstrb   = s_axi4l_peri_wstrb    ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_wvalid  = s_axi4l_peri_wvalid   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_bready  = s_axi4l_peri_bready   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_araddr  = s_axi4l_peri_araddr   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_arprot  = s_axi4l_peri_arprot   ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_arvalid = s_axi4l_peri_arvalid  ;
    always_comb force u_top.u_main.u_design_1.axi4l_peri_rready  = s_axi4l_peri_rready   ;

    assign s_axi4l_peri_aresetn = u_top.u_main.u_design_1.m_axi4l_peri_aresetn    ;
    assign s_axi4l_peri_aclk    = u_top.u_main.u_design_1.m_axi4l_peri_aclk       ;
    assign s_axi4l_peri_awready = u_top.u_main.u_design_1.m_axi4l_peri_awready    ;
    assign s_axi4l_peri_wready  = u_top.u_main.u_design_1.m_axi4l_peri_wready     ;
    assign s_axi4l_peri_bresp   = u_top.u_main.u_design_1.m_axi4l_peri_bresp      ;
    assign s_axi4l_peri_bvalid  = u_top.u_main.u_design_1.m_axi4l_peri_bvalid     ;
    assign s_axi4l_peri_arready = u_top.u_main.u_design_1.m_axi4l_peri_arready    ;
    assign s_axi4l_peri_rdata   = u_top.u_main.u_design_1.m_axi4l_peri_rdata      ;
    assign s_axi4l_peri_rresp   = u_top.u_main.u_design_1.m_axi4l_peri_rresp      ;
    assign s_axi4l_peri_rvalid  = u_top.u_main.u_design_1.m_axi4l_peri_rvalid     ;
   

endmodule


`default_nettype wire


// end of file
