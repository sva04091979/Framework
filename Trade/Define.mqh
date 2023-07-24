#include "../Common/Mask.mqh"

enum ETradeType{
   e_TradeTypeError,
   e_TradeTypeAny,
   e_TradeTypePending,
   e_TradeTypeMarket
};

enum EStrongMask{
   e_pendingStrong=0x1<<0,
   e_slStrong     =0x1<<1,
   e_tpStrong     =0x1<<2,
   e_volumeStrong =0x1<<3,
   e_strongMaskEnd=0x1<<4,
   e_strongTradeAll = e_pendingStrong | e_slStrong | e_tpStrong | e_volumeStrong
};