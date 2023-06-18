#include "WeakPtr.mqh"

template<typename Type>
class TEnableSharedFromThis{
protected:
   TEnableSharedFromThis() {}
public:
   static bool __IsIt(const TEnableSharedFromThis*) {return true;}
   static bool __IsIt(const void*) {return false;}
   static void __InitEnableSharedFromThis(TEnableSharedFromThis* obj,TSharedPtr<Type>& ptr) {obj.__SetPtr(ptr);}
   static void __InitEnableSharedFromThis(void* obj,void* ptr) {}
   static TSharedPtr<Type> __CloneEnableSharedFromThis(TEnableSharedFromThis* obj) {return obj.SharedFromThis();}
   static TSharedPtr<Type> __CloneEnableSharedFromThis(void* obj) {return TSharedPtr<Type>();}
   TWeakPtr<Type> WeakFromThis() {return m_val;}
   TSharedPtr<Type> SharedFromThis() {return m_val.Lock();}
   void __SetPtr(TSharedPtr<Type>& ptr) {m_val=ptr;}
private:
   TWeakPtr<Type> m_val;
};

template<typename Type>
bool __IsEnableSharedFromThis(const Type* ptr) {return TEnableSharedFromThis<Type>::__IsIt(ptr);}

template<typename Type>
void __InitEnableSharedFromThis(Type* obj,TSharedPtr<Type>& ptr) {
   TEnableSharedFromThis<Type>::__InitEnableSharedFromThis(obj,ptr);
}

template<typename Type>
TSharedPtr<Type> __CloneEnableSharedFromThis(Type* obj) {
   return TEnableSharedFromThis<Type>::__CloneEnableSharedFromThis(obj);
}