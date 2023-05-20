#include "../Common/Mask.mqh"

struct TTradeError{
public:
   static string Text(const TMask& err) {return Text(err.Get());}
   static string Text(_tSizeT err);
public:
   static const _tSizeT symbol;
   static const _tSizeT volume;
};
//-------------------------------------------
// static
string TTradeError::Text(_tSizeT err){
   if (!err) return "No error.";
   string ret="Errors:";
   if (bool(err&symbol)) ret+=" symbol not available,";
   if (bool(err&volume)) ret+=" wrong volume,";
   StringSetCharacter(ret,StringLen(ret)-1,'.');
   return ret;
}
//-------------------------------------------
const _tSizeT TTradeError::symbol=0x1;
const _tSizeT TTradeError::volume=0x2;