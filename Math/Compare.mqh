#include "../Types.mqh"

template<typename Type1,typename Type2>
_tCompare Compare(Type1 l,Type2 r){
   return l==r?_eEqually:l<r?_eLess:_eMore;
}

template<typename Type1,typename Type2>
_tCompare Compare(const Type1& l,const Type2& r){
   return l==r?_eEqually:l<r?_eLess:_eMore;
}

template<typename Type1,typename Type2>
_tCompare Compare(const Type1& l,Type2 r){
   return l==r?_eEqually:l<r?_eLess:_eMore;
}

template<typename Type1,typename Type2>
_tCompare Compare(Type1 l,const Type2& r){
   return l==r?_eEqually:l<r?_eLess:_eMore;
}

_tCompare Compare(double l,double r,int digits){
   double res=NormalizeDouble(l-r,digits);
   return res==0.0?_eEqually:res<0.0?_eLess:_eMore;
}

_tCompare Compare(double l,double r,double epsilon){
   double res=l-r;
   return MathAbs(res)<=epsilon?_eEqually:l<r?_eLess:_eMore;
}

_tCompare Compare(float l,float r,int digits){
   double res=NormalizeDouble(l-r,digits);
   return res==0.0?_eEqually:res<0.0?_eLess:_eMore;
}

_tCompare Compare(float l,float r,float epsilon){
   float res=l-r;
   return MathAbs(res)<=epsilon?_eEqually:l<r?_eLess:_eMore;
}