Strict

Import ShapesMod
Import Mojo
'******************************************************************************************
'
'		elastic/non elastic ball/cirlcle collision engine
'
'******************************************************************************************

' Collision storage.
Class ElasticEngine
	Field wallList:List<VectorObject>
	Field ballList:List<Ball>
	Field colls:CollisionTrend[99]
	
	Method New()
		Self.wallList= New List<VectorObject>
		Self.ballList= New List<Ball>
		For Local i:Int=0 Until 99
			Self.colls[i]= New CollisionTrend()
		End
	End
	
	Method SetGravity:Void(vx:Float,vy:Float)
		VectorObject.SetGlobalGravity(vx,vy)
	End
	
	Method SetFriction:Void(f:Float)
		VectorObject.SetGlobalFriction(f)
	End
	
	Method RemoveWalls:Void()
		Self.wallList.Clear()
	End
	
	Method AddWall:list.Node<VectorObject>(t_wall:VectorObject)
		Return Self.wallList.AddLast(t_wall)
	End
	
	Method AddLineWallImage:LineWall(x1:Float,y1:Float,x2:Float,y2:Float,image:Image,color:Int)
		Local line:LineWall= New LineWall(x1,y1,x2,y2,Null,1.0,1.0)
		Local animation:AImageLineStained= New AImageLineStained(line.P,line.V.x,line.V.y,image,color)
		line.SetAnimation(animation)
		Self.AddWall(line)
		Return line
	End
	
	Method AddLineWallOutline:LineWall(x1:Float,y1:Float,x2:Float,y2:Float,image:Image,color:Int)
		Local line:LineWall=New LineWall(x1,y1,x2,y2,Null,1.0,1.0)
		Local animation:APixelLine= New APixelLine(line.P,line.V.x,line.V.y,color)
		line.SetAnimation(animation)
		Self.AddWall(line)
		Return line
	End
	
	Method AddArcWallImage:ArcWall(x:Float,y:Float,radius:Float,startAngle:Float,endAngle:Float,image:Image,color:Int)
		Local arc:ArcWall=New ArcWall(x,y,radius,startAngle,endAngle,Null,1.0,1.0)
		Local animation:AImageArcStained= New AImageArcStained(arc.P,image,color)
		arc.SetAnimation(animation)
		Self.AddWall(arc)
		Return arc
	End
	
	Method AddArcWallOutline:ArcWall(x:Float,y:Float,radius:Float,startAngle:Float,endAngle:Float,color:Int)
		Local arc:ArcWall=New ArcWall(x,y,radius,startAngle,endAngle,Null,1.0,1.0)
		Local animation:APixelArc=New APixelArc(arc.P,radius,startAngle,endAngle,color)
		arc.SetAnimation(animation)
		Self.AddWall(arc)
		Return arc
	End
	
	Method AddBall:list.Node<Ball>(ball:Ball)
		ball.node=Self.ballList.AddLast(ball)
		Return ball.node
	End
	
	Method Add3DBall:Ball(x:Float,y:Float,radius:Float,vx:Float,vy:Float,image:Image,color:Float,txtColor:Float,number:Int,displayFloat:Int)
		Local ball:Ball=New Ball(x,y,radius,vx,vy,Null,1.0,1.0,1.0,number,False)
		Local animation:ObjectAnimation= New ABall3D(ball.P,radius,image,((color)),((txtColor)),number)
		ball.SetAnimation(animation)
		Self.AddBall(ball)
		Return ball
	End
	
	Field totalCol:Int=0
	Field nearesBall:Ball
	Field colCount:Int=0
	Field firstCollision:Ball
	
	Method Process:Void()
		
		Local distance:Float=INVALID_DISTANCE
		Local done:Int=0
		Self.nearesBall = Null
		Local nearestObject:VectorObject
		Self.colCount=-1
		For Local ball:Ball = Eachin Self.ballList
			For Local ball2:Ball = Eachin Self.ballList.Backwards()
				If(ball=ball2)
					Exit
				End
				If(Not ball.IsMoving() And Not ball2.IsMoving())
					Continue
				End
				Local balla:Ball
				Local ballb:Ball
				If(ball.L>=ball2.L)
					balla=ball2
					ballb=ball
				Else
					balla=ball
					ballb=ball2
				End
				Local t_oldL:Float=ballb.L
				Local d:Float=balla.Distance(ballb)
				If(d=INVALID_DISTANCE)
					Continue
				Else
					If(d<distance)
						distance=d
						Self.colCount=0
						Self.colls[Self.colCount].ball=ballb
						Self.colls[Self.colCount].obj= balla
						Self.colls[Self.colCount].cdx=balla.cdx
						Self.colls[Self.colCount].cdy=balla.cdy
						Self.colls[Self.colCount].oldL=t_oldL
					Else
						If(d=distance)
							Self.colCount+=1
							Self.colls[Self.colCount].ball=ballb
							Self.colls[Self.colCount].obj= balla
							Self.colls[Self.colCount].cdx=balla.cdx
							Self.colls[Self.colCount].cdy=balla.cdy
							Self.colls[Self.colCount].oldL=t_oldL
						End
					End
				End
			End
			For Local t_wall:VectorObject = Eachin Self.wallList
				Local d2:Float=t_wall.Distance(ball)
				If(d2=INVALID_DISTANCE)
					Continue
				Else
					If(d2<distance)
						distance=d2
						Self.colCount=0
						Self.colls[Self.colCount].ball=ball
						Self.colls[Self.colCount].obj=t_wall
						Self.colls[Self.colCount].cdx=t_wall.cdx
						Self.colls[Self.colCount].cdy=t_wall.cdy
						Self.colls[Self.colCount].oldL=0.0
					Else
						If(d2=distance)
							Self.colCount+=1
							Self.colls[Self.colCount].ball=ball
							Self.colls[Self.colCount].obj=t_wall
							Self.colls[Self.colCount].cdx=t_wall.cdx
							Self.colls[Self.colCount].cdy=t_wall.cdy
							Self.colls[Self.colCount].oldL=0.0
						End
					End
				End
			End
		End
		If(distance=INVALID_DISTANCE)
			distance=1.0
			done=True
		End
		
		For Local ball3:Ball = Eachin Self.ballList
			ball3.Advance(distance)
		End
		
		For Local i:Int=0 to Self.colCount
			Self.colls[i].obj.Bounce(Self.colls[i].ball,Self.colls[i].cdx,Self.colls[i].cdy)
			If(Not((Self.firstCollision)<>Null))
				Local b1:Ball=Ball(Self.colls[i].obj)
				Local b2:Ball=Self.colls[i].ball
				If(((b1)<>Null) And b1.num=16)
					Self.firstCollision=b2
				Else
					If(b2.num=16 And ((b1)<>Null))
						Self.firstCollision=b1
					End
				End
			End
		End
		
		If(Self.totalCol>=0)
			Self.totalCol+=Self.colCount+1
		End
		
		If(Not done)
			Self.Process()
		End
	End
	
	Method Update:Void(timeFrame:Float)
	
		If(timeFrame=0.0)
			Return
		End
		
		If(timeFrame>3.0)
			timeFrame=3.0
		End
		
		For Local ball:Ball = Eachin Self.ballList
			ball.updateIn(timeFrame)
		End
		
		Self.totalCol=0
		Self.Process()
		
		For Local ball2:Ball = Eachin Self.ballList
			ball2.updateOut(timeFrame)
		End
	
	End
	
	Method RemoveBall:Void(ball:Ball)
		ball.node.Remove()
	End
	
	Method BallsMoving:Bool()
		For Local b:Ball = Eachin Self.ballList
			If(b.IsMoving())
				Return True
			End
		End
		Return False
	End
	
	Method GetFirstCollision:Ball()
		Return Self.firstCollision
	End
	
	Method ClearFirstCollision:Void()
		Self.firstCollision = Null
	End
	
	Method Render:Void()
		For Local ball:Ball = Eachin Self.ballList
			If(ball.P.x<0.0 Or ball.P.x>(DeviceWidth()) Or ball.P.y<0.0 Or ball.P.y>(DeviceHeight()))
				Error("ball exited screen ")
			End
			ball.Render()
		End
		Return
	End
	
	Method CollisionDistance2Ghost:Void(ghost:GhostBall)
		Local distance:Float=INVALID_DISTANCE
		Local cdx:Float=.0
		Local cdy:Float=.0
		For Local b:Ball = Eachin Self.ballList
			cdx=ghost.cn.x
			cdy=ghost.cn.y
			Local dist:Float=b.CollisionDistance2Ghost(ghost)
			If(dist<distance)
				distance=dist
				ghost.colBall=b
			Else
				ghost.cn.x=cdx
				ghost.cn.y=cdy
			End
		End
		For Local w:VectorObject = Eachin Self.wallList
			cdx=ghost.cn.x
			cdy=ghost.cn.y
			Local dist2:Float=w.CollisionDistance2Ghost(ghost)
			If(dist2<distance)
				ghost.colBall = Null
				distance=dist2
			Else
				ghost.cn.x=cdx
				ghost.cn.y=cdy
			End
		End
		ghost.distance=distance
	End
End

Class CollisionTrend
	Field temp:PVector2D
	Method New()
		Self.temp=New PVector2D()
	End
	Field ball:Ball
	Field obj:VectorObject
	Field cdx:Float=.0
	Field cdy:Float=.0
	Field oldL:Float=.0
End

