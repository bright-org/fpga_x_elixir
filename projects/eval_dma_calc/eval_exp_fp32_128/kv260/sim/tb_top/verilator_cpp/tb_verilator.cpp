#include <memory>
#include <verilated.h>
#include "Vtb_main.h"
#include "jelly/simulator/Manager.h"
#include "jelly/simulator/ResetNode.h"
#include "jelly/simulator/ClockNode.h"
#include "jelly/simulator/VerilatorNode.h"
#include "jelly/simulator/Axi4LiteMasterNode.h"
#include "jelly/JellyRegs.h"


namespace jsim = jelly::simulator;


#if VM_TRACE
#include <verilated_fst_c.h> 
#include <verilated_vcd_c.h> 
#endif


int main(int argc, char** argv)
{
    auto contextp = std::make_shared<VerilatedContext>();
    contextp->debug(0);
    contextp->randReset(2);
    contextp->commandArgs(argc, argv);
    
    const auto top = std::make_shared<Vtb_main>(contextp.get(), "top");


    jsim::trace_ptr_t tfp = nullptr;
#if VM_TRACE
    contextp->traceEverOn(true);

    tfp = std::make_shared<jsim::trace_t>();
    top->trace(tfp.get(), 100);
    tfp->open("tb_verilator" TRACE_EXT);
#endif

    auto mng = jsim::Manager::Create();

    mng->AddNode(jsim::VerilatorNode_Create(top, tfp));

    mng->AddNode(jsim::ResetNode_Create(&top->reset, 100));
    mng->AddNode(jsim::ClockNode_Create(&top->clk, 1000.0/333.0));

    jsim::Axi4Lite axi4l_signals =
            {
                &top->s_axi4l_peri_aresetn,
                &top->s_axi4l_peri_aclk   ,
                &top->s_axi4l_peri_awaddr ,
                &top->s_axi4l_peri_awprot ,
                &top->s_axi4l_peri_awvalid,
                &top->s_axi4l_peri_awready,
                &top->s_axi4l_peri_wdata  ,
                &top->s_axi4l_peri_wstrb  ,
                &top->s_axi4l_peri_wvalid ,
                &top->s_axi4l_peri_wready ,
                &top->s_axi4l_peri_bresp  ,
                &top->s_axi4l_peri_bvalid ,
                &top->s_axi4l_peri_bready ,
                &top->s_axi4l_peri_araddr ,
                &top->s_axi4l_peri_arprot ,
                &top->s_axi4l_peri_arvalid,
                &top->s_axi4l_peri_arready,
                &top->s_axi4l_peri_rdata  ,
                &top->s_axi4l_peri_rresp  ,
                &top->s_axi4l_peri_rvalid ,
                &top->s_axi4l_peri_rready ,
            };
    auto axi4l = jsim::Axi4LiteMasterNode_Create(axi4l_signals);
    mng->AddNode(axi4l);

   
    const int ADR_DMAR   = 0xa0000000;
    const int ADR_DMAW   = 0xa0100000;

    const int REG_DMAR_CORE_ID          = 0x00 * 8;
    const int REG_DMAR_PARAM_ARID       = 0x10 * 8;
    const int REG_DMAR_PARAM_ARADDR     = 0x11 * 8;
    const int REG_DMAR_PARAM_ARLEN      = 0x12 * 8;
    const int REG_DMAR_PARAM_ARSIZE     = 0x13 * 8;
    const int REG_DMAR_PARAM_ARBURST    = 0x14 * 8;
    const int REG_DMAR_PARAM_ARLOCK     = 0x15 * 8;
    const int REG_DMAR_PARAM_ARCACHE    = 0x16 * 8;
    const int REG_DMAR_PARAM_ARPROT     = 0x17 * 8;
    const int REG_DMAR_PARAM_ARQOS      = 0x18 * 8;
    const int REG_DMAR_PARAM_ARREGION   = 0x19 * 8;

    const int REG_DMAW_CORE_ID          = 0x00 * 8;
    const int REG_DMAW_CTL_STATUS       = 0x08 * 8;
    const int REG_DMAW_CTL_ISSUE_CNT    = 0x09 * 8;
    const int REG_DMAW_PARAM_AWID       = 0x10 * 8;
    const int REG_DMAW_PARAM_AWADDR     = 0x11 * 8;
    const int REG_DMAW_PARAM_AWLEN      = 0x12 * 8;
    const int REG_DMAW_PARAM_AWSIZE     = 0x13 * 8;
    const int REG_DMAW_PARAM_AWBURST    = 0x14 * 8;
    const int REG_DMAW_PARAM_AWLOCK     = 0x15 * 8;
    const int REG_DMAW_PARAM_AWCACHE    = 0x16 * 8;
    const int REG_DMAW_PARAM_AWPROT     = 0x17 * 8;
    const int REG_DMAW_PARAM_AWQOS      = 0x18 * 8;
    const int REG_DMAW_PARAM_AWREGION   = 0x19 * 8;


    axi4l->Wait(1000);
    axi4l->Display("start");

    axi4l->ExecRead(ADR_DMAR + REG_DMAR_CORE_ID);
    axi4l->ExecRead(ADR_DMAW + REG_DMAW_CORE_ID);

    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARLEN,  0x0f,   0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x100,  0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARLEN,  0xff,   0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x1000, 0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x2000, 0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x3000, 0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x4000, 0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x5000, 0xff);
    axi4l->ExecWrite(ADR_DMAR + REG_DMAR_PARAM_ARADDR, 0x6000, 0xff);

    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWLEN,  0x0f,   0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x100,  0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWLEN,  0xff,   0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x1000, 0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x2000, 0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x3000, 0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x4000, 0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x5000, 0xff);
    axi4l->ExecWrite(ADR_DMAW + REG_DMAW_PARAM_AWADDR, 0x6000, 0xff);

