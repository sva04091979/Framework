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