

`timescale 1ns / 1ps
`default_nettype none


module dma_read
        #(
            parameter   bit         AXI4L_ASYNC         = 0                         ,
            parameter   bit         AXI4S_ASYNC         = 0                         ,
            parameter   int         ARFIFO_PTR_BITS     = 8                         ,
            parameter   int         RFIFO_PTR_BITS      = 8                         ,
            parameter   int         ID_BITS             = 8                         ,
            parameter   int         ADDR_BITS           = 32                        ,
            parameter   int         DATA_BITS           = 128                       ,
            parameter   int         BYTE_BITS           = 8                         ,
            parameter   int         STRB_BITS           = DATA_BITS / BYTE_BITS     ,
            parameter   int         LEN_BITS            = 8                         ,
            parameter   int         SIZE_BITS           = 3                         ,
            parameter   int         BURST_BITS          = 2                         ,
            parameter   int         LOCK_BITS           = 1                         ,
            parameter   int         CACHE_BITS          = 4                         ,
            parameter   int         PROT_BITS           = 3                         ,
            parameter   int         QOS_BITS            = 4                         ,
            parameter   int         REGION_BITS         = 4                         ,
            parameter   int         RESP_BITS           = 2                         ,
            parameter   type        id_t                = logic [ID_BITS    -1:0]   ,
            parameter   type        addr_t              = logic [ADDR_BITS  -1:0]   ,
            parameter   type        len_t               = logic [LEN_BITS   -1:0]   ,
            parameter   type        size_t              = logic [SIZE_BITS  -1:0]   ,
            parameter   type        burst_t             = logic [BURST_BITS -1:0]   ,
            parameter   type        lock_t              = logic [LOCK_BITS  -1:0]   ,
            parameter   type        cache_t             = logic [CACHE_BITS -1:0]   ,
            parameter   type        prot_t              = logic [PROT_BITS  -1:0]   ,
            parameter   type        qos_t               = logic [QOS_BITS   -1:0]   ,
            parameter   type        region_t            = logic [REGION_BITS-1:0]   ,
            parameter   type        data_t              = logic [DATA_BITS  -1:0]   ,
            parameter   type        strb_t              = logic [STRB_BITS  -1:0]   ,
            parameter   type        resp_t              = logic [RESP_BITS  -1:0]   ,
            parameter   int         REGADR_BITS         = 8                         ,
            parameter   type        regadr_t            = logic [REGADR_BITS-1:0]   ,
            parameter   id_t        INIT_PARAM_ARID     = '0,
            parameter   addr_t      INIT_PARAM_ARADDR   = '0,
            parameter   len_t       INIT_PARAM_ARLEN    = '0,
            parameter   size_t      INIT_PARAM_ARSIZE   = size_t'($clog2(DATA_BITS/8)),
            parameter   burst_t     INIT_PARAM_ARBURST  = 2'b01,
            parameter   lock_t      INIT_PARAM_ARLOCK   = '0,
            parameter   cache_t     INIT_PARAM_ARCACHE  = '0,
            parameter   prot_t      INIT_PARAM_ARPROT   = '0,
            parameter   qos_t       INIT_PARAM_ARQOS    = '0,
            parameter   region_t    INIT_PARAM_ARREGION = '0,
            parameter               DEVICE      = "RTL"                        ,
            parameter               SIMULATION  = "false"                      ,
            parameter               DEBUG       = "false"                       
        )
        (

            jelly3_axi4l_if.s                   s_axi4l,
            jelly3_axi4_if.mr                   m_axi4,
            jelly3_axi4s_if.m                   m_axi4s
        );

    // -------------------------------------
    //  localparam
    // -------------------------------------

    localparam type axi4s_data_t = logic [m_axi4s.DATA_BITS-1:0];
    localparam type axi4l_data_t = logic [s_axi4l.DATA_BITS-1:0];

    // -------------------------------------
    //  signals
    // -------------------------------------
    

    logic       fifo_arvalid    ;
    logic       fifo_arready    ;


    // -------------------------------------
    //  registers
    // -------------------------------------
    
    // register address offset
    
    localparam  regadr_t REGADR_CORE_ID             = regadr_t'('h00);
    localparam  regadr_t REGADR_CTL_STATUS          = regadr_t'('h08);
    localparam  regadr_t REGADR_PARAM_ARID          = regadr_t'('h10);
    localparam  regadr_t REGADR_PARAM_ARADDR        = regadr_t'('h11);
    localparam  regadr_t REGADR_PARAM_ARLEN         = regadr_t'('h12);
    localparam  regadr_t REGADR_PARAM_ARSIZE        = regadr_t'('h13);
    localparam  regadr_t REGADR_PARAM_ARBURST       = regadr_t'('h14);
    localparam  regadr_t REGADR_PARAM_ARLOCK        = regadr_t'('h15);
    localparam  regadr_t REGADR_PARAM_ARCACHE       = regadr_t'('h16);
    localparam  regadr_t REGADR_PARAM_ARPROT        = regadr_t'('h17);
    localparam  regadr_t REGADR_PARAM_ARQOS         = regadr_t'('h18);
    localparam  regadr_t REGADR_PARAM_ARREGION      = regadr_t'('h19);
    
    // registers
    logic           reg_ctl_arvalid     ;
    id_t            reg_param_arid      ;
    addr_t          reg_param_araddr    ;
    len_t           reg_param_arlen     ;
    size_t          reg_param_arsize    ;
    burst_t         reg_param_arburst   ;
    lock_t          reg_param_arlock    ;
    cache_t         reg_param_arcache   ;
    prot_t          reg_param_arprot    ;
    qos_t           reg_param_arqos     ;
    region_t        reg_param_arregion  ;

    function [s_axi4l.DATA_BITS-1:0] write_mask(
                                        input [s_axi4l.DATA_BITS-1:0] org,
                                        input [s_axi4l.DATA_BITS-1:0] data,
                                        input [s_axi4l.STRB_BITS-1:0] strb
                                    );
        for ( int i = 0; i < s_axi4l.DATA_BITS; i++ ) begin
            write_mask[i] = strb[i/8] ? data[i] : org[i];
        end
    endfunction

    regadr_t  regadr_write;
    regadr_t  regadr_read;
    assign regadr_write = regadr_t'(s_axi4l.awaddr / s_axi4l.ADDR_BITS'(s_axi4l.STRB_BITS));
    assign regadr_read  = regadr_t'(s_axi4l.araddr / s_axi4l.ADDR_BITS'(s_axi4l.STRB_BITS));

    always_ff @(posedge s_axi4l.aclk) begin
        if ( ~s_axi4l.aresetn ) begin
            reg_ctl_arvalid     <= 1'b0;
            reg_param_arid      <= INIT_PARAM_ARID      ;
            reg_param_araddr    <= INIT_PARAM_ARADDR    ;
            reg_param_arlen     <= INIT_PARAM_ARLEN     ;
            reg_param_arsize    <= INIT_PARAM_ARSIZE    ;
            reg_param_arburst   <= INIT_PARAM_ARBURST   ;
            reg_param_arlock    <= INIT_PARAM_ARLOCK    ;
            reg_param_arcache   <= INIT_PARAM_ARCACHE   ;
            reg_param_arprot    <= INIT_PARAM_ARPROT    ;
            reg_param_arqos     <= INIT_PARAM_ARQOS     ;
            reg_param_arregion  <= INIT_PARAM_ARREGION  ;
        end
        else if ( s_axi4l.aclken) begin
            if ( fifo_arready ) begin
                reg_ctl_arvalid <= 1'b0;
            end

            if ( s_axi4l.awvalid && s_axi4l.awready && s_axi4l.wvalid && s_axi4l.wready ) begin
                case ( regadr_write )
                REGADR_PARAM_ARID       :  begin reg_param_arid     <=     id_t'(write_mask(axi4l_data_t'(reg_param_arid    ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARADDR     :  begin reg_param_araddr   <=   addr_t'(write_mask(axi4l_data_t'(reg_param_araddr  ), s_axi4l.wdata, s_axi4l.wstrb)); reg_ctl_arvalid <= 1'b1; end
                REGADR_PARAM_ARLEN      :  begin reg_param_arlen    <=    len_t'(write_mask(axi4l_data_t'(reg_param_arlen   ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARSIZE     :  begin reg_param_arsize   <=   size_t'(write_mask(axi4l_data_t'(reg_param_arsize  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARBURST    :  begin reg_param_arburst  <=  burst_t'(write_mask(axi4l_data_t'(reg_param_arburst ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARLOCK     :  begin reg_param_arlock   <=   lock_t'(write_mask(axi4l_data_t'(reg_param_arlock  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARCACHE    :  begin reg_param_arcache  <=  cache_t'(write_mask(axi4l_data_t'(reg_param_arcache ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARPROT     :  begin reg_param_arprot   <=   prot_t'(write_mask(axi4l_data_t'(reg_param_arprot  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARQOS      :  begin reg_param_arqos    <=    qos_t'(write_mask(axi4l_data_t'(reg_param_arqos   ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_ARREGION   :  begin reg_param_arregion <= region_t'(write_mask(axi4l_data_t'(reg_param_arregion), s_axi4l.wdata, s_axi4l.wstrb)); end
                default: ;
                endcase
            end
        end
    end

    always_ff @(posedge s_axi4l.aclk ) begin
        if ( ~s_axi4l.aresetn ) begin
            s_axi4l.bvalid <= 0;
        end
        else if ( s_axi4l.aclken) begin
            if ( s_axi4l.bready ) begin
                s_axi4l.bvalid <= 0;
            end
            if ( s_axi4l.awvalid && s_axi4l.awready ) begin
                s_axi4l.bvalid <= 1'b1;
            end
        end
    end

    assign s_axi4l.awready = (~s_axi4l.bvalid || s_axi4l.bready) && s_axi4l.wvalid;
    assign s_axi4l.wready  = (~s_axi4l.bvalid || s_axi4l.bready) && s_axi4l.awvalid;
    assign s_axi4l.bresp   = '0;


    // read
    always_ff @(posedge s_axi4l.aclk ) begin
        if ( s_axi4l.aclken) begin
            if ( s_axi4l.arvalid && s_axi4l.arready ) begin
                case ( regadr_read )
                REGADR_CORE_ID          :   s_axi4l.rdata <= axi4l_data_t'(32'haa550002); 
                REGADR_CTL_STATUS       :   s_axi4l.rdata <= axi4l_data_t'(reg_ctl_arvalid   );
                REGADR_PARAM_ARID       :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arid    );
                REGADR_PARAM_ARADDR     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_araddr  );
                REGADR_PARAM_ARLEN      :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arlen   );
                REGADR_PARAM_ARSIZE     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arsize  );
                REGADR_PARAM_ARBURST    :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arburst );
                REGADR_PARAM_ARLOCK     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arlock  );
                REGADR_PARAM_ARCACHE    :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arcache );
                REGADR_PARAM_ARPROT     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arprot  );
                REGADR_PARAM_ARQOS      :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arqos   );
                REGADR_PARAM_ARREGION   :   s_axi4l.rdata <= axi4l_data_t'(reg_param_arregion);
                default                 :   s_axi4l.rdata <= '0;
                endcase
            end
        end
    end

    logic           axi4l_rvalid;
    always_ff @(posedge s_axi4l.aclk ) begin
        if ( ~s_axi4l.aresetn ) begin
            s_axi4l.rvalid <= 1'b0;
        end
        else if ( s_axi4l.aclken) begin
            if ( s_axi4l.rready ) begin
                s_axi4l.rvalid <= 1'b0;
            end
            if ( s_axi4l.arvalid && s_axi4l.arready ) begin
                s_axi4l.rvalid <= 1'b1;
            end
        end
    end

    assign s_axi4l.arready = ~s_axi4l.rvalid || s_axi4l.rready;
    assign s_axi4l.rresp   = '0;
    
    assign fifo_arvalid = reg_ctl_arvalid;


    
    // -------------------------------------
    //  core
    // -------------------------------------
    
    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4L_ASYNC        ),
                .DATA_WIDTH     (
                                    $bits(reg_param_arid    ) +
                                    $bits(reg_param_araddr  ) +
                                    $bits(reg_param_arlen   ) +
                                    $bits(reg_param_arsize  ) +
                                    $bits(reg_param_arburst ) +
                                    $bits(reg_param_arlock  ) +
                                    $bits(reg_param_arcache ) +
                                    $bits(reg_param_arprot  ) +
                                    $bits(reg_param_arqos   ) +
                                    $bits(reg_param_arregion)
                                ),
                .PTR_WIDTH      (ARFIFO_PTR_BITS    ),
                .DOUT_REGS      (1                  ),
                .RAM_TYPE       ("distributed"      ),
                .LOW_DEALY      (0                  ),
                .S_REGS         (0                  ),
                .M_REGS         (1                  )
            )
        u_fifo_generic_fwtf_ar
            (
                .s_reset        (~s_axi4l.aresetn   ),
                .s_clk          (s_axi4l.aclk       ),
                .s_cke          (s_axi4l.aclken     ),
                .s_data         ({
                                    reg_param_arid    ,
                                    reg_param_araddr  ,
                                    reg_param_arlen   ,
                                    reg_param_arsize  ,
                                    reg_param_arburst ,
                                    reg_param_arlock  ,
                                    reg_param_arcache ,
                                    reg_param_arprot  ,
                                    reg_param_arqos   ,
                                    reg_param_arregion
                                }),
                .s_valid        (fifo_arvalid       ),
                .s_ready        (fifo_arready       ),
                .s_free_count   (                   ),

                .m_reset        (~m_axi4.aresetn    ),
                .m_clk          (m_axi4.aclk        ),
                .m_cke          (m_axi4.aclken      ),
                .m_data         ({
                                    m_axi4.arid    ,
                                    m_axi4.araddr  ,
                                    m_axi4.arlen   ,
                                    m_axi4.arsize  ,
                                    m_axi4.arburst ,
                                    m_axi4.arlock  ,
                                    m_axi4.arcache ,
                                    m_axi4.arprot  ,
                                    m_axi4.arqos   ,
                                    m_axi4.arregion
                                }),
                .m_valid        (m_axi4.arvalid     ),
                .m_ready        (m_axi4.arready     ),
                .m_data_count   (                   )
            );
    

    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4S_ASYNC        ),
                .DATA_WIDTH     (m_axi4.DATA_BITS   ),
                .PTR_WIDTH      (RFIFO_PTR_BITS     ),
                .DOUT_REGS      (1                  ),
                .RAM_TYPE       ("distributed"      ),
                .LOW_DEALY      (0                  ),
                .S_REGS         (0                  ),
                .M_REGS         (1                  )
            )
        u_fifo_generic_fwtf_r
            (
                .s_reset        (~m_axi4.aresetn    ),
                .s_clk          (m_axi4.aclk        ),
                .s_cke          (m_axi4.aclken      ),
                .s_data         (m_axi4.rdata       ),
                .s_valid        (m_axi4.rvalid      ),
                .s_ready        (m_axi4.rready      ),
                .s_free_count   (                   ),

                .m_reset        (~m_axi4s.aresetn   ),
                .m_clk          (m_axi4s.aclk       ),
                .m_cke          (m_axi4s.aclken     ),
                .m_data         (m_axi4s.tdata      ),
                .m_valid        (m_axi4s.tvalid     ),
                .m_ready        (m_axi4s.tready     ),
                .m_data_count   (                   )
            );

endmodule


`default_nettype wire


// end of file
