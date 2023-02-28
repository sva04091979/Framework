#include "IteratorNode.mqh"

template<typename NodeType>
struct TIterator{
protected:
   void* m_container;
   NodeType* m_node;
   TIterator(NodeType* node,void* container):m_node(node){}
   TIterator(const TIterator& o) {m_node=o.m_node; m_container=o.m_container;}
public:
   void operator =(const TIterator& o) {m_node=o.m_node;}
   NodeType* Get() const {return m_node;}
   bool End() {return !m_node;}
   bool operator==(const TIterator<NodeType>& o) const {return m_container==o.m_container && m_node==o.m_node;}
   bool operator!=(const TIterator<NodeType>& o) const {return m_container!=o.m_container || m_node!=o.m_node;}
};

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
