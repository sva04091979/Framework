#include "../../Common/Types.mqh"
#include "../TradeError.mqh"
#include "../TradeWarning.mqh"

class ITrade{
public:
   virtual ITrade* Direct(_tDirect direct) =0;
   virtual ITrade* Symbol(const string& symbol) =0;
   virtual ITrade* Type(ENUM_POSITION_TYPE type) =0;
   virtual ITrade* Type(ENUM_ORDER_TYPE type) =0;
   virtual ITrade* Volume(double volume) =0;
   virtual ITrade* Price(double price) =0;
   virtual _tSizeT CheckErrors() =0;
};