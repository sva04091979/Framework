#include "../Common/Mask.mqh"

enum ETradeError{
   e_TradeErrorSymbol=  0x1<<0,
   e_TradeErrorType=    0x1<<1,
   e_TradeErrorVolume=  0x1<<2,
   e_TradeErrorPrice=   0x1<<3,
   e_TradeErrorSL=      0x1<<4,
   e_TradeErrorTP=      0x1<<5
};

class TTradeError:public TMaskInt{
public:
   static string Text(ETradeError code);
};
//------------------------------------------
string TTradeError::Text(ETradeError code){
   switch(code){
      case e_TradeErrorSymbol: return "symbol error";
      case e_TradeErrorType: return "wrong type";
      case e_TradeErrorVolume: return "wrong volume";
      case e_TradeErrorPrice: return "wrong open price";
      case e_TradeErrorSL: return "wrong sl";
      case e_TradeErrorTP: return "wrong tp";
   }
   return NULL;
}