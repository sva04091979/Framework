#include "Wraper.mqh"

#define __tCounter TWraper<_tSizeT>

template<typename Type>
struct TSharedPtr{
private:
   __tCounter* m_counter;
   Type* m_ptr;
public:
   TSharedPtr():m_ptr(NULL),m_counter(NULL){}
   TSharedPtr(Type* ptr):m_ptr(ptr),m_counter(!ptr?NULL:new __tCounter()){m_counter.val=1;}
   TSharedPtr(Type* ptr,__tCounter* _count):m_ptr(ptr),m_counter(!ptr?NULL:_count){if (m_counter!=NULL) ++m_counter.val;}
   TSharedPtr(TSharedPtr<Type> &other);
  ~TSharedPtr() {if (m_counter!=NULL&&!--m_counter.val) {DEL(m_ptr); DEL(m_counter);}}
   template<typename T1>
   TSharedPtr<T1> StaticCast() {TSharedPtr<T1> ret((T1*)m_ptr,m_counter); return ret;}
   template<typename T1>
   TSharedPtr<T1> DynamicCast() {TSharedPtr<T1> ret(dynamic_cast<T1*>(m_ptr),m_conter); return ret;}
   const Type* Get() const {return m_ptr;}
   Type* Get() {return m_ptr;}
   void Reset(Type* ptr=NULL);
   void operator =(TSharedPtr<Type> &other);
   void operator =(Type* ptr) {Reset(ptr);}
   _tSizeT Count() {return !m_counter?0:m_counter.val;}
   bool operator !() {return !m_ptr;}
};
//--------------------------------------------------------------------------
template<typename Type>
TSharedPtr::TSharedPtr(TSharedPtr<Type> &other){
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.val;}
//--------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::Reset(Type* ptr=NULL){
   if (ptr==m_ptr) return;
   if (m_counter!=NULL&&!--m_counter.val){
      DEL(m_ptr);
      DELETE(m_counter);
   }
   m_ptr=ptr;
   if (m_ptr){
      m_counter=new __tCounter();
      m_counter.val=1;
   }
}
//--------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::operator =(TSharedPtr<Type> &other){
   if (m_ptr==other.m_ptr) return;
   if (m_counter!=NULL&&!--m_counter.val) {delete m_ptr; delete m_counter;}
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.val;
}

#undef __tCounter;