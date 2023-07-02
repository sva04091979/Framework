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
   ulong Delta() const {return m_step;}
   Type Checkpoint() const {return m_checkPoint;}
   TTimerBase* Step(ulong step) {m_step=step; return &this;}
   TTimerBase* WaitFor(Type checkPoint) {m_checkPoint=checkPoint; return &this;}
private:
   ulong m_step;
   Type m_checkPoint;
};
//----------------------------------------
template<typename Type>
void TTimerBase::Reset(){
   m_step=0;
   m_checkPoint=0;
}
//----------------------------------------
template<typename Type>
void TTimerBase::Check(Type currentValue){
   if (!m_checkPoint || currentValue < m_checkPoint)
      return;
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
   TTimerMilli():TTimerBase<ulong>(){}
   void Check() {TTimerBase<ulong>::Check(GetTickCount());}
};

class TTimerTime:public TTimerBase<datetime>{
public:
   TTimerTime():TTimerBase<datetime>(){}
   void Check() {TTimerBase<datetime>::Check(TimeCurrent());}
};