#include "../../Common/StartStopController.mqh"
#include "../../Env/Account.mqh"
#include "../Trade.mqh"

class ITradeController{
public:
   _tEvent0(EFinal);
public:
   virtual ITrade* NewTrade()=0;
   virtual ITrade* NewPosition(string symbol,ENUM_POSITION_TYPE type,double volume) =0;
   virtual ITrade* NewOrder(string symbol,ENUM_ORDER_TYPE type,double volume,double price) =0;
   
   virtual bool CloseAllPositions(ENUM_POSITION_TYPE type,string symbol)=0;
   virtual bool CloseAllPositions(ENUM_POSITION_TYPE type,const string& symbols[])=0;
   virtual bool CloseAllPositions(_tDirect direct,string symbol)=0;
   virtual bool CloseAllPositions(_tDirect direct,const string& symbols[])=0;
   virtual bool CloseAllPositions(string symbol)=0;
   virtual bool CloseAllPositions(const string& symbols[])=0;
   virtual bool CloseAllPositionsExceptSymbol(ENUM_POSITION_TYPE type,string symbol)=0;
   virtual bool CloseAllPositionsExceptSymbol(ENUM_POSITION_TYPE type,const string& symbols[])=0;
   virtual bool CloseAllPositionsExceptSymbol(_tDirect direct,string symbol)=0;
   virtual bool CloseAllPositionsExceptSymbol(_tDirect direct,const string& symbols[])=0;
   virtual bool CloseAllPositionsExceptSymbol(string symbol)=0;
   virtual bool CloseAllPositionsExceptSymbol(const string& symbols[])=0;
   
   virtual bool CloseAllOrders(ENUM_ORDER_TYPE type,string symbol)=0;
   virtual bool CloseAllOrders(const ENUM_ORDER_TYPE& type[],string symbol)=0;
   virtual bool CloseAllOrders(_tDirect direct,string symbol)=0;
   virtual bool CloseAllOrders(ENUM_ORDER_TYPE type,const string& symbols[])=0;
   virtual bool CloseAllOrders(const ENUM_ORDER_TYPE& type[],const string& symbols[])=0;
   virtual bool CloseAllOrders(_tDirect direct,const string& symbols[])=0;
   virtual bool CloseAllOrders(string symbol)=0;
   virtual bool CloseAllOrders(const string& symbols[])=0;
   virtual bool CloseAllOrders(_tDirect direct)=0;   
   virtual bool CloseAllOrdersExceptSymbol(ENUM_ORDER_TYPE type,string symbol)=0;
   virtual bool CloseAllOrdersExceptSymbol(const ENUM_ORDER_TYPE& type[],string symbol)=0;
   virtual bool CloseAllOrdersExceptSymbol(_tDirect direct,string symbol)=0;
   virtual bool CloseAllOrdersExceptSymbol(ENUM_ORDER_TYPE type,const string& symbols[])=0;
   virtual bool CloseAllOrdersExceptSymbol(const ENUM_ORDER_TYPE& type[],const string& symbols[])=0;
   virtual bool CloseAllOrdersExceptSymbol(_tDirect direct,const string& symbols[])=0;
   virtual bool CloseAllOrdersExceptSymbol(string symbol)=0;
   virtual bool CloseAllOrdersExceptSymbol(const string& symbols[])=0;
   
   virtual _tSizeT LoadPositions(_tDirect direct,string symbol)=0;
   virtual _tSizeT LoadPositions(_tDirect direct,const string& symbol[])=0;
   virtual _tSizeT LoadPositionsExceptSymbol(_tDirect direct,string symbol)=0;
   virtual _tSizeT LoadPositionsExceptSymbol(_tDirect direct,const string& symbol)=0;
   
   virtual _tSizeT LoadOrders(_tDirect direct,string symbol)=0;
   virtual _tSizeT LoadOrders(_tDirect direct,const string& symbol)=0;
   virtual _tSizeT LoadOrders(ENUM_ORDER_TYPE direct,string symbol)=0;
   virtual _tSizeT LoadOrders(ENUM_ORDER_TYPE direct,const string& symbol)=0;
   virtual _tSizeT LoadOrdersExceptSymbol(_tDirect direct,string symbol)=0;
   virtual _tSizeT LoadOrdersExceptSymbol(_tDirect direct,const string& symbol)=0;
   
   bool CloseAll() {return CloseAll(_eNoDirect,NULL);}
   bool CloseAll(string symbol) {return CloseAll(_eNoDirect,symbol);}
   bool CloseAll(const string& symbols[]) {return CloseAll(_eNoDirect,symbols);}
   bool CloseAll(_tDirect direct) {return CloseAll(direct,NULL);}
   bool CloseAllExceptSymbol(string symbol) {return CloseAllExceptSymbol(_eNoDirect,symbol);}
   bool CloseAllExceptSymbol(const string& symbols[]) {return CloseAllExceptSymbol(_eNoDirect,symbols);}
#ifdef __MQL5__
   bool CloseAll(_tDirect direct,string symbol);
   bool CloseAll(_tDirect direct,const string& symbols[]);
   bool CloseAllExceptSymbol(_tDirect direct,string symbol);
   bool CloseAllExceptSymbol(_tDirect direct,const string& symbols[]);
#else
   virtual bool CloseAll(_tDirect direct,string symbol)=0;
   virtual bool CloseAll(_tDirect direct,const string& symbols[])=0;
   virtual bool CloseAllExceptSymbol(_tDirect direct,string symbol)=0;
   virtual bool CloseAllExceptSymbol(_tDirect direct,const string& symbols[])=0;
#endif
protected:
   ITradeController();
   ~ITradeController();
private:
   static void CloseProgram(void* it,int reason) {dynamic_cast<ITradeController*>(it).EFinal.Invoke();}
};
//------------------------------------------
ITradeController::ITradeController(void){
   TStartStopController::AddClose(&this,CloseProgram);
}
//------------------------------------------
ITradeController::~ITradeController(){
   EFinal.Invoke();
}
//---------------------------------------------
bool ITradeController::CloseAll(_tDirect direct,string symbol){
   bool ret=CloseAllPositions(direct,symbol);
   ret=CloseAllOrders(direct,symbol)&&ret;
   return ret;
}
//---------------------------------------------
bool ITradeController::CloseAll(_tDirect direct,const string& symbols[]){
   bool ret=CloseAllPositions(direct,symbols);
   ret=CloseAllOrders(direct,symbols)&&ret;
   return ret;
}
//---------------------------------------------
bool ITradeController::CloseAllExceptSymbol(_tDirect direct,string symbol){
   bool ret=CloseAllPositionsExceptSymbol(direct,symbol);
   ret=CloseAllOrdersExceptSymbol(direct,symbol)&&ret;
   return ret;
}
//---------------------------------------------
bool ITradeController::CloseAllExceptSymbol(_tDirect direct,const string& symbols[]){
   bool ret=CloseAllPositionsExceptSymbol(direct,symbols);
   ret=CloseAllOrdersExceptSymbol(direct,symbols)&&ret;
   return ret;
}
//---------------------------------------------
//ITrade* ITradeController::NewPosition(const string &symbol,ENUM_POSITION_TYPE type,double volume){
//   return NewTrade().Symbol(symbol).Type(type).Volume(volume).CheckErrors();
//}
//---------------------------------------------
//TNewTradeResult ITradeController::NewOrder(const string &symbol,ENUM_ORDER_TYPE type,double volume,double price){
//   return NewTrade().Symbol(symbol).Type(type).Volume(volume).Price(price).CheckErrors();
//}