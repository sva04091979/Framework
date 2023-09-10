#ifdef __MQL5__
   #define _tSizeT ulong
   #define _tPtrDiff long
   #define _tTicket ulong
#else
   #define _tSizeT uint
   #define _tPtrDiff int
#endif

#define _tVoidPtr _tSizeT

enum ECompare{
   e_compareLess=-1,
   e_compareEqually=0,
   e_compareMore=1
};

#define _tCompare ECompare
#define _eMore e_compareMore
#define _eEqually e_compareEqually
#define _eLess e_compareLess

#define _tDirect _tCompare
#define _eUp _eMore
#define _eNoDirect _eEqually
#define _eDown _eLess

enum EBiDirect{
   e_directDown=-1,
   e_directUp=1
};

#define _tBiDirect EBiDirect
#define _eBiUp e_directUp
#define _eBiDown e_directDown