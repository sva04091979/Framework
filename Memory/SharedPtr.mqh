#include "Wraper.mqh"

struct TSharedLinkCounter{
   uint shared;
   uint weak;
   TSharedLinkCounter():shared(0),weak(0){}
   bool operator !() const {return !shared&&!weak;}
};

#define __tCounter TWraper<TSharedLinkCounter>

template<typename Type>
struct TSharedPtr{
private:
   __tCounter* m_counter;
   Type* m_ptr;
public:
   TSharedPtr():m_ptr(NULL),m_counter(NULL){}
   TSharedPtr(Type* ptr):m_ptr(ptr),m_counter(!ptr?NULL:new __tCounter()){if (m_counter) ++m_counter.val.shared;}
   TSharedPtr(TSharedPtr<Type> &other);
   TSharedPtr(Type* ptr,__tCounter* _count):m_ptr(ptr),m_counter(!ptr?NULL:_count){if (m_counter!=NULL) ++m_counter.val.shared;}
  ~TSharedPtr();
   template<typename T1>
   TSharedPtr<T1> StaticCast() {TSharedPtr<T1> ret((T1*)m_ptr,m_counter); return ret;}
   template<typename T1>
   TSharedPtr<T1> DynamicCast() {TSharedPtr<T1> ret(dynamic_cast<T1*>(m_ptr),m_conter); return ret;}
   Type* Get() const {return m_ptr;}
   __tCounter* Counter() const {return m_counter;} 
   void Reset(Type* ptr=NULL);
   void Swap(TSharedPtr<Type>& other);
   void operator =(TSharedPtr<Type> &other);
   void operator =(Type* ptr) {Reset(ptr);}
   _tSizeT Count() {return !m_counter?0:m_counter.val.shared;}
   bool operator !() {return !m_ptr;}
   bool IsInit() const {return m_ptr!=NULL;}
   bool operator ==(const TSharedPtr<Type>& other) const {return m_ptr==other.m_ptr;}
   bool operator !=(const TSharedPtr<Type>& other) const {return m_ptr!=other.m_ptr;}
};
//--------------------------------------------------------------------------
template<typename Type>
TSharedPtr::TSharedPtr(TSharedPtr<Type> &other){
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.val.shared;
}
//---------------------------------------------------------------------------
template<typename Type>
TSharedPtr::~TSharedPtr(){
   if (!m_counter) return;
   if (!--m_counter.val.shared)
      DEL(m_ptr);
   if (!m_counter.val)
      DEL(m_counter);
}
//--------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::Reset(Type* ptr=NULL){
   if (ptr==m_ptr) return;
   if (m_counter!=NULL&&!--m_counter.val.shared){
      DEL(m_ptr);
      if (!m_counter.val)
         DELETE(m_counter);
   }
   m_ptr=ptr;
   if (m_ptr){
      m_counter=new __tCounter();
      ++m_counter.val.shared;
   }
}
//--------------------------------------------------------------------------
//------------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::Swap(TSharedPtr<Type>& other){
   if (this!=other){
      Type* tmpPtr=m_ptr;
      __tCounter* tmpCounter=m_counter;
      m_ptr=other.m_ptr;
      m_counter=other.m_counter;
      other.m_ptr=tmpPtr;
      other.m_counter=tmpCounter;
   }
}
//--------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::operator =(TSharedPtr<Type> &other){
   if (m_ptr==other.m_ptr) return;
   if (m_counter!=NULL&&!--m_counter.val.shared) {
      delete m_ptr;
      if (!m_counter.val)
         delete m_counter;
   }
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.val.shared;
}

template<typename Type>
void Swap(TSharedPtr<Type>& l,TSharedPtr<Type>& r) {l.Swap(r);}

#undef __tCounter;