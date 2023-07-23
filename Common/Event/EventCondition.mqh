#include "EventBase.mqh"

#define _tEventCondDecl(name) EventCond##name

#define __tEventCond0(STAT,name) \
typedef bool(*__##name##_funcGlobal)(void);\
typedef bool(*__##name##_funcObj)(void*);\
STAT class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if (it.m_global.func()) break;}\
         else if (it.m_obj.func(it.m_obj.it)) break;\
      }\
} name

#define _tEventCond0(name) __tEventCond0(,name)
#define _tStaticEventCond0(name) __tEventCond0(static,name)

#define __tEventCond1(STAT,name,Type1) \
typedef bool(*__##name##_funcGlobal)(Type1);\
typedef bool(*__##name##_funcObj)(void*,Type1);\
STAT class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if it.m_global.func(p1) break;}\
         else if (it.m_obj.func(it.m_obj.it,p1)) break;\
      }\
} name

#define _tEventCond1(name,Type1) __tEventCond1(,name,Type1)
#define _tStaticEventCond1(name,Type1) __tEventCond1(static,name,Type1)

#define __tEventCond2(STAT,name,Type1,Type2) \
typedef bool(*__##name##_funcGlobal)(Type1,Type2);\
typedef bool(*__##name##_funcObj)(void*,Type1,Type2);\
STAT class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if it.m_global.func(p1,p2) break;}\
         else if (it.m_obj.func(it.m_obj.it,p1,p2)) break;\
      }\
} name

#define _tEventCond2(name,Type1,Type2) __tEventCond2(,name,Type1,Type2)
#define _tStaticEventCond2(name,Type1,Type2) __tEventCond2(static,name,Type1,Type2)

#define __tEventCond3(STAT,name,Type1,Type2,Type3) \
typedef bool(*__##name##_funcGlobal)(Type1,Type2,Type3);\
typedef bool(*__##name##_funcObj)(void*,Type1,Type2,Type3);\
STAT class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if it.m_global.func(p1,p2,p3) break;}\
         else if (it.m_obj.func(it.m_obj.it,p1,p2,p3)) break;\
      }\
} name

#define _tEventCond3(name,Type1,Type2,Type3) __tEventCond3(,name,Type1,Type2,Type3)
#define _tStaticEventCond3(name,Type1,Type2,Type3) __tEventCond3(static,name,Type1,Type2,Type3)

#define __tEventCond4(STAT,name,Type1,Type2,Type3,Type4) \
typedef bool(*__##name##_funcGlobal)(Type1,Type2,Type3,Type4);\
typedef bool(*__##name##_funcObj)(void*,Type1,Type2,Type3,Type4);\
class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3,Type4 p4){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if it.m_global.func(p1,p2,p3,p4) break;}\
         else if (it.m_obj.func(it.m_obj.it,p1,p2,p3,p4)) break;\
      }\
} name

#define _tEventCond4(name,Type1,Type2,Type3,Type4) __tEventCond4(,name,Type1,Type2,Type3,Type4)
#define _tStaticEventCond4(name,Type1,Type2,Type3,Type4) __tEventCond4(static,name,Type1,Type2,Type3,Type4)

#define __tEventCond5(STAT,name,Type1,Type2,Type3,Type4,Type5) \
typedef bool(*__##name##_funcGlobal)(Type1,Type2,Type3,Type4,Type5);\
typedef bool(*__##name##_funcObj)(void*,Type1,Type2,Type3,Type4,Type5);\
class EventCond##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3,Type4 p4,Type5 p5){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) {if it.m_global.func(p1,p2,p3,p5) break;}\
         else if (it.m_obj.func(it.m_obj.it,p1,p2,p3,p5)) break;\
      }\
} name

#define _tEventCond5(name,Type1,Type2,Type3,Type4,Type5) __tEventCond5(,name,Type1,Type2,Type3,Type4,Type5)
#define _tStaticEventCond5(name,Type1,Type2,Type3,Type4,Type5) __tEventCond5(static,name,Type1,Type2,Type3,Type4,Type5)