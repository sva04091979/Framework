#include "Types.mqh"
#include "../Common.mqh"
#include "../Memory.mqh"
#include "../Symbol.mqh"

class TTradeInitParam{
public:
   double volume;
   double price;
   _tDirect direct;
   TTradeInitParam():volume(0.0),price(0.0),direct(_eNoDirect){}
   TTradeInitParam(const TTradeInitParam& o) {this=o;}
};

class ITrade{
protected:
   TSharedPtr<TSymbol> m_symbol;
   TUniquePtr<TTradeInitParam> m_initParam;
   bool m_isRun;
public:
   virtual bool Control() =0;
   virtual _tDirect Direct() const =0;
   virtual bool IsFinish() const =0;
   virtual bool IsOpen() const =0;
   virtual bool _Run() =0;
public:
   bool HasRun() const {return m_isRun;}
   bool HasInit() const {return m_symbol.IsInit()&&m_symbol.Get().IsInit();}
   bool HasSetParam() const {const TTradeInitParam* p=m_initParam.Get(); return p!=NULL&&p.volume>0.0&&p.direct!=_eNoDirect;}
   bool Init(string symbol=NULL,TTradeInitParam* set=NULL);
   bool Run() {return m_isRun=_Run();}
   ITrade* Volume(double volume) {if (HasInit()&&!HasRun()) m_initParam.Get().volume=volume; return &this;}
   ITrade* Price(double price) {if (HasInit()&&!HasRun()) m_initParam.Get().price=price; return &this;}
   ITrade* Direct(_tDirect direct) {if (HasInit()&&!HasRun()) m_initParam.Get().direct=direct; return &this;}
#ifdef __MQL5__
   bool IsNetting() const {return m_symbol.Get().IsNetting();}
#endif
protected:
   ITrade();
};
//------------------------------------------------------------
ITrade::ITrade(void):m_symbol(NULL),m_isRun(false){}
//------------------------------------------------------------
bool ITrade::Init(string symbol,TTradeInitParam* set=NULL){
   m_symbol.Reset(new TSymbol(symbol));
   bool ret=m_symbol.Get().IsInit();
   if (ret){
      if (!set) set=new TTradeInitParam();
      m_initParam.Reset(set);
   }
   return ret;
}