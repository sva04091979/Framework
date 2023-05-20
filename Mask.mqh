#include "Types.mqh"

template<typename Type>
class TMaskBase{
protected:
   TMaskBase():m_mask(0){}
   TMaskBase(Type mask):m_mask(mask){}
   TMaskBase(const TMaskBase& other):m_mask(other.m_mask){}
public:
   TMaskBase* operator=(Type mask){m_mask=mask; return &this;}
   template<typename Type1>
   TMaskBase* operator=(const TMaskBase<Type1>& other){m_mask=other.Get(); return &this;}
   bool Has(Type mask) const {return bool(m_mask&mask);} 
   template<typename Type1>
   bool Has(const TMaskBase<Type1>& other) const {return m_mask.Has(mask.Get());}
   Type Get() const {return m_mask;}
   TMaskBase* operator |= (Type mask) {m_mask|=mask; return &this;}
   template<typename Type1>
   TMaskBase* operator |= (const TMaskBase<Type1>& other) {m_mask|=other.Get(); return &this;}
   TMaskBase* operator &= (Type mask) {m_mask&=mask; return &this;}
   template<typename Type1>
   TMaskBase* operator &= (const TMaskBase<Type1>& other) {m_mask&=other.Get(); return &this;}
   TMaskBase* operator ^= (Type mask) {m_mask^=mask; return &this;}
   template<typename Type1>
   TMaskBase* operator ^= (const TMaskBase<Type1>& other) {m_mask^=other.Get(); return &this;}
   TMaskBase* operator += (Type mask) {m_mask|=mask; return &this;}
   template<typename Type1>
   TMaskBase* operator += (const TMaskBase<Type1>& other) {m_mask|=other.Get(); return &this;}
   TMaskBase* operator -= (Type mask) {m_mask&=(~mask); return &this;}
   template<typename Type1>
   TMaskBase* operator -= (const TMaskBase<Type1>& other) {m_mask&=(~other.Get()); return &this;}
   Type operator ~() const {return ~m_mask;}
   Type operator | (Type mask) const {return m_mask | mask;}
   template<typename Type1>
   Type operator | (const TMaskBase<Type1>& other) const {return m_mask | other.Get();}
   Type operator & (Type mask) const {return m_mask & mask;}
   template<typename Type1>
   Type operator & (const TMaskBase<Type1>& other) const {return m_mask & other.Get();}
   Type operator ^ (Type mask) const {return m_mask ^ mask;}
   template<typename Type1>
   Type operator ^ (const TMaskBase<Type1>& other) const {return m_mask ^ other.Get();}
   bool operator !() const {return !m_mask;}
   bool operator ==(Type mask) const {return m_mask==mask;}
   template<typename Type1>
   bool operator ==(const TMaskBase<Type1>& other) const {return m_mask==other.Get();}
   bool operator !=(Type mask) const {return m_mask!=mask;}
   template<typename Type1>
   bool operator !=(const TMaskBase<Type1>& other) const {return m_mask!=other.Get();}
   bool CheckAdd(Type mask) {bool ret=Has(mask); m_mask|=mask; return ret;}
   template<typename Type1>
   bool CheckAdd(const TMaskBase<Type1>& other) {bool ret=Has(other); m_mask|=other.Get(); return ret;}
   bool CheckRemove(Type mask) {bool ret=Has(mask); m_mask&=(~mask); return ret;}
   template<typename Type1>
   bool CheckRemove(const TMaskBase<Type1>& other) {bool ret=Has(other); m_mask&=(~other.Get()); return ret;}
private:
   Type m_mask;
};

class TMask:public TMaskBase<_tSizeT>{
public:
   TMask():TMaskBase<_tSizeT>(){}
   TMask(_tSizeT mask):TMaskBase<_tSizeT>(mask){}
   template<typename Type1>
   TMask(const TMaskBase<Type1>& other):TMaskBase<_tSizeT>(other){}
};

class TMaskLong:public TMaskBase<ulong>{
public:
   TMaskLong():TMaskBase<ulong>(){}
   TMaskLong(ulong mask):TMaskBase<ulong>(mask){}
   template<typename Type1>
   TMaskLong(const TMaskBase<Type1>& other):TMaskBase<ulong>(other){}
};

class TMaskInt:public TMaskBase<uint>{
public:
   TMaskInt():TMaskBase<uint>(){}
   TMaskInt(uint mask):TMaskBase<uint>(mask){}
   template<typename Type1>
   TMaskInt(const TMaskBase<Type1>& other):TMaskBase<uint>(other){}
};