template<typename Type>
class TSingleton:public Type{
private:
   TSingleton(){}
public:
   static Type* Inst();
   TSingleton(const TSingleton& o)=delete;
   Type* operator=(const TSingleton&)=delete;
};
//-------------------------------------------
template<typename Type>
Type* TSingleton::Inst(){
   static Type inst;
   return &inst;
}
