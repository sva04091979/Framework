#include "SharedPtr.mqh"

template<typename Type>
struct TWeakPtr{
private:
   __TSharedLinkCounter* m_counter;
   Type* m_ptr;
public:
   TWeakPtr():m_ptr(NULL),m_counter(NULL){}
   TWeakPtr(TSharedPtr<Type> &other);
   TWeakPtr(TWeakPtr<Type> &other);
  ~TWeakPtr();
   void Reset();
   void Swap(TWeakPtr<Type>& other);
   void operator =(TSharedPtr<Type> &other);
   void operator =(TWeakPtr<Type> &other);
   _tSizeT Count() const {return !m_counter?0:m_counter.shared;}
   bool Expired() const {return !Count();}
   TSharedPtr<Type> Lock();
};
//--------------------------------------------------------------------------
template<typename Type>
TWeakPtr::TWeakPtr(TSharedPtr<Type> &other){
   m_ptr=other.Get();
   m_counter=other.Counter();
   if (m_counter!=NULL) ++m_counter.weak;
}
//--------------------------------------------------------------------------
template<typename Type>
TWeakPtr::TWeakPtr(TWeakPtr<Type> &other){
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter!=NULL) ++m_counter.weak;
}
//--------------------------------------------------------------------------
template<typename Type>
TWeakPtr::~TWeakPtr(){
   if (!m_counter)
      return;
   if(!--m_counter.weak)
      if (!m_counter.shared)
         delete m_counter;
}
//--------------------------------------------------------------------------
template<typename Type>
void TWeakPtr::Reset(){
   if (!m_counter)
      return;
   if(!--m_counter.weak)
      if (!m_counter.shared)
         delete m_counter;
   m_counter=NULL;
}
//------------------------------------------------------------------------------
template<typename Type>
void TWeakPtr::Swap(TWeakPtr<Type>& other){
   if (m_ptr!=other.m_ptr){
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
void TWeakPtr::operator =(TSharedPtr<Type> &other){
   if (m_ptr==other.Get()) return;
   if (m_counter!=NULL){
      if(!--m_counter.weak)
         if (!m_counter.shared)
            delete m_counter;
   }
   m_ptr=other.Get();
   m_counter=other.Counter();
   if (m_counter)
      ++m_counter.weak;
}
//--------------------------------------------------------------------------
template<typename Type>
void TWeakPtr::operator =(TWeakPtr<Type> &other){
   if (m_ptr==other.m_ptr) return;
   if (m_counter!=NULL){
      if(!--m_counter.weak)
         if (!m_counter.shared)
            delete m_counter;
   }
   m_ptr=other.m_ptr;
   m_counter=other.m_counter;
   if (m_counter)
      ++m_counter.weak;
}
//---------------------------------------------------------------------------
template<typename Type>
TSharedPtr<Type> TWeakPtr::Lock(){
   if (!m_counter||!m_counter.shared)
      return TSharedPtr<Type>();
   return TSharedPtr<Type>(m_ptr,m_counter);
}

template<typename Type>
void Swap(TWeakPtr<Type>& l,TWeakPtr<Type>& r) {l.Swap(r);}