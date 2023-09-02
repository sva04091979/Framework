struct TTimeConst{
   static const ulong min;
   static const ulong hour;
   static const ulong day;   
};
//------------------------------
const ulong TTimeConst::min = 60;
const ulong TTimeConst::hour = TTimeConst::min * 60;
const ulong TTimeConst::day = TTimeConst::hour *24;