class TAccount{
public:
   static long ID() {return m_id;}
   static ENUM_ACCOUNT_TRADE_MODE TradeMode() {return m_tradeMode;}
   static bool IsReal() {return m_tradeMode==ACCOUNT_TRADE_MODE_REAL;}
   static long Leverage() {return AccountInfoInteger(ACCOUNT_LEVERAGE);}
   static int LimitOrders() {return (int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS);}
   static ENUM_ACCOUNT_STOPOUT_MODE StopOutMode() {return (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);}
   static bool TradeAlloed() {return (bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED);}
   static bool EATradeAlloed() {return (bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT);}
   static ENUM_ACCOUNT_MARGIN_MODE MarginMode() {return m_marginMode;}
   static bool IsNetting() {return m_marginMode!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;}
   static int CurrencyDigits() {return m_curDigits;}
   static bool IsFIFO() {return m_isFIFO;}
   static bool IsHedgeAlloed() {return m_isHedgeAlloed;}
private:
   static const long m_id;
   static const ENUM_ACCOUNT_TRADE_MODE m_tradeMode;
   static const ENUM_ACCOUNT_MARGIN_MODE m_marginMode;
   static const int m_curDigits;
   static const bool m_isFIFO;
   static const bool m_isHedgeAlloed;
};

const long TAccount::m_id=AccountInfoInteger(ACCOUNT_LOGIN);
const ENUM_ACCOUNT_TRADE_MODE TAccount::m_tradeMode=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
const ENUM_ACCOUNT_MARGIN_MODE TAccount::m_marginMode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
const int TAccount::m_curDigits=(int)AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS);
const bool TAccount::m_isFIFO=(bool)AccountInfoInteger(ACCOUNT_FIFO_CLOSE);
const bool TAccount::m_isHedgeAlloed=(bool)AccountInfoInteger(ACCOUNT_HEDGE_ALLOWED);