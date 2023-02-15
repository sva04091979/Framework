#include "../Common.mqh"

class TSymbol{
   string                  m_symbol;
   int                     m_lotDigits;
   double                  m_lotStep;
   double                  m_lotMax;
   double                  m_lotMin;
   double                  m_tickSize;
   double                  m_point;
   double                  m_stopLevel;
   double                  m_freezeLevel;
   int                     m_digits;
   ENUM_SYMBOL_TRADE_EXECUTION   m_executionMode;
   bool                    m_isInit;
#ifdef __MQL5__
   ENUM_ACCOUNT_MARGIN_MODE      m_marginMode;
   int                           m_expirationMode;
   int                           m_fillingMode;
   int                           m_orderMode;
#endif   
public:
   TSymbol():m_isInit(false){}
   TSymbol(string symbol=NULL) {m_isInit=Init(symbol);}
   double NormalizePrice(double price) {return NormalizeDouble(MathRound(price/m_tickSize)*m_tickSize,m_digits);}
   bool              Init(string symbol);
   string Symbol() const {return m_symbol;}
   int LotDigits() const {return m_lotDigits;}
   double LotStep() const {return m_lotStep;}
   double LotMax() const {return m_lotMax;}
   double LotMin() const {return m_lotMin;}
   double TickSize() const {return m_tickSize;}
   double Point() const {return m_point;}
   double StopLevel() const {return m_stopLevel;}
   double FreezeLevel() const {return m_freezeLevel;}
   int Digits() const {return m_digits;}
   ENUM_SYMBOL_TRADE_EXECUTION   ExecutionMode() const {return m_executionMode;}
   bool IsInit() const {return m_isInit;}
   double Ask() const {return ::Ask(m_symbol);}
   double Bid() const {return ::Bid(m_symbol);}
#ifdef __MQL5__
   ENUM_ACCOUNT_MARGIN_MODE MarginMode() const {return m_marginMode;}
   int ExpirationMode() const {return m_expirationMode;}
   int FillingMode() const {return m_fillingMode;}
   int OrderMode() const {return m_orderMode;}
   bool IsNetting() const {return m_marginMode!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;}
#endif   
};
bool TSymbol::Init(string symbol){
   if (symbol==NULL||symbol=="") symbol=_Symbol;
   if (!MQLInfoInteger(MQL_TESTER)&&!SymbolSelect(symbol,true)) return false;
   m_symbol=symbol;
   m_lotStep=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_STEP);
   m_lotDigits=MathMax(-(int)MathFloor(MathLog10(m_lotStep)),0);
   m_lotMax=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_MAX);
   m_lotMin=SymbolInfoDouble(m_symbol,SYMBOL_VOLUME_MIN);
   m_point=SymbolInfoDouble(m_symbol,SYMBOL_POINT);
   m_tickSize=SymbolInfoDouble(m_symbol,SYMBOL_TRADE_TICK_SIZE);
   m_stopLevel=SymbolInfoInteger(m_symbol,SYMBOL_TRADE_STOPS_LEVEL)*m_point;
   m_freezeLevel=SymbolInfoInteger(m_symbol,SYMBOL_TRADE_FREEZE_LEVEL)*m_point;
   m_digits=(int)SymbolInfoInteger(m_symbol,SYMBOL_DIGITS);
   m_executionMode=(ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(m_symbol,SYMBOL_TRADE_EXEMODE);
#ifdef __MQL5__
   m_marginMode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   m_fillingMode=(int)SymbolInfoInteger(m_symbol,SYMBOL_FILLING_MODE);
   m_expirationMode=(int)SymbolInfoInteger(m_symbol,SYMBOL_EXPIRATION_MODE);
   m_orderMode=(int)SymbolInfoInteger(m_symbol,SYMBOL_ORDER_MODE);
#endif 
   return true;}