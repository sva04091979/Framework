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
   static string ClientName() {return m_clientName;}
   static string ServerName() {return m_server;}
   static string Currency() {return m_currency;};
   static string CompanyName() {return m_company;}
   static double Ballance() {return AccountInfoDouble(ACCOUNT_BALANCE);}
   static double Credit() {return AccountInfoDouble(ACCOUNT_CREDIT);}
   static double Profit() {return AccountInfoDouble(ACCOUNT_PROFIT);}
   static double Equity() {return AccountInfoDouble(ACCOUNT_EQUITY);}
   static double Margin() {return AccountInfoDouble(ACCOUNT_MARGIN);}
   static double MarginFree() {return AccountInfoDouble(ACCOUNT_MARGIN_FREE);}
   static double MarginLevel() {return AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);}
   static double MarginCall() {return AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);}
   static double MarginStopOut() {return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);}
#ifdef __MQL5__
   static double MarginInitial() {return AccountInfoDouble(ACCOUNT_MARGIN_INITIAL);}
   static double MarginMaintenance() {return AccountInfoDouble(ACCOUNT_MARGIN_MAINTENANCE);}
   static double Assets() {return AccountInfoDouble(ACCOUNT_ASSETS);}
   static double Liabilities() {return AccountInfoDouble(ACCOUNT_LIABILITIES);}
   static double CommissionBlocked() {return AccountInfoDouble(ACCOUNT_COMMISSION_BLOCKED);}
   static ENUM_ACCOUNT_MARGIN_MODE MarginMode() {return m_marginMode;}
   static int CurrencyDigits() {return m_curDigits;}
   static bool IsFIFO() {return m_isFIFO;}
   static bool IsHedgeAlloed() {return m_isHedgeAlloed;}
   static bool IsNetting() {return m_marginMode!=ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;}
#else
   static double FreeMarginMode() {return m_freeMarginMode;}
#endif
private:
   static const string m_clientName;
   static const string m_server;
   static const string m_currency;
   static const string m_company;
   static const long m_id;
   static const ENUM_ACCOUNT_TRADE_MODE m_tradeMode;
#ifdef __MQL5__
   static const int m_curDigits;
   static const ENUM_ACCOUNT_MARGIN_MODE m_marginMode;
   static const bool m_isFIFO;
   static const bool m_isHedgeAlloed;
#else
   static const double m_freeMarginMode;
#endif
};

const long TAccount::m_id=AccountInfoInteger(ACCOUNT_LOGIN);
const ENUM_ACCOUNT_TRADE_MODE TAccount::m_tradeMode=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
const string TAccount::m_clientName=AccountInfoString(ACCOUNT_NAME);
const string TAccount::m_server=AccountInfoString(ACCOUNT_SERVER);
const string TAccount::m_currency=AccountInfoString(ACCOUNT_CURRENCY);
const string TAccount::m_company=AccountInfoString(ACCOUNT_COMPANY);
#ifdef __MQL5__
const ENUM_ACCOUNT_MARGIN_MODE TAccount::m_marginMode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
const int TAccount::m_curDigits=(int)AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS);
const bool TAccount::m_isFIFO=(bool)AccountInfoInteger(ACCOUNT_FIFO_CLOSE);
const bool TAccount::m_isHedgeAlloed=(bool)AccountInfoInteger(ACCOUNT_HEDGE_ALLOWED);
#else
const double TAccount::m_freeMarginMode=AccountFreeMarginMode();
#endif