#include "Node.mqh"

template<typename NodeType,typename Type>
class IListNode:public TNode<Type>{
protected:
   NodeType* m_next;
   IListNode():m_next(NULL){}
public:
   void Next(NodeType* next) {m_next=next;}
   NodeType* Next() const {return m_next;}
};

template<typename Type>
class TForwardListNode:public IListNode<TForwardListNode<Type>,Type>{
};

template<typename Type>
class TLinkedListNode:public IListNode<TLinkedListNode<Type>,Type>{
   TLinkedListNode* m_prev;
public:
   TLinkedListNode():IListNode<TLinkedListNode<Type>,Type>(),m_prev(NULL){}
   void Prev(TLinkedListNode<Type>* prev) {m_prev=prev;}
   TLinkedListNode<Type>* Prev() const {return m_prev;}   
};