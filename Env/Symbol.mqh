#include  "../Math/Compare.mqh"

#include "SymbolSnapshot.mqh"

class TSymbol{
public:
   TSymbol() {Reset(_Symbol);}
   TSymbol(string symbol){Reset(symbol);}
   void Reset(string symbol);
   TSymbolSnapshot* Refresh();
   const TSymbolSnapshot* State() const {return &m_snapshot;}
   TSymbolSnapshot* State() {return &m_snapshot;}  
   string Symbol() const {return m_symbol;};
   double Ask() const {return SymbolInfoDouble(m_symbol,SYMBOL_ASK);}
   double Bid() const {return SymbolInfoDouble(m_symbol,SYMBOL_BID);}
   double Last() const {return SymbolInfoDouble(m_symbol,SYMBOL_LAST);}
   double Price(_tDirect direct) const {return direct==_eUp?Ask():Bid();}
   double AskFast() const {return m_snapshot.Ask();}
   double BidFast() const {return m_snapshot.Bid();}
   double LastFast() const {return m_snapshot.Last();}
   double PriceFast(_tDirect direct) const {return direct==_eUp?AskFast():BidFast();}
   double Ask(bool isFast) const {return isFast?AskFast():Ask();}
   double Bid(bool isFast) const {return isFast?BidFast():Bid();}
   double Last(bool isFast) const {return isFast?LastFast():Last();}
   double Price(_tDirect direct,bool isFast) const {return isFast?PriceFast(direct):Price(direct);}
   double Point() const {return m_point;}
   double LotMin() const {return m_minLot;}
   double LotMax() const {return m_maxLot;}
   double LotStep() const {return m_lotStep;}
   int StopLevel() const {return m_stopLevel;}
   int FreezeLevel() const {return m_freezeLevel;}
   double StopLevelDelta() const {return m_stopLevelDelta;}
   double FreezeLevelDelta() const {return m_freezeLevelDelta;}
   int Digits() const {return m_digits;}
   int LotDigits() const {return m_lotDigits;}
   _tCompare ComparePrice(double l,double r) const {return Compare(l,r,m_digits);}
   _tCompare CompareAsk(double price) const {return Compare(price,Ask());}
   _tCompare CompareBid(double price) const {return Compare(price,Bid());}
   _tCompare CompareAskFast(double price) const {return Compare(price,AskFast());}
   _tCompare CompareBidFast(double price) const {return Compare(price,BidFast());}
   _tCompare CompareAsk(double price,bool isFast) const {return Compare(price,Ask(isFast));}
   _tCompare CompareBid(double price,bool isFast) const {return Compare(price,Bid(isFast));}
   bool Has() const {return m_has;}
   bool CheckVolume(double volume) const {return Compare(volume,m_minLot,m_lotDigits)!=_eLess && Compare(volume,m_maxLot,m_lotDigits)!=_eMore;}
   bool CheckStopLevel(double price1,double price2) const {return CheckStopLevel(price1-price2);}
   bool CheckStopLevel(double delta) const {return Compare(MathAbs(delta),m_stopLevelDelta)!=_eLess;}
   bool CheckStopLevel(int delta) const {return Compare(MathAbs(delta),m_stopLevel)!=_eLess;}   
   bool CheckFreezeLevel(double price1,double price2) const {return CheckFreezeLevel(price1-price2);}
   bool CheckFreezeLevel(double delta) const {return Compare(MathAbs(delta),m_freezeLevelDelta)!=_eLess;}
   bool CheckFreezeLevel(int delta) const {return Compare(MathAbs(delta),m_freezeLevel)!=_eLess;}
   bool CheckMinLot(double volume) const {return Compare(volume,m_minLot,m_lotDigits)!=_eLess;}
   bool CheckMaxLot(double volume) const {return Compare(volume,m_maxLot,m_lotDigits)!=_eMore;}
   long Integer(ENUM_SYMBOL_INFO_INTEGER e) const {return SymbolInfoInteger(m_symbol,e);}
   double Double(ENUM_SYMBOL_INFO_DOUBLE e) const {return SymbolInfoDouble(m_symbol,e);}
   string String(ENUM_SYMBOL_INFO_STRING e) const {return SymbolInfoString(m_symbol,e);}
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
   int m_stopLevel;
   int m_freezeLevel;
   bool m_has;
};
//--------------------------------------------
void TSymbol::Reset(string symbol){
   m_symbol=symbol;
   m_has=(bool)Integer(SYMBOL_EXIST);
   if (!m_has)
      return;
   m_point=Double(SYMBOL_POINT);
   m_digits=(int)Integer(SYMBOL_DIGITS);
   m_minLot=Double(SYMBOL_VOLUME_MIN);
   m_maxLot=Double(SYMBOL_VOLUME_MAX);
   m_lotStep=Double(SYMBOL_VOLUME_STEP);
   m_lotDigits=MathMax(-(int)MathFloor(MathLog10(m_lotStep)),0);
   m_stopLevel=(int)Integer(SYMBOL_TRADE_STOPS_LEVEL);
   m_freezeLevel=(int)Integer(SYMBOL_TRADE_FREEZE_LEVEL);
   m_stopLevelDelta=m_stopLevel*m_point;
   m_freezeLevelDelta=m_freezeLevel*m_point;
   m_snapshot.Reset(symbol);
}
//--------------------------------------------
TSymbolSnapshot* TSymbol::Refresh(void){
   return m_snapshot.Refresh()?
      &m_snapshot:NULL;
}