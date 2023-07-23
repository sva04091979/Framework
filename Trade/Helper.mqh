#include "../Common/Types.mqh"
#include "../Env/Symbol.mqh"
#include "../Math/Compare.mqh"

struct TTradeHelper{
   static bool IsMarketOrder(ENUM_ORDER_TYPE type) {
      return type==ORDER_TYPE_BUY || type==ORDER_TYPE_SELL;
   }
   static _tDirect OrderDirect(ENUM_ORDER_TYPE type);
   static _tDirect PositionDirect(ENUM_POSITION_TYPE type) {
      return type==POSITION_TYPE_BUY?_eUp:_eDown;
   }
};
//------------------------------------------
_tDirect TTradeHelper::OrderDirect(ENUM_ORDER_TYPE type){
   switch(type){
      case ORDER_TYPE_BUY:
      case ORDER_TYPE_BUY_LIMIT:
      case ORDER_TYPE_BUY_STOP:
      case ORDER_TYPE_BUY_STOP_LIMIT: return _eUp;
      case ORDER_TYPE_SELL:
      case ORDER_TYPE_SELL_LIMIT:
      case ORDER_TYPE_SELL_STOP:
      case ORDER_TYPE_SELL_STOP_LIMIT: return _eDown;
      case ORDER_TYPE_CLOSE_BY: return _eNoDirect;
   }
   return _eNoDirect;
}
