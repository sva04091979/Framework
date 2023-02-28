#include "IteratorBase.mqh"

template<typename Type>
struct TListIterator:TIterator<TIteratorListNode<Type>>{
   TListIterator(TIteratorListNode<Type>* node,void* container):TIterator<TIteratorListNode<Type>>(node,container){}
   TListIterator(const TListIterator<Type>& o):TIterator<TIteratorListNode<Type>>(o){}
   void operator =(const TListIterator& o){this=o;}
   TIteratorListNode<Type>* operator ++(){
      m_node=m_node.Next();
      return m_node;
   }
   TIteratorListNode<Type>* operator ++(int){
      TIteratorListNode<Type>* ret=m_node;
      m_node=m_node.Next();
      return ret;
   }
   TIteratorListNode<Type>* operator --(){
      m_node=m_node.Prev();
      return m_node;
   }
   TIteratorListNode<Type>* operator --(int){
      TIteratorListNode<Type>* ret=m_node;
      m_node=m_node.Prev();
      return ret;
   }
};