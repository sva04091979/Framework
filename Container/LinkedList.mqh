#include "../Common.mqh"
#include "LinkedListNode.mqh"
#include "Iterator.mqh"

template<typename IteratorType,typename NodeType,typename Type>
class ILinkedList{
protected:
   NodeType* m_front;
   _tSizeT m_size;
public:
   ILinkedList():m_front(NULL),m_size(0){}
   ~ILinkedList(){
      while(m_front!=NULL){
         NodeType* del=m_front;
         m_front=m_front.Next();
         delete del;
      }
   }
   NodeType* Front() const {return m_front;}
   bool Empty() const {return !m_size;}
   _tSizeT Size() const {return m_size;}
   TNode<Type>* PushFront(){
      NodeType* node=new NodeType();
      node.Next(m_front);
      m_front=node;
      ++m_size;
      return m_front;
   }
   IteratorType Begin() {return IteratorType(m_front);}
   IteratorType End() {return IteratorType(NULL);}
};

template<typename Type>
class TForwardList:public ILinkedList<TForwardIterator<Type>,TForwardListNode<Type>,Type>{
public:
   TForwardList():ILinkedList<TForwardIterator<Type>,TForwardListNode<Type>,Type>(){}
};