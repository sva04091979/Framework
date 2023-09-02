#include  "../Math/Compare.mqh"

#include "SymbolSnapshot.mqh"

class TSymbol{
public:
   TSymbol() {Reset(NULL);}
   TSymbol(string symbol){Reset(symbol);}
   void Reset(string symbol);
   TSymbolSnapshot* Refresh();
   const TSymbolSnapshot* State() const {return &m_snapshot;}
   TSymbolSnapshot* State() {return &m_snapshot;}  
   string Symbol() const {return m_symbol==NULL?_Symbol:m_symbol;};
   double Ask() const {return Get(SYMBOL_ASK);}
   double Bid() const {return Get(SYMBOL_BID);}
   double Last() const {return Get(SYMBOL_LAST);}
   double Price(_tDirect direct) const {return direct==_eUp?Ask():Bid();}
   double Point() const {return m_point;}
   double LotMin() const {return m_minLot;}
   double LotMax() const {return m_maxLot;}
   double LotStep() const {return m_lotStep;}
   uint StopLevel() const {return m_stopLevel;}
   uint FreezeLevel() const {return m_freezeLevel;}
   double StopLevelDelta() const {return m_stopLevelDelta;}
   double FreezeLevelDelta() const {return m_freezeLevelDelta;}
   int Digits() const {return m_digits;}
   int LotDigits() const {return m_lotDigits;}
   ENUM_SYMBOL_TRADE_EXECUTION Execution() const {return m_execution;}
   
   _tCompare ComparePrice(double l,double r) const {return Compare(l,r,m_digits);}
   _tCompare CompareAsk(double price) const {return ComparePrice(price,Ask());}
   _tCompare CompareBid(double price) const {return ComparePrice(price,Bid());}
   _tCompare CompareAskFast(double price) const {return ComparePrice(price,m_snapshot.Ask());}
   _tCompare CompareBidFast(double price) const {return ComparePrice(price,m_snapshot.Bid());}
   _tCompare CompareAsk(double price,bool isFast) const {return isFast?CompareAskFast(price):CompareAsk(price);}
   _tCompare CompareBid(double price,bool isFast) const {return isFast?CompareBidFast(price):CompareBid(price);}
   bool Has() const {return m_has;}
   
   
   bool CheckVolume(double volume) const {return Compare(volume,m_minLot,m_lotDigits)!=_eLess && Compare(volume,m_maxLot,m_lotDigits)!=_eMore;}
   bool CheckVolumeFast(double volume) const {return Compare(volume,m_minLot)!=_eLess && Compare(volume,m_maxLot)!=_eMore;}
   
   bool CheckStopLevel(double price1,double price2) const {return CheckStopLevel(price1-price2);}
   bool CheckStopLevel(double delta) const {return Compare(MathAbs(delta),m_stopLevelDelta,m_digits)!=_eLess;}
   bool CheckStopLevel(uint delta) const {return Compare(delta,m_stopLevel)!=_eLess;}   
   
   bool CheckFreezeLevel(double price1,double price2) const {return CheckFreezeLevel(price1-price2);}
   bool CheckFreezeLevel(double delta) const {return Compare(MathAbs(delta),m_freezeLevelDelta,m_digits)!=_eLess;}
   bool CheckFreezeLevel(uint delta) const {return Compare(delta,m_freezeLevel)!=_eLess;}
   
   bool CheckMinLot(double volume) const {return Compare(volume,m_minLot,m_lotDigits)!=_eLess;}
   bool CheckMaxLot(double volume) const {return Compare(volume,m_maxLot,m_lotDigits)!=_eMore;}
   double NormalizeVolume(double volume) const {return NormalizeDouble(volume,m_lotDigits);}
   double NormalizePrice(double price) const {return NormalizeDouble(price,m_digits);}
   
   long Get(ENUM_SYMBOL_INFO_INTEGER e) const {return SymbolInfoInteger(m_symbol,e);}
   double Get(ENUM_SYMBOL_INFO_DOUBLE e) const {return SymbolInfoDouble(m_symbol,e);}
   string Get(ENUM_SYMBOL_INFO_STRING e) const {return SymbolInfoString(m_symbol,e);}
private:
   TSymbolSnapshot m_snapshot;
   string m_symbol;
   double m_point;
   double m_minLot;
   double m_maxLot;
   double m_lotStep;
   double m_stopLevelDelta;
   double m_freezeLevelDelta;
   int m_digits;
   int m_lotDigits;
   uint m_stopLevel;
   uint m_freezeLevel;
   ENUM_SYMBOL_TRADE_EXECUTION m_execution;
   bool m_has;
};
//--------------------------------------------
void TSymbol::Reset(string symbol){
   m_symbol=symbol;
   m_has=m_symbol==NULL || (bool)Get(SYMBOL_EXIST);
   if (!m_has)
      return;
   m_point=Get(SYMBOL_POINT);
   m_digits=(int)Get(SYMBOL_DIGITS);
   m_minLot=Get(SYMBOL_VOLUME_MIN);
   m_maxLot=Get(SYMBOL_VOLUME_MAX);
   m_lotStep=Get(SYMBOL_VOLUME_STEP);
   m_lotDigits=MathMax(-(int)MathFloor(MathLog10(m_lotStep)),0);
   m_stopLevel=(uint)Get(SYMBOL_TRADE_STOPS_LEVEL);
   m_freezeLevel=(uint)Get(SYMBOL_TRADE_FREEZE_LEVEL);
   m_stopLevelDelta=m_stopLevel*m_point;
   m_freezeLevelDelta=m_freezeLevel*m_point;
   m_execution=(ENUM_SYMBOL_TRADE_EXECUTION)Get(SYMBOL_TRADE_EXEMODE);
   m_snapshot.Reset(symbol);
}
//--------------------------------------------
TSymbolSnapshot* TSymbol::Refresh(void){
   return m_snapshot.Refresh()?
      &m_snapshot:NULL;
}