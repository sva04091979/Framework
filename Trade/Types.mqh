#include "..\Types.mqh"

#ifdef __MQL5__
   #define _tTicket ulong
   #define _tOrderType ENUM_ORDER_TYPE
   #define _tPositionType ENUM_POSITION_TYPE
   #define _tDealType ENUM_DEAL_TYPE
#else
   #define _tTicket int
   #define _tOrderType int
   #define _tPositionType int
   #define ORDER_TYPE_BUY OP_BUY
   #define ORDER_TYPE_SELL OP_SELL
   #define ORDER_TYPE_BUY_LIMIT OP_BUYLIMIT
   #define ORDER_TYPE_BUY_STOP OP_BUYSTOP
   #define ORDER_TYPE_SELL_LIMIT OP_SELLLIMIT
   #define ORDER_TYPE_SELL_STOP OP_SELLSTOP
#endif
