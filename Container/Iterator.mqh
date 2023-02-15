#include "LinkedListNode.mqh"

template<typename NodeType>
struct TIterator{
protected:
   NodeType* m_node;
public:
   TIterator(NodeType* node):m_node(node){}
   TIterator(const TIterator& o) {m_node=o.m_node; }
   void operator =(const TIterator& o) {m_node=o.m_node;}
   NodeType* Get() const {return m_node;}
   bool End() {return !m_node;}
};

template<typename Type>
struct TForwardIterator:TIterator<TForwardListNode<Type>>{
   TForwardIterator(TForwardListNode<Type>* node):TIterator<TForwardListNode<Type>>(node){}
   TForwardIterator(const TForwardIterator<Type>& o):TIterator<TForwardListNode<Type>>(o){}
   void operator =(const TForwardIterator& o){this=o;}
   TForwardIterator operator ++(){
      m_node=m_node.Next();
      return this;
   }
};