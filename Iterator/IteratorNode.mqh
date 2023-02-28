template<typename Type>
class TIteratorNode{
public:
   Type val;
};

template<typename NodeType,typename Type>
class IIteratorListNode:public TIteratorNode<Type>{
protected:
   NodeType* m_next;
   IIteratorListNode():m_next(NULL){}
public:
   void Next(NodeType* next) {m_next=next;}
   NodeType* Next() const {return m_next;}
};

template<typename Type>
class TIteratorForwardNode:public IIteratorListNode<TIteratorForwardNode<Type>,Type>{
};

template<typename Type>
class TIteratorListNode:public IIteratorListNode<TLinkedListNode<Type>,Type>{
   TIteratorListNode* m_prev;
public:
   TIteratorListNode():IListNode<TIteratorListNode<Type>,Type>(),m_prev(NULL){}
   void Prev(TIteratorListNode<Type>* prev) {m_prev=prev;}
   TIteratorListNode<Type>* Prev() const {return m_prev;}   
};

template<typename Type>
class IArrayContainerHolder{
public:
   virtual TIteratorArrayNode<Type>* Get(int id) const=0;
   virtual uint Size() const=0;
   virtual uint Capacity() const=0;
   virtual uint ShrinkToFit()=0;
   virtual uint Reserve(uint reserve)=0;
   virtual TIteratorArrayNode<Type>* PushBack()=0;
   virtual TIteratorArrayNode<Type>* PushFront()=0;
   virtual TIteratorArrayNode<Type>* Insert(uint i)=0;
   virtual void PopBack()=0;
   virtual void PopFront()=0;
   virtual void Erase(uint i)=0;
};

template<typename Type>
class TVectorHolder:public IArrayContainerHolder<Type>{
   static const uint s_maxSize;
   TIteratorArrayNode<Type> m_arr[];
   uint m_size;
   uint m_reserve;
public:
   TVectorHolder():m_size(0),m_reserve(0){}
   TIteratorArrayNode<Type>* Get(int id) const override {return id<(int)m_size?id<0?NULL:&m_arr[id]:NULL;}
   uint Size() const override {return m_size;}
   uint Capacity() const override {return m_reserve;}
   uint ShrinkToFit() override {return m_reserve=ArrayResize(m_arr,m_size);}
   uint Reserve(uint reserve) override {
      if (m_reserve<s_maxSize&&m_reserve<reserve)
         m_reserve=ArrayResize(m_arr,MathMin(s_maxSize,reserve));
      return m_reserve;
   }
   TIteratorArrayNode<Type>* PushBack() override{
      if (m_size<m_reserve) return &m_arr[m_size++];
      if (m_reserve==s_maxSize) return NULL;
      if (m_size<Reserve(MathMax(m_size+1,m_size*3/2)))
         return &m_arr[m_size++];
      return NULL;
   }
   TIteratorArrayNode<Type>* PushFront() override{
      if (m_size<m_reserve) Shift(0,1);
      else if (m_reserve==s_maxSize) return NULL;
      else if (m_size<Reserve(MathMax(m_size+1,m_size*3/2))) Shift(0,1);
      else return NULL;
      return &m_arr[0];
   }
   TIteratorArrayNode<Type>* Insert(uint i) override{
      if (m_size<m_reserve) Shift(i,1);
      else if (m_reserve==s_maxSize) return NULL;
      else if (m_size<Reserve(MathMax(m_size+1,m_size*3/2))) Shift(i,1);
      else return NULL;
      return &m_arr[i];
   }
   void PopBack() override {--m_size;}
   void PopFront() override{
      if (m_size>1)
         Shift(1,-1);
      --m_size;
   }
   void Erase(uint i) override{
      if (++i<m_size) Shift(i,-1);
      --m_size;
   }
private:
   void Shift(uint i,int shift){
      if (!shift) return;
      if (shift<0) ShiftLeft(i,-shift);
      else ShiftRight(i,shift);
   }
   void ShiftLeft(uint i,int shift){
      for(int ii=(int)i-shift;i<m_size;++ii,++i){
         m_arr[ii]=m_arr[i];
         m_arr[ii].ID(ii);
      }
      m_size-=shift;
   }
   void ShiftRight(uint i,int shift){
      int ii=(int)m_size;
      int iii=(int)m_size+shift;
      m_size+=shift;
      while(ii!=i){
         m_arr[--iii]=m_arr[--ii];
         m_arr[iii].ID(iii);
      }
   }
};

template<typename Type>
const uint TVectorHolder::s_maxSize=INT_MAX;

template<typename Type>
class TDequeNode{
public:
   static const uint s_size;
   TIteratorArrayNode<Type> arr[];
   TDequeNode(){ArrayResize(arr,s_size);}
   bool operator !() {return ArraySize(arr)!=s_size;}
};

template<typename Type>
const uint TDequeNode::s_size=100;

