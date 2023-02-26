#ifdef __MQL5__
   #define _tSizeT ulong
   #define _tPtrDiff long
#else
   #define _tSizeT uint
   #define _tPtrDiff int
#endif

#define _tVoidPtr _tSizeT

enum EDirect{
   EDirectDown=-1,
   ENoDirect=0,
   EDirectUp=1
};

#define _tCompare EDirect
#define _eMore EDirectUp
#define _eEqually ENoDirect
#define _eLess EDirectDown

#define _tDirect _tCompare
#define _eUp _eMore
#define _eNoDirect _eEqually
#define _eDown _eLess