#ifdef __MQL5__

#include "ITrade.mqh"

#ifndef __MakeHedgeTradeDefine
ITrade* __MakeHedge(const TTradeInit&);
#endif


class TTrade:public ITrade{

};

ITrade* __MakeTrade(const TTradeInit* init){
   if (init.IsHedge()){
      return __MakeHedge(init);
   }
}

#endif