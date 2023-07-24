#include "../Common/Types.mqh"

struct TTradeChangeFlag{
   static bool IsVolume(_tSizeT flag) {return bool(flag&volume);}
   static bool IsPrice(_tSizeT flag) {return bool(flag&price);}
   static bool IsSL(_tSizeT flag) {return bool(flag&sl);}
   static bool IsTP(_tSizeT flag) {return bool(flag&tp);}   
   static bool IsDisappear(_tSizeT flag) {return bool(flag&disappear);}   
   
   static const _tSizeT volume;
   static const _tSizeT price;
   static const _tSizeT sl;
   static const _tSizeT tp;
   static const _tSizeT disappear;

   static const _tSizeT end;
};

const _tSizeT TTradeChangeFlag::volume    =0x1<<0;
const _tSizeT TTradeChangeFlag::price     =0x1<<1;
const _tSizeT TTradeChangeFlag::sl        =0x1<<2;
const _tSizeT TTradeChangeFlag::tp        =0x1<<3;
const _tSizeT TTradeChangeFlag::disappear =0x1<<4;

const _tSizeT TTradeChangeFlag::end       =0x1<<5;

template<typename Type>
class TTradeStateBase{
public:
   Type* Volume(double volume) {SetVolume(volume); return &this;}
   Type* Price(double price) {SetPrice(price); return &this;}
   Type* SL(double sl) {SetSL(sl); return &this;}
   Type* TP(double tp) {SetTP(tp); return &this;}
private:
   virtual void SetVolume(double volume) =0;
   virtual void SetPrice(double price) =0;
   virtual void SetSL(double sl) =0;
   virtual void SetTP(double tp) =0;
};