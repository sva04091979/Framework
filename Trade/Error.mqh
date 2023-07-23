#include "../Common/Mask.mqh"

enum ETradeError{
   eTradeErrorSymbol=0x1   <<0,
   eTradeErrorType=0x1     <<1,
   eTradeErrorVolume=0x1   <<2,
   eTradeErrorPrice=0x1    <<3,
   eTradeErrorSL=0x1       <<4,
   eTradeErrorTP=0x1       <<5
};

class TTradeError:public TMask{
public:
   static string Text(ETradeError code);
};
//------------------------------------------
string TTradeError::Text(ETradeError code){
   switch(code){
      case eTradeErrorSymbol: return "symbol error";
      case eTradeErrorType: return "wrong type";
      case eTradeErrorVolume: return "wrong volume";
      case eTradeErrorPrice: return "wrong open price";
      case eTradeErrorSL: return "wrong sl";
      case eTradeErrorTP: return "wrong tp";
   }
   return NULL;
}