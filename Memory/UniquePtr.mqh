#include "../Common/Common.mqh"

template<typename Type>
struct TUniquePtr{
private:
   Type* m_ptr;
public:
   TUniquePtr():m_ptr(NULL){}
   TUniquePtr(Type* ptr):m_ptr(ptr){}
  ~TUniquePtr() {DEL(m_ptr);}
   const Type* Get() const {return m_ptr;}
   Type* Get() {return m_ptr;}
   void Reset(Type* ptr=NULL);
   Type* Release();
   void Swap(TUniquePtr<Type>& other);
   void operator =(Type* ptr) {Reset(ptr);}
   bool operator !() {return !m_ptr;}
   bool IsInit() const {return m_ptr!=NULL;}
   bool operator ==(const TUniquePtr<Type>& other) const {return m_ptr==other.m_ptr;}
   bool operator !=(const TUniquePtr<Type>& other) const {return m_ptr!=other.m_ptr;}
};
//--------------------------------------------------------------------------
template<typename Type>
void TUniquePtr::Reset(Type* ptr=NULL){
   if (ptr==m_ptr) return;
   DEL(m_ptr);
   m_ptr=ptr;
}
//---------------------------------------------------------------------------
template<typename Type>
Type* TUniquePtr::Release(){
   Type* ret=m_ptr;
   m_ptr=NULL;
   return ret;
}
//------------------------------------------------------------------------------
template<typename Type>
void TUniquePtr::Swap(TUniquePtr<Type>& other){
   if (this!=other){
      Type* tmp=m_ptr;
      m_ptr=other.m_ptr;
      other.m_ptr=tmp;
   }
}

template<typename Type>
void Swap(TUniquePtr<Type>& l,TUniquePtr<Type>& r) {l.Swap(r);}