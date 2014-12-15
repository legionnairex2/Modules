Strict

Import VectorBaseMod
Import JPMod.MediaMod
Import BallAnimationMod

'************************************************************************
'
'	Movable vector ball
'
'************************************************************************
Class Ball Extends VectorObject
	Field tv:PVector2D
	
	Method New()
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.tv=New PVector2D()
		Self.cp=New PVector2D()
		Self.name="Ball"
	End
	
	Field radius:Float
	Field mass:Float
	Field displayFloat:Bool

	Method New(x:Float,y:Float,radius:Float,vx:Float,vy:Float,animation:ObjectAnimation,frictn:Float,bounse:Float,mass:Float,num:Int,displayFloat:Bool)
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.tv=New PVector2D()
		Self.cp=New PVector2D()
		Self.name="Ball"
		Self.P.x=x
		Self.P.y=y
		Self.radius=radius
		Self.Init(vx,vy)
		Self.friction=frictn
		Self.bounce=bounse
		Self.mass=mass
		Self.num=num
		Self.displayFloat=displayFloat
		Self.animation=animation
	End
	Method SetPosition:Void(x:Float,y:Float)
		Self.P.x=x
		Self.P.y=y
	End
	Method ResetAnimation:Void()
		Self.animation.Reset()
	End
	Method updateIn:Void(timeFrame:Float)
		Self.V.x+=VectorObject.ApplicableGravityx
		Self.V.y+=VectorObject.ApplicableGravityy
		Self.V.x*=VectorObject.ApplicableSurfaceFriction
		Self.V.y*=VectorObject.ApplicableSurfaceFriction
		Self.V.x*=timeFrame
		Self.V.y*=timeFrame
		Self.Init(Self.V.x,Self.V.y)
	End
	Method IsMoving:Bool()
		Local t_:Bool=((Self.V.x)<>0.0) Or ((Self.V.y)<>0.0)
		Return t_
	End
	Method MovingToBall:Bool(ball:Ball)
		Local t_:Bool=(ball.P.x-Self.P.x)*(Self.V.x-ball.V.x)+(ball.P.y-Self.P.y)*(Self.V.y-ball.V.y)>0.0
		Return t_
	End
	Method Distance:Float(ball:Ball)
		Local vx:Float=ball.P.x-Self.P.x
		Local vy:Float=ball.P.y-Self.P.y
		
		If(vx*vx+vy*vy<(Self.radius+ball.radius)*(Self.radius+ball.radius))
			If(Self.MovingToBall(ball))
				Local len:Float=Sqrt(vx*vx+vy*vy)
				Self.cdx=vx/len
				Self.cdy=vy/len
				Return 0.0
			End
		End
		If(-vx*ball.V.x-vy*ball.V.y<0.0)
			Return INVALID_DISTANCE
		End
		Local vx1:Float=Self.V.x-ball.V.x
		Local vy1:Float=Self.V.y-ball.V.y
		Local totalRadius:Float=Self.radius+ball.radius
		Local l1:Float=Sqrt(vx1*vx1+vy1*vy1)
		Local dx1:Float=vx1/l1
		Local dy1:Float=vy1/l1
		Local dp:Float=vx*dx1+vy*dy1
		Local vx2:Float=dp*dx1
		Local vy2:Float=dp*dy1
		Local lengt:Float=Sqrt(Pow(ball.P.x-(Self.P.x+vx2),2.0)+Pow(ball.P.y-(Self.P.y+vy2),2.0))
		Local diff:Float=totalRadius-lengt
		Self.tp = Null
		If(diff>0.0)
			Local moveBack:Float=Sqrt(totalRadius*totalRadius-lengt*lengt)
			Local vx4:Float=vx2-moveBack*dx1
			Local vy4:Float=vy2-moveBack*dy1
			Local l4:Float=Sqrt(vx4*vx4+vy4*vy4)
			If(l4<=l1 And vx4*Self.V.x+vy4*Self.V.y>=0.0)
				Local dist:Float=l4/l1
				Local x1:Float=ball.P.x+ball.V.x*dist
				Local y1:Float=ball.P.y+ball.V.y*dist
				Local x2:Float=Self.P.x+Self.V.x*dist
				Local y2:Float=Self.P.y+Self.V.y*dist
				Local vx3:Float=x2-x1
				Local vy3:Float=y2-y1
				l1=Sqrt(vx3*vx3+vy3*vy3)
				If((l1)<>0.0)
					Self.cdx=vx3/l1
					Self.cdy=vy3/l1
				Else
					Self.cdx=0.0
					Self.cdy=0.0
				End
				Self.cp.x=x1+Self.cdx*ball.radius
				Self.cp.y=y1+Self.cdy*ball.radius
				Self.tp=Self.cp
				Return dist
			End
		End
		Return INVALID_DISTANCE
	End
	Field tvx:Float=.0
	Field tvy:Float=.0
	Method Advance:Void(distance:Float)
		Local vx:Float=Self.V.x*distance
		Local vy:Float=Self.V.y*distance
		If(vx=0.0 And vy=0.0)
			Return
		End
		Self.V.x-=vx
		Self.V.y-=vy
		Self.P.x+=vx
		Self.P.y+=vy
		Self.tvx+=vx
		Self.tvy+=vy
		Self.L-=Sqrt(vx*vx+vy*vy)
	End
	Method updateOut:Void(timeFrame:Float)
		Self.V.x=Self.tvx
		Self.V.y=Self.tvy
		If(ABall3D(Self.animation)<>Null)
			ABall3D(Self.animation).Rotate(Self.tvx,Self.tvy)
		End
		Self.tvx=0.0
		Self.tvy=0.0
		Self.V.x/=timeFrame
		Self.V.y/=timeFrame
		If(Abs(Self.V.x)<0.1 And Abs(Self.V.y)<0.1)
			Self.V.x=0.0
			Self.V.y=0.0
		End
		Self.Init(Self.V.x,Self.V.y)
	End
	Method Render:Void()
		If((Self.animation)<>Null)
			Self.animation.Render()
		End
		If(Self.displayFloat)
			DrawText(String(Self.num),Self.P.x,Self.P.y,0.0,0.0)
		End
	End
	Method BounceB2B:Void(ball:Ball,dx:Float,dy:Float)
		Local vx1:Float=ball.tvx+ball.V.x
		Local vy1:Float=ball.tvy+ball.V.y
		Local dp:Float=Self.V.x*dx+Self.V.y*dy
		Local a1:Float=dp*dx
		Local b1:Float=dp*dy
		dp=Self.V.x*dy-Self.V.y*dx
		Local a2:Float=dp*dy
		Local b2:Float=dp*-dx
		dp=ball.V.x*dx+ball.V.y*dy
		Local a21:Float=dp*dx
		Local b21:Float=dp*dy
		dp=ball.V.x*dy-ball.V.y*dx
		Local a22:Float=dp*dy
		Local b22:Float=dp*-dx
		Local t_P:Float=Self.mass*a1+ball.mass*a21
		Local t_Vn:Float=a1-a21
		Local v2fx:Float=(t_P+t_Vn*Self.mass)/(Self.mass+ball.mass)
		Local v1fx:Float=v2fx-t_Vn
		t_P=Self.mass*b1+ball.mass*b21
		t_Vn=b1-b21
		Local v2fy:Float=(t_P+t_Vn*Self.mass)/(Self.mass+ball.mass)
		Local v1fy:Float=v2fy-t_Vn
		Self.V.x=Self.friction*ball.friction*a2+Self.bounce*ball.bounce*v1fx
		Self.V.y=Self.friction*ball.friction*b2+Self.bounce*ball.bounce*v1fy
		ball.V.x=Self.friction*ball.friction*a22+Self.bounce*ball.bounce*v2fx
		ball.V.y=Self.friction*ball.friction*b22+Self.bounce*ball.bounce*v2fy
		Self.Init(Self.V.x,Self.V.y)
		ball.Init(ball.V.x,ball.V.y)
		dp=Self.tvx*dx+Self.tvy*dy
		a1=dp*dx
		b1=dp*dy
		dp=Self.tvx*dy-Self.tvy*dx
		a2=dp*dy
		b2=dp*-dx
		dp=ball.tvx*dx+ball.tvy*dy
		a21=dp*dx
		b21=dp*dy
		dp=ball.tvx*dy-ball.tvy*dx
		a22=dp*dy
		b22=dp*-dx
		t_P=Self.mass*a1+ball.mass*a21
		t_Vn=a1-a21
		v2fx=(t_P+t_Vn*Self.mass)/(Self.mass+ball.mass)
		v1fx=v2fx-t_Vn
		t_P=Self.mass*b1+ball.mass*b21
		t_Vn=b1-b21
		v2fy=(t_P+t_Vn*Self.mass)/(Self.mass+ball.mass)
		v1fy=v2fy-t_Vn
		Self.tvx=Self.friction*ball.friction*a2+Self.bounce*ball.bounce*v1fx
		Self.tvy=Self.friction*ball.friction*b2+Self.bounce*ball.bounce*v1fy
		ball.tvx=Self.friction*ball.friction*a22+Self.bounce*ball.bounce*v2fx
		ball.tvy=Self.friction*ball.friction*b22+Self.bounce*ball.bounce*v2fy
		vx1-=ball.V.x+ball.tvx
		vy1-=ball.V.y+ball.tvy
		dp=Sqrt(vx1*vx1+vy1*vy1)
		If(dp>20.0)
			media.PlayBallCol(3)
		Else
			If(dp>10.0)
				media.PlayBallCol(2)
			Else
				If(dp>2.0)
					media.PlayBallCol(1)
				Else
					media.PlayBallCol(0)
				End
			End
		End
	End
	Method Bounce:Void(ball:Ball,dx:Float,dy:Float)
		Self.BounceB2B(ball,dx,dy)
	End
	
	Method CollisionDistance2Ghost:Float(ball:GhostBall)
		If(Self.num=16)
			Return INVALID_DISTANCE
		End
		Local t_:Float=Self.Distance2Ghost(ball,Self.P.x,Self.P.y,Self.radius)
		Return t_
	End
End
