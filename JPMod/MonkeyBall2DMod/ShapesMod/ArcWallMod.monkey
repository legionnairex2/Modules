Import JPMod.MonkeyBall2DMod

Class ArcWall Extends VectorObject
	Field pa:PVector2D
	Field np:PVector2D
	Field target:PVector2D
	Field radius:Float=.0
	Field startAngle:Float=.0
	Field endAngle:Float=.0
	
	Method New()
		
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.pa=New PVector2D()
		Self.cp=New PVector2D()
		Self.np=New PVector2D()
		Self.name="Arc Wall"
		
	End Method
	
	Method SetAperture:Void()
		
		Self.pa.x=Self.P.x+Cos((Self.startAngle))*Self.radius
		Self.pa.y=Self.P.y+Sin((Self.startAngle))*Self.radius
		Self.V.x=Self.P.x+Cos((Self.endAngle))*Self.radius-Self.pa.x
		Self.V.y=Self.P.y+Sin((Self.endAngle))*Self.radius-Self.pa.y
		Self.Init(Self.V.x,Self.V.y)
		
	End Method
	
	Method New(x:Float,y:Float,radius:Float,startAngle:Float,endAngle:Float,animation:ObjectAnimation=Null,friction:Float=1.0,bounce:Float=1.0)
		
		Self.P=New PVector2D()
		Self.V=New PVector2D()
		Self.D=New PVector2D()
		Self.pa=New PVector2D()
		Self.cp=New PVector2D()
		Self.np=New PVector2D()
		Self.target=New PVector2D()
		Self.name="Arc Wall"
		Self.P.x=x
		Self.P.y=y
		Self.target.x=x
		Self.target.y=y
		Self.radius=radius
		Self.startAngle=startAngle
		Self.endAngle=endAngle
		Self.SetAperture()
		Self.friction=friction
		Self.bounce=bounce
		Self.animation=animation
		
	End Method
	
	Method SetTarget:void(x:Float,y:Float)
		
		Self.target.x=x
		Self.target.y=y
		
	End Method
	
	Method BallInside:Bool(ball:Ball)
		
		Local vx:Float=ball.P.x-Self.P.x
		Local vy:Float=ball.P.y-Self.P.y
		Return vx*vx+vy*vy < radius * radius
		
	End Method
	
	Method Distance:float(ball:Ball)
		
		If(ball.L = 0.0)
			Return 100000000.0
		Endif
		
		Self.tp=Null
		Local tcdx:Float
		Local tcdy:Float
		Local dist:Float=Self.CollisionDistanceB2RW(ball,Self.P.x,Self.P.y,Self.radius)
		If(dist<>100000000.0)
			Local vx:Float=Self.tp.x-Self.pa.x
			Local vy:Float=Self.tp.y-Self.pa.y
			If(vx*Self.V.y-vy*Self.V.x>=0.0)
				
				Return dist
			Endif
			Self.tp=Null
			dist=100000000.0
		Endif
		Local vx2:Float=Self.P.x-ball.P.x
		Local vy2:Float=Self.P.y-ball.P.y
		Local vx1:Float=-vx2
		Local vy1:Float=-vy2
		Local totRadius:Float=Self.radius-ball.radius
		Local distSq:Float=vx2*vx2+vy2*vy2
		Local totRadSq:Float=totRadius*totRadius
		If(distSq>totRadSq  And  distSq<Self.radius*Self.radius)
			Local dst:Float=Sqrt(distSq)
			if(dst>0.0)
				Self.cdx=vx1/dst
				Self.cdy=vy1/dst
			Else
				Self.cdx=ball.D.x
				Self.cdy=ball.D.y
			Endif
			vx1=Self.cdx*Self.radius
			vy1=Self.cdy*Self.radius
			Self.cp.x=Self.P.x+vx1
			Self.cp.y=Self.P.y+vy1
			If(vx1*Self.D.y-vy1*Self.D.x>0.0  And  vx1*ball.D.x+vy1*ball.D.y>=0.0)
				Self.tp=Self.cp
				
				Return 0.0
			endif
		Endif
		Local dp:Float=vx2*ball.D.y-vy2*ball.D.x
		If(Abs(dp)<Self.radius)
			vx2=dp*ball.D.y
			vy2=dp*-ball.D.x
			Local a:Float=Sqrt(totRadSq-dp*dp)
			Local px:Float=Self.P.x-vx2+a*ball.D.x
			Local py:Float=Self.P.y-vy2+a*ball.D.y
			vx2=px-ball.P.x
			vy2=py-ball.P.y
			dp=vx2*ball.D.x+vy2*ball.D.y
			If(Abs(dp)<=ball.L  And  dp >= 0.0)
				vx2=px-Self.P.x
				vy2=py-Self.P.y
				Local len:Float=Self.radius-ball.radius
				If(len>0.0)
					Self.cdx=vx2/len
					Self.cdy=vy2/len
				Else
					Self.cdx=ball.D.x
					Self.cdy=ball.D.y
				Endif
				px=Self.P.x+Self.cdx*Self.radius
				py=Self.P.y+Self.cdy*Self.radius
				vx2=px-Self.pa.x
				vy2=py-Self.pa.y
				Local dp2:Float=vx2*Self.D.y-vy2*Self.D.x
				If(dp2>=0.0  And  ball.L>0.0)
					Self.cp.x=px
					Self.cp.y=py
					Self.tp=Self.cp
					
					dist=dp/ball.L
					
					Return dist
				Endif
				Self.tp=Null
				dist=100000000.0
			Endif
		Endif
		
		Local nextDist:Float = Self.CollisionDistanceB2RW(ball,Self.pa.x,Self.pa.y,0.0)
		
		If(nextDist<dist)
			dist=nextDist
			Self.np.x=Self.tp.x
			Self.np.y=Self.tp.y
			tcdx=Self.cdx
			tcdy=Self.cdy
		Endif
		
		nextDist=Self.CollisionDistanceB2RW(ball,Self.pa.x+Self.D.x*Self.L,Self.pa.y+Self.D.y*Self.L,0.0)
		
		If(nextDist<dist)
			dist=nextDist
			Self.np.x=Self.tp.x
			Self.np.y=Self.tp.y
			tcdx=Self.cdx
			tcdy=Self.cdy
		Endif
		
		Self.tp=Self.np
		Self.cdx=tcdx
		Self.cdy=tcdy
		
		If(dist = 100000000.0)
			Self.tp=Null
		endif
		
		return dist
	End Method
	
	Method Bounce:Void(ball:Ball,dx:Float,dy:Float)
		
		Self.Bounce2Fixed(ball,dx,dy)
		
	End Method
	
	Method Render:void()
		
		If((Self.animation)<>Null)
			Self.animation.Render()
		Endif
		
	End Method
	
	Method CollisionDistance2Ghost:Float(ball:GhostBall)
		
		Local dx:Float=.0
		Local dy:Float=.0
		Local dist:Float=Self.Distance2Ghost(ball,Self.P.x,Self.P.y,Self.radius)
		
		If(dist <> 100000000.0)
			Local px:Float=ball.position.x+ball.dx*dist
			Local py:Float=ball.position.y+ball.dy*dist
			Local vx:Float=px-Self.P.x
			Local vy:Float=py-Self.P.y
			Local ln:Float=Sqrt(vx*vx+vy*vy)
			If(ln > 0.0)
				dx=vx/ln
				dy=vy/ln
				px=Self.P.x+dx*Self.radius
				py=Self.P.y+dy*Self.radius
			Endif
			vx=px-Self.pa.x
			vy=py-Self.pa.y
			If(vx*Self.D.y-vy*Self.D.x>=0.0)
				
				Return dist
			Endif
			dist=100000000.0
		Endif
		
		Local vx2:Float=Self.P.x-ball.position.x
		Local vy2:Float=Self.P.y-ball.position.y
		Local vx1:Float=-vx2
		Local vy1:Float=-vy2
		Local totRadius:Float=Self.radius-ball.radius
		Local distSq:Float=vx2*vx2+vy2*vy2
		Local totRadSq:Float=totRadius*totRadius
		Local dp:Float=vx2*ball.dy-vy2*ball.dx
		
		if(Abs(dp)<Self.radius)
			vx2=dp*ball.dy
			vy2=dp*-ball.dx
			Local a:Float=Sqrt(totRadSq-dp*dp)
			Local px2:Float=Self.P.x-vx2+a*ball.dx
			Local py2:Float=Self.P.y-vy2+a*ball.dy
			vx2=px2-ball.position.x
			vy2=py2-ball.position.y
			dp=vx2*ball.dx+vy2*ball.dy
			
			If(dp>=0.0)
				vx2=px2-Self.P.x
				vy2=py2-Self.P.y
				
				Local len:Float=Self.radius-ball.radius
				
				If(len>0.0)
					Self.cdx=vx2/len
					Self.cdy=vy2/len
				Else
					Self.cdx=ball.dx
					Self.cdy=ball.dy
				Endif
				
				px2=Self.P.x+Self.cdx*Self.radius
				py2=Self.P.y+Self.cdy*Self.radius
				vx2=px2-Self.pa.x
				vy2=py2-Self.pa.y
				Local dp2:Float=vx2*Self.D.y-vy2*Self.D.x
				
				If(dp2>=0.0)
					ball.cn.x=-Self.cdx
					ball.cn.y=-Self.cdy
					
					Return dp
				endif
				dist=100000000.0
			Endif
		Endif
		
		dx=ball.cn.x
		dy=ball.cn.y
		
		Local nextDist:Float=Self.Distance2Ghost(ball,Self.pa.x,Self.pa.y,0.0)
		
		If(nextDist<dist)
			dist=nextDist
			dx=ball.cn.x
			dy=ball.cn.y
		Endif
		
		nextDist=Self.Distance2Ghost(ball,Self.pa.x+Self.D.x*Self.L,Self.pa.y+Self.D.y*Self.L,0.0)
		
		If(nextDist<dist)
			dist=nextDist
			dx=ball.cn.x
			dy=ball.cn.y
		Endif
		
		ball.cn.x=dx
		ball.cn.y=dy
		
		Return dist
		
	End Method
	
End Class
