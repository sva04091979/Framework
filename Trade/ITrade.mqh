#define __RunTradeDefine

#include "../Event.mqh"

#include "TradeInit.mqh"

class ITrade{
public:
   ITrade(){}
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
};
ITrade::ITrade(const TTradeInit& tradeInit):
   m_tradeInit(tradeInit){
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
ITrade* ITrade::Run(const TTradeInit& init){
   m_tradeInit=init;
   m_tradeInit.Run(m_error);
   return &this;
}


ITrade* __RunTrade(const TTradeInit& init) {
   return new ITrade(init);
}

ITrade* __RunTrade(ITrade& trade,const TTradeInit&init){
   return trade.Run(init);
}

ITrade::EventEventStaticDestroy ITrade::EventStaticDestroy;
TTradeInit ITrade::m_startTradeInit;