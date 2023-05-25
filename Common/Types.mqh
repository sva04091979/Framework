#ifdef __MQL5__
   #define _tSizeT ulong
   #define _tPtrDiff long
#else
   #define _tSizeT uint
   #define _tPtrDiff int
#endif

#define _tVoidPtr _tSizeT

enum ECompare{
   ECompareLess=-1,
   ECompareEqually=0,
   ECompareMore=1
};

#define _tCompare ECompare
#define _eMore ECompareMore
#define _eEqually ECompareEqually
#define _eLess ECompareLess

#define _tDirect _tCompare
#define _eUp _eMore
#define _eNoDirect _eEqually
#define _eDown _eLess