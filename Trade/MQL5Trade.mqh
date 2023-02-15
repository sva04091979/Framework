#include "ITrade.mqh"
#include "../Container/LinkedListNode.mqh"
class TTrade:public ITrade{
public:
   bool Control() override {/*TODO*/ return false;}
   _tDirect Direct() const override {/*TODO*/ return _eNoDirect;}
 };