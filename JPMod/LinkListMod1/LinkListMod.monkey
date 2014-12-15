Class Link

	Field _succ:Link
	Field _pred:Link
	
	Method New( succ:Link,pred:Link )
		_succ=succ
		_pred=pred
		_succ._pred=Self
		_pred._succ=Self
	End
	
	Method LinkIt:Void( succ:Link,pred:Link )
		_succ=succ
		_pred=pred
		_succ._pred=Self
		_pred._succ=Self
	End
	
	Method Value:Link()
		Return _data
	End

	Method Remove:Void()
		_succ._pred=_pred
		_pred._succ=_succ
	End Method

	Method NextLink:Link()
		Return _succ.GetLink()
	End

	Method PrevLink:Link()
		Return _pred.GetLink()
	End

	Method GetLink:Link()
		Return Self
	End

End

Class LinkList<T>

	Field _head:Link=New HeadLink
	
	Field _enum:Enumerator<T>
	Field _backEnum:BackwardsEnumerator<T>
	
	Method New()
		_enum = New Enumerator<T>(Self)
		_backEnum = New BackwardsEnumerator<T>(Self)
	End
	
	Method New( data:T[] )
		For Local t:=Eachin data
			AddLast t
		Next
	End
	
	Method ToArray:T[]()
		Local arr:T[Count()],i
		For Local t:=Eachin Self
			arr[i]= t
			i+=1
		Next
		Return arr
	End

	Method Equals?( lhs:Link,rhs:Link )
		Return lhs=rhs
	End
	
	Method Compare?( lhs:Link,rhs:Link )	'This method should be implemented by subclasses for Sort to work
		Error "Unable to compare items"
		Return 0
	End
	
	Method Clear:int()
		_head._succ=_head
		_head._pred=_head
	End

	Method Count:int()
		Local n:int,link:=_head._succ
		While link<>_head
			link=link._succ
			n+=1
		Wend
		Return n
	End
	
	Method IsEmpty?()
		Return _head._succ=_head
	End
	
	Method Contains?( value:Link )
		Local link:=_head._succ
		While link<>_head
			If Equals( link._data,value ) Return True
			link=link._succ
		Wend		
	End Method
	
	Method First:T()
		Return T(_head.NextLink())
	End

	Method Last:T()
		Return T(_head.PrevLink())
	End
	
	Method RemoveFirst:T()
		If IsEmpty() Return Null
		Local data := _head.NextLink()
		_head._succ.Remove
		Return T(data)
	End

	Method RemoveLast:T()
		If IsEmpty() Return Null 
		Local data := _head.PrevLink()
		_head._pred.Remove
		Return data
	End

	Method Remove:Void( value:Link )
		Local link:=_head._succ
		While link<>_head
			Local succ:=link._succ
			If Equals( link,value ) link.Remove
			link=succ
		Wend
	End

	Method AddFirst:Void( data:Link )
		data.LinkIt( _head._succ,_head)
	End

	Method AddLast:Void( data:Link )
		data.LinkIt( _head,_head._pred)
	End
	
	Method ObjectEnumerator:Enumerator<T>()
		Return _enum.Init()
	End

	Method Backwards:BackwardsLinkList<T>()
		Return _backEnum.Init()
	End
	
	Method Sort:Void( ascending:Bool=True )
		Local ccsgn:Int=-1
		If ascending ccsgn=1
		Local insize:int=1
		
		Repeat
			Local merges:Int
			Local tail:=_head
			Local p:=_head._succ

			While p<>_head
				merges+=1
				Local q:=p._succ,qsize:Int=insize,psize:int=1
				
				While psize<insize And q<>_head
					psize+=1
					q=q._succ
				Wend

				Repeat
					Local t:Link
					If psize And qsize And q<>_head
						Local cc:int=Compare( p,q ) * ccsgn
						If cc<=0
							t=p
							p=p._succ
							psize-=1
						Else
							t=q
							q=q._succ
							qsize-=1
						Endif
					Else If psize
						t=p
						p=p._succ
						psize-=1
					Else If qsize And q<>_head
						t=q
						q=q._succ
						qsize-=1
					Else
						Exit
					Endif
					t._pred=tail
					tail._succ=t
					tail=t
				Forever
				p=q
			Wend
			tail._succ=_head
			_head._pred=tail

			If merges<=1 Return

			insize*=2
		Forever

	End Method
	
End



Class HeadLink Extends Link

	Method New()
		_succ=Self
		_pred=Self
	End

	Method GetLink:Link()
		Return Null
	End
	
End

Class BackwardsLinkList<T>

	Method New( list:LinkList<T> )
		_list=list
		_backEnumarator = New BackwardsEnumarator<T>
	End

	Method ObjectEnumerator:BackwardsEnumerator<T>()
		Return _backEnumarator
	End Method
	
	Field _list:LinkList<T>
	Field _backEnumarator:BackwardsEnumarator<T>
End


Class Enumerator<T>

	Method New( list:LinkList<T> )
		_list=list
		_curr=T(list._head._succ)
	End Method
	
	Method Init:Enumerator()
		_curr=_list._head._succ
		Return Self
	End Method

	Method HasNext:Bool()
		While _curr._succ._pred<>_curr
			_curr=_curr._succ
		Wend
		Return _curr<>_list._head
	End 

	Method NextObject:T()
		Local obj:T=T(_curr)
		_curr=_curr._succ
		Return obj
	End

	Field _list:LinkList<T>
	Field _curr:Link

End

Class BackwardsEnumerator<T>

	Method New( list:LinkList<T> )
		_list=list
		_curr=list._head._pred
	End Method
	
	Method Init:BackwardsEnumarator()
		_curr = _list._head._pred
	End Method
	
	Method HasNext:Bool()
		While _curr._pred._succ<>_curr
			_curr=_curr._pred
		Wend
		Return _curr<>_list._head
	End 

	Method NextObject:T()
		Local obj:T=T(_curr)
		_curr=_curr._pred
		Return obj
	End

	Field _list:LinkList<T>
	Field _curr:Link

End
