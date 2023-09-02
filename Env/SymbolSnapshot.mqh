#include "../Common/Types.mqh"

class TSymbolSnapshot{
public:
   TSymbolSnapshot(){Reset(NULL);}
   TSymbolSnapshot(string symbol){Reset(symbol);}
   TSymbolSnapshot(const TSymbolSnapshot& other) {this=other; Refresh();}
   void Reset(string symbol);
   string Symbol() const {return m_symbol==NULL?_Symbol:m_symbol;}
   double Ask() const {return m_info.ask;}
   double Bid() const {return m_info.bid;}
   double Last() const {return m_info.last;}
   double Price(_tDirect direct) {return direct==_eUp?Ask():Bid();}
   MqlTick Info() const {return m_info;}  
   bool Refresh() {return SymbolInfoTick(m_symbol,m_info);}
private:
   MqlTick m_info;
   string m_symbol;
};
//----------------------------------------------
void TSymbolSnapshot::Reset(string symbol){
   m_symbol=symbol;
   Refresh();
}