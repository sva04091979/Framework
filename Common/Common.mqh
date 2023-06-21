#ifdef __DEBUG__
   #define DEL(ptr) do if (ptr) delete ptr; while(false)
#else
   #define DEL(ptr) delete ptr
#endif

#define DELETE(ptr) do {DEL(ptr); ptr=NULL;} while(false)

#define DLOG Print
#define QUOTES(text) #text

#define _rv(dVal) (TRVWrape(dVal)).cVal

template<typename T>
class __TRVWrape{
public:
   T m_val;
   TRVWrape(T val):m_val(val){}
   TRVWrape(TRVWrape& other){this=other;}
};

template<typename T>
__TRVWrape<T> TRVWrape(T val){
   __TRVWrape)<T> ret(val);
   return ret;
}