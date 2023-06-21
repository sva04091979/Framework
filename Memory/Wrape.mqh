#include "../Common/Common.mqh"

template<typename Type>
class TWrape{
public:
   TWrape(){}
   TWrape(const Type& _obj):obj(_obj){}
public:
   Type obj;
};