#ifdef __MQL5__

#define __MakeHedgeTradeDefine

#include "TradeMQL5.mqh"

class TTradeHedge:public TTrade{
public:
   
};


ITrade* __MakeHedge(const TTradeInit& init){
   return new TTradeHedge(init);
}

#endif