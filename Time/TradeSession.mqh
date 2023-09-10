#include "Common.mqh"
#include "TimerDuration.mqh"

class TTradeSession: public TTimerTimeDuration{
public:
   TTradeSession():isFirstInit(false){Init(_Symbol);}
   TTradeSession(string symbol):isFirstInit(false){Init(symbol);}
   bool Init(string symbol);
   bool IsInit() const {return m_symbol!="";}
   datetime SessionStart() const {return m_sessionStart;}
   datetime SessionStop() const {return m_sessionStop;}  
private:
   static void StopTimerFunc(void* self,const void*,datetime time) {dynamic_cast<TTradeSession*>(self).StopTimer(time);}
   bool SetDuration(datetime time);
   bool IsTradeTime() const {return m_isFirstChecked;}
   void StopTimer(datetime time);
private:
   string m_symbol;
   datetime m_sessionStart;
   datetime m_sessionStop;
   uint m_i;
   bool isFirstInit;
};
//------------------------------------------------
bool TTradeSession::Init(string symbol){
   if (symbol==m_symbol)
      return true;
   m_i=0;
   m_sessionStart=0;
   m_sessionStop=0;
   if (!SymbolInfoInteger(symbol,SYMBOL_EXIST)){
      m_symbol="";
      return false;
   }
   m_symbol=symbol;
   if (!isFirstInit){
      isFirstInit = true;
      m_stop.EventTimer.Add(&this,StopTimerFunc);
   }
   return SetDuration(TimeCurrent());
}
//---------------------------------------------------
void TTradeSession::StopTimer(datetime time){
   ++m_i;
   SetDuration(time);
}
//---------------------------------------------------
bool TTradeSession::SetDuration(datetime time){
   m_sessionStart=0;
   m_sessionStop=0;
   datetime thisDay=datetime(time/TTimeConst::day*TTimeConst::day);
   ENUM_DAY_OF_WEEK day=DayOfWeak(time);
   ENUM_DAY_OF_WEEK dayStart=day;
   datetime timeStart=0;
   datetime timeStop=0;
   uint i=0;
   while(true){
      while(SymbolInfoSessionTrade(m_symbol,day,m_i,timeStart,timeStop)){
         if (time < thisDay+timeStop){
            if (!m_sessionStart){
               m_sessionStart=thisDay+timeStart;
            }
            else if (m_sessionStop < thisDay+timeStart){
               return Duration(m_sessionStart,m_sessionStop).Start();
            }
            m_sessionStop=thisDay+timeStop;
         }
         ++m_i;
      }
      if (!m_i && m_sessionStart){
         return Duration(m_sessionStart,m_sessionStop).Start();
      }
      thisDay+=(datetime)TTimeConst::day;
      m_i=0;
      day=NextDayOfWeak(day);
      if (day==dayStart)
         break;
   }
   if (m_sessionStart)
      return Duration(m_sessionStart,m_sessionStop=(datetime)LONG_MAX).Start();
   return false;
}