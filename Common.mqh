#include "Types.mqh"

#ifdef __DEBUG__
   #define DEL(ptr) do if (ptr) delete ptr; while(false)
#else
   #define DEL(ptr) delete ptr
#endif

#define DELETE(ptr) do {DEL(ptr); ptr=NULL;} while(false)
#define DLOG Print

double Ask(const string& symbol) {return SymbolInfoDouble(symbol,SYMBOL_ASK);}
double Bid(const string& symbol) {return SymbolInfoDouble(symbol,SYMBOL_BID);}