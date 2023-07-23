#include "../Env/Symbol.mqh"
#include "../Memory.mqh"

#include "Define.mqh"
#include "Error.mqh"
#include "Helper.mqh"

class TTradeSet{
public:
   TTradeSet() {Reset();}
   TTradeSet(string symbol):m_symbol(symbol) {Reset();}
   TTradeSet(const TTradeSet& other) {this=other;}
   // Get
   const TSymbol* Symbol() const {return &m_symbol;}
   TSymbolSnapshot* SymbolState() {return m_symbol.State();}
   const TSymbolSnapshot* SymbolState() const {return m_symbol.State();}
   ETradeType Type() const {return m_type;}
   ENUM_ORDER_TYPE OrderType() const {return !m_orderType?ORDER_TYPE_BUY:m_orderType.Get().obj;}
   _tDirect Direct() const {return m_tradeDirect;}
   double Volume() const {return m_volume;}
   double Price() const {return m_price;}
   double SL() const {return m_sl;}
   double TP() const {return m_tp;}
   uint TPPoint() const {return m_tpPoint;}
   uint SLPoint() const {return m_slPoint;}
   bool IsPendingStrong() const {return m_isPendingStrong;}
   bool IsSLStrong() const {return m_isSLStrong;}
   bool IsTPStrong() const {return m_isTPStrong;}
   // Set
   void Symbol(string symbol) {m_symbol.Reset(symbol);}
   void Type(ETradeType type) {m_type=type;}
   void Type(ENUM_ORDER_TYPE type) {m_orderType=new TWrape<ENUM_ORDER_TYPE>(type);}
   void Type(_tDirect type) {m_tradeDirect=type;}
   void Volume(double volume) {m_volume=volume;}
   void Price(double price) {m_price=price;}
   void SL(double sl) {m_sl=sl;}
   void TP(double tp) {m_tp=tp;}
   void TPPoint(uint tpPoint) {m_tpPoint=tpPoint;}
   void SLPoint(uint slPoint) {m_slPoint=slPoint;}
   void StrongPending(bool isStrong) {m_isPendingStrong=isStrong;}
   void StrongSL(bool isStrong) {m_isSLStrong=isStrong;}
   void StrongTP(bool isStrong) {m_isTPStrong=isStrong;}
   void StrongVolume(bool isStrong) {m_isVolumeStrong=isStrong;}
   void StrongTrade(bool isStrong);
   
   void Reset();
   
   bool CheckSetUp(TTradeError& err);
   bool CheckSymbol() const {return m_symbol.Has();}
   _tDirect CheckType() const;
   bool CheckVolume() const {return !m_isVolumeStrong || m_symbol.CheckVolume(m_volume);}
   bool ComputeVolume();
   _tDirect ComputeType();
   
   bool CheckSL() const {return CheckSL(DetectDirect(),OpenPriceNow());}
   bool CheckTP() const {return CheckTP(DetectDirect(),OpenPriceNow());}
   bool CheckPrice() const {return CheckPrice(DetectDirect());}   
   bool CheckPriceFast() const {return CheckPrice(DetectDirect());}   
   
   bool CheckPrice(_tDirect direct) const {return CheckPrice(direct,false);}
   bool CheckPriceFast(_tDirect direct) const {return CheckPrice(direct,true);}

   bool CheckSL(_tDirect direct,double openPrice) const;
   bool CheckTP(_tDirect direct,double openPrice) const;
   bool CheckPrice(_tDirect direct,bool isFast) const;

