#include "IteratorBase.mqh"

template<typename Type>
struct TArrayIterator:TIterator<TIteratorArrayNode<Type>>{
   TArrayIterator(TIteratorArrayNode<Type>* node,void* container):TIterator<TIteratorArrayNode<Type>>(node,container){}
   TArrayIterator(const TArrayIterator<Type>& o):TIterator<TIteratorArrayNode<Type>>(o){}
   void operator =(const TArrayIterator& o){this=o;}
   TIteratorArrayNode<Type>* operator ++(){
      m_node=m_node.Next();
      return m_node;
   }
   TIteratorArrayNode<Type>* operator ++(int){
      TIteratorArrayNode<Type>* ret=m_node;
      m_node=m_node.Next();
      return ret;
   }
   TIteratorArrayNode<Type>* operator --(){
      m_node=m_node.Prev();
      return m_node;
   }
   TIteratorArrayNode<Type>* operator --(int){
      TIteratorArrayNode<Type>* ret=m_node;
      m_node=m_node.Prev();
      return ret;
   }
   TIteratorArrayNode<Type>* operator +=(int shift) {return m_node=m_node.Shift(shift);}
   TIteratorArrayNode<Type>* operator -=(int shift) {return m_node=m_node.Shift(-shift);}
   TIteratorArrayNode<Type>* operator +(int shift) const {return m_node.Shift(shift);}
   TIteratorArrayNode<Type>* operator -(int shift) const {return m_node.Shift(-shift);}
   int operator -(const TArrayIterator<Type>& other) const {return m_node.ID()-other.m_node.ID();}
};