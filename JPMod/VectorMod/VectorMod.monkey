Strict
Import mojo

Class PVector2D
	Field x:Float
	Field y:Float
	
	Method New(x:Float,y:Float)
		Set(x,y)
	End Method
	
	Method New(x1:Float,y1:Float,x2:Float,y2:Float)
		Set(x2-x1,y2-y1)
	End Method
	
	Method New(v:PVector2D)
		Set(v)
	End Method
	
	Method Set:PVector2D(v:PVector2D)
		x = v.x
		y = v.y
		Return Self
	End Method

	Method Set:PVector2D(x:Float,y:Float)
		Self.x = x
		Self.y = y
		Return Self
	End Method
		
	Method Add:PVector2D(x:Float,y:Float)
		Self.x += x
		Self.y += y
		Return Self
	End Method
	
	Method Add:PVector2D(v:PVector2D)
		Self.x += v.x
		Self.y += v.y
		Return Self
	End Method
	
	Method Add:PVector2D(value:Float)
		Self.x += value
		Self.y += value
		Return Self
	End Method
	
	Method Subtract:PVector2D(x:Float,y:Float)
		Self.x -= x
		Self.y -= y
		Return Self
	End Method
	
	Method Subtract:PVector2D(v:PVector2D)
		Self.x -= v.x
		Self.y -= v.y
		Return Self
	End Method
	
	Method Subtract:PVector2D(value:Float)
		Self.x -= value
		Self.y -= value
		Return Self
	End Method
	
	Method Multiply:PVector2D(x:Float,y:Float)
		Self.x *= x
		Self.y *= y
		Return Self
	End Method
	
	Method Multiply:PVector2D(v:PVector2D)
		Self.x *= v.x
		Self.y *= v.y
		Return Self
	End Method
	
	Method Multiply:PVector2D(value:Float)
		Self.x *= value
		Self.y *= value
		Return Self
	End Method
	
	Method Divide:PVector2D(x:Float,y:Float)
		Self.x /= x
		Self.y /= y
		Return Self
	End Method
	
	Method Divide:PVector2D(v:PVector2D)
		Self.x /= v.x
		Self.y /= v.y
		Return Self
	End Method
	
	Method Divide:PVector2D(value:Float)
		Self.x /= value
		Self.y /= value
		Return Self
	End Method
	
	Method DotProduct:Float(x:Float,y:Float)
		Return Self.x * x + Self.y * y
	End Method
	
	Method DotProduct:Float(v:PVector2D)
		Return Self.x * v.x + Self.y * v.y
	End Method
	
	Method PerpDotProduct:Float(x:Float,y:Float)
		Return Self.x * y - Self.y * x
	End Method
	
	Method PerpDotProduct:Float(v:PVector2D)
		Return Self.x * v.y - Self.y * v.x
	End Method
	
	Method MagnitudeSquare:Float()
		Return Self.x * Self.x + Self.y * Self.y
	End Method
	
	Method Magnitude:Float()
		Return Sqrt(MagnitudeSquare())
	End Method
	
	Method LeftNormal:Float()
		Local n:Float = y
		y = -x 
		x = n
	End Method
	
	Method RightNormal:Float()
		Local n:Float = y
		y = x
		x = -n
	End Method
	
	Method Normalize:PVector2D()
		Divide(Magnitude())
		Return Self
	End Method
		
	Method GetAngle:Float()
		Return ATan2(y,x)
	End Method
	
	Method ToString:String()
		Return x+"  "+y
	End Method
	
	Method Draw:Void(x:Float,y:Float)
		DrawLine(x,y,x+Self.x,y+Self.y)
	End Method
	
End Class

Function Projection:PVector2D(this:PVector2D,into:PVector2D,destination:PVector2D=Null)
	
	If destination = Null destination = New PVector2D
		
	Return destination.Set(into).Normalize().Multiply(destination.DotProduct(this))
	
End Function

Function CrossProjection:PVector2D(this:PVector2D,into:PVector2D,destination:PVector2D=Null)
	
	If destination = Null destination = New PVector2D
	
	Return destination.Set(into.y,-into.x).Normalize().Multiply(destination.DotProduct(this))
		
End Function

