
Class Store<T>
	Field last:T
	Field total:int
		
	Method New(count:Int)
		Fill(count)
	End Method	

	Method Fill:Void(total:Int)
		For Local i:Int = 0 Until total
			Local c:T = New T()
			c._pred = last
			last = c
		Next
		Self.total = total
	End Method
	
	Method Count:Int()
		Return total
	End Method
	
	Method GetItem:T()
		If last
			Local c:T = last
			last = T(last._pred)
			c._pred = Null
			total -= 1
			Return c
		Endif
		Return New T()
	End Method
	
	Method ReturnItem:Void(obj:T)
		obj._succ = Null
		obj._pred = last
		last = obj
		total += 1
	End Method
	
End Class

Class StoreObject
	Field _pred:StoreObject
	Field _succ:StoreObject
	
	Function Separate:Void(obj:StoreObject)
		If obj._pred
			If obj._succ
				obj._pred._succ = obj._succ
				obj._succ._pred = obj._pred
			Else
				obj._pred._succ = Null
			Endif
		Elseif obj._succ
			obj._succ._pred = Null
		Endif
			
	End Function
	
End Class
	
	
