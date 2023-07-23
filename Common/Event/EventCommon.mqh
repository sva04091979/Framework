#include "EventBase.mqh"

#define _tEventDecl(name) Event##name

#define __tEvent0(STAT,name) \
typedef void(*__##name##_funcGlobal)(void);\
typedef void(*__##name##_funcObj)(void*);\
STAT class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func();\
         else it.m_obj.func(it.m_obj.it);\
      }\
} name

#define _tEvent0(name) __tEvent0(,name)
#define _tStaticEvent0(name) __tEvent0(static,name)

#define __tEvent1(STAT,name,Type1) \
typedef void(*__##name##_funcGlobal)(Type1);\
typedef void(*__##name##_funcObj)(void*,Type1);\
STAT class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func(p1);\
         else it.m_obj.func(it.m_obj.it,p1);\
      }\
} name

#define _tEvent1(name,Type1) __tEvent1(,name,Type1)
#define _tStaticEvent1(name,Type1) __tEvent1(static,name,Type1)

#define __tEvent2(STAT,name,Type1,Type2) \
typedef void(*__##name##_funcGlobal)(Type1,Type2);\
typedef void(*__##name##_funcObj)(void*,Type1,Type2);\
STAT class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func(p1,p2);\
         else it.m_obj.func(it.m_obj.it,p1,p2);\
      }\
} name

#define _tEvent2(name,Type1,Type2) __tEvent2(,name,Type1,Type2)
#define _tStaticEvent2(name,Type1,Type2) __tEvent2(static,name,Type1,Type2)

#define __tEvent3(STAT,name,Type1,Type2,Type3) \
typedef void(*__##name##_funcGlobal)(Type1,Type2,Type3);\
typedef void(*__##name##_funcObj)(void*,Type1,Type2,Type3);\
STAT class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func(p1,p2,p3);\
         else it.m_obj.func(it.m_obj.it,p1,p2,p3);\
      }\
} name

#define _tEvent3(name,Type1,Type2,Type3) __tEvent3(,name,Type1,Type2,Type3)
#define _tStaticEvent3(name,Type1,Type2,Type3) __tEvent3(static,name,Type1,Type2,Type3)

#define __tEvent4(STAT,name,Type1,Type2,Type3,Type4) \
typedef void(*__##name##_funcGlobal)(Type1,Type2,Type3,Type4);\
typedef void(*__##name##_funcObj)(void*,Type1,Type2,Type3,Type4);\
class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3,Type4 p4){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func(p1,p2,p3,p4);\
         else it.m_obj.func(it.m_obj.it,p1,p2,p3,p4);\
      }\
} name

#define _tEvent4(name,Type1,Type2,Type3,Type4) __tEvent4(,name,Type1,Type2,Type3,Type4)
#define _tStaticEvent4(name,Type1,Type2,Type3,Type4) __tEvent4(static,name,Type1,Type2,Type3,Type4)

#define __tEvent5(STAT,name,Type1,Type2,Type3,Type4,Type5) \
typedef void(*__##name##_funcGlobal)(Type1,Type2,Type3,Type4,Type5);\
typedef void(*__##name##_funcObj)(void*,Type1,Type2,Type3,Type4,Type5);\
class Event##name:public STD_EventBase<__##name##_funcGlobal,__##name##_funcObj>{\
public:\
   void Invoke(Type1 p1,Type2 p2,Type3 p3,Type4 p4,Type5 p5){\
      STD_EventStructHolder<__##name##_funcGlobal,__##name##_funcObj>* it=NULL;\
      while((it=Next(it))!=NULL)\
         if (it.IsGlobal()) it.m_global.func(p1,p2,p3,p4,p5);\
         else it.m_obj.func(it.m_obj.it,p1,p2,p3,p4,p5);\
      }\
} name

#define _tEvent5(name,Type1,Type2,Type3,Type4,Type5) __tEvent5(,name,Type1,Type2,Type3,Type4,Type5)
#define _tStaticEvent5(name,Type1,Type2,Type3,Type4,Type5) __tEvent5(static,name,Type1,Type2,Type3,Type4,Type5)