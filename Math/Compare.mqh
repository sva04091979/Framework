#include "../Common/Types.mqh"

template<typename Type1,typename Type2>
_tCompare Compare(Type1 l,Type2 r){
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

_tCompare CompareEps(double l, double r) {return Compare(l,r,DBL_EPSILON);}

_tCompare CompareEps(float l, double r) {return Compare(l,r,DBL_EPSILON);}

_tCompare CompareEps(double l, float r) {return Compare(l,r,DBL_EPSILON);}

template<typename Type>
_tCompare CompareEps(Type l, double r){return Compare(l,r,DBL_EPSILON);}

template<typename Type>
_tCompare CompareEps(double l, Type r){return Compare(l,r,DBL_EPSILON);}

template<typename Type>
_tCompare CompareEps(Type l, float r){return Compare(l,r,FLT_EPSILON);}

template<typename Type>
_tCompare CompareEps(float l, Type r){return Compare(l,r,FLT_EPSILON);}