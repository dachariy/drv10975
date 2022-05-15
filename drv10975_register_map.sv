// Class : DRV10975 Register MAP

`ifndef DRV10975_REGISTER_MAP
`define DRV1095_REGISTER_MAP

class drv10975_register_map extends uvm_object;

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

  bit [07:00] motorparam1_reg;
  bit [07:00] motorparam2_reg;
  bit [07:00] motorparam3_reg;
  bit [07:00] sysopt1_reg;
  bit [07:00] sysopt2_reg;
  bit [07:00] sysopt3_reg;
  bit [07:00] sysopt4_reg;
  bit [07:00] sysopt5_reg;
  bit [07:00] sysopt6_reg;
  bit [07:00] sysopt7_reg;
  bit [07:00] sysopt8_reg;
  bit [07:00] sysopt9_reg;

  //UVM Automation Macro
  `uvm_object_utils_begin(drv10975_register_map)
    `uvm_field_int(SpdCtrl,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(OverRide,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(enProgKey,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(sleepDis,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Sldata,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(eeRefresh,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(eeWrite,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(OverTemp,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Slp_Stdby,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(OverCurr,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(MtrLck,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(MotorSpeed,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(MotorPeriod,   UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(MotorKt,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(MotorCurrent,  UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(IPDPosition,   UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(SupplyVoltage, UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(SpeedCmd,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(spdCmdBuffer,  UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Lock5,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Lock4,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Fault3,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Lock2,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Lock1,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Lock0,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(DoubleFreq,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Rm,            UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(AdjMode,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Kt,            UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(CtrlAdvMd,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(TCtrlAdv,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(ISDThr,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(IPDAdvcAgl,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(ISDen,         UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(RvsDrEn,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(RvsDrThr,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(OpenLCurr,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(OpenLCurrRt,   UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(BrkDoneThr,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(CtrlCoef,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(StAccel2,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(StAccel,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Op2ClsThr,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(AlignTime,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(LockEn,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(AVSIndEn,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(AVSMEn,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(AVSMMd,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(IPDRlsMd,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(SWiLimitThr,   UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(HWiLimitThr,   UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(LockEn5,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(ClsLpAccel,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(Deadtime,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(IPDCurrThr,    UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(LockEn4,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(VregSel,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(IPDClk,        UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(FGOLsel,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(FGcycle,       UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(KtLckThr,      UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(SpdCtrlMd,     UVM_DEFAULT | UVM_NOPRINT)
    `uvm_field_int(CLoopDis,      UVM_DEFAULT | UVM_NOPRINT)
  `uvm_object_utils_end

  //Constructor
  function new(string name = "drv10975_register_map");
    bit temp;

    super.new(name);

    motorparam1_reg = `MOTORPARAM1_DEFAULT;
    motorparam2_reg = `MOTORPARAM2_DEFAULT;
    motorparam3_reg = `MOTORPARAM3_DEFAULT;
    sysopt1_reg     = `SYSOPT1_DEFAULT;
    sysopt2_reg     = `SYSOPT2_DEFAULT;
    sysopt3_reg     = `SYSOPT3_DEFAULT;
    sysopt4_reg     = `SYSOPT4_DEFAULT;
    sysopt5_reg     = `SYSOPT5_DEFAULT;
    sysopt6_reg     = `SYSOPT6_DEFAULT;
    sysopt7_reg     = `SYSOPT7_DEFAULT;
    sysopt8_reg     = `SYSOPT8_DEFAULT;
    sysopt9_reg     = `SYSOPT9_DEFAULT;

    temp = reg_write(`MOTORPARAM1, motorparam1_reg);
    temp = reg_write(`MOTORPARAM2, motorparam2_reg);
    temp = reg_write(`MOTORPARAM3, motorparam3_reg);
    temp = reg_write(`SYSOPT1, sysopt1_reg);
    temp = reg_write(`SYSOPT2, sysopt2_reg);
    temp = reg_write(`SYSOPT3, sysopt3_reg);
    temp = reg_write(`SYSOPT4, sysopt4_reg);
    temp = reg_write(`SYSOPT5, sysopt5_reg);
    temp = reg_write(`SYSOPT6, sysopt6_reg);
    temp = reg_write(`SYSOPT7, sysopt7_reg);
    temp = reg_write(`SYSOPT8, sysopt8_reg);
    temp = reg_write(`SYSOPT9, sysopt9_reg);

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
           reg_data = 0;
           reg_read = 0;
         end
    endcase

  endfunction : reg_read

  function bit reg_write(input [7:0] reg_addr, input [7:0] reg_data, bit backdoor_wr = 0);

    //Assume Successful write
    reg_write = 1;

    if(backdoor_wr == 0 && reg_addr inside {[`STATUS : `SPDCMDBUFFER], `FAULTCODE})
    begin
      reg_write = 0;
    end
    else
    begin
      case(reg_addr)
        `SPEEDCTRL1    : {SpdCtrl[7:0]}                                    = reg_data;
        `SPEEDCTRL2    : {OverRide, SpdCtrl[8]}                            = {reg_data[7], reg_data[0]};
        `DEVCTRL       : {enProgKey}                                       = reg_data;
        `EECTRL        : {sleepDis, Sldata, eeRefresh, eeWrite}            = reg_data[7:4];
        `STATUS        : {OverTemp, Slp_Stdby, OverCurr, MtrLck}           = reg_data[7:4];
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
            reg_write = 0;
          end
      endcase

      //EEPROM Update
      if(reg_addr == `EECTRL && eeWrite == 1 && enProgKey == 8'hB6 && Sldata == 1)
      begin
        eeWrite = 0;
        motorparam1_reg = {DoubleFreq, Rm};
        motorparam2_reg = {AdjMode, Kt};
        motorparam3_reg = {CtrlAdvMd, TCtrlAdv};
        sysopt1_reg     = {ISDThr, IPDAdvcAgl, ISDen, RvsDrEn, RvsDrThr};
        sysopt2_reg     = {OpenLCurr, OpenLCurrRt, BrkDoneThr};
        sysopt3_reg     = {CtrlCoef, StAccel2, StAccel};
        sysopt4_reg     = {Op2ClsThr, AlignTime};
        sysopt5_reg     = {LockEn, AVSIndEn, AVSMEn, AVSMMd, IPDRlsMd};
        sysopt6_reg     = {SWiLimitThr, HWiLimitThr, 1'b0};
        sysopt7_reg     = {LockEn5, ClsLpAccel, Deadtime};
        sysopt8_reg     = {IPDCurrThr, LockEn4, VregSel, IPDClk};
        sysopt9_reg     = {FGOLsel, FGcycle, KtLckThr, SpdCtrlMd, CLoopDis};
      end
    end

  endfunction : reg_write

  function reset();
    {SpdCtrl[7:0]}                                    = 'h0;
    {OverRide, SpdCtrl[8]}                            = 'h0;
    {enProgKey}                                       = 'h0;
    {sleepDis, Sldata, eeRefresh, eeWrite}            = 'h0;
    {OverTemp, Slp_Stdby, OverCurr, MtrLck}           = 'h0;
    {MotorSpeed[15:8]}                                = 'h0;
    {MotorSpeed[7:0]}                                 = 'h0;
    {MotorPeriod[15:0]}                               = 'h0;
    {MotorPeriod[7:0]}                                = 'h0;
    {MotorKt[15:0]}                                   = 'h0;
    {MotorKt[7:0]}                                    = 'h0;
    {MotorCurrent[10:8]}                              = 'h0;
    {MotorCurrent[7:0]}                               = 'h0;
    {IPDPosition}                                     = 'h0;
    {SupplyVoltage}                                   = 'h0;
    {SpeedCmd}                                        = 'h0;
    {spdCmdBuffer}                                    = 'h0;
    {Lock5, Lock4, Fault3, Lock2, Lock1, Lock0}       = 'h0;
    {DoubleFreq, Rm}                                  = motorparam1_reg;
    {AdjMode, Kt}                                     = motorparam2_reg;
    {CtrlAdvMd, TCtrlAdv}                             = motorparam3_reg;
    {ISDThr, IPDAdvcAgl, ISDen, RvsDrEn, RvsDrThr}    = sysopt1_reg;
    {OpenLCurr, OpenLCurrRt, BrkDoneThr}              = sysopt2_reg;
    {CtrlCoef, StAccel2, StAccel}                     = sysopt3_reg;
    {Op2ClsThr, AlignTime}                            = sysopt4_reg;
    {LockEn, AVSIndEn, AVSMEn, AVSMMd, IPDRlsMd}      = sysopt5_reg;
    {SWiLimitThr, HWiLimitThr}                        = sysopt6_reg[7:1];
    {LockEn5, ClsLpAccel, Deadtime}                   = sysopt7_reg;
    {IPDCurrThr, LockEn4, VregSel, IPDClk}            = sysopt8_reg;
    {FGOLsel, FGcycle, KtLckThr, SpdCtrlMd, CLoopDis} = sysopt9_reg;
  endfunction : reset 

endclass : drv10975_register_map

`endif

