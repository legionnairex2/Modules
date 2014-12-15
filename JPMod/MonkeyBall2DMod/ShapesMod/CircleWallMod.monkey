Strict

Import JPMod.MonkeyBall2D

'*******************************************************
'
'	static roundwall(circle)
'
'*******************************************************

Class CircleWall Extends VectorObject

	Field radius:Float 'circle radius
	
	Method New()
		P = New PVector
		cp = New PVector
		name = "round wall"
	End Method
	
	Method New(x:Float,y:Float,radius:Float,animation:ObjectAnimation = Null,friction:Float = 1,bounce:Float=1)
		
		P = New PVector
		cp = New PVector
		
		name = "round wall"
		
		P.x = x
		P.y = y
		
		Self.radius = radius
		Self.friction = friction
		Self.bounce = bounce
		Self.animation = animation
	
	End Method
	
	Method SetFriction:Void(f:Float)
		friction = f
	End Method
	
	Method Update:Void()
	
	End Method

	'************************************************************************
	'
	'	distance of ball to wall(circle)
	'	returned values
	' 	valid distance distance 0.0 - 1.0.
	'
	'************************************************************************
	
	Method Distance:Float(ball:Ball)
		Return CollisionDistanceB2RW(ball,P.x,P.y,radius)
	End Method
	
	'************************************************************************
	'
	'	change movement vector after collision with wal(circle)
	'	
	'************************************************************************
	 
	Method Bounce:Void(ball:Ball,dx:Float,dy:Float)
		Bounce2Fixed(ball,dx,dy)
	End Method

	Method Render:Void()
		If animation
			animation.Render()
		Else
			RenderCircle(P.x,P.y,radius)
		Endif
	End Method

End Class

