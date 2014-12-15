
Import JPMod.StoreMod

Class Transport<T>
	Field item:T
	Method New()
		item = New T
	End Method
End Class

Class LinkList<T>

	Field head:StoreObject
	
	Method New()
		head = New StoreObject
		head._pred = head
		head._succ = head
	End Method
	
	Method IsEmpty:Bool()
		Return head = head._pred
	End Method
	
	Method SetStart:T(trans:Transport<T>)
		trans.item = T(head._pred)
		If trans.item = head Return Null
		Return trans.item
	End Method
	
	Method SetEnd:T(trans:Transport<T>)
		trans.item = T(head._succ)
		If trans.item = head Return Null
		Return trans.item
	End Method
	
	Method GetNext:T(trans:Transport<T>)
		If trans.item = Null Return Null
		trans.item = T(trans.item._succ)
		If trans.item = head Return Null
		Return trans.item
	End Method
	
	Method GetPrev:T(trans:Transport<T>)
		trans.item = T(trans.item._pred)
		If trans.item = head Return Null
		Return trans.item
	End Method
	
	Method GetFirst:T()
		If head._pred = head Return Null
		Return T(head._pred)
	End Method
	
	Method GetLast:T()
		If head._succ = head Return Null
		Return T(head._succ)
	End Method
	
	Method PeekPrev:T(trans:Transport<T>)
		If trans.item = head Return Null
		If trans.item = Null Return Null
		If trans.item._pred = head Return Null
		Return T(trans.item._pred)
	End Method
	
	
	Method PeekNext:T(trans:T)
		If trans.item = head Return Null
		If trans.item = Null Return Null
		If trans.item._succ = head Return Null
		Return T(trans.item._succ)
	End Method
	
	Method PeekFirst:T()
		If head._pred = head Return Null
		Return T(head._pred)
	End Method
	
	Method PeekLast:T()
		If head._succ = head Return Null
		Return T(head._succ)
	End Method
	
	Method AddFirst:Void(itm:T)
		If head._pred = head
			head._pred = itm
			head._succ = itm
			itm._pred = head
			itm._succ = head
		Else
			itm._pred = head
			itm._succ = head._pred
			head._pred._pred = itm
			head._pred = itm
		Endif
	End Method
	
	Method AddLast:Void(itm:T)
		If head._succ = head
			head._succ = itm
			head._pred = itm
			itm._succ = head
			itm._pred = head
		Else
			itm._succ = head
			itm._pred = head._succ
			head._succ._succ = itm	
			head._succ = itm
		Endif
	End Method
	
	Method AddGroupToEnd:Void(itm:T)
		Local o:T = itm
		While o
			If o._succ
				Local n:T = o
				o = T(o._succ)
				AddLast(n)
			Else
				Local n:T = o
				o = T(o._succ)
				AddLast(n)
			Endif
		Wend
	End Method
	
	Method AddGroupToStart:Void(itm:T)
		If itm = Null Return
		Local g:T = itm
		Repeat
			If g._succ = Null Exit
			g = T(g._succ)
		Forever
		While g
			If g._pred
				Local n:T = g
				g = T(g._pred)
				AddFirst(n)
			Else
				Local n:T = g
				g = T(g._pred)
				AddFirst(n)
			Endif
		Wend
		
	End Method
		
	Method RemoveFirst:T()
		Local itm:StoreObject
		If head._pred  = head Return Null
		If head._pred = head._succ
			itm = head._pred
			head._succ = head
			head._pred = head
			Return T(itm)
		Endif
		
		itm = head._pred
		head._pred = itm._succ
		head._pred._pred = head
		itm._succ = Null
		itm._pred = Null
		Return T(itm)
	End Method
	
	Method RemoveLast:T()
		Local itm:StoreObject
		If head._succ = head Return Null
		If head._succ = head._pred
			itm = head._succ
		 	head._succ = head
		 	head._pred = head
		 	Return T(itm)
		 Endif
		 		
		itm = head._succ
		head._succ = itm._pred
		head._succ._succ = head
		itm._succ = Null
		itm._pred = Null
		Return T(itm)
	End Method
	
	
	Method RemoveFromToEnd:T(itm:T)
		If itm._pred = head
			head._pred = head
			itm._pred = Null
			head._succ._succ = Null
			head._succ = head
		Else
			head._succ._succ = Null
			head._succ = itm._pred
			head._succ._succ = head
			itm._pred = Null
		Endif
		Return itm
	End Method
	
	Method RemoveFromToStart:T(itm:T)
		Local obj:T = SetEnd()
		While obj
			If obj = itm
				If itm._succ = head
					head._pred = head
					head._succ = head
					itm._succ = Null
				Else
					head._pred = itm._succ
					head._pred._pred = head
				Endif
				Local i:T = itm
				While i
					itm = i
					i = T(i._pred)
				Wend
				Return itm
			Endif
				
			obj = GetPrev()
		Wend
		Error "Object not In LinkList"
	End Method


End Class