
`timescale 1 ns / 1 ps

module design_1
   (fan_en,
    m_axi4l_peri_aclk,
    m_axi4l_peri_araddr,
    m_axi4l_peri_aresetn,
    m_axi4l_peri_arprot,
    m_axi4l_peri_arready,
    m_axi4l_peri_arvalid,
    m_axi4l_peri_awaddr,
    m_axi4l_peri_awprot,
    m_axi4l_peri_awready,
    m_axi4l_peri_awvalid,
    m_axi4l_peri_bready,
    m_axi4l_peri_bresp,
    m_axi4l_peri_bvalid,
    m_axi4l_peri_rdata,
    m_axi4l_peri_rready,
    m_axi4l_peri_rresp,
    m_axi4l_peri_rvalid,
    m_axi4l_peri_wdata,
    m_axi4l_peri_wready,
    m_axi4l_peri_wstrb,
    m_axi4l_peri_wvalid,
    s_axi4_mem_aclk,
    s_axi4_mem_araddr,
    s_axi4_mem_arburst,
    s_axi4_mem_arcache,
    s_axi4_mem_aresetn,
    s_axi4_mem_arid,
    s_axi4_mem_arlen,
    s_axi4_mem_arlock,
    s_axi4_mem_arprot,
    s_axi4_mem_arqos,
    s_axi4_mem_arready,
    s_axi4_mem_arsize,
    s_axi4_mem_aruser,
    s_axi4_mem_arvalid,
    s_axi4_mem_awaddr,
    s_axi4_mem_awburst,
    s_axi4_mem_awcache,
    s_axi4_mem_awid,
    s_axi4_mem_awlen,
    s_axi4_mem_awlock,
    s_axi4_mem_awprot,
    s_axi4_mem_awqos,
    s_axi4_mem_awready,
    s_axi4_mem_awsize,
    s_axi4_mem_awuser,
    s_axi4_mem_awvalid,
    s_axi4_mem_bid,
    s_axi4_mem_bready,
    s_axi4_mem_bresp,
    s_axi4_mem_bvalid,
    s_axi4_mem_rdata,
    s_axi4_mem_rid,
    s_axi4_mem_rlast,
    s_axi4_mem_rready,
    s_axi4_mem_rresp,
    s_axi4_mem_rvalid,
    s_axi4_mem_wdata,
    s_axi4_mem_wlast,
    s_axi4_mem_wready,
    s_axi4_mem_wstrb,
    s_axi4_mem_wvalid);
  output [0:0]fan_en;
  output m_axi4l_peri_aclk;
  output [39:0]m_axi4l_peri_araddr;
  output [0:0]m_axi4l_peri_aresetn;
  output [2:0]m_axi4l_peri_arprot;
  input m_axi4l_peri_arready;
  output m_axi4l_peri_arvalid;
  output [39:0]m_axi4l_peri_awaddr;
  output [2:0]m_axi4l_peri_awprot;
  input m_axi4l_peri_awready;
  output m_axi4l_peri_awvalid;
  output m_axi4l_peri_bready;
  input [1:0]m_axi4l_peri_bresp;
  input m_axi4l_peri_bvalid;
  input [63:0]m_axi4l_peri_rdata;
  output m_axi4l_peri_rready;
  input [1:0]m_axi4l_peri_rresp;
  input m_axi4l_peri_rvalid;
  output [63:0]m_axi4l_peri_wdata;
  input m_axi4l_peri_wready;
  output [7:0]m_axi4l_peri_wstrb;
  output m_axi4l_peri_wvalid;
  output s_axi4_mem_aclk;
  input [48:0]s_axi4_mem_araddr;
  input [1:0]s_axi4_mem_arburst;
  input [3:0]s_axi4_mem_arcache;
  output [0:0]s_axi4_mem_aresetn;
  input [5:0]s_axi4_mem_arid;
  input [7:0]s_axi4_mem_arlen;
  input s_axi4_mem_arlock;
  input [2:0]s_axi4_mem_arprot;
  input [3:0]s_axi4_mem_arqos;
  output s_axi4_mem_arready;
  input [2:0]s_axi4_mem_arsize;
  input s_axi4_mem_aruser;
  input s_axi4_mem_arvalid;
  input [48:0]s_axi4_mem_awaddr;
  input [1:0]s_axi4_mem_awburst;
  input [3:0]s_axi4_mem_awcache;
  input [5:0]s_axi4_mem_awid;
  input [7:0]s_axi4_mem_awlen;
  input s_axi4_mem_awlock;
  input [2:0]s_axi4_mem_awprot;
  input [3:0]s_axi4_mem_awqos;
  output s_axi4_mem_awready;
  input [2:0]s_axi4_mem_awsize;
  input s_axi4_mem_awuser;
  input s_axi4_mem_awvalid;
  output [5:0]s_axi4_mem_bid;
  input s_axi4_mem_bready;
  output [1:0]s_axi4_mem_bresp;
  output s_axi4_mem_bvalid;
  output [127:0]s_axi4_mem_rdata;
  output [5:0]s_axi4_mem_rid;
  output s_axi4_mem_rlast;
  input s_axi4_mem_rready;
  output [1:0]s_axi4_mem_rresp;
  output s_axi4_mem_rvalid;
  input [127:0]s_axi4_mem_wdata;
  input s_axi4_mem_wlast;
  output s_axi4_mem_wready;
  input [15:0]s_axi4_mem_wstrb;
  input s_axi4_mem_wvalid;

  wire [0:0]fan_en;
  wire m_axi4l_peri_aclk;
  wire [39:0]m_axi4l_peri_araddr;
  wire [0:0]m_axi4l_peri_aresetn;
  wire [2:0]m_axi4l_peri_arprot;
  wire m_axi4l_peri_arready;
  wire m_axi4l_peri_arvalid;
  wire [39:0]m_axi4l_peri_awaddr;
  wire [2:0]m_axi4l_peri_awprot;
  wire m_axi4l_peri_awready;
  wire m_axi4l_peri_awvalid;
  wire m_axi4l_peri_bready;
  wire [1:0]m_axi4l_peri_bresp;
  wire m_axi4l_peri_bvalid;
  wire [63:0]m_axi4l_peri_rdata;
  wire m_axi4l_peri_rready;
  wire [1:0]m_axi4l_peri_rresp;
  wire m_axi4l_peri_rvalid;
  wire [63:0]m_axi4l_peri_wdata;
  wire m_axi4l_peri_wready;
  wire [7:0]m_axi4l_peri_wstrb;
  wire m_axi4l_peri_wvalid;
  wire s_axi4_mem_aclk;
  wire [48:0]s_axi4_mem_araddr;
  wire [1:0]s_axi4_mem_arburst;
  wire [3:0]s_axi4_mem_arcache;
  wire [0:0]s_axi4_mem_aresetn;
  wire [5:0]s_axi4_mem_arid;
  wire [7:0]s_axi4_mem_arlen;
  wire s_axi4_mem_arlock;
  wire [2:0]s_axi4_mem_arprot;
  wire [3:0]s_axi4_mem_arqos;
  wire s_axi4_mem_arready;
  wire [2:0]s_axi4_mem_arsize;
  wire s_axi4_mem_aruser;
  wire s_axi4_mem_arvalid;
  wire [48:0]s_axi4_mem_awaddr;
  wire [1:0]s_axi4_mem_awburst;
  wire [3:0]s_axi4_mem_awcache;
  wire [5:0]s_axi4_mem_awid;
  wire [7:0]s_axi4_mem_awlen;
  wire s_axi4_mem_awlock;
  wire [2:0]s_axi4_mem_awprot;
  wire [3:0]s_axi4_mem_awqos;
  wire s_axi4_mem_awready;
  wire [2:0]s_axi4_mem_awsize;
  wire s_axi4_mem_awuser;
  wire s_axi4_mem_awvalid;
  wire [5:0]s_axi4_mem_bid;
  wire s_axi4_mem_bready;
  wire [1:0]s_axi4_mem_bresp;
  wire s_axi4_mem_bvalid;
  wire [127:0]s_axi4_mem_rdata;
  wire [5:0]s_axi4_mem_rid;
  wire s_axi4_mem_rlast;
  wire s_axi4_mem_rready;
  wire [1:0]s_axi4_mem_rresp;
  wire s_axi4_mem_rvalid;
  wire [127:0]s_axi4_mem_wdata;
  wire s_axi4_mem_wlast;
  wire s_axi4_mem_wready;
  wire [15:0]s_axi4_mem_wstrb;
  wire s_axi4_mem_wvalid;


    // テストベンチから force する前提
    reg             reset               /*verilator public_flat*/;
    reg             clk                 /*verilator public_flat*/;

    reg    [39:0]   axi4l_peri_araddr   /*verilator public_flat*/;
    reg    [2:0]    axi4l_peri_arprot   /*verilator public_flat*/;
    reg             axi4l_peri_arready  /*verilator public_flat*/;
    reg             axi4l_peri_arvalid  /*verilator public_flat*/;
    reg    [39:0]   axi4l_peri_awaddr   /*verilator public_flat*/;
    reg    [2:0]    axi4l_peri_awprot   /*verilator public_flat*/;
    reg             axi4l_peri_awready  /*verilator public_flat*/;
    reg             axi4l_peri_awvalid  /*verilator public_flat*/;
    reg             axi4l_peri_bready   /*verilator public_flat*/;
    reg    [1:0]    axi4l_peri_bresp    /*verilator public_flat*/;
    reg             axi4l_peri_bvalid   /*verilator public_flat*/;
    reg    [63:0]   axi4l_peri_rdata    /*verilator public_flat*/;
    reg             axi4l_peri_rready   /*verilator public_flat*/;
    reg    [1:0]    axi4l_peri_rresp    /*verilator public_flat*/;
    reg             axi4l_peri_rvalid   /*verilator public_flat*/;
    reg    [63:0]   axi4l_peri_wdata    /*verilator public_flat*/;
    reg             axi4l_peri_wready   /*verilator public_flat*/;
    reg    [7:0]    axi4l_peri_wstrb    /*verilator public_flat*/;
    reg             axi4l_peri_wvalid   /*verilator public_flat*/;


    assign m_axi4l_peri_aresetn = ~reset                ;
    assign m_axi4l_peri_aclk    = clk                   ;
    assign m_axi4l_peri_awaddr  = axi4l_peri_awaddr     ;
    assign m_axi4l_peri_awprot  = axi4l_peri_awprot     ;
    assign m_axi4l_peri_awvalid = axi4l_peri_awvalid    ;
    assign m_axi4l_peri_wdata   = axi4l_peri_wdata      ;
    assign m_axi4l_peri_wstrb   = axi4l_peri_wstrb      ;
    assign m_axi4l_peri_wvalid  = axi4l_peri_wvalid     ;
    assign m_axi4l_peri_bready  = axi4l_peri_bready     ;
    assign m_axi4l_peri_araddr  = axi4l_peri_araddr     ;
    assign m_axi4l_peri_arprot  = axi4l_peri_arprot     ;
    assign m_axi4l_peri_arvalid = axi4l_peri_arvalid    ;
    assign m_axi4l_peri_rready  = axi4l_peri_rready     ;

    assign axi4l_peri_awready = m_axi4l_peri_awready    ;
    assign axi4l_peri_wready  = m_axi4l_peri_wready     ;
    assign axi4l_peri_bresp   = m_axi4l_peri_bresp      ;
    assign axi4l_peri_bvalid  = m_axi4l_peri_bvalid     ;
    assign axi4l_peri_arready = m_axi4l_peri_arready    ;
    assign axi4l_peri_rdata   = m_axi4l_peri_rdata      ;
    assign axi4l_peri_rresp   = m_axi4l_peri_rresp      ;
    assign axi4l_peri_rvalid  = m_axi4l_peri_rvalid     ;



    // memory
    assign s_axi4_mem_aresetn = ~reset   ;
    assign s_axi4_mem_aclk    = clk      ;

    wire    axi4_mem0_awvalid_tmp;
    wire    axi4_mem0_awready_tmp;
    wire    axi4_mem0_wvalid_tmp;
    wire    axi4_mem0_wready_tmp;

    assign fan_en = 1'b0;
    
    jelly2_axi4_slave_model
            #(
                .AXI_ID_WIDTH           (6                      ),
                .AXI_ADDR_WIDTH         (49                     ),
                .AXI_DATA_SIZE          (4                      ),
                .READ_DATA_ADDR         (1                      ),
                .MEM_WIDTH              (17                     ),
                .WRITE_LOG_FILE         ("axi4_write_log.txt"   ),
                .READ_LOG_FILE          ("axi4_read_log.txt"    ),
                .AW_DELAY               (10                     ),
                .AR_DELAY               (10                     ),
                .AW_FIFO_PTR_WIDTH      (4                      ),
                .W_FIFO_PTR_WIDTH       (4                      ),
                .B_FIFO_PTR_WIDTH       (4                      ),
                .AR_FIFO_PTR_WIDTH      (4                      ),
                .R_FIFO_PTR_WIDTH       (4                      ),
                .AW_BUSY_RATE           (50                     ),
                .W_BUSY_RATE            (50                     ),
                .B_BUSY_RATE            (50                     ),
                .AR_BUSY_RATE           (20                     ),
                .R_BUSY_RATE            (20                     )
            )
        i_axi4_slave_model
            (
                .aresetn                (s_axi4_mem_aresetn     ),
                .aclk                   (s_axi4_mem_aclk        ),
                .aclken                 (1'b1                   ),
                
                .s_axi4_awid            (s_axi4_mem_awid        ),
                .s_axi4_awaddr          (s_axi4_mem_awaddr      ),
                .s_axi4_awlen           (s_axi4_mem_awlen       ),
                .s_axi4_awsize          (s_axi4_mem_awsize      ),
                .s_axi4_awburst         (s_axi4_mem_awburst     ),
                .s_axi4_awlock          (s_axi4_mem_awlock      ),
                .s_axi4_awcache         (s_axi4_mem_awcache     ),
                .s_axi4_awprot          (s_axi4_mem_awprot      ),
                .s_axi4_awqos           (s_axi4_mem_awqos       ),
                .s_axi4_awvalid         (s_axi4_mem_awvalid     ),
                .s_axi4_awready         (s_axi4_mem_awready     ),
                .s_axi4_wdata           (s_axi4_mem_wdata       ),
                .s_axi4_wstrb           (s_axi4_mem_wstrb       ),
                .s_axi4_wlast           (s_axi4_mem_wlast       ),
                .s_axi4_wvalid          (s_axi4_mem_wvalid      ),
                .s_axi4_wready          (s_axi4_mem_wready      ),
                .s_axi4_bid             (s_axi4_mem_bid         ),
                .s_axi4_bresp           (s_axi4_mem_bresp       ),
                .s_axi4_bvalid          (s_axi4_mem_bvalid      ),
                .s_axi4_bready          (s_axi4_mem_bready      ),
                .s_axi4_arid            (s_axi4_mem_arid        ),
                .s_axi4_araddr          (s_axi4_mem_araddr      ),
                .s_axi4_arlen           (s_axi4_mem_arlen       ),
                .s_axi4_arsize          (s_axi4_mem_arsize      ),
                .s_axi4_arburst         (s_axi4_mem_arburst     ),
                .s_axi4_arlock          (s_axi4_mem_arlock      ),
                .s_axi4_arcache         (s_axi4_mem_arcache     ),
                .s_axi4_arprot          (s_axi4_mem_arprot      ),
                .s_axi4_arqos           (s_axi4_mem_arqos       ),
                .s_axi4_arvalid         (s_axi4_mem_arvalid     ),
                .s_axi4_arready         (s_axi4_mem_arready     ),
                .s_axi4_rid             (s_axi4_mem_rid         ),
                .s_axi4_rdata           (s_axi4_mem_rdata       ),
                .s_axi4_rresp           (s_axi4_mem_rresp       ),
                .s_axi4_rlast           (s_axi4_mem_rlast       ),
                .s_axi4_rvalid          (s_axi4_mem_rvalid      ),
                .s_axi4_rready          (s_axi4_mem_rready      )
        );
    

endmodule
