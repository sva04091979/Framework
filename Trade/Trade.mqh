#include "Trade/ITrade.mqh"

#ifdef __MQL5__
#else
enum ENUM_POSITION_TYPE{
   POSITION_TYPE_BUY=OP_BUY,
   POSITION_TYPE_SELL=OP_SELL   
};
#endif