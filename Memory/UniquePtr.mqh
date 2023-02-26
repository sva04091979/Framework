#include "../Common.mqh"

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
   void operator =(Type* ptr) {Reset(ptr);}
   bool operator !() {return !m_ptr;}
   bool IsInit() const {return m_ptr!=NULL;}
};
//--------------------------------------------------------------------------
template<typename Type>
void TUniquePtr::Reset(Type* ptr=NULL){
   if (ptr==m_ptr) return;
   DEL(m_ptr);
   m_ptr=ptr;
}
