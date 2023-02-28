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
