template<typename Type>
class TSingleton{
protected:
   TSingleton(){}
public:
   static Type* Inst() {static Type inst; return &inst;}
   TSingleton(const TSingleton& o)=delete;
   Type* operator=(const TSingleton&)=delete;
};
