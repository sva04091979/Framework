#include "Event.mqh"
#include "Singleton.mqh"

enum EStartProgramReason{
   eStartReasonStart,
   eStartReasonChartChange,
   eStartReasonParams
};

class TStartStopController{
   _tStaticEvent1(EStart,ENUM_INIT_RETCODE&);
   _tStaticEvent2(ETimeFrame,ENUM_TIMEFRAMES,ENUM_INIT_RETCODE&);
   _tStaticEvent2(ESymbol,const string&,ENUM_INIT_RETCODE&);
   _tStaticEvent1(EParams,ENUM_INIT_RETCODE&);
   _tStaticEvent1(EClose,int);
   _tStaticEvent1(EDeinit,int);
public:
   static void AddStartFunc(__EStart_funcGlobal func) {EStart.Add(func);}
   static void AddStartFunc(void* ptr,__EStart_funcObj func) {EStart.Add(ptr,func);}
   static void AddTimeFrameFunc(__ETimeFrame_funcGlobal func) {ETimeFrame.Add(func);}
   static void AddTimeFrameFunc(void* ptr,__ETimeFrame_funcObj func) {ETimeFrame.Add(ptr,func);}
   static void AddSymbolFunc(__ESymbol_funcGlobal func) {ESymbol.Add(func);}
   static void AddSymbolFunc(void* ptr,__ESymbol_funcObj func) {ESymbol.Add(ptr,func);}
   static void AddParamsFunc(__EParams_funcGlobal func) {EParams.Add(func);}
   static void AddParamsFunc(void* ptr,__EParams_funcObj func) {EParams.Add(ptr,func);}
   static void AddClose(__EClose_funcGlobal func) {EClose.Add(func);}
   static void AddClose(void* ptr,__EClose_funcObj func) {EClose.Add(ptr,func);}
   static void AddDeinit(__EDeinit_funcGlobal func) {EDeinit.Add(func);}
   static void AddDeinit(void* ptr,__EDeinit_funcObj func) {EDeinit.Add(ptr,func);}
   static void RemoveStartFunc(__EStart_funcGlobal func) {EStart.Remove(func);}
   static void RemoveStartFunc(void* ptr,__EStart_funcObj func) {EStart.Remove(ptr,func);}
   static void RemoveTimeFrameFunc(__ETimeFrame_funcGlobal func) {ETimeFrame.Remove(func);}
   static void RemoveTimeFrameFunc(void* ptr,__ETimeFrame_funcObj func) {ETimeFrame.Remove(ptr,func);}
   static void RemoveSymbolFunc(__ESymbol_funcGlobal func) {ESymbol.Remove(func);}
   static void RemoveSymbolFunc(void* ptr,__ESymbol_funcObj func) {ESymbol.Remove(ptr,func);}
   static void RemoveParamsFunc(__EParams_funcGlobal func) {EParams.Remove(func);}
   static void RemoveParamsFunc(void* ptr,__EParams_funcObj func) {EParams.Remove(ptr,func);}
   static void RemoveClose(__EClose_funcGlobal func) {EClose.Remove(func);}
   static void RemoveClose(void* ptr,__EClose_funcObj func) {EClose.Remove(ptr,func);}
   static void RemoveDeinit(__EDeinit_funcGlobal func) {EDeinit.Remove(func);}
   static void RemoveDeinit(void* ptr,__EDeinit_funcObj func) {EDeinit.Remove(ptr,func);}
   static void InitStartFunc(__EStart_funcGlobal func) {if (m_state==eStartReasonStart) EStart.Add(func);}
   static void InitStartFunc(void* ptr,__EStart_funcObj func) {if (m_state==eStartReasonStart) EStart.Add(ptr,func);}
   static void InitTimeFrameFunc(__ETimeFrame_funcGlobal func) {if (m_state==eStartReasonStart) ETimeFrame.Add(func);}
   static void InitTimeFrameFunc(void* ptr,__ETimeFrame_funcObj func) {if (m_state==eStartReasonStart) ETimeFrame.Add(ptr,func);}
   static void InitSymbolFunc(__ESymbol_funcGlobal func) {if (m_state==eStartReasonStart) ESymbol.Add(func);}
   static void InitSymbolFunc(void* ptr,__ESymbol_funcObj func) {if (m_state==eStartReasonStart) ESymbol.Add(ptr,func);}
   static void InitParamsFunc(__EParams_funcGlobal func) {if (m_state==eStartReasonStart) EParams.Add(func);}
   static void InitParamsFunc(void* ptr,__EParams_funcObj func) {if (m_state==eStartReasonStart) EParams.Add(ptr,func);}
   static void InitClose(__EClose_funcGlobal func) {if (m_state==eStartReasonStart) EClose.Add(func);}
   static void InitClose(void* ptr,__EClose_funcObj func) {if (m_state==eStartReasonStart) EClose.Add(ptr,func);}
   static void InitDeinit(__EDeinit_funcGlobal func) {if (m_state==eStartReasonStart) EDeinit.Add(func);}
   static void InitDeinit(void* ptr,__EDeinit_funcObj func) {if (m_state==eStartReasonStart) EDeinit.Add(ptr,func);}
   static ENUM_INIT_RETCODE OnInit();
   static void OnDeinit(const int reason);
private:
   static string m_symbol;
   static EStartProgramReason m_state;
   static ENUM_TIMEFRAMES m_timeframe;
};
string TStartStopController::m_symbol=_Symbol;
EStartProgramReason TStartStopController::m_state=eStartReasonStart;
ENUM_TIMEFRAMES TStartStopController::m_timeframe=_Period;
TStartStopController::_tEventDecl(EStart) TStartStopController::EStart;
TStartStopController::_tEventDecl(ETimeFrame) TStartStopController::ETimeFrame;
TStartStopController::_tEventDecl(ESymbol) TStartStopController::ESymbol;
TStartStopController::_tEventDecl(EParams) TStartStopController::EParams;
TStartStopController::_tEventDecl(EClose) TStartStopController::EClose;
TStartStopController::_tEventDecl(EDeinit) TStartStopController::EDeinit;
//-----------------------------------------
ENUM_INIT_RETCODE TStartStopController::OnInit(){
   ENUM_INIT_RETCODE ret=INIT_SUCCEEDED;
   switch(m_state){
      case eStartReasonStart:
         EStart.Invoke(ret);
         break;
      case eStartReasonChartChange:
         if (m_timeframe!=_Period){
            ETimeFrame.Invoke(m_timeframe,ret);
            m_timeframe=_Period;
         }
         else{
            ESymbol.Invoke(m_symbol,ret);
            m_symbol=_Symbol;
         }
         break;
      case eStartReasonParams:
         EParams.Invoke(ret);
         break;
   }
   return ret;  
}
//-----------------------------------------------------------------------
void TStartStopController::OnDeinit(const int reason){
   EDeinit.Invoke(reason);
   switch(reason){
      case REASON_PROGRAM:
      case REASON_REMOVE:
      case REASON_RECOMPILE:
      case REASON_CLOSE:
      case REASON_ACCOUNT:
      case REASON_TEMPLATE:
      case REASON_INITFAILED:
      case REASON_CHARTCLOSE:
         EClose.Invoke(reason);
         break;
      case REASON_CHARTCHANGE:
         m_state=eStartReasonChartChange;
         break;
      case REASON_PARAMETERS:
         m_state=eStartReasonParams;
         break;
   }
}