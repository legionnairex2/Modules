Strict

Import JPMod.MonkeyBall2DMod
Import JPMod.VectorMod

Class VectorObject
	
	Global Gravityx:Float
	Global Gravityy:Float
	Global ApplicableGravityx:Float
	Global ApplicableGravityy:Float
	
	Function SetGlobalGravity:Void(t_gx:Float,t_gy:Float)
		Gravityx=t_gx
		Gravityy=t_gy
		ApplicableGravityx=t_gx
		ApplicableGravityy=t_gy
	End
	
	Global SurfaceFriction:Float
	Global ApplicableSurfaceFriction:Float
	
	Function SetGlobalFriction:Void(f:Float)
		SurfaceFriction=f
		ApplicableSurfaceFriction=f
	End
	
	Field P:PVector2D
	Field V:PVector2D
	Field D:PVector2D
	Field cp:PVector2D
	Field name:String=""
	
	Method Magnitude:Float(vx:Float,vy:Float)
		Return Sqrt(Self.V.x*Self.V.x+Self.V.y*Self.V.y)
	End

	Field L:Float
	
	Method Init:Void(vx:Float,vy:Float)
		Self.V.x=vx
		Self.V.y=vy
		Self.L=Self.Magnitude(vx,vy)
		If(Self.L>0.0)
			Self.D.x=Self.V.x/Self.L
			Self.D.y=Self.V.y/Self.L
		Else
			Self.D.x=0.0
			Self.D.y=0.0
		End
	End
	
	Field friction:Float
	Field bounce:Float
	Field animation:ObjectAnimation
	
	Method SetAnimation:Void(animation:ObjectAnimation)
		Self.animation=animation
	End
	
	Field num:Int
	Field node:list.Node<Ball>
	
	Method Distance:Float(b:Ball)
		Return 0
	End
	
	Field cdx:Float=.0
	Field cdy:Float=.0
	Field tp:PVector2D

	Method Bounce:Void(ball:Ball,px:Float,py:Float) Abstract

	Method Render:Void() Abstract

	Method CollisionDistanceB2RW:Float(ball:Ball,x:Float,y:Float,radius:Float)
		Self.tp = Null
		Local vx:Float=x-ball.P.x
		Local vy:Float=y-ball.P.y
		Local totRadiusSq:Float=(ball.radius+radius)*(ball.radius+radius)
		Local distSq:Float=vx*vx+vy*vy
		If(distSq<totRadiusSq And distSq>radius*radius)
			If((ball.P.x-x)*(0.0-ball.V.x)+(ball.P.y-y)*(0.0-ball.V.y)>0.0)
				Local len:Float=Sqrt(distSq)
				Self.cdx=vx/len
				Self.cdy=vy/len
				Self.cp.x=ball.P.x+Self.cdx*ball.radius
				Self.cp.y=ball.P.y+Self.cdy*ball.radius
				Self.tp=Self.cp
				Return 0.0
			End
		End
		Local vx2:Float=x-(ball.P.x+ball.V.x)
		Local vy2:Float=y-(ball.P.y+ball.V.y)
		Local dp:Float=vx*ball.D.x+vy*ball.D.y
		If(dp>0.0)
			Local tvx:Float=dp*ball.D.x
			Local tvy:Float=dp*ball.D.y
			Local x1:Float=ball.P.x+tvx
			Local y1:Float=ball.P.y+tvy
			tvx=x-x1
			tvy=y-y1
			Local llSq:Float=tvx*tvx+tvy*tvy
			Local maxDist:Float=radius+ball.radius
			If(llSq<=maxDist*maxDist)
				Local c:Float=ball.radius+radius
				Local b:Float=Sqrt(llSq)
				Local a:Float=Sqrt(c*c-b*b)
				Local x2:Float=x1-ball.D.x*a
				Local y2:Float=y1-ball.D.y*a
				Local rvx:Float=x2-ball.P.x
				Local rvy:Float=y2-ball.P.y
				Local distSq2:Float=rvx*rvx+rvy*rvy
				If(distSq2<=ball.L*ball.L And vx*rvx+vy*rvy>=0.0)
					vx=x-(ball.P.x+rvx)
					vy=y-(ball.P.y+rvy)
					If((c)<>0.0)
						Self.cdx=vx/c
						Self.cdy=vy/c
					Else
						Self.cdx=0.0
						Self.cdy=0.0
					End
					Self.cp.x=ball.P.x+rvx+Self.cdx*ball.radius
					Self.cp.y=ball.P.y+rvy+Self.cdy*ball.radius
					Self.tp=Self.cp
					Local t_:Float=Sqrt(distSq2)/ball.L
					Return t_
				End
			End
		End
		Return INVALID_DISTANCE
		
	End Method
	
	Method Bounce2Fixed:Void(ball:Ball,dx:Float,dy:Float)
		Local dp:Float=ball.V.x*dx+ball.V.y*dy
		Local vx1:Float=-dp*dx
		Local vy1:Float=-dp*dy
		dp=ball.V.x*dy-ball.V.y*dx
		Local vx2:Float=dp*dy
		Local vy2:Float=-dp*dx
		Local vx:Float=vx1+vx2
		Local vy:Float=vy1+vy2
		ball.Init(vx,vy)
		dp=ball.tvx*dx+ball.tvy*dy
		vx1=-dp*dx
		vy1=-dp*dy
		dp=ball.tvx*dy-ball.tvy*dx
		vx2=dp*dy
		vy2=-dp*dx
		ball.tvx=vx1+vx2
		ball.tvy=vy1+vy2
		Local n:Float=ball.tvx+ball.V.x
		If(n<5.0)
			n=0.0
		End
		If(n>=5.0)
			n=1.0
		End
		media.PlayRailCol((n))
	End
	
	Method CollisionDistance2Ghost:Float(ball:GhostBall) Abstract

	Method Distance2Ghost:Float(t_ghost:GhostBall,x:Float,y:Float,radius:Float)
		Local vx:Float=x-t_ghost.position.x
		Local vy:Float=y-t_ghost.position.y
		Local dp:Float=vx*t_ghost.dy-vy*t_ghost.dx
		Local c:Float=t_ghost.radius+radius
		If(Abs(dp)<c)
			Local dp2:Float=vx*t_ghost.dx+vy*t_ghost.dy
			If(dp2>0.0)
				dp2-=Sqrt(c*c-dp*dp)
				vx=t_ghost.position.x+t_ghost.dx*dp2-x
				vy=t_ghost.position.y+t_ghost.dy*dp2-y
				dp=Sqrt(vx*vx+vy*vy)
				t_ghost.cn.x=vx/dp
				t_ghost.cn.y=vy/dp
				Return dp2
			End
		End
		Return INVALID_DISTANCE
	End
	
End Class

