#include "Preprocessor.mqh"
#include "Common.mqh"

template<typename FuncType>
class STD_EventStructBase{
public:
   STD_EventStructBase(FuncType _func):func(_func){}
public:
   FuncType func;
};

#define __BaseType STD_EventStructBase<FuncType>
template<typename FuncType>
class STD_EventStructGlobal:public __BaseType{
public:
   STD_EventStructGlobal(FuncType _func):__BaseType(_func){}
};
#undef __BaseType

#define __BaseType STD_EventStructBase<FuncType>
template<typename FuncType>
class STD_EventStructObj:public __BaseType{
public:
   STD_EventStructObj(void* _it,FuncType _func):__BaseType(_func),it(_it){}
public:
   void* it;
};
#undef __BaseType

template<typename FuncGlobalType,typename FuncObjType>
class STD_EventStructHolder{
public:
   STD_EventStructHolder(STD_EventStructGlobal<FuncGlobalType>* global,STD_EventStructHolder* prev):
      m_global(global),m_obj(NULL),m_next(NULL),m_prev(prev){}
   STD_EventStructHolder(STD_EventStructObj<FuncObjType>* obj,STD_EventStructHolder* prev):
      m_global(NULL),m_obj(obj),m_next(NULL),m_prev(prev){}   
   ~STD_EventStructHolder(){
      DEL(m_global);
      DEL(m_obj);
   }
   STD_EventStructHolder* Next() const {return m_next;}
   STD_EventStructHolder* Prev() const {return m_prev;}
   void Next(STD_EventStructHolder* it) {m_next=it;}
   void Prev(STD_EventStructHolder* it) {m_prev=it;}
   bool IsValid() const {return !m_obj || CheckPointer(m_obj.it)!=POINTER_INVALID;}
   bool IsGlobal() const {return !m_obj;}
   bool IsSame(FuncGlobalType func) {return !m_obj&&m_global.func==func;}
   bool IsSame(void* ptr,FuncObjType func) {return !m_global&&m_obj.it==ptr&&m_obj.func==func;}
public:
   STD_EventStructGlobal<FuncGlobalType>* m_global;
   STD_EventStructObj<FuncObjType>* m_obj;
private:
   STD_EventStructHolder* m_next;
   STD_EventStructHolder* m_prev;
};

template<typename FuncGlobalType,typename FuncObjType>
class STD_EventBase{
protected:
   STD_EventStructHolder<FuncGlobalType,FuncObjType>* m_front;
   STD_EventStructHolder<FuncGlobalType,FuncObjType>* m_back;
public:
   STD_EventBase():m_front(NULL),m_back(NULL){}
  ~STD_EventBase(){
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* it=m_front;
      while (it!=NULL){
         void* forDelete=it;
         it=it.Next();
         delete forDelete;
      }
   }
   void Add(void* it,FuncObjType func){
      PushBack(new STD_EventStructObj<FuncObjType>(it,func));
   }
   void Add(FuncGlobalType func){
      PushBack(new STD_EventStructGlobal<FuncGlobalType>(func));
   }
   void Remove(STD_EventStructHolder<FuncGlobalType,FuncObjType>* it){
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* prev = it.Prev();
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* next = it.Next();
      if (!prev) m_front=next;
      else prev.Next(next);
      if(!next) m_back=prev;
      else next.Prev(prev);
      delete it;
   }
   void Remove(void* ptr,FuncObjType func){
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* it=m_back;
      while (it!=NULL){
         if (it.IsSame(ptr,func)){
            Remove(it);            
            break;
         }
         it=it.Prev();
      }      
   }
   void Remove(FuncGlobalType func){
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* it=m_back;
      while (it!=NULL){
         if (it.IsSame(func)){
            Remove(it);            
            break;
         }
         it=it.Prev();
      }         
   }
protected:  
   STD_EventStructHolder<FuncGlobalType,FuncObjType>* Next(STD_EventStructHolder<FuncGlobalType,FuncObjType>* it){
      it=!it?m_front:it.Next();
      if(!it)
         return NULL;
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* prev=it.Prev();
      while(it!=NULL&&!it.IsValid()){
         STD_EventStructHolder<FuncGlobalType,FuncObjType>* next=it.Next();
         if (!prev) m_front=next;
         else prev.Next(next);
         if(!next) m_back=prev;
         else next.Prev(prev);
         delete it;
         it=next;
      }
      return it;
   }
private:
   template<typename Type>
   void PushBack(Type* foo){
      STD_EventStructHolder<FuncGlobalType,FuncObjType>* it=new STD_EventStructHolder<FuncGlobalType,FuncObjType>(foo,m_back);
      if (!m_front){
         m_front=m_back=it;
      }
      else{
         m_back.Next(it);
         it.Prev(m_back);
         m_back=it;
      }
   }
};

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

#define __tEvent4(name,Type1,Type2,Type3,Type4) \
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

#define __tEvent5(name,Type1,Type2,Type3,Type4,Type5) \
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