#include "../Env/Symbol.mqh"
#include "../Memory.mqh"

#include "Define.mqh"
#include "Error.mqh"
#include "Helper.mqh"
#include "TradePoint.mqh"

class TTradeSet{
public:
   TTradeSet():m_symbol(new TSymbol()) {Reset();}
   TTradeSet(string symbol):m_symbol(new TSymbol(symbol)) {Reset();}
   TTradeSet(const TTradeSet& other) {this=other;}
   // Get
   TSharedPtr<TSymbol> Symbol() const {return m_symbol;}
   TSymbolSnapshot* SymbolState() {return m_symbol.Get().State();}
   const TSymbolSnapshot* SymbolState() const {return m_symbol.Get().State();}
   ETradeType Type() const {return m_type;}
   ENUM_ORDER_TYPE OrderType() const {return m_orderType;}
   _tDirect Direct() const {return m_tradeDirect;}
   double Volume() const {return m_tradePoint.volume;}
   double Price() const {return m_tradePoint.price;}
   double SL() const {return m_tradePoint.sl;}
   double TP() const {return m_tradePoint.tp;}
   uint TPPoint() const {return m_tpPoint;}
   uint SLPoint() const {return m_slPoint;}
   bool IsPendingStrong() const {return m_strongMask.Has(e_pendingStrong);}
   bool IsSLStrong() const {return m_strongMask.Has(e_slStrong);}
   bool IsTPStrong() const {return m_strongMask.Has(e_tpStrong);}
   // Set
   void Symbol(string symbol);
   void Type(ETradeType type) {m_type=type;}
   void Type(ENUM_ORDER_TYPE type);
   void Type(_tDirect type) {m_tradeDirect=type;}
   void Volume(double volume) {m_tradePoint.volume=m_symbol.NormalizeVolume(volume);}
   void Price(double price) {m_tradePoint.price=m_symbol.NormalizePrice(price);}
   void SL(double sl) {m_tradePoint.sl=m_symbol.NormalizePrice(sl);}
   void TP(double tp) {m_tradePoint.tp=m_symbol.NormalizePrice(tp);}
   void TPPoint(uint tpPoint) {m_tpPoint=tpPoint;}
   void SLPoint(uint slPoint) {m_slPoint=slPoint;}
   void StrongPending(bool isStrong) {m_strongMask.Set(e_pendingStrong,isStrong);}
   void StrongSL(bool isStrong) {m_strongMask.Set(e_slStrong,isStrong);}
   void StrongTP(bool isStrong) {m_strongMask.Set(e_tpStrong,isStrong);}
   void StrongVolume(bool isStrong) {m_strongMask.Set(e_volumeStrong,isStrong);}
   void StrongTrade(bool isStrong) {m_strongMask.Set(e_strongTradeAll,isStrong);}
   
   void Reset();
   
   bool CheckSetUp(TTradeError& err);
   bool CheckSymbol() const {return m_symbol.Has();}
   _tDirect CheckType() const;
   bool CheckVolume() const {return !m_strongMask.Has(e_volumeStrong) || m_symbol.CheckVolume(m_tradePoint.volume);}
   bool ComputeVolume();
   _tDirect ComputeType();
   
   bool CheckSL() const {return CheckSL(DetectDirect(),OpenPriceNow());}
   bool CheckTP() const {return CheckTP(DetectDirect(),OpenPriceNow());}
   bool CheckPrice() const {return CheckPrice(DetectDirect());}   
   bool CheckPriceFast() const {return CheckPriceFast(DetectDirect());}   
   
   bool CheckPrice(_tDirect direct) const {return CheckPrice(direct,false);}
   bool CheckPriceFast(_tDirect direct) const {return CheckPrice(direct,true);}

   bool CheckSL(_tDirect direct,double openPrice) const;
   bool CheckTP(_tDirect direct,double openPrice) const;
   bool CheckPrice(_tDirect direct,bool isFast) const;

