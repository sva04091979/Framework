#include "Timer.mqh"

template<typename TimerType, typename Type>
class TTimerDuration{
   _tEvent2(__STDTimer,const void*,Type);
   _tEvent1(__STDDestroy,const void*);
   _tEvent1(__STDStart,const void*);
   _tEvent1(__STDStop,const void*);
public:
   Event__STDTimer EventTimerFirst;
   Event__STDTimer EventTimerSecond;   
   Event__STDDestroy EventDestroy;
   Event__STDStart EventStart;
   Event__STDStart EventStop;
public:
   TTimerDuration();
   ~TTimerDuration();
   TTimerDuration* First(Type val) {m_start.WaitUntil(val); return &this;}
   TTimerDuration* Second(Type val) {m_stop.WaitUntil(val); return &this;}
   TTimerDuration* Duration(Type first, Type second) {return First(first).Second(second);}
   TTimerDuration* Step(ulong val) {m_start.Step(val); m_stop.Step(val); return &this;}
   bool Start() {return State(true);}
   bool Stop() {return State(false);}
   bool State(bool isStart);
   bool IsStarted() {return m_isStart;}
   bool IsFirstChecked() const {return m_isFirstChecked;}
   bool IsSecondChecked() const {return m_isSecondChecked;}
   void Check(Type currentValue);
   void Check() {_Check();}
private:
   static void StartTimerFunc(void* self,const void*,Type curValue) {dynamic_cast<TTimerDuration*>(self).StartInvoke(curValue);}
   static void StopTimerFunc(void* self,const void*,Type curValue) {dynamic_cast<TTimerDuration*>(self).StopInvoke(curValue);}
   void StartInvoke(Type curValue);
   void StopInvoke(Type curValue);   
   virtual void _Check() = 0;
protected:
   TimerType m_start;
   TimerType m_stop;
   bool m_isStart;
   bool m_isFirstChecked;
   bool m_isSecondChecked;
};
//--------------------------------------------
template<typename TimerType, typename Type>
TTimerDuration::TTimerDuration():
   m_isStart(false),
   m_isFirstChecked(false),
   m_isSecondChecked(false){
   m_start.EventTimer.Add(&this,StartTimerFunc);
   m_stop.EventTimer.Add(&this,StopTimerFunc);   
}
//--------------------------------------------
template<typename TimerType, typename Type>
TTimerDuration::~TTimerDuration(){
   Stop();
   EventDestroy.Invoke(&this);
}
//--------------------------------------------
template<typename TimerType, typename Type>
bool TTimerDuration::State(bool isStart){
   if (isStart==m_isStart)
      return true;
   if (isStart){
      if (m_start.WaitUntil()>=m_stop.WaitUntil())
         return false;
      if (m_start.Start()&&m_stop.Start()){
         m_isStart = true;
         EventStart.Invoke(&this);
         return true;
      }
      Stop();
      return false;
   }
   else{
      m_start.Stop();
      m_stop.Stop();
      m_isStart = false;
      EventStop.Invoke(&this);
      return true;
   }
}
//--------------------------------------------
template<typename TimerType, typename Type>
void TTimerDuration::StartInvoke(Type curValue){
   m_isFirstChecked = true;
   m_isSecondChecked = false;
   EventTimerFirst.Invoke(&this,curValue);
}
//--------------------------------------------
template<typename TimerType, typename Type>
void TTimerDuration::StopInvoke(Type curValue){
   m_isSecondChecked = true;
   m_isFirstChecked = false;
   EventTimerSecond.Invoke(&this,curValue);
}
//--------------------------------------------
template<typename TimerType, typename Type>
void TTimerDuration::Check(Type curValue){
   if (m_isStart){
      m_start.Check(curValue);
      m_stop.Check(curValue);
   }
}

class TTimerTimeDuration:public TTimerDuration<TTimerTime,datetime>{
private:
   void _Check() override {TTimerDuration<TTimerTime,datetime>::Check(TimeCurrent());}
};