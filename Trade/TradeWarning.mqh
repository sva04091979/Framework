#include "../Common/Mask.mqh"

struct TTradeWarning{
public:
   static string Text(const TMask& err) {return Text(err.Get());}
   static string Text(_tSizeT err);
public:
   static const _tSizeT volumeMin;
   static const _tSizeT volumeMax;   
};
//-------------------------------------------
// static
string TTradeWarning::Text(_tSizeT err){
   if (!err) return "No error.";
   string ret="Errors:";
   if (bool(err&volumeMin)) ret+=" min volume,";
   if (bool(err&volumeMax)) ret+=" max volume,";
   StringSetCharacter(ret,StringLen(ret)-1,'.');
   return ret;
}
//-------------------------------------------
const _tSizeT TTradeWarning::volumeMin=0x1;
const _tSizeT TTradeWarning::volumeMax=0x2;