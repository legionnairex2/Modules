Strict

Import JPMod.MonkeyBall2DMod


Class LineWall Extends VectorObject
	
	Method New()
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.cp=New PVector2D()
		Self.name="Straight wall"
	End

	Method New(x1:Float,y1:Float,x2:Float,y2:Float,animation:ObjectAnimation,friction:Float,bounce:Float)
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.cp=New PVector2D()
		Self.name="Straight wall"
		Self.P.x=x1
		Self.P.y=y1
		Self.Init(x2-x1,y2-y1)
		Self.friction=friction
		Self.bounce=bounce
		Self.animation=animation
	End
	Method Distance:Float(ball:Ball)
		Self.tp = null
		Local a:Float=ball.P.x-Self.P.x
		Local b:Float=ball.P.y-Self.P.y
		Local a1:Float=ball.P.x+ball.V.x-Self.P.x
		Local b1:Float=ball.P.y+ball.V.y-Self.P.y
		Local d1:Float=a*Self.D.y-b*Self.D.x
		Local d2:Float=a1*Self.D.y-b1*Self.D.x
		If(Abs(d1)<ball.radius)
			Local vx:Float=ball.P.x-(Self.P.x+Self.V.x)
			Local vy:Float=ball.P.y-(Self.P.y+Self.V.y)
			If(vx*Self.V.x+vy*Self.V.y<=0.0 And a*Self.V.x+b*Self.V.y>=0.0)
				If(d1>0.0 And d1>d2)
					Self.cdx=-Self.D.y
					Self.cdy=Self.D.x
					Return 0.0
				Else
					If(d1<0.0 And d1<d2)
						Self.cdx=Self.D.y
						Self.cdy=-Self.D.x
						Return 0.0
					End
				End
			End
		End
		Local t:Float=0.0
		If(d1>0.0)
			t=(ball.radius-d1)/(d2-d1)
		Else
			If(d1<0.0)
				t=(ball.radius+d1)/(d1-d2)
			End
		End
		If(d1>0.0 And d2>=d1 Or d1<0.0 And d2<=d1)
			Local vx2:Float=ball.P.x-(Self.P.x+Self.V.x)
			Local vy2:Float=ball.P.y-(Self.P.y+Self.V.y)
			If(a*Self.D.x+b*Self.D.y>=0.0 And vx2*Self.D.x+vy2*Self.D.y<0.0)
				Return INVALID_DISTANCE
			End
		End
		If(t<=1.0 And t>=0.0)
			a=ball.V.x*t
			b=ball.V.y*t
			Self.cp.x=ball.P.x+a
			Self.cp.y=ball.P.y+b
			Local vx3:Float=Self.cp.x-Self.P.x
			Local vy3:Float=Self.cp.y-Self.P.y
			Local dp:Float=vx3*Self.D.x+vy3*Self.D.y
			If(dp>0.0)
				vx3=Self.cp.x-(Self.P.x+Self.V.x)
				vy3=Self.cp.y-(Self.P.y+Self.V.y)
				Self.cp.x=Self.P.x+dp*Self.D.x
				Self.cp.y=Self.P.y+dp*Self.D.y
				dp=vx3*Self.D.x+vy3*Self.D.y
				If(dp<0.0)
					If(Abs(d1)<ball.radius)
						Local diff:Float=ball.radius-Abs(d1)
						ball.P.x+=diff*Self.D.y
						ball.P.y-=diff*Self.D.x
					End
					Self.cdx=Self.D.y
					Self.cdy=-Self.D.x
					Self.tp=Self.cp
					Return t
				End
			End
		End
		Local dist:Float=Self.CollisionDistanceB2RW(ball,Self.P.x+Self.V.x,Self.P.y+Self.V.y,0.0)
		If(dist<>INVALID_DISTANCE)
			Return dist
		End
		dist=Self.CollisionDistanceB2RW(ball,Self.P.x,Self.P.y,0.0)
		If(dist=INVALID_DISTANCE)
			Self.tp = null
		End
		
		Return dist
	End
	Method Bounce:Void(ball:Ball,dx:Float,dy:Float)
		Self.Bounce2Fixed(ball,dx,dy)
	End
	Method Render:Void()
		If((Self.animation)<>Null)
			Self.animation.Render()
		End
	End
	Method CollisionDistance2Ghost:Float(ball:GhostBall)
		Self.tp = null
		Local a:Float=ball.position.x-Self.P.x
		Local b:Float=ball.position.y-Self.P.y
		Local a1:Float=ball.position.x+ball.dx-Self.P.x
		Local b1:Float=ball.position.y+ball.dy-Self.P.y
		Local d1:Float=a*Self.D.y-b*Self.D.x
		Local d2:Float=a1*Self.D.y-b1*Self.D.x
		Local t:Float=0.0
		If(d1>0.0)
			t=(ball.radius-d1)/(d2-d1)
		Else
			If(d1<0.0)
				t=(ball.radius+d1)/(d1-d2)
			End
		End
		If(d1>0.0 And d2>=d1 Or d1<0.0 And d2<=d1)
			Return INVALID_DISTANCE
		End
		If(t>=0.0)
			Local px:Float=ball.position.x+ball.dx*t
			Local py:Float=ball.position.y+ball.dy*t
			Local vx:Float=px-Self.P.x
			Local vy:Float=py-Self.P.y
			Local dp:Float=vx*Self.D.x+vy*Self.D.y
			If(dp>0.0)
				vx=px-(Self.P.x+Self.V.x)
				vy=py-(Self.P.y+Self.V.y)
				dp=vx*Self.D.x+vy*Self.D.y
				If(dp<0.0)
					ball.cn.x=-Self.D.y
					ball.cn.y=Self.D.x
					Return t
				End
			End
		End
		Local dist:Float=Self.Distance2Ghost(ball,Self.P.x+Self.V.x,Self.P.y+Self.V.y,0.0)
		Local dx1:Float=ball.cn.x
		Local dy1:Float=ball.cn.y
		Local dist2:Float=Self.Distance2Ghost(ball,Self.P.x,Self.P.y,0.0)
		If(dist2<dist)
			dist=dist2
		Else
			ball.cn.x=dx1
			ball.cn.y=dy1
		End
		Return dist
	End
End

