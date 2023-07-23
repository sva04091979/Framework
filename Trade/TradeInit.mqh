#include "../Math.mqh"

#include "Define.mqh"
#include "TradeSet.mqh"
#include "Tral.mqh"
#include "State.mqh"
#include "Types.mqh"

class ITrade;

#ifndef __RunTradeDefine
class TTradeInit;
ITrade* __RunTrade(const TTradeInit&);
ITrade* __RunTrade(ITrade&,const TTradeInit&);
#endif

class TTradeInit{
public:
   TTradeInit():m_trade(NULL){}
   TTradeInit(string symbol):m_init(symbol),m_trade(NULL){}
   TTradeInit(ITrade& trade):m_trade(&trade){}
   TTradeInit(string symbol,ITrade& trade):m_init(symbol),m_trade(&trade){}
   TTradeInit(const TTradeInit& other) {this=other;}
// Init section
public:
   TTradeInit* Init() {return Init(_Symbol);}
   TTradeInit* Init(string symbol);
   TTradeInit* Symbol(string symbol);
   TTradeInit* Type(ETradeType type) {m_init.Type(type); return &this;}
   TTradeInit* Type(ENUM_ORDER_TYPE type) {m_init.Type(type); return &this;}
   TTradeInit* Type(_tDirect type) {m_init.Type(type); return &this;}
   TTradeInit* Volume(double volume) {m_init.Volume(volume); return &this;}
   TTradeInit* Price(double price) {m_init.Price(price); return &this;}
   TTradeInit* SL(double sl) {m_init.SL(sl); return &this;}
   TTradeInit* TP(double tp) {m_init.TP(tp); return &this;}
   TTradeInit* SL(uint sl) {m_init.SL(sl); return &this;}
   TTradeInit* TP(uint tp) {m_init.TP(tp); return &this;}
   TTradeInit* StrongTrade(bool isStrong) {m_init.StrongTrade(isStrong); return &this;}
   TTradeInit* StrongPending(bool isStrong) {m_init.StrongPending(isStrong); return &this;}
   TTradeInit* StrongSL(bool isStrong) {m_init.StrongSL(isStrong); return &this;}
   TTradeInit* StrongTP(bool isStrong) {m_init.StrongTP(isStrong); return &this;}
   TTradeInit* StrongVolume(bool isStrong) {m_init.StrongVolume(isStrong); return &this;}
   
   ITrade* Run();
   ITrade* Run(ITrade& trade);
   bool Run(TTradeError& err);
   
   _tSizeT CheckInitSetup();
private:
   void Reset();
// Work sektion
public:
   TSymbolSnapshot* RefreshSymbol() {return m_init.RefreshSymbol();}
// Get section
public:
   TSharedPtr<TSymbol> SymbolClone() const {return m_init.SymbolClone();}
   const TSymbol* SymbolInfo() const {return m_init.SymbolInfo();}
   TSymbolSnapshot* SymbolState() {return m_init.SymbolState();}
   const TSymbolSnapshot* SymbolState() const {return m_init.SymbolState();}
protected:
   TTradeSet m_init;
   ITrade* m_trade;
};
//--------------------------------------
void TTradeInit::Reset(){
   m_init.Reset();
}
//--------------------------------------
TTradeInit* TTradeInit::Init(string symbol){
   Reset();
   return Symbol(symbol);
}
//---------------------------------------
TTradeInit* TTradeInit::Symbol(string symbol){
   m_init.Symbol(symbol);
   return &this;
}
//---------------------------------------
ITrade* TTradeInit::Run(){
   return !m_trade?__RunTrade(this):Run(m_trade);
}
//---------------------------------------
ITrade* TTradeInit::Run(ITrade& trade){
   return __RunTrade(trade,this);
}
//------------------------------------
bool TTradeInit::Run(TTradeError& err){
   return m_init.Run(err);
}
//--------------------------------------
_tSizeT TTradeInit::CheckInitSetup() {
   TTradeError err;
   m_init.CheckSetUp(err);
   return err.Get();
}