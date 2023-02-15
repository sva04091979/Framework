#include "Types.mqh"

#ifdef __DEBUG__
   #define DEL(ptr) do if (ptr) delete ptr; while(false)
#else
   #define DEL(ptr) delete ptr
#endif

#define DELETE(ptr) do {DEL(ptr); ptr=NULL;} while(false)