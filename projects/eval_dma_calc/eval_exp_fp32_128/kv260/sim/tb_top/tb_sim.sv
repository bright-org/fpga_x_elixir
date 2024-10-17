

`timescale 1ns / 1ps
`default_nettype none


module tb_sim();
    
    initial begin
        $dumpfile("tb_sim.vcd");
        $dumpvars(0, tb_sim);
        
    #10000000
        $display("timeout");
        $finish;
    end
    
    
    // ---------------------------------
    //  clock & reset
    // ---------------------------------

    localparam RATE333 = 1000.0/333.00;

    logic       reset = 1;
    initial #100 reset = 0;

    logic       clk333 = 1'b1;
    always #(RATE333/2.0) clk333 <= ~clk333;


    
    // ---------------------------------
    //  main
    // ---------------------------------

    //  Peripheral Bus
    jelly3_axi4l_if
            #(
                .ADDR_BITS  (40                     ),
                .DATA_BITS  (64                     )
            )
        axi4l_peri
            (
                .aresetn    (~reset                 ),
                .aclk       (clk333                 ),
                .aclken     (1'b1                   )
            );


    tb_main
        u_tb_main
            (
                .reset                  (reset              ),
                .clk                    (clk333             ),

                .s_axi4l_peri_aresetn   (                   ),
                .s_axi4l_peri_aclk      (                   ),
                .s_axi4l_peri_awaddr    (axi4l_peri.awaddr  ),
                .s_axi4l_peri_awprot    (axi4l_peri.awprot  ),
                .s_axi4l_peri_awvalid   (axi4l_peri.awvalid ),
                .s_axi4l_peri_awready   (axi4l_peri.awready ),
                .s_axi4l_peri_wdata     (axi4l_peri.wdata   ),
                .s_axi4l_peri_wstrb     (axi4l_peri.wstrb   ),
                .s_axi4l_peri_wvalid    (axi4l_peri.wvalid  ),
                .s_axi4l_peri_wready    (axi4l_peri.wready  ),
                .s_axi4l_peri_bresp     (axi4l_peri.bresp   ),
                .s_axi4l_peri_bvalid    (axi4l_peri.bvalid  ),
                .s_axi4l_peri_bready    (axi4l_peri.bready  ),
                .s_axi4l_peri_araddr    (axi4l_peri.araddr  ),
                .s_axi4l_peri_arprot    (axi4l_peri.arprot  ),
                .s_axi4l_peri_arvalid   (axi4l_peri.arvalid ),
                .s_axi4l_peri_arready   (axi4l_peri.arready ),
                .s_axi4l_peri_rdata     (axi4l_peri.rdata   ),
                .s_axi4l_peri_rresp     (axi4l_peri.rresp   ),
                .s_axi4l_peri_rvalid    (axi4l_peri.rvalid  ),
                .s_axi4l_peri_rready    (axi4l_peri.rready  )
            );
    

    // ----------------------------------
    //  Peripheral bus master
    // ----------------------------------

    jelly3_axi4l_accessor
            #(
                .RAND_RATE_AW   (0),
                .RAND_RATE_W    (0),
                .RAND_RATE_B    (0),
                .RAND_RATE_AR   (0),
                .RAND_RATE_R    (0)
            )
        u_axi4l_accessor
            (
                .m_axi4l        (axi4l_peri.m)
            );

    localparam  type  adr_t = logic [axi4l_peri.ADDR_BITS-1:0];

    localparam  adr_t   ADR_DMAR = adr_t'('ha000_0000);
    localparam  adr_t   ADR_DMAW = adr_t'('ha010_0000);

    localparam  int     REG_DMAR_CORE_ID             = 'h00;
    localparam  int     REG_DMAR_PARAM_ARID          = 'h10;
    localparam  int     REG_DMAR_PARAM_ARADDR        = 'h11;
    localparam  int     REG_DMAR_PARAM_ARLEN         = 'h12;
    localparam  int     REG_DMAR_PARAM_ARSIZE        = 'h13;
    localparam  int     REG_DMAR_PARAM_ARBURST       = 'h14;
    localparam  int     REG_DMAR_PARAM_ARLOCK        = 'h15;
    localparam  int     REG_DMAR_PARAM_ARCACHE       = 'h16;
    localparam  int     REG_DMAR_PARAM_ARPROT        = 'h17;
    localparam  int     REG_DMAR_PARAM_ARQOS         = 'h18;
    localparam  int     REG_DMAR_PARAM_ARREGION      = 'h19;

    localparam  int     REG_DMAW_CORE_ID             = 'h00;
    localparam  int     REG_DMAW_CTL_STATUS          = 'h08;
    localparam  int     REG_DMAW_CTL_ISSUE_CNT       = 'h09;
    localparam  int     REG_DMAW_PARAM_AWID          = 'h10;
    localparam  int     REG_DMAW_PARAM_AWADDR        = 'h11;
    localparam  int     REG_DMAW_PARAM_AWLEN         = 'h12;
    localparam  int     REG_DMAW_PARAM_AWSIZE        = 'h13;
    localparam  int     REG_DMAW_PARAM_AWBURST       = 'h14;
    localparam  int     REG_DMAW_PARAM_AWLOCK        = 'h15;
    localparam  int     REG_DMAW_PARAM_AWCACHE       = 'h16;
    localparam  int     REG_DMAW_PARAM_AWPROT        = 'h17;
    localparam  int     REG_DMAW_PARAM_AWQOS         = 'h18;
    localparam  int     REG_DMAW_PARAM_AWREGION      = 'h19;

    initial begin
        automatic   logic   [63:0]  rdata;

    #1000;
        $display("mem read test");
        u_axi4l_accessor.read_reg(ADR_DMAR, REG_DMAR_CORE_ID, rdata);
        u_axi4l_accessor.read_reg(ADR_DMAW, REG_DMAW_CORE_ID, rdata);

        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARLEN,  64'h0f, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h100, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARLEN,  64'hff, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h1000, 8'hff);
//      u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARLEN,  64'hff, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h2000, 8'hff);

        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAR, REG_DMAR_PARAM_ARADDR, 64'h2000, 8'hff);

        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWLEN,  64'h0f, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h100, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWLEN,  64'hff, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h1000, 8'hff);
//      u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWLEN,  64'hff, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h2000, 8'hff);

        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h2000, 8'hff);
        u_axi4l_accessor.write_reg(ADR_DMAW, REG_DMAW_PARAM_AWADDR, 64'h2000, 8'hff);

        u_axi4l_accessor.read_reg(ADR_DMAR, REG_DMAW_CTL_ISSUE_CNT, rdata);

        u_axi4l_accessor.read_reg(ADR_DMAW, REG_DMAW_CTL_ISSUE_CNT, rdata);
        while ( rdata != 0 ) begin
            #1000;
            u_axi4l_accessor.read_reg(ADR_DMAW, REG_DMAW_CTL_ISSUE_CNT, rdata);
        end

    #10000;
        $display("end");
        $finish;
    end
    
endmodule


`default_nettype wire


// end of file
