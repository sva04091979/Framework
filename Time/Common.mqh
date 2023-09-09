struct TTimeConst{
   static const ulong min;
   static const ulong hour;
   static const ulong day;
};
//------------------------------
const ulong TTimeConst::min = 60;
const ulong TTimeConst::hour = TTimeConst::min * 60;
const ulong TTimeConst::day = TTimeConst::hour *24;

ENUM_DAY_OF_WEEK DayOfWeak(datetime time){
   switch(int(time/TTimeConst::day%7)){
      case 0: return THURSDAY;
      case 1: return FRIDAY;
      case 2: return SATURDAY;
      case 3: return SUNDAY;
      case 4: return MONDAY;
      case 5: return TUESDAY;
      case 6: return WEDNESDAY;
   }
   return SUNDAY;
}

ENUM_DAY_OF_WEEK NextDayOfWeak(ENUM_DAY_OF_WEEK day){
   return day==SATURDAY?SUNDAY:ENUM_DAY_OF_WEEK(day+1);
}