template<typename Type>
class TDequeHolder:public IArrayContainerHolder<Type>{
   static const uint s_maxBlocks;
   uint m_work[];
   uint m_reserve[]
   TDequeNode<Type>* m_node[];
   TDequeNode<Type>* m_reserveNode[];
   uint m_workNodeSize;
   uint m_reserveNodeSize;
   uint m_reserveNodeReserve;
   uint m_front;
   uint m_back;
public:
   TDequeHolder():m_workNodeSize(0),m_reserveNodeSize(0),m_reserveNodeReserve(0),m_front(0),m_back(0){}
   
   ~TDequeHolder(){
      for(uint i=0;i<m_workNodeSize;delete m_workNode[i++]);
      for(uint i=0;i<m_reserveNodeSize;delete m_reserveNode[i++]);
   }
   
   TIteratorArrayNode<Type>* Get(int id) const override{
      if (!m_workNodeSize) return NULL;
      int i=(int)m_front+id;
      int ii=i/(int)TDequeNode<Type>::s_size;
      if (ii<(int)m_workNodeSize){
         i%=(int)TDequeNode<Type>::s_size;
         return &(m_workNode[ii].arr[i]);
      }
      return NULL;
   }
   
   uint Size() const override{
      if (!!m_workNodeSize) return 0;
      uint ret=m_workNodeSize>2?TDequeNode<Type>::s_size*(m_workNodeSize-2):0;
      if (ret) return ret+TDequeNode<Type>::s_size-m_front+m_back+1;
      return m_workNodeSize==1?m_back-m_front+1:TDequeNode<Type>::s_size-m_front+m_back+1;
   }
   
   uint Capacity() const override{return (m_workNodeSize+m_reserveNodeSize)*TDequeNode<Type>::s_size;}
   
   uint ShrinkToFit() override{
      m_reserveNodeReserve=m_reserveNodeSize=ArrayResize(m_reserveNode,0);
      return Capacity();
   }
   
   uint Reserve(uint reserve) override{
      uint max=s_maxBlocks-m_reserveNodeSize-m_workNodeSize;
      if (max>0){
         uint capacity=Capacity();
         uint needed=reserve<capacity?0:reserve-capacity;
         if (needed>0){
            uint newBlocks=MathMin(needed/TDequeNode<Type>::s_size+1,max);
            uint haveReserve=m_reserveNodeReserve-m_reserveNodeSize;
            uint needMake=newBlocks<haveReserve?0:haveReserve-newBlocks;
            if (needMake>0){
               m_reserveNodeSize=m_reserveNodeReserve=ArrayResize(m_reserveNode,m_reserveNodeReserve+needMake);
            }
         }
      }
      return Capacity();
   }
   
   TIteratorArrayNode<Type>* PushBack() override{
      if (!m_workNodeSize){
         if (!AddRight())
            return NULL;
         m_front=m_back=TDequeNode<Type>::s_size/2;
      }
      else if (++m_back==TDequeNode<Type>::s_size){
         if (!AddRight())
            return NULL;
         m_back=0;
      }
      return &m_workNode[m_workNodeSize-1].arr[m_back];
   }
   
   TIteratorArrayNode<Type>* PushFront() override{
      if (!m_workNodeSize){
         if (!AddRight())
            return NULL;
         m_front=m_back=TDequeNode<Type>::s_size/2;
      }
      else if (m_front==0){
         if (!AddLeft())
            return NULL;
         m_front=TDequeNode<Type>::s_size-1;
      }
      return &m_workNode[0].arr[m_front];
   }
   
   TIteratorArrayNode<Type>* Insert(uint i) override{
      if (++m_back==TDequeNode<Type>::s_size){
         if (!AddRight())
            return NULL;
         m_back=0;  
      }
      ShiftRight(i,1);
      return Get(i);
   }
   
   void PopBack() override;
   void PopFront() override;
   void Erase(uint i) override;
private:
   bool AddLeft();
   bool AddRight();
   void ShiftLeft(uint i,uint count);
   void ShiftRight(uint i,uint count);
};

template<typename Type>
const uint TDequeHolder::s_maxBlocks=INT_MAX/TDequeNode<Type>::s_size;

template<typename Type>
class TIteratorArrayNode:public TIteratorNode<Type>{
   IArrayContainerHolder<Type>* m_holder;
   int m_id;
public:
   int ID() const {return m_id;}
   void ID(int id) {m_id=id;}
   IArrayContainerHolder<Type>* Holder() const {return m_holder;}
   void Holder(IArrayContainerHolder<Type>* holder) {m_holder=holder;}
   TIteratorArrayNode<Type>* Next() const {return m_holder.Get(m_id+1);}
   TIteratorArrayNode<Type>* Prev() const {return m_holder.Get(m_id-1);}
   TIteratorArrayNode<Type>* Shift(int shift) const {return m_holder.Get(m_id+shift);}
};