   bool Run(TTradeError& err);
private:
   _tDirect DetectDirect() const;
   double DetectOpenPrice() const;
   double OpenPriceNow() const;
private:
   TSharedPtr<TSymbol> m_symbol;
   TMaskInt m_strongMask;
   TTradePoint m_tradePoint;
   ETradeType m_type;
   ENUM_ORDER_TYPE m_orderType;
   _tDirect m_tradeDirect;
   uint m_slPoint;
   uint m_tpPoint;
   bool m_isOrderTypeSet;
};
//----------------------------------
void TTradeSet::Reset(){
   m_strongMask.Clear();
   m_tradePoint.Reset();
   m_type=e_TradeTypeAny;
   m_tradeDirect=_eNoDirect;
   m_slPoint=0;
   m_tpPoint=0;
   m_isOrderTypeSet=false;
}
//----------------------------------
void TTradeSet::Symbol(string symbol){
   m_symbol.Reset(symbol);
   m_tradePoint.volume=m_symbol.NormalizeVolume(m_tradePoint.volume);
   m_tradePoint.price=m_symbol.NormalizePrice(m_tradePoint.price);
   m_tradePoint.sl=m_symbol.NormalizePrice(m_tradePoint.sl);
   m_tradePoint.tp=m_symbol.NormalizePrice(m_tradePoint.tp);
}
//---------------------------------------
void TTradeSet::Type(ENUM_ORDER_TYPE type) {
   m_orderType=type;
   m_isOrderTypeSet=true;
}
//----------------------------------
bool TTradeSet::CheckSetUp(TTradeError &err) {
   static TTradeError _err;
   _err.Clear();
   m_symbol.Refresh();
   if (!CheckSymbol()) _err+=e_TradeErrorSymbol;
   if (!CheckVolume()) _err+=e_TradeErrorVolume;
   _tDirect direct=CheckType();
   if (!direct){
      err+=e_TradeErrorType | _err.Get();
      return false;
   }
   if (!CheckPriceFast(direct)){
      err+=e_TradeErrorPrice | _err.Get();
      return false;
   }
   double openPrice=DetectOpenPrice();
   if (!openPrice)
      openPrice=m_symbol.State().Price(direct);
   if (!CheckSL(direct,openPrice)) _err+=e_TradeErrorSL;
   if (!CheckTP(direct,openPrice)) _err+=e_TradeErrorTP;
   err+=_err;
   return _err.IsEmpty();
}
//-------------------------------------
bool TTradeSet::Run(TTradeError &err){
   m_symbol.Refresh();
   if (!CheckSymbol()) err+=e_TradeErrorSymbol;
   if (!ComputeVolume()) err+=e_TradeErrorVolume;
   _tDirect direct=ComputeType();
   if (!direct){
      err+=e_TradeErrorType;
      return false;
   }
   if (!CheckPriceFast(direct)){
      err+=e_TradeErrorPrice;
      return false;
   }
   double openPrice=DetectOpenPrice();
   m_price=openPrice;
   if (!openPrice)
      openPrice=m_symbol.State().Price(direct);
   if (!CheckSL(direct,openPrice)) err+=e_TradeErrorSL;
   if (!CheckTP(direct,openPrice)) err+=e_TradeErrorTP;
   return err.IsEmpty();
}
//-------------------------------------
_tDirect TTradeSet::DetectDirect(void) const {
   _tDirect order=m_isOrderTypeSet?TTradeHelper::OrderDirect(m_orderType):_eNoDirect;
   if (order)
      return (!m_tradeDirect || m_tradeDirect==order)?order:_eNoDirect;
   if (m_tradeDirect)
      return m_tradeDirect;
   if (m_tradePoint.price){
      if ()
   }
}
//----------------------------------------
double TTradeSet::DetectOpenPrice(void) const {
   return (m_isOrderTypeSet&&TTradeHelper::IsMarketOrder(m_orderType))?0.0:m_price;
}
//----------------------------------
_tDirect TTradeSet::ComputeType(){
   _tDirect direct=CheckType();
   if (direct)
      m_tradeDirect=direct;
   return direct;
}
//----------------------------------
bool TTradeSet::ComputeVolume() {
   if (!CheckVolume())
      return false;
   if (m_strongMask.Has(e_pendingStrong))
      return true;
   if (!m_symbol.CheckMinLot(m_tradePoint.volume))
      m_tradePoint.volume=m_symbol.LotMin();
   else if (!m_symbol.CheckMaxLot(m_tradePoint.volume))
      m_tradePoint.volume=m_symbol.LotMax();
   return true;
}
//----------------------------------
_tDirect TTradeSet::CheckType() const{
   switch(m_type){
      case e_TradeTypeAny:
         return DetectDirect();
      case e_TradeTypeMarket:
         if (m_isOrderTypeSet){
            if (!TTradeHelper::IsMarketOrder(m_orderType))
               return _eNoDirect;
            return !m_tradeDirect?TTradeHelper::OrderDirect(m_orderType):
               m_tradeDirect==TTradeHelper::OrderDirect(m_orderType)?m_tradeDirect:_eNoDirect;
         }
         return m_tradeDirect;     
      case e_TradeTypePending:
         if (m_isOrderTypeSet){
            if (TTradeHelper::IsMarketOrder(m_orderType))
               return _eNoDirect;
            return !m_tradeDirect?TTradeHelper::OrderDirect(m_orderType):
               m_tradeDirect==TTradeHelper::OrderDirect(m_orderType)?m_tradeDirect:_eNoDirect;
         }
         return m_tradeDirect;
   }
   return _eNoDirect;
}
//----------------------------------
bool TTradeSet::CheckPrice(_tDirect direct,bool isFast) const{
   if (!direct)
      return true;
   switch(m_type){
      case e_TradeTypeAny:
         return !m_price || !m_strongMask.Has(e_pendingStrong) || m_symbol.CheckFreezeLevel(m_symbol.Price(direct,isFast),m_price);
      case e_TradeTypeMarket:
         return true;
      case e_TradeTypePending:
         return m_price>0.0 && (!m_strongMask.Has(e_pendingStrong) || m_symbol.CheckFreezeLevel(m_symbol.Price(direct,isFast),m_price));
   }
   return false;
}
//--------------------------------------
bool TTradeSet::CheckSL(_tDirect direct,double openPrice) const{
   if ((!m_sl && !m_slPoint) || !direct)
      return true;
   if (m_sl<0.0)
      return false;
   if (!m_strongMask.Has(e_slStrong))
      return true;
   if (m_sl>0.0){
      if (m_slPoint>0.0)
         return false;
      return m_symbol.CheckStopLevel(openPrice,m_sl);    
   }
   return m_symbol.CheckStopLevel(m_slPoint);
}
//--------------------------------------
bool TTradeSet::CheckTP(_tDirect direct,double openPrice) const{
   if ((!m_tradePoint.tp && !m_tpPoint) || !direct)
      return true;
   if (m_tradePoint.tp<0.0)
      return false;
   if (!m_strongMask.Has(e_tpStrong))
      return true;
   if (m_tradePoint.tp>0.0){
      if (m_tpPoint>0.0)
         return false;
      return m_symbol.CheckStopLevel(openPrice,m_tp);    
   }
   return m_symbol.CheckStopLevel(m_tpPoint);
}