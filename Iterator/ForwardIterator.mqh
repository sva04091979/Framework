#include "IteratorBase.mqh"

template<typename Type>
struct TForwardIterator:TIterator<TIteratorForwardNode<Type>>{
   TForwardIterator(TIteratorForwardNode<Type>* node,void* container):TIterator<TIteratorForwardNode<Type>>(node,container){}
   TForwardIterator(const TForwardIterator<Type>& o):TIterator<TIteratorForwardNode<Type>>(o){}
   void operator =(const TForwardIterator& o){this=o;}
   TIteratorForwardNode<Type>* operator ++(){
      m_node=m_node.Next();
      return m_node;
   }
   TIteratorForwardNode<Type>* operator ++(int){
      TIteratorForwardNode<Type>* ret=m_node;
      m_node=m_node.Next();
      return ret;
   }
};