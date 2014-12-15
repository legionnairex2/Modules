Const ATR:Float = Pi/180.0
Const RTA:Float = 180.0/Pi
	
Class Color

	Field red:Int
	Field green:Int
	Field blue:Int
	
	Method New(r:Int,g:Int,b:Int)
	
		Init(r,g,b)
		
	End Method
	
	Method Init:Void(r:Int,g:Int,b:Int)

		red = r
		green = g
		blue = b

	End Method
	
	Method InitFromActive:Void()
		
		Local c:Float[] = GetColor()
		
		red = c[0]
		green = c[1]
		blue = c[2]
	
	End Method
	
	
	Method Set()
	
		SetColor(red,green,blue)
		
	End Method
	
End Class


 