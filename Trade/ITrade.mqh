#define __RunTradeDefine

#include "../Common/Event.mqh"

#include "TradeInit.mqh"

#ifndef __MakeTradeDefine
class ITrade;
#ifdef __MQL5__
ITrade* __MakeTrade(const TTradeInit&);
#else 
#endif
#endif

class ITrade{
public:
   ITrade():m_isBase(false){}
   ITrade(const TTradeInit& tradeInit);
public:
   _tStaticEvent1(EventStaticDestroy,const ITrade&);
   _tEvent1(EventDestroy,const ITrade&);
public:
   ~ITrade();
// Init section
public:
   static TTradeInit* Make();
   static TTradeInit* Make(string symbol);
public:
   TTradeInit* Init() {return Init(_Symbol);}
   TTradeInit* Init(string symbol);
   ITrade* Run();
   ITrade* Run(const TTradeInit& init);
// Work section
public:
   bool Control();
   bool Close();
   bool Remove();
   bool SL(double sl);
   bool TP(double tp);
   bool SLPoint(uint sl);
   bool TPPoint(uint tp);
   bool SetTral(ITral* tral);
   bool TradeTransaction(const MqlTradeTransaction& trans,
                         const MqlTradeRequest& request,
                         const MqlTradeResult& result);
// Get section
public:
   const TSymbol* SymbolInfo() const {return m_tradeInit.SymbolInfo();}
   string Symbol() const {return SymbolInfo().Symbol();}
   bool HaveError() const {return m_state.HasError();}
   bool HasStarted() const {return m_state.HasStarted();}
   bool HasPending() const {return m_state.HasPending();}
   bool HasOpened() const {return m_state.HasOpened();}
   bool WasInMarket() const {return m_state.WasInMarket();}
   bool HasFinished() const {return m_state.HasFinished();}
private:
   static TTradeInit m_startTradeInit;
   TTradeError m_error;
   TTradeState m_state;
   TTradeInit m_tradeInit;
   TSharedPtr<TSymbol> m_symbol;
   bool m_isBase;
};
//-------------------------------------------
ITrade::ITrade(const TTradeInit& tradeInit):
   m_tradeInit(tradeInit),
   m_symbol(tradeInit.SymbolClone()),
   m_isBase(false){
   m_tradeInit.Run(m_error);
   Control();
}
//--------------------------------------------
TTradeInit* ITrade::Make() {
   m_startTradeInit.Init();
   return &m_startTradeInit;
}
//--------------------------------------------
TTradeInit* ITrade::Make(string symbol) {
   m_startTradeInit.Init(symbol);
   return &m_startTradeInit;
}
//---------------------------------------
ITrade::~ITrade(){
   EventDestroy.Invoke(this);
   EventStaticDestroy.Invoke(this);
}
//----------------------------------------
TTradeInit* ITrade::Init(string symbol){
   m_isBase=true;
   TTradeInit* ret=m_tradeInit.Init(symbol);
   m_symbol.Reset();
   return ret;
}
//----------------------------------------
ITrade* ITrade::Run(const TTradeInit& init){
   if (!m_isBase){
      m_tradeInit=init;
   }
   m_tradeInit.Run(m_error);
   m_symbol=m_tradeInit.SymbolClone();
   Control();
   return &this;
}


ITrade* __RunTrade(const TTradeInit& init) {
   return __MakeTrade(init);
}

ITrade* __RunTrade(ITrade& trade,const TTradeInit&init){
   return trade.Run(init);
}

ITrade::EventEventStaticDestroy ITrade::EventStaticDestroy;
TTradeInit ITrade::m_startTradeInit;