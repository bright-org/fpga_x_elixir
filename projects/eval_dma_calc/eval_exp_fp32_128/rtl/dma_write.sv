

`timescale 1ns / 1ps
`default_nettype none


module dma_write
        #(
            parameter   bit         AXI4L_ASYNC         = 0                             ,
            parameter   bit         AXI4S_ASYNC         = 0                             ,
            parameter   int         AWFIFO_PTR_BITS     = 8                             ,
            parameter   int         LFIFO_PTR_BITS      = AWFIFO_PTR_BITS               ,
            parameter   int         WFIFO_PTR_BITS      = 8                             ,
            parameter   int         BFIFO_PTR_BITS      = 8                             ,
            parameter   int         ISSUE_CNT_BITS      = 8                             ,
            parameter   int         ID_BITS             = 8                             ,
            parameter   int         ADDR_BITS           = 32                            ,
            parameter   int         DATA_BITS           = 128                           ,
            parameter   int         BYTE_BITS           = 8                             ,
            parameter   int         STRB_BITS           = DATA_BITS / BYTE_BITS         ,
            parameter   int         LEN_BITS            = 8                             ,
            parameter   int         SIZE_BITS           = 3                             ,
            parameter   int         BURST_BITS          = 2                             ,
            parameter   int         LOCK_BITS           = 1                             ,
            parameter   int         CACHE_BITS          = 4                             ,
            parameter   int         PROT_BITS           = 3                             ,
            parameter   int         QOS_BITS            = 4                             ,
            parameter   int         REGION_BITS         = 4                             ,
            parameter   int         RESP_BITS           = 2                             ,
            parameter   type        issue_cnt_t         = logic [ISSUE_CNT_BITS-1:0]    ,
            parameter   type        id_t                = logic [ID_BITS    -1:0]       ,
            parameter   type        addr_t              = logic [ADDR_BITS  -1:0]       ,
            parameter   type        len_t               = logic [LEN_BITS   -1:0]       ,
            parameter   type        size_t              = logic [SIZE_BITS  -1:0]       ,
            parameter   type        burst_t             = logic [BURST_BITS -1:0]       ,
            parameter   type        lock_t              = logic [LOCK_BITS  -1:0]       ,
            parameter   type        cache_t             = logic [CACHE_BITS -1:0]       ,
            parameter   type        prot_t              = logic [PROT_BITS  -1:0]       ,
            parameter   type        qos_t               = logic [QOS_BITS   -1:0]       ,
            parameter   type        region_t            = logic [REGION_BITS-1:0]       ,
            parameter   type        data_t              = logic [DATA_BITS  -1:0]       ,
            parameter   type        strb_t              = logic [STRB_BITS  -1:0]       ,
            parameter   type        resp_t              = logic [RESP_BITS  -1:0]       ,
            parameter   int         REGADR_BITS         = 8                             ,
            parameter   type        regadr_t            = logic [REGADR_BITS-1:0]       ,
            parameter   id_t        INIT_PARAM_AWID     = '0                            ,
            parameter   addr_t      INIT_PARAM_AWADDR   = '0                            ,
            parameter   len_t       INIT_PARAM_AWLEN    = '0                            ,
            parameter   size_t      INIT_PARAM_AWSIZE   = size_t'($clog2(DATA_BITS/8))  ,
            parameter   burst_t     INIT_PARAM_AWBURST  = 2'b01                         ,
            parameter   lock_t      INIT_PARAM_AWLOCK   = '0                            ,
            parameter   cache_t     INIT_PARAM_AWCACHE  = '0                            ,
            parameter   prot_t      INIT_PARAM_AWPROT   = '0                            ,
            parameter   qos_t       INIT_PARAM_AWQOS    = '0                            ,
            parameter   region_t    INIT_PARAM_AWREGION = '0                            ,
            parameter               DEVICE              = "RTL"                         ,
            parameter               SIMULATION          = "false"                       ,
            parameter               DEBUG               = "false"                        
        )
        (

            jelly3_axi4l_if.s                   s_axi4l,
            jelly3_axi4s_if.s                   s_axi4s,
            jelly3_axi4_if.mw                   m_axi4
        );


    // -------------------------------------
    //  localparam
    // -------------------------------------

    localparam type axi4s_data_t = logic [s_axi4s.DATA_BITS-1:0];
    localparam type axi4l_data_t = logic [s_axi4l.DATA_BITS-1:0];

    // -------------------------------------
    //  signals
    // -------------------------------------
    

    logic       fifo_awvalid    ;
    logic       fifo_awready    ;

    logic       fifo_lvalid     ;
    logic       fifo_lready     ;

    logic       fifo_bvalid     ;
    logic       fifo_bready     ;

    assign fifo_bready = 1'b1;


    // -------------------------------------
    //  registers
    // -------------------------------------
    
    // register address offset
    localparam  regadr_t REGADR_CORE_ID             = regadr_t'('h00);
    localparam  regadr_t REGADR_CTL_STATUS          = regadr_t'('h08);
    localparam  regadr_t REGADR_CTL_ISSUE_CNT       = regadr_t'('h09);
    localparam  regadr_t REGADR_PARAM_AWID          = regadr_t'('h10);
    localparam  regadr_t REGADR_PARAM_AWADDR        = regadr_t'('h11);
    localparam  regadr_t REGADR_PARAM_AWLEN         = regadr_t'('h12);
    localparam  regadr_t REGADR_PARAM_AWSIZE        = regadr_t'('h13);
    localparam  regadr_t REGADR_PARAM_AWBURST       = regadr_t'('h14);
    localparam  regadr_t REGADR_PARAM_AWLOCK        = regadr_t'('h15);
    localparam  regadr_t REGADR_PARAM_AWCACHE       = regadr_t'('h16);
    localparam  regadr_t REGADR_PARAM_AWPROT        = regadr_t'('h17);
    localparam  regadr_t REGADR_PARAM_AWQOS         = regadr_t'('h18);
    localparam  regadr_t REGADR_PARAM_AWREGION      = regadr_t'('h19);
    
    // registers
    logic           reg_ctl_awvalid     ;
    logic           reg_ctl_lvalid      ;
    issue_cnt_t     reg_ctl_issue_cnt   ;

    id_t            reg_param_awid      ;
    addr_t          reg_param_awaddr    ;
    len_t           reg_param_awlen     ;
    size_t          reg_param_awsize    ;
    burst_t         reg_param_awburst   ;
    lock_t          reg_param_awlock    ;
    cache_t         reg_param_awcache   ;
    prot_t          reg_param_awprot    ;
    qos_t           reg_param_awqos     ;
    region_t        reg_param_awregion  ;

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
            reg_ctl_awvalid     <= 1'b0                 ;
            reg_ctl_lvalid      <= 1'b0                 ;
            reg_ctl_issue_cnt   <= '0                   ;
            reg_param_awid      <= INIT_PARAM_AWID      ;
            reg_param_awaddr    <= INIT_PARAM_AWADDR    ;
            reg_param_awlen     <= INIT_PARAM_AWLEN     ;
            reg_param_awsize    <= INIT_PARAM_AWSIZE    ;
            reg_param_awburst   <= INIT_PARAM_AWBURST   ;
            reg_param_awlock    <= INIT_PARAM_AWLOCK    ;
            reg_param_awcache   <= INIT_PARAM_AWCACHE   ;
            reg_param_awprot    <= INIT_PARAM_AWPROT    ;
            reg_param_awqos     <= INIT_PARAM_AWQOS     ;
            reg_param_awregion  <= INIT_PARAM_AWREGION  ;
        end
        else if ( s_axi4l.aclken) begin
            automatic issue_cnt_t issue_cnt;
            issue_cnt = reg_ctl_issue_cnt;

            if ( fifo_awready ) begin
                reg_ctl_awvalid <= 1'b0;
            end
            if ( fifo_lready ) begin
                reg_ctl_lvalid <= 1'b0;
            end
            if ( fifo_bvalid && fifo_bready ) begin
                issue_cnt--;
            end

            if ( s_axi4l.awvalid && s_axi4l.awready && s_axi4l.wvalid && s_axi4l.wready ) begin
                case ( regadr_write )
                REGADR_PARAM_AWID       :  begin reg_param_awid     <=     id_t'(write_mask(axi4l_data_t'(reg_param_awid    ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWADDR     :  begin reg_param_awaddr   <=   addr_t'(write_mask(axi4l_data_t'(reg_param_awaddr  ), s_axi4l.wdata, s_axi4l.wstrb)); reg_ctl_awvalid <= 1'b1; reg_ctl_lvalid <= 1'b1; issue_cnt++; end
                REGADR_PARAM_AWLEN      :  begin reg_param_awlen    <=    len_t'(write_mask(axi4l_data_t'(reg_param_awlen   ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWSIZE     :  begin reg_param_awsize   <=   size_t'(write_mask(axi4l_data_t'(reg_param_awsize  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWBURST    :  begin reg_param_awburst  <=  burst_t'(write_mask(axi4l_data_t'(reg_param_awburst ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWLOCK     :  begin reg_param_awlock   <=   lock_t'(write_mask(axi4l_data_t'(reg_param_awlock  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWCACHE    :  begin reg_param_awcache  <=  cache_t'(write_mask(axi4l_data_t'(reg_param_awcache ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWPROT     :  begin reg_param_awprot   <=   prot_t'(write_mask(axi4l_data_t'(reg_param_awprot  ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWQOS      :  begin reg_param_awqos    <=    qos_t'(write_mask(axi4l_data_t'(reg_param_awqos   ), s_axi4l.wdata, s_axi4l.wstrb)); end
                REGADR_PARAM_AWREGION   :  begin reg_param_awregion <= region_t'(write_mask(axi4l_data_t'(reg_param_awregion), s_axi4l.wdata, s_axi4l.wstrb)); end
                default: ;
                endcase
            end

            reg_ctl_issue_cnt <= issue_cnt;
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
                REGADR_CORE_ID          :   s_axi4l.rdata <= axi4l_data_t'(32'haa550001); 
                REGADR_CTL_STATUS       :   s_axi4l.rdata <= axi4l_data_t'({reg_ctl_lvalid, reg_ctl_awvalid});
                REGADR_CTL_ISSUE_CNT    :   s_axi4l.rdata <= axi4l_data_t'(reg_ctl_issue_cnt);
                REGADR_PARAM_AWID       :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awid    );
                REGADR_PARAM_AWADDR     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awaddr  );
                REGADR_PARAM_AWLEN      :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awlen   );
                REGADR_PARAM_AWSIZE     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awsize  );
                REGADR_PARAM_AWBURST    :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awburst );
                REGADR_PARAM_AWLOCK     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awlock  );
                REGADR_PARAM_AWCACHE    :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awcache );
                REGADR_PARAM_AWPROT     :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awprot  );
                REGADR_PARAM_AWQOS      :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awqos   );
                REGADR_PARAM_AWREGION   :   s_axi4l.rdata <= axi4l_data_t'(reg_param_awregion);
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
    
    assign fifo_awvalid = reg_ctl_awvalid;
    assign fifo_lvalid  = reg_ctl_lvalid;


    
    // -------------------------------------
    //  core
    // -------------------------------------
    
    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4L_ASYNC        ),
                .DATA_WIDTH     (
                                    $bits(reg_param_awid    ) +
                                    $bits(reg_param_awaddr  ) +
                                    $bits(reg_param_awlen   ) +
                                    $bits(reg_param_awsize  ) +
                                    $bits(reg_param_awburst ) +
                                    $bits(reg_param_awlock  ) +
                                    $bits(reg_param_awcache ) +
                                    $bits(reg_param_awprot  ) +
                                    $bits(reg_param_awqos   ) +
                                    $bits(reg_param_awregion)
                                ),
                .PTR_WIDTH      (AWFIFO_PTR_BITS    ),
                .DOUT_REGS      (1                  ),
                .RAM_TYPE       ("distributed"      ),
                .LOW_DEALY      (0                  ),
                .S_REGS         (0                  ),
                .M_REGS         (1                  )
            )
        u_fifo_generic_fwtf_aw
            (
                .s_reset        (~s_axi4l.aresetn   ),
                .s_clk          (s_axi4l.aclk       ),
                .s_cke          (s_axi4l.aclken     ),
                .s_data         ({
                                    reg_param_awid    ,
                                    reg_param_awaddr  ,
                                    reg_param_awlen   ,
                                    reg_param_awsize  ,
                                    reg_param_awburst ,
                                    reg_param_awlock  ,
                                    reg_param_awcache ,
                                    reg_param_awprot  ,
                                    reg_param_awqos   ,
                                    reg_param_awregion
                                }),
                .s_valid        (fifo_awvalid       ),
                .s_ready        (fifo_awready       ),
                .s_free_count   (                   ),

                .m_reset        (~m_axi4.aresetn    ),
                .m_clk          (m_axi4.aclk        ),
                .m_cke          (m_axi4.aclken      ),
                .m_data         ({
                                    m_axi4.awid    ,
                                    m_axi4.awaddr  ,
                                    m_axi4.awlen   ,
                                    m_axi4.awsize  ,
                                    m_axi4.awburst ,
                                    m_axi4.awlock  ,
                                    m_axi4.awcache ,
                                    m_axi4.awprot  ,
                                    m_axi4.awqos   ,
                                    m_axi4.awregion
                                }),
                .m_valid        (m_axi4.awvalid     ),
                .m_ready        (m_axi4.awready     ),
                .m_data_count   (                   )
            );
    

    len_t   lfifo_wlen  ;
    logic   lfifo_valid ;
    logic   lfifo_ready ;

    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4L_ASYNC || AXI4S_ASYNC),
                .DATA_WIDTH     ($bits(reg_param_awlen) ),
                .PTR_WIDTH      (AWFIFO_PTR_BITS        ),
                .DOUT_REGS      (1                      ),
                .RAM_TYPE       ("distributed"          ),
                .LOW_DEALY      (0                      ),
                .S_REGS         (0                      ),
                .M_REGS         (1                      )
            )
        u_fifo_generic_fwtf_len
            (
                .s_reset        (~s_axi4l.aresetn       ),
                .s_clk          (s_axi4l.aclk           ),
                .s_cke          (s_axi4l.aclken         ),
                .s_data         (reg_param_awlen        ),
                .s_valid        (fifo_lvalid            ),
                .s_ready        (fifo_lready            ),
                .s_free_count   (                       ),

                .m_reset        (~s_axi4s.aresetn        ),
                .m_clk          (s_axi4s.aclk            ),
                .m_cke          (s_axi4s.aclken          ),
                .m_data         (lfifo_wlen             ),
                .m_valid        (lfifo_valid            ),
                .m_ready        (lfifo_ready            ),
                .m_data_count   (                       )
            );

    // last 付与
    logic       wenable ;
    len_t       wlen    ;
    logic       wlast   ;
    always_ff @(posedge s_axi4s.aclk) begin
        if ( ~s_axi4s.aresetn ) begin
            wenable <= 1'b0;
            wlen    <= 0;
            wlast   <= 1'bx;
        end
        else if ( s_axi4s.aclken ) begin
            if ( lfifo_ready ) begin
                wenable <= lfifo_valid;
                wlen    <= lfifo_wlen - 1'b1;
                wlast   <= lfifo_wlen == '0;
            end
            else if ( s_axi4s.tvalid && s_axi4s.tready ) begin
                wlen    <= wlen - 1'b1;
                wlast   <= wlen == '0;
            end
        end
    end

    assign lfifo_ready = !wenable || (wlast && s_axi4s.tvalid && s_axi4s.tready);


    logic   fifo_wvalid;
    logic   fifo_wready;

    assign fifo_wvalid = s_axi4s.tvalid && wenable;
    assign s_axi4s.tready = fifo_wready && wenable;

    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4S_ASYNC            ),
                .DATA_WIDTH     (1+m_axi4.DATA_BITS     ),
                .PTR_WIDTH      (WFIFO_PTR_BITS         ),
                .DOUT_REGS      (1                      ),
                .RAM_TYPE       ("distributed"          ),
                .LOW_DEALY      (0                      ),
                .S_REGS         (0                      ),
                .M_REGS         (1                      )
            )
        u_fifo_generic_fwtf_w
            (
                .s_reset        (~s_axi4s.aresetn       ),
                .s_clk          (s_axi4s.aclk           ),
                .s_cke          (s_axi4s.aclken         ),
                .s_data         ({
                                    wlast,
                                    s_axi4s.tdata
                                }),
                .s_valid        (fifo_wvalid            ),
                .s_ready        (fifo_wready            ),
                .s_free_count   (                       ),

                .m_reset        (~m_axi4.aresetn        ),
                .m_clk          (m_axi4.aclk            ),
                .m_cke          (m_axi4.aclken          ),
                .m_data         ({
                                    m_axi4.wlast,
                                    m_axi4.wdata
                                }),
                .m_valid        (m_axi4.wvalid          ),
                .m_ready        (m_axi4.wready          ),
                .m_data_count   (                       )
            );
   
    assign m_axi4.wstrb = '1;


    jelly2_fifo_generic_fwtf
            #(
                .ASYNC          (AXI4L_ASYNC        ),
                .DATA_WIDTH     (m_axi4.RESP_BITS   ),
                .PTR_WIDTH      (BFIFO_PTR_BITS     ),
                .DOUT_REGS      (1                  ),
                .RAM_TYPE       ("distributed"      ),
                .LOW_DEALY      (0                  ),
                .S_REGS         (0                  ),
                .M_REGS         (1                  )
            )
        u_fifo_generic_fwtf_b
            (
                .s_reset        (~m_axi4.aresetn    ),
                .s_clk          (m_axi4.aclk        ),
                .s_cke          (m_axi4.aclken      ),
                .s_data         (m_axi4.bresp       ),
                .s_valid        (m_axi4.bvalid      ),
                .s_ready        (m_axi4.bready      ),
                .s_free_count   (                   ),

                .m_reset        (~s_axi4l.aresetn   ),
                .m_clk          (s_axi4l.aclk       ),
                .m_cke          (s_axi4l.aclken     ),
                .m_data         (                   ),
                .m_valid        (fifo_bvalid        ),
                .m_ready        (fifo_bready        ),
                .m_data_count   (                   )
            );

endmodule


`default_nettype wire


// end of file
