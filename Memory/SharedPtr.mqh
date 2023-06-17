#include "../Common/Common.mqh"
#include "../Common/Types.mqh"

class __TSharedLinkCounter{
public:
   uint shared;
   uint weak;
   __TSharedLinkCounter():shared(0),weak(0){}
};

template<typename Type>
struct TSharedPtr{
private:
   __TSharedLinkCounter* m_counter;
   Type* m_ptr;
public:
   TSharedPtr():m_ptr(NULL),m_counter(NULL){}
   TSharedPtr(Type* ptr):m_ptr(ptr),m_counter(!ptr?NULL:new __TSharedLinkCounter()){if (m_counter) ++m_counter.shared;}
   TSharedPtr(TSharedPtr<Type> &other);
   TSharedPtr(Type* ptr,__TSharedLinkCounter* _count):m_ptr(ptr),m_counter(!ptr?NULL:_count){if (m_counter!=NULL) ++m_counter.shared;}
  ~TSharedPtr();
   template<typename T1>
   TSharedPtr<T1> StaticCast() {TSharedPtr<T1> ret((T1*)m_ptr,m_counter); return ret;}
   template<typename T1>
   TSharedPtr<T1> DynamicCast() {TSharedPtr<T1> ret(dynamic_cast<T1*>(m_ptr),m_conter); return ret;}
   Type* Get() const {return m_ptr;}
   __TSharedLinkCounter* Counter() const {return m_counter;} 
   void Reset(Type* ptr=NULL);
   void Swap(TSharedPtr<Type>& other);
   void operator =(TSharedPtr<Type> &other);
   void operator =(Type* ptr) {Reset(ptr);}
   _tSizeT Count() {return !m_counter?0:m_counter.shared;}
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
   if (m_counter!=NULL) ++m_counter.shared;
}
//---------------------------------------------------------------------------
template<typename Type>
TSharedPtr::~TSharedPtr(){
   if (!m_counter) return;
   if (!--m_counter.shared){
      DEL(m_ptr);
      if (!m_counter.weak)
         DEL(m_counter);
   }
}
//--------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::Reset(Type* ptr=NULL){
   if (ptr==m_ptr) return;
   if (m_counter!=NULL&&!--m_counter.shared){
      DEL(m_ptr);
      if (!m_counter.weak)
         DELETE(m_counter);
   }
   m_ptr=ptr;
   if (m_ptr){
      m_counter=new __TSharedLinkCounter();
      ++m_counter.shared;
   }
}
//--------------------------------------------------------------------------
//------------------------------------------------------------------------------
template<typename Type>
void TSharedPtr::Swap(TSharedPtr<Type>& other){
   if (this!=other){
      Type* tmpPtr=m_ptr;
      __TSharedLinkCounter* tmpCounter=m_counter;
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
   if (m_counter!=NULL&&!--m_counter.shared) {
      delete m_ptr;
      if (!m_counter.weak)
         delete m_counter;
   }
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.shared;
}

template<typename Type>
void Swap(TSharedPtr<Type>& l,TSharedPtr<Type>& r) {l.Swap(r);}

class A{
   int a;
};
