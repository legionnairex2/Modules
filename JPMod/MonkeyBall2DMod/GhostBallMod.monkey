Strict
Import Monkeyball2DMod
Import JPMod.VectorMod

Class GhostBall
	Field position:PVector2D
	Field cn:PVector2D
	Field radius:Float=.0
	Field image:Image
	Field dx:Float=.0
	Field dy:Float=.0
	Field frame:Int=0
	Field delay:Int=0
	Field stripImg:Image
	Field time:Int=0
	Method New(position:PVector2D,radius:Float,image:Image,angle:Float,stpImg:Image)
		Self.position=position
		Self.cn=New PVector2D()
		Self.radius=radius
		Self.image=image
		Self.dx=Cos((angle))
		Self.dy=Sin((angle))
		Self.frame=0
		Self.delay=1
		Self.stripImg=stpImg
		Self.time=Millisecs()
	End

	Field colBall:Ball
	Field distance:Float=.0
	Method Render:Void()
		Local x:Float=Self.position.x+Self.dx*Self.distance
		Local y:Float=Self.position.y+Self.dy*Self.distance
		If(Millisecs()>Self.time+Self.delay)
			Self.frame=(Self.frame+1) Mod 3
			Self.time=Millisecs()
		End
		Local ang:Float=-(ATan2(Self.dy,Self.dx))
		DrawImage(Self.image,x,y,Self.frame)
		DrawImage(Self.stripImg,Self.position.x,Self.position.y,ang,Self.distance,1.0,0)
		If((Self.colBall)<>Null)
			Local r2:Float=Self.colBall.radius*2.0
			DrawLine(Self.colBall.P.x,Self.colBall.P.y,Self.colBall.P.x-Self.cn.x*r2,Self.colBall.P.y-Self.cn.y*r2)
			Local dp:Float=Self.cn.x*-Self.dx+Self.cn.y*-Self.dy
			Local dx1:Float=dp*Self.cn.x
			Local dy1:Float=dp*Self.cn.y
			dp=Self.cn.y*Self.dx-Self.cn.x*Self.dy
			dx1=dp*Self.cn.y
			dy1=-dp*Self.cn.x
			DrawLine(x,y,x+dx1*20.0,y+dy1*20.0)
		Else
			Local dp2:Float=Self.cn.x*-Self.dx+Self.cn.y*-Self.dy
			Local dx12:Float=dp2*Self.cn.x
			Local dy12:Float=dp2*Self.cn.y
			dp2=Self.cn.y*Self.dx-Self.cn.x*Self.dy
			dx12+=dp2*Self.cn.y
			dy12+=dp2*-Self.cn.x
			DrawLine(x,y,x+dx12*20.0,y+dy12*20.0)
		End
	End
End
