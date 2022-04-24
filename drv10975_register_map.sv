// Class : DRV10975 Register MAP

`ifndef DRV10975_REGISTER_MAP
`define DRV1095_REGISTER_MAP

class drv10975_register_map extends uvm_sequence_item;

  //Register Fields
  bit [08:00] SpdCtrl;

  bit [00:00] OverRide;

  bit [07:00] enProgKey;

  bit [00:00] sleepDis;
  bit [00:00] Sldata;
  bit [00:00] eeRefresh;
  bit [00:00] eeWrite;

  bit [00:00] OverTemp;
  bit [00:00] Slp_Stdby;
  bit [00:00] OverCurr;
  bit [00:00] MtrLck;

  bit [15:00] MotorSpeed;

  bit [15:00] MotorPeriod;

  bit [15:00] MotorKt;

  bit [10:00] MotorCurrent;

  bit [07:00] IPDPosition;

  bit [07:00] SupplyVoltage;

  bit [07:00] SpeedCmd;

  bit [07:00] spdCmdBuffer;

  bit [00:00] Lock5;
  bit [00:00] Lock4;
  bit [00:00] Fault3;
  bit [00:00] Lock2;
  bit [00:00] Lock1;
  bit [00:00] Lock0;

  bit [00:00] DoubleFreq;
  bit [06:00] Rm;

  bit [00:00] AdjMode;
  bit [06:00] Kt;

  bit [00:00] CtrlAdvMd;
  bit [06:00] TCtrlAdv;

  bit [01:00] ISDThr;
  bit [01:00] IPDAdvcAgl;
  bit [00:00] ISDen;
  bit [00:00] RvsDrEn;
  bit [01:00] RvsDrThr;

  bit [01:00] OpenLCurr;
  bit [02:00] OpenLCurrRt;
  bit [02:00] BrkDoneThr;

  bit [01:00] CtrlCoef;
  bit [02:00] StAccel2;
  bit [02:00] StAccel;

  bit [04:00] Op2ClsThr;
  bit [02:00] AlignTime;

  bit [03:00] LockEn;
  bit [00:00] AVSIndEn;
  bit [00:00] AVSMEn;
  bit [00:00] AVSMMd;
  bit [00:00] IPDRlsMd;

  bit [03:00] SWiLimitThr;
  bit [02:00] HWiLimitThr;

  bit [00:00] LockEn5;
  bit [02:00] ClsLpAccel;
  bit [03:00] Deadtime;

  bit [03:00] IPDCurrThr;
  bit [00:00] LockEn4;
  bit [00:00] VregSel;
  bit [01:00] IPDClk;

  bit [01:00] FGOLsel;
  bit [01:00] FGcycle;
  bit [01:00] KtLckThr;
  bit [00:00] SpdCtrlMd;
  bit [00:00] CLoopDis;

  //UVM Automation Macro
  `uvm_object_utils_begin(drv10975_register_map)
    `uvm_field_int(SpdCtrl,       UVM_ALL_ON)
    `uvm_field_int(OverRide,      UVM_ALL_ON)
    `uvm_field_int(enProgKey,     UVM_ALL_ON)
    `uvm_field_int(sleepDis,      UVM_ALL_ON)
    `uvm_field_int(Sldata,        UVM_ALL_ON)
    `uvm_field_int(eeRefresh,     UVM_ALL_ON)
    `uvm_field_int(eeWrite,       UVM_ALL_ON)
    `uvm_field_int(OverTemp,      UVM_ALL_ON)
    `uvm_field_int(Slp_Stdby,     UVM_ALL_ON)
    `uvm_field_int(OverCurr,      UVM_ALL_ON)
    `uvm_field_int(MtrLck,        UVM_ALL_ON)
    `uvm_field_int(MotorSpeed,    UVM_ALL_ON)
    `uvm_field_int(MotorPeriod,   UVM_ALL_ON)
    `uvm_field_int(MotorKt,       UVM_ALL_ON)
    `uvm_field_int(MotorCurrent,  UVM_ALL_ON)
    `uvm_field_int(IPDPosition,   UVM_ALL_ON)
    `uvm_field_int(SupplyVoltage, UVM_ALL_ON)
    `uvm_field_int(SpeedCmd,      UVM_ALL_ON)
    `uvm_field_int(spdCmdBuffer,  UVM_ALL_ON)
    `uvm_field_int(Lock5,         UVM_ALL_ON)
    `uvm_field_int(Lock4,         UVM_ALL_ON)
    `uvm_field_int(Fault3,        UVM_ALL_ON)
    `uvm_field_int(Lock2,         UVM_ALL_ON)
    `uvm_field_int(Lock1,         UVM_ALL_ON)
    `uvm_field_int(Lock0,         UVM_ALL_ON)
    `uvm_field_int(DoubleFreq,    UVM_ALL_ON)
    `uvm_field_int(Rm,            UVM_ALL_ON)
    `uvm_field_int(AdjMode,       UVM_ALL_ON)
    `uvm_field_int(Kt,            UVM_ALL_ON)
    `uvm_field_int(CtrlAdvMd,     UVM_ALL_ON)
    `uvm_field_int(TCtrlAdv,      UVM_ALL_ON)
    `uvm_field_int(ISDThr,        UVM_ALL_ON)
    `uvm_field_int(IPDAdvcAgl,    UVM_ALL_ON)
    `uvm_field_int(ISDen,         UVM_ALL_ON)
    `uvm_field_int(RvsDrEn,       UVM_ALL_ON)
    `uvm_field_int(RvsDrThr,      UVM_ALL_ON)
    `uvm_field_int(OpenLCurr,     UVM_ALL_ON)
    `uvm_field_int(OpenLCurrRt,   UVM_ALL_ON)
    `uvm_field_int(BrkDoneThr,    UVM_ALL_ON)
    `uvm_field_int(CtrlCoef,     UVM_ALL_ON)
    `uvm_field_int(StAccel2,      UVM_ALL_ON)
    `uvm_field_int(StAccel,       UVM_ALL_ON)
    `uvm_field_int(Op2ClsThr,     UVM_ALL_ON)
    `uvm_field_int(AlignTime,     UVM_ALL_ON)
    `uvm_field_int(LockEn,        UVM_ALL_ON)
    `uvm_field_int(AVSIndEn,      UVM_ALL_ON)
    `uvm_field_int(AVSMEn,        UVM_ALL_ON)
    `uvm_field_int(AVSMMd,        UVM_ALL_ON)
    `uvm_field_int(IPDRlsMd,      UVM_ALL_ON)
    `uvm_field_int(SWiLimitThr,   UVM_ALL_ON)
    `uvm_field_int(HWiLimitThr,   UVM_ALL_ON)
    `uvm_field_int(LockEn5,       UVM_ALL_ON)
    `uvm_field_int(ClsLpAccel,    UVM_ALL_ON)
    `uvm_field_int(Deadtime,      UVM_ALL_ON)
    `uvm_field_int(IPDCurrThr,    UVM_ALL_ON)
    `uvm_field_int(LockEn4,       UVM_ALL_ON)
    `uvm_field_int(VregSel,       UVM_ALL_ON)
    `uvm_field_int(IPDClk,        UVM_ALL_ON)
    `uvm_field_int(FGOLsel,       UVM_ALL_ON)
    `uvm_field_int(FGcycle,       UVM_ALL_ON)
    `uvm_field_int(KtLckThr,      UVM_ALL_ON)
    `uvm_field_int(SpdCtrlMd,     UVM_ALL_ON)
    `uvm_field_int(CLoopDis,      UVM_ALL_ON)
  `uvm_object_utils_end

  //Constructor
  function new(string name = "drv10975_register_map");
    bit temp;

    super.new(name);

    temp = reg_write(8'h20, 'h4A);
    temp = reg_write(8'h21, 'h4E);
    temp = reg_write(8'h22, 'h2A);
    temp = reg_write(8'h23, 'h00);
    temp = reg_write(8'h24, 'h98);
    temp = reg_write(8'h25, 'hE4);
    temp = reg_write(8'h26, 'h7A);
    temp = reg_write(8'h27, 'hF4);
    temp = reg_write(8'h28, 'h69);
    temp = reg_write(8'h29, 'hB8);
    temp = reg_write(8'h2A, 'hAD);
    temp = reg_write(8'h2B, 'h0C);
  endfunction : new

  function bit reg_read(input [7:0] reg_addr, output [7:0] reg_data);

    //Assume Successful read
    reg_read = 1;

    case(reg_addr)
       `SPEEDCTRL1    : reg_data = {SpdCtrl[7:0]};
       `SPEEDCTRL2    : reg_data = {OverRide, 6'b0, SpdCtrl[8]};
       `DEVCTRL       : reg_data = {enProgKey};
       `EECTRL        : reg_data = {sleepDis, Sldata, eeRefresh, eeWrite, 4'b0};
       `STATUS        : reg_data = {OverTemp, Slp_Stdby, OverCurr, MtrLck, 4'b0};
       `MOTORSPEED1   : reg_data = {MotorSpeed[15:8]};
       `MOTORSPEED2   : reg_data = {MotorSpeed[7:0]};
       `MOTORPERIOD1  : reg_data = {MotorPeriod[15:0]};
       `MOTORPERIOD2  : reg_data = {MotorPeriod[7:0]};
       `MOTORKT1      : reg_data = {MotorKt[15:0]};
       `MOTORKT2      : reg_data = {MotorKt[7:0]};
       `MOTORCURRENT1 : reg_data = {MotorCurrent[10:8]};
       `MOTORCURRENT2 : reg_data = {MotorCurrent[7:0]};
       `IPDPOSITION   : reg_data = {IPDPosition};
       `SUPPLYVOLTAGE : reg_data = {SupplyVoltage};
       `SPEEDCMD      : reg_data = {SpeedCmd};
       `SPDCMDBUFFER  : reg_data = {spdCmdBuffer};
       `FAULTCODE     : reg_data = {Lock5, Lock4, Fault3, Lock2, Lock1, Lock0};
       `MOTORPARAM1   : reg_data = {DoubleFreq, Rm};
       `MOTORPARAM2   : reg_data = {AdjMode, Kt};
       `MOTORPARAM3   : reg_data = {CtrlAdvMd, TCtrlAdv};
       `SYSOPT1       : reg_data = {ISDThr, IPDAdvcAgl, ISDen, RvsDrEn, RvsDrThr};
       `SYSOPT2       : reg_data = {OpenLCurr, OpenLCurrRt, BrkDoneThr};
       `SYSOPT3       : reg_data = {CtrlCoef, StAccel2, StAccel};
       `SYSOPT4       : reg_data = {Op2ClsThr, AlignTime};
       `SYSOPT5       : reg_data = {LockEn, AVSIndEn, AVSMEn, AVSMMd, IPDRlsMd};
       `SYSOPT6       : reg_data = {SWiLimitThr, HWiLimitThr, 1'b0};
       `SYSOPT7       : reg_data = {LockEn5, ClsLpAccel, Deadtime};
       `SYSOPT8       : reg_data = {IPDCurrThr, LockEn4, VregSel, IPDClk};
       `SYSOPT9       : reg_data = {FGOLsel, FGcycle, KtLckThr, SpdCtrlMd, CLoopDis};
       default:
         begin
           `uvm_warning(get_full_name(), "Invalid Address read.");
           reg_data = 0;
           reg_read = 0;
         end
    endcase

  endfunction : reg_read

  function bit reg_write(input [7:0] reg_addr, input [7:0] reg_data);

    //Assume Successful write
    reg_write = 1;
    case(reg_addr)
       `SPEEDCTRL1    : {SpdCtrl[7:0]}                                    = reg_data;
       `SPEEDCTRL2    : {OverRide, SpdCtrl[8]}                            = {reg_data[7], reg_data[0]};
       `DEVCTRL       : {enProgKey}                                       = reg_data;
       `EECTRL        : {sleepDis, Sldata, eeRefresh, eeWrite}            = reg_data[7:5];
       `STATUS        : {OverTemp, Slp_Stdby, OverCurr, MtrLck}           = reg_data[7:5];
       `MOTORSPEED1   : {MotorSpeed[15:8]}                                = reg_data;
       `MOTORSPEED2   : {MotorSpeed[7:0]}                                 = reg_data;
       `MOTORPERIOD1  : {MotorPeriod[15:0]}                               = reg_data;
       `MOTORPERIOD2  : {MotorPeriod[7:0]}                                = reg_data;
       `MOTORKT1      : {MotorKt[15:0]}                                   = reg_data;
       `MOTORKT2      : {MotorKt[7:0]}                                    = reg_data;
       `MOTORCURRENT1 : {MotorCurrent[10:8]}                              = reg_data;
       `MOTORCURRENT2 : {MotorCurrent[7:0]}                               = reg_data;
       `IPDPOSITION   : {IPDPosition}                                     = reg_data;
       `SUPPLYVOLTAGE : {SupplyVoltage}                                   = reg_data;
       `SPEEDCMD      : {SpeedCmd}                                        = reg_data;
       `SPDCMDBUFFER  : {spdCmdBuffer}                                    = reg_data;
       `FAULTCODE     : {Lock5, Lock4, Fault3, Lock2, Lock1, Lock0}       = reg_data;
       `MOTORPARAM1   : {DoubleFreq, Rm}                                  = reg_data;
       `MOTORPARAM2   : {AdjMode, Kt}                                     = reg_data;
       `MOTORPARAM3   : {CtrlAdvMd, TCtrlAdv}                             = reg_data;
       `SYSOPT1       : {ISDThr, IPDAdvcAgl, ISDen, RvsDrEn, RvsDrThr}    = reg_data;
       `SYSOPT2       : {OpenLCurr, OpenLCurrRt, BrkDoneThr}              = reg_data;
       `SYSOPT3       : {CtrlCoef, StAccel2, StAccel}                     = reg_data;
       `SYSOPT4       : {Op2ClsThr, AlignTime}                            = reg_data;
       `SYSOPT5       : {LockEn, AVSIndEn, AVSMEn, AVSMMd, IPDRlsMd}      = reg_data;
       `SYSOPT6       : {SWiLimitThr, HWiLimitThr}                        = reg_data[7:1];
       `SYSOPT7       : {LockEn5, ClsLpAccel, Deadtime}                   = reg_data;
       `SYSOPT8       : {IPDCurrThr, LockEn4, VregSel, IPDClk}            = reg_data;
       `SYSOPT9       : {FGOLsel, FGcycle, KtLckThr, SpdCtrlMd, CLoopDis} = reg_data;
       default:
         begin
           `uvm_warning(get_full_name(), "Invalid Address write.");
           reg_write = 0;
         end
    endcase

  endfunction : reg_write

endclass : drv10975_register_map

`endif

