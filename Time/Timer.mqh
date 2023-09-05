#include "../Event.mqh"

template<typename Type>
class TTimerBase{
   _tEvent2(__STDTimer,Type,Type);
public:
   Event__STDTimer Event;
public:
   TTimerBase() {Reset();}
   void Reset();
   void Check(Type currentValue);
   void Check() {_Check();}
   ulong Step() const {return m_step;}
   Type WaitFor() const {return m_checkPoint;}
   TTimerBase* Step(ulong step);
   TTimerBase* WaitFor(Type checkPoint) {m_checkPoint=checkPoint; return &this;}
   bool IsStarted() const {return m_isStart;}
   void Start() {m_isStart=true;}
   void Stop() {m_isStart=false;}
 private:
   virtual void _Check() = 0;
private:
   ulong m_step;
   Type m_checkPoint;
   bool m_isStart;
};
//----------------------------------------
template<typename Type>
void TTimerBase::Reset(){
   m_step=0;
   m_checkPoint=0;
   m_isStart=false;
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
      Event.Invoke(m_checkPoint,currentValue);
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
      m_startTime(TimeCurrent()),
      m_isTester((bool)MQLInfoInteger(MQL_TESTER)){}
private:
   void _Check() override {
      if (m_isTester)
         TTimerBase<ulong>::Check((TimeCurrent()-m_startTime)*1000);         
      else  
         TTimerBase<ulong>::Check(GetTickCount64());
   }
private:
   datetime m_startTime;
   bool m_isTester;
};

class TTimerTime:public TTimerBase<datetime>{
public:
   TTimerTime():TTimerBase<datetime>(){}
private:
   void _Check() override {TTimerBase<datetime>::Check(TimeCurrent());}
};