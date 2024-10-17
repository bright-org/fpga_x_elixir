

`timescale 1ns / 1ps
`default_nettype none


module eval_exp_fp32_128_main
        #(
            parameter               DEVICE      = "ULTRASCALE_PLUS"            ,
            parameter               SIMULATION  = "false"                      ,
            parameter               DEBUG       = "false"                       
        )
        (
            output var logic fan_en 
        );
    


    // -------------------------------------
    //  Zynq Core
    // -------------------------------------

    localparam AXI4L_PERI_ADDR_BITS = 40    ;
    localparam AXI4L_PERI_DATA_BITS = 64    ;

    localparam AXI4_MEM_ID_BITS     = 6     ;
    localparam AXI4_MEM_ADDR_BITS   = 49    ;
    localparam AXI4_MEM_DATA_BITS   = 128   ;


    logic       axi4l_peri_aresetn  ;
    logic       axi4l_peri_aclk     ;

    jelly3_axi4l_if
            #(
                .ADDR_BITS      (AXI4L_PERI_ADDR_BITS   ),
                .DATA_BITS      (AXI4L_PERI_DATA_BITS   )
            )
        axi4l_peri
            (
                .aresetn        (axi4l_peri_aresetn     ),
                .aclk           (axi4l_peri_aclk        ),
                .aclken         (1'b1                   )
            );


    logic   axi4_mem_aresetn    ;
    logic   axi4_mem_aclk       ;

    jelly3_axi4_if
            #(
                .ID_BITS        (AXI4_MEM_ID_BITS   ),
                .ADDR_BITS      (AXI4_MEM_ADDR_BITS ),
                .DATA_BITS      (AXI4_MEM_DATA_BITS )
            )
        axi4_mem
            (
                .aresetn        (axi4_mem_aresetn   ),
                .aclk           (axi4_mem_aclk      ),
                .aclken         (1'b1               )
            );

    design_1
        u_design_1
            (
                .fan_en                 ,

                .m_axi4l_peri_aresetn   (axi4l_peri_aresetn ),
                .m_axi4l_peri_aclk      (axi4l_peri_aclk    ),
                .m_axi4l_peri_araddr    (axi4l_peri.araddr  ),
                .m_axi4l_peri_arprot    (axi4l_peri.arprot  ),
                .m_axi4l_peri_arready   (axi4l_peri.arready ),
                .m_axi4l_peri_arvalid   (axi4l_peri.arvalid ),
                .m_axi4l_peri_awaddr    (axi4l_peri.awaddr  ),
                .m_axi4l_peri_awprot    (axi4l_peri.awprot  ),
                .m_axi4l_peri_awready   (axi4l_peri.awready ),
                .m_axi4l_peri_awvalid   (axi4l_peri.awvalid ),
                .m_axi4l_peri_bready    (axi4l_peri.bready  ),
                .m_axi4l_peri_bresp     (axi4l_peri.bresp   ),
                .m_axi4l_peri_bvalid    (axi4l_peri.bvalid  ),
                .m_axi4l_peri_rdata     (axi4l_peri.rdata   ),
                .m_axi4l_peri_rready    (axi4l_peri.rready  ),
                .m_axi4l_peri_rresp     (axi4l_peri.rresp   ),
                .m_axi4l_peri_rvalid    (axi4l_peri.rvalid  ),
                .m_axi4l_peri_wdata     (axi4l_peri.wdata   ),
                .m_axi4l_peri_wready    (axi4l_peri.wready  ),
                .m_axi4l_peri_wstrb     (axi4l_peri.wstrb   ),
                .m_axi4l_peri_wvalid    (axi4l_peri.wvalid  ),
                
                .s_axi4_mem_aresetn     (axi4_mem_aresetn   ),
                .s_axi4_mem_aclk        (axi4_mem_aclk      ),
                .s_axi4_mem_araddr      (axi4_mem.araddr    ),
                .s_axi4_mem_arburst     (axi4_mem.arburst   ),
                .s_axi4_mem_arcache     (axi4_mem.arcache   ),
                .s_axi4_mem_arid        (axi4_mem.arid      ),
                .s_axi4_mem_arlen       (axi4_mem.arlen     ),
                .s_axi4_mem_arlock      (axi4_mem.arlock    ),
                .s_axi4_mem_arprot      (axi4_mem.arprot    ),
                .s_axi4_mem_arqos       (axi4_mem.arqos     ),
                .s_axi4_mem_arready     (axi4_mem.arready   ),
                .s_axi4_mem_arsize      (axi4_mem.arsize    ),
                .s_axi4_mem_aruser      (axi4_mem.aruser    ),
                .s_axi4_mem_arvalid     (axi4_mem.arvalid   ),
                .s_axi4_mem_awaddr      (axi4_mem.awaddr    ),
                .s_axi4_mem_awburst     (axi4_mem.awburst   ),
                .s_axi4_mem_awcache     (axi4_mem.awcache   ),
                .s_axi4_mem_awid        (axi4_mem.awid      ),
                .s_axi4_mem_awlen       (axi4_mem.awlen     ),
                .s_axi4_mem_awlock      (axi4_mem.awlock    ),
                .s_axi4_mem_awprot      (axi4_mem.awprot    ),
                .s_axi4_mem_awqos       (axi4_mem.awqos     ),
                .s_axi4_mem_awready     (axi4_mem.awready   ),
                .s_axi4_mem_awsize      (axi4_mem.awsize    ),
                .s_axi4_mem_awuser      (axi4_mem.awuser    ),
                .s_axi4_mem_awvalid     (axi4_mem.awvalid   ),
                .s_axi4_mem_bid         (axi4_mem.bid       ),
                .s_axi4_mem_bready      (axi4_mem.bready    ),
                .s_axi4_mem_bresp       (axi4_mem.bresp     ),
                .s_axi4_mem_bvalid      (axi4_mem.bvalid    ),
                .s_axi4_mem_rdata       (axi4_mem.rdata     ),
                .s_axi4_mem_rid         (axi4_mem.rid       ),
                .s_axi4_mem_rlast       (axi4_mem.rlast     ),
                .s_axi4_mem_rready      (axi4_mem.rready    ),
                .s_axi4_mem_rresp       (axi4_mem.rresp     ),
                .s_axi4_mem_rvalid      (axi4_mem.rvalid    ),
                .s_axi4_mem_wdata       (axi4_mem.wdata     ),
                .s_axi4_mem_wlast       (axi4_mem.wlast     ),
                .s_axi4_mem_wready      (axi4_mem.wready    ),
                .s_axi4_mem_wstrb       (axi4_mem.wstrb     ),
                .s_axi4_mem_wvalid      (axi4_mem.wvalid    )
        );
    

    // ----------------------------------------
    //  Address decoder
    // ----------------------------------------

    localparam DEC_DMAR  = 0;
    localparam DEC_DMAW  = 1;
    localparam DEC_NUM   = 2;

    jelly3_axi4l_if
            #(
                .ADDR_BITS      (AXI4L_PERI_ADDR_BITS),
                .DATA_BITS      (AXI4L_PERI_DATA_BITS)
            )
        axi4l_dec [DEC_NUM]
            (
                .aresetn        (axi4l_peri_aresetn  ),
                .aclk           (axi4l_peri_aclk     ),
                .aclken         (1'b1                )
            );
    
    // address map
    assign {axi4l_dec[DEC_DMAR].addr_base, axi4l_dec[DEC_DMAR].addr_high} = {40'ha000_0000, 40'ha000_ffff};
    assign {axi4l_dec[DEC_DMAW].addr_base, axi4l_dec[DEC_DMAW].addr_high} = {40'ha010_0000, 40'ha010_ffff};

    jelly3_axi4l_addr_decoder
            #(
                .NUM            (DEC_NUM    ),
                .DEC_ADDR_BITS  (28         )
            )
        u_axi4l_addr_decoder
            (
                .s_axi4l        (axi4l_peri   ),
                .m_axi4l        (axi4l_dec    )
            );



    // -------------------------------------
    //  DMA read
    // -------------------------------------

    jelly3_axi4s_if
            #(
                .USE_LAST       (0                  ),  
                .DATA_BITS      (AXI4_MEM_DATA_BITS )
            )
        axi4s_read
            (
                .aresetn        (axi4_mem_aresetn   ),
                .aclk           (axi4_mem_aclk      ),
                .aclken         (1'b1               )
            );

    dma_read
            #(
                .AXI4L_ASYNC            (0                  ),
                .AXI4S_ASYNC            (0                  ),
                .ARFIFO_PTR_BITS        (5                  ),
                .RFIFO_PTR_BITS         (8                  ),
                .ID_BITS                (AXI4_MEM_ID_BITS   ),
                .ADDR_BITS              (AXI4_MEM_ADDR_BITS ),
                .DATA_BITS              (AXI4_MEM_DATA_BITS ),
                .DEVICE                 (DEVICE             ),
                .SIMULATION             (SIMULATION         ),
                .DEBUG                  (DEBUG              )
            )
        u_dma_read
            (
                .s_axi4l                (axi4l_dec[DEC_DMAR]),
                .m_axi4                 (axi4_mem.mr        ),
                .m_axi4s                (axi4s_read.m       )
            );


    // -------------------------------------
    //  DMA write
    // -------------------------------------

    jelly3_axi4s_if
            #(
                .USE_LAST       (0                  ),  
                .DATA_BITS      (AXI4_MEM_DATA_BITS )
            )
        axi4s_write
            (
                .aresetn        (axi4_mem_aresetn   ),
                .aclk           (axi4_mem_aclk      ),
                .aclken         (1'b1               )
            );
    
    dma_write
            #(
                .AXI4L_ASYNC            (0                  ),
                .AXI4S_ASYNC            (0                  ),
                .AWFIFO_PTR_BITS        (5                  ),
                .WFIFO_PTR_BITS         (8                  ),
                .ID_BITS                (AXI4_MEM_ID_BITS   ),
                .ADDR_BITS              (AXI4_MEM_ADDR_BITS ),
                .DATA_BITS              (AXI4_MEM_DATA_BITS ),
                .DEVICE                 (DEVICE             ),
                .SIMULATION             (SIMULATION         ),
                .DEBUG                  (DEBUG              )
            )
        u_dma_write
            (
                .s_axi4l                (axi4l_dec[DEC_DMAW]),
                .s_axi4s                (axi4s_write.s      ),
                .m_axi4                 (axi4_mem.mw        )
            );


    // -------------------------------------
    //  Calc Core
    // -------------------------------------

    calc_exp_f32
            #(
                .DEVICE                 (DEVICE             ),
                .SIMULATION             (SIMULATION         ),
                .DEBUG                  (DEBUG              )
            )
        u_calc_exp_f32
            (
                .s_axi4s                (axi4s_read.s       ),
                .m_axi4s                (axi4s_write.m      )
            );

endmodule


`default_nettype wire


// end of file
