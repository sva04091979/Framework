#include "../Event.mqh"

template<typename Type>
class TTimerBase{
   _tEvent2(__STDTimer,const void*,Type);
   _tEvent1(__STDDestroy,const void*);
   _tEvent1(__STDStart,const void*);
   _tEvent1(__STDStop,const void*);
public:
   Event__STDTimer EventTimer;
   Event__STDDestroy EventDestroy;
   Event__STDStart EventStart;
   Event__STDStart EventStop;   
public:
   TTimerBase() {Reset();}
   void Reset();
   void Check(Type currentValue);
   void Check() {_Check();}
   ulong Step() const {return m_step;}
   Type WaitUntil() const {return m_checkPoint;}
   TTimerBase* Step(ulong step);
   TTimerBase* WaitUntil(Type checkPoint) {m_checkPoint=checkPoint; return &this;}
   bool IsStarted() const {return m_isStart;}
   bool Start() {return State(true);}
   bool Stop() {return State(false);}
   bool State(bool isStart);
 private:
   virtual void _Check() = 0;
private:
   ulong m_step;
   Type m_checkPoint;
   bool m_isStart;
};
//----------------------------------------
template<typename Type>
TTimerBase::~TTimerBase(){
   EventDestroy.Invoke(&this);
   Stop();
}
//----------------------------------------
template<typename Type>
void TTimerBase::Reset(){
   Stop();
   m_step=0;
   m_checkPoint=0;
}
//----------------------------------------
template<typename Type>
bool TTimerBase::State(bool isStart){
   if (isStart==m_isStart)
      return true;
   if (isStart){
      if (m_checkPoint){
         m_isStart = true;
         EventStart.Invoke(&this);
         return true;
      }
      return false;
   }
   else{
      m_isStart = false;
      EventStop.Invoke(&this);
      return true;
   }
}
//----------------------------------------
template<typename Type>
TTimerBase* TTimerBase::Step(ulong step){
   if (step==m_step)
      return &this;
   if (m_step && m_checkPoint){
      if (step < m_step)
         m_checkPoint-=(Type)MathMin(m_checkPoint,m_step-step);
      else
         m_checkPoint+=Type(step-m_step);
   }
   m_step=step;
   return &this;
}
//----------------------------------------
template<typename Type>
void TTimerBase::Check(Type currentValue){
   if (!m_checkPoint || currentValue < m_checkPoint)
      return;
   if (m_isStart)
      EventTimer.Invoke(&this,currentValue);
   if (!m_step)
      m_checkPoint=0;
   else{
      ulong div=(currentValue-m_checkPoint)%m_step;
      m_checkPoint=currentValue+(Type)(m_step-div);
   }
}

class TTimerMilli:public TTimerBase<ulong>{
public:
   TTimerMilli():TTimerBase<ulong>(),
      m_startTime(m_isTester?TimeCurrent():0){}
private:
   void _Check() override {
      if (m_isTester)
         TTimerBase<ulong>::Check((TimeCurrent()-m_startTime)*1000);         
      else  
         TTimerBase<ulong>::Check(GetTickCount64());
   }
private:
   datetime m_startTime;
   static const bool m_isTester;
};

const bool TTimerMilli::m_isTester=(bool)MQLInfoInteger(MQL_TESTER);

class TTimerTime:public TTimerBase<datetime>{
public:
   TTimerTime():TTimerBase<datetime>(){}
private:
   void _Check() override {TTimerBase<datetime>::Check(TimeCurrent());}
};