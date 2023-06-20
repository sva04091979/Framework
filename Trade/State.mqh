#include "../Common/Mask.mqh"

enum ETradeState{
   eTradeStateStart=0x1,
   eTradeStatePending=0x2,
   eTradeStateOpen=0x4,
   eTradeStateClose=0x8,
   eTradeStateError=0x10,
   eTradeStateInMarket=eTradeStatePending | eTradeStateOpen,
   eTradeStateFinish=eTradeStateClose | eTradeStateError
};

class TTradeState:public TMask{
public:
   bool HasStarted() const {return Has(eTradeStateStart);}
   bool HasPending() const {return Has(eTradeStatePending);}
   bool HasOpened() const {return Has(eTradeStateOpen);}
   bool WasInMarket() const {return Has(eTradeStateInMarket);}
   bool HasFinished() const {return Has(eTradeStateFinish);}
   bool HasError() const {return Has(eTradeStateError);}
};