   bool Run(TTradeError& err);
   TSymbolSnapshot* RefreshSymbol() {return m_symbol.Refresh();}
private:
   _tDirect DetectDirect() const;
   double DetectOpenPrice() const;
   double OpenPriceNow() const;
private:
   TSymbol m_symbol;
   ETradeType m_type;
   TSharedPtr<TWrape<ENUM_ORDER_TYPE>> m_orderType;
   _tDirect m_tradeDirect;
   double m_volume;
   double m_price;
   double m_sl;
   double m_tp;
   uint m_slPoint;
   uint m_tpPoint;
   bool m_isPendingStrong;
   bool m_isSLStrong; 
   bool m_isTPStrong;
   bool m_isVolumeStrong;
};
//----------------------------------
void TTradeSet::Reset(){
   m_type=eTradeTypeAny;
   m_orderType.Reset();
   m_tradeDirect=_eNoDirect;
   m_volume=0.0;
   m_price=0.0;
   m_sl=0.0;
   m_tp=0.0;
   m_slPoint=0;
   m_tpPoint=0;
   m_isPendingStrong=false;
   m_isSLStrong=false;
   m_isTPStrong=false;
   m_isVolumeStrong=false;
}
//----------------------------------
bool TTradeSet::CheckSetUp(TTradeError &err) {
   static TTradeError _err;
   _err.Clear();
   m_symbol.Refresh();
   if (!CheckSymbol()) _err+=eTradeErrorSymbol;
   if (!CheckVolume()) _err+=eTradeErrorVolume;
   _tDirect direct=CheckType();
   if (!direct){
      err+=eTradeErrorType | _err.Get();
      return false;
   }
   if (!CheckPriceFast(direct)){
      err+=eTradeErrorPrice | _err.Get();
      return false;
   }
   double openPrice=DetectOpenPrice();
   if (!openPrice)
      openPrice=m_symbol.PriceFast(direct);
   if (!CheckSL(direct,openPrice)) _err+=eTradeErrorSL;
   if (!CheckTP(direct,openPrice)) _err+=eTradeErrorTP;
   err+=_err;
   return _err.IsEmpty();
}
//-------------------------------------
bool TTradeSet::Run(TTradeError &err){
   m_symbol.Refresh();
   if (!CheckSymbol()) err+=eTradeErrorSymbol;
   if (!ComputeVolume()) err+=eTradeErrorVolume;
   _tDirect direct=ComputeType();
   if (!direct){
      err+=eTradeErrorType;
      return false;
   }
   if (!CheckPriceFast(direct)){
      err+=eTradeErrorPrice;
      return false;
   }
   double openPrice=DetectOpenPrice();
   m_price=openPrice;
   if (!openPrice)
      openPrice=m_symbol.PriceFast(direct);
   if (!CheckSL(direct,openPrice)) err+=eTradeErrorSL;
   if (!CheckTP(direct,openPrice)) err+=eTradeErrorTP;
   return err.IsEmpty();
}
//-------------------------------------
_tDirect TTradeSet::DetectDirect(void) const {
   _tDirect direct=m_orderType.IsInit()?TTradeHelper::OrderDirect(m_orderType.Get().obj):_eNoDirect;
   return !direct?m_tradeDirect:direct==m_tradeDirect?direct:_eNoDirect;
}
//----------------------------------------
double TTradeSet::DetectOpenPrice(void) const {
   return (m_orderType.IsInit()&&TTradeHelper::IsMarketOrder(m_orderType.Get().obj))?0.0:m_price;
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
   if (m_isPendingStrong)
      return true;
   if (!m_symbol.CheckMinLot(m_volume))
      m_volume=m_symbol.LotMin();
   else if (!m_symbol.CheckMaxLot(m_volume))
      m_volume=m_symbol.LotMax();
   return true;
}
//----------------------------------
_tDirect TTradeSet::CheckType() const{
   switch(m_type){
      case eTradeTypeAny:
         return DetectDirect();
      case eTradeTypeMarket:
         if (m_orderType.IsInit()){
            ENUM_ORDER_TYPE type=m_orderType.Get().obj;
            if (!TTradeHelper::IsMarketOrder(type))
               return _eNoDirect;
            return !m_tradeDirect?TTradeHelper::OrderDirect(type):
               m_tradeDirect==TTradeHelper::OrderDirect(type)?m_tradeDirect:_eNoDirect;
         }
         return m_tradeDirect;     
      case eTradeTypePending:
         if (m_orderType.IsInit()){
            ENUM_ORDER_TYPE type=m_orderType.Get().obj;
            if (TTradeHelper::IsMarketOrder(type))
               return _eNoDirect;
            return !m_tradeDirect?TTradeHelper::OrderDirect(type):
               m_tradeDirect==TTradeHelper::OrderDirect(type)?m_tradeDirect:_eNoDirect;
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
      case eTradeTypeAny:
         return !m_price || !m_isPendingStrong || m_symbol.CheckFreezeLevel(m_symbol.Price(direct,isFast),m_price);
      case eTradeTypeMarket:
         return true;
      case eTradeTypePending:
         return m_price>0.0 && (!m_isPendingStrong || m_symbol.CheckFreezeLevel(m_symbol.Price(direct,isFast),m_price));
   }
   return false;
}
//--------------------------------------
bool TTradeSet::CheckSL(_tDirect direct,double openPrice) const{
   if ((!m_sl && !m_slPoint) || !direct)
      return true;
   if (m_sl<0.0)
      return false;
   if (!m_isSLStrong)
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
   if ((!m_tp && !m_tpPoint) || !direct)
      return true;
   if (m_tp<0.0)
      return false;
   if (!m_isTPStrong)
      return true;
   if (m_tp>0.0){
      if (m_tpPoint>0.0)
         return false;
      return m_symbol.CheckStopLevel(openPrice,m_tp);    
   }
   return m_symbol.CheckStopLevel(m_tpPoint);
}
//------------------------------------
void TTradeSet::StrongTrade(bool isStrong){
   m_isPendingStrong=isStrong;
   m_isSLStrong=isStrong;
   m_isTPStrong=isStrong;
   m_isVolumeStrong=isStrong;
}