//    while ( axi4l->ExecRead(ADR_DMAR + REG_DMAW_CTL_ISSUE_CNT) != 0 ) {
//        axi4l->Wait(100);
//    }


    /*
    axi4l->Wait(1000);
    axi4l->Display("read core ID");
    axi4l->ExecRead (reg_gid);     // gid
    axi4l->ExecRead (reg_fmtr);    // fmtr
    axi4l->ExecRead (reg_demos);   // demosaic
    axi4l->ExecRead (reg_colmat);  // col mat
    axi4l->ExecRead (reg_wdma);    // wdma

    wb->Display("set format regularizer");
    wb->ExecRead (reg_fmtr + REG_VIDEO_FMTREG_CORE_ID);                         // CORE ID
    wb->ExecWrite(reg_fmtr + REG_VIDEO_FMTREG_PARAM_WIDTH,      X_NUM, 0xf);    // width
    wb->ExecWrite(reg_fmtr + REG_VIDEO_FMTREG_PARAM_HEIGHT,     Y_NUM, 0xf);    // height
//  wb->ExecWrite(reg_fmtr + REG_VIDEO_FMTREG_PARAM_FILL,           0, 0xf);    // fill
//  wb->ExecWrite(reg_fmtr + REG_VIDEO_FMTREG_PARAM_TIMEOUT,     1024, 0xf);    // timeout
    wb->ExecWrite(reg_fmtr + REG_VIDEO_FMTREG_CTL_CONTROL,          3, 0xf);    // enable
    wb->ExecWait(1000);

    wb->Display("set DEMOSIC");
    wb->ExecRead (reg_demos + REG_IMG_DEMOSAIC_CORE_ID);
    wb->ExecWrite(reg_demos + REG_IMG_DEMOSAIC_PARAM_PHASE,    0x0, 0xf);
    wb->ExecWrite(reg_demos + REG_IMG_DEMOSAIC_CTL_CONTROL,    0x3, 0xf);

    wb->Display("set colmat");
    wb->ExecRead (reg_colmat + REG_IMG_COLMAT_CORE_ID);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX00, 0x00010000, 0xf); // 0x0003a83a
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX01, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX02, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX03, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX10, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX11, 0x00010000, 0xf); // 0x00030c30
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX12, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX13, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX20, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX21, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX22, 0x00010000, 0xf); // 0x000456c7
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_PARAM_MATRIX23, 0x00000000, 0xf);
    wb->ExecWrite(reg_colmat + REG_IMG_COLMAT_CTL_CONTROL, 3, 0xf);

    wb->ExecWait(10000);
    wb->Display("set write DMA");
    wb->ExecRead (reg_wdma + REG_VDMA_WRITE_CORE_ID);                               // CORE ID
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_ADDR,          0x00000000, 0xf);  // address
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_LINE_STEP,        X_NUM*4, 0xf);  // stride
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_H_SIZE,           X_NUM-1, 0xf);  // width
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_V_SIZE,           Y_NUM-1, 0xf);  // height
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_F_SIZE,               1-1, 0xf);
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_PARAM_FRAME_STEP, X_NUM*Y_NUM*4, 0xff);
    wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_CTL_CONTROL,                  3, 0xf);  // update & enable
//  wb->ExecWrite(reg_wdma + REG_VDMA_WRITE_CTL_CONTROL,                  7, 0xf);  // update & enable & oneshot
    wb->ExecWait(1000);

    wb->Display("wait for DMA end");
//    wb->SetVerbose(false);
    while ( wb->ExecRead (reg_wdma + REG_VDMA_WRITE_CTL_STATUS) != 0 ) {
//      wb->ExecWait(10000);
        mng->Run(100000);
    }
    wb->Display("DMA end");
    */
   
    mng->Run(10000);
    
//    mng->Run(1000000);
//    mng->Run();

#if VM_TRACE
    tfp->close();
#endif

#if VM_COVERAGE
    contextp->coveragep()->write("coverage.dat");
#endif

    return 0;
}


// end of file
