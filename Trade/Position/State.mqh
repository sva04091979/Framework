#include "../../Mask.mqh"

#include "../State.mqh"

struct TPositionChangeFlag: public TTradeChangeFlag{
   static bool IsTicket(_tSizeT flag) {return bool(flag&ticket);}   

   static const _tSizeT ticket;
};

const _tSizeT TPositionChangeFlag::ticket =TTradeChangeFlag::end<<0;

class TPositionState{
public:
   TPositionState() {Reset();}
   static TPositionState* MakeByTicket(_tTicket ticket);
   static TPositionState* MakeByID(_tTicket id);
   static long Get(ENUM_POSITION_PROPERTY_INTEGER id) {return PositionGetInteger(id);}
   static double Get(ENUM_POSITION_PROPERTY_DOUBLE id) {return PositionGetDouble(id);}
   static string Get(ENUM_POSITION_PROPERTY_STRING id) {return PositionGetString(id);}
   static bool SelectByTicket(_tTicket ticket) {return PositionSelectByTicket(ticket);}
   static bool SelectByID(_tTicket id);
   _tSizeT Refresh();
private:
   void Reset();
   _tSizeT CheckSimple();
   _tSizeT CheckHard();
private:
   double m_volume;
   double m_openPrice;
   double m_sl;
   double m_tp;
   datetime m_openTime;
   TPositionState* m_prevState;
   ulong m_openTimeMs;
   _tTicket m_ticket;
   _tTicket m_id;
};
//----------------------------------------
TPositionState* TPositionState::MakeByTicket(_tTicket ticket){
   if (!SelectByTicket(ticket))
      return NULL;
   return new TPositionState();
}
//----------------------------------------
TPositionState* TPositionState::MakeByID(_tTicket id){
   if (!SelectByID(id))
      return NULL;
   return new TPositionState();
}
//----------------------------------------
bool TPositionState::SelectByID(ulong id){
   for (int i=PositionsTotal()-1;i>=0;--i){
      ulong ticket=PositionGetTicket(i);
      if (!ticket)
         continue;
      if (Get(POSITION_IDENTIFIER) == id)
         return true;
   }
   return false;
}
//----------------------------------------
_tSizeT TPositionState::Refresh(){
   if (SelectByTicket(m_ticket)){
      ulong timeMS = Get(POSITION_TIME_MSC);
      if (timeMS != m_openTimeMs)
         return CheckSimple();
   }
   else if (SelectByID(m_id)){
      return CheckHard();
   }
   return TPositionChangeFlag::disappear;
}
//----------------------------------------
void TPositionState::Reset(){
   m_volume = Get(POSITION_VOLUME);
   m_openPrice = Get(POSITION_PRICE_OPEN);
   m_sl = Get(POSITION_SL);
   m_tp = Get(POSITION_TP);
   m_openTime = (datetime)Get(POSITION_TIME);
   m_openTimeMs = (ulong)Get(POSITION_TIME_MSC);
   m_ticket = (_tTicket)Get(POSITION_TICKET);
   m_id = (_tTicket)Get(POSITION_IDENTIFIER);
};