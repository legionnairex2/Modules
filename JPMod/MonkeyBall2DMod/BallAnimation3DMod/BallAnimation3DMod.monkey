Strict
Import Mojo
Import JPMod.MonkeyBall2DMod

Class ABall3D Extends ObjectAnimation
	Field oldP:PVector2D=New PVector2D()
	Field textColor:Color
	Field ball3d:Ball3d
	Field image:Image
	Method New(t_P:PVector2D,radius:Float,image:Image,ballColor:Int,textColor:Int,number:Int)
		Self.P=t_P
		Self.oldP.x=t_P.x
		Self.oldP.y=t_P.y
		Self.color=New BallAnimationMod.Color(ballColor)
		Self.textColor=New Color(textColor)
		If(number<16)
			Self.ball3d= New Ball3d(number,radius-1.0)
		End
		Self.image=image
	End

	Method Rotate:Void(vx:Float,vy:Float)
		If((Self.ball3d)<>Null)
			Self.ball3d.Rotate(vx,vy)
		End
	End
	Method Reset:Void()
		If((Self.ball3d)<>Null)
			Self.ball3d.Reset()
		End
	End
	Method Render:Void()
		graphics.SetColor(0.0,0.0,0.0)
		SetAlpha(.3)
		DrawImage(Self.image,Self.P.x+3.0,Self.P.y-1.0,0)
		SetAlpha(1.0)
		Self.color.Set()
		DrawImage(Self.image,Self.P.x,Self.P.y,0)
		Self.textColor.Set()
		If((Self.ball3d)<>Null)
			Self.ball3d.Display(Self.P.x,Self.P.y)
		End
	End
End

Class Ball3d
	Field distance:Float=.0
	Field radius:Float=.0
	Field nodeList:List<Node3d>
	Global numbers:Int[][][]
	Method Decorate:Void(n:Int)
		If(n=0)
			Return
		End
		Local s:String=String(n)
		Local len:Float=(s.Length)
		For Local i:Float=0.0 Until len
			Local t_o:Int=s[i]-48
			For Local yaw:Float=0.0 Until 8.0
				For Local pitch:Float=0.0 Until 5.0
					Local t_:Int=((yaw))
					Local t_2:Int=((pitch))
					If((numbers[t_o][t_][t_2])<>0)
						Local node:Node3d= New Node3d()
						node.z=-(Cos((-20.0+yaw*7.0))*Cos((-20.0+pitch*7.0)))*(Self.radius-1.0)
						node.y=Cos((-20.0*len+i*32.0+yaw*7.0))*Sin((-20.0*len+i*30.0+pitch*8.0))*(Self.radius-1.0)
						node.x=Sin((-20.0+yaw*7.0))*(Self.radius-1.0)
						node.sx=node.x
						node.sy=node.y
						node.sz=node.z
						node.link=Self.nodeList.AddLast(node)
						Local node2:Node3d=New Node3d()
						node2.x=node.x
						node2.y=-node.y
						node2.z=-node.z
						node2.sx=node2.x
						node2.sy=node2.y
						node2.sz=node2.z
						node2.link=Self.nodeList.AddLast(node2)
					End
				End
			End
		End
		If(n>8)
			For Local i2:Float=0.0 Until 360.0
				Local node3:Node3d= New Node3d()
				node3.x=Cos((0.0))*Cos((i2))*Self.radius
				node3.y=Cos((0.0))*Sin((i2))*Self.radius
				node3.z=Sin((0.0))*Self.radius
				node3.sx=node3.x
				node3.sy=node3.y
				node3.sz=node3.z
				node3.link=Self.nodeList.AddLast(node3)
			End
		End
	End
	Method New(n:Int,rad:Float)
		Self.distance=500.0
		Self.radius=rad
		Self.nodeList=New List<Node3d>()
		If( Not (numbers.Length<>0))
			numbers=[[[0,0,1,1,0],[0,1,0,0,1],[0,1,0,0,1],[0,1,0,0,1],[0,1,0,0,1],[0,1,0,0,1],[0,0,1,1,0],[0,0,0,0,0]],
					[[0,0,1,0,0],[0,1,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,1,1,1,0],[0,0,0,0,0]],
					[[0,1,1,1,0],[0,1,0,0,1],[0,0,0,0,1],[0,0,0,1,0],[0,0,1,0,0],[0,1,0,0,0],[0,1,1,1,1],[0,0,0,0,0]],
					[[0,1,1,1,0],[0,0,0,0,1],[0,0,0,0,1],[0,0,1,1,0],[0,0,0,0,1],[0,0,0,0,1],[0,1,1,1,0],[0,0,0,0,0]],
					[[0,0,0,1,0],[0,0,1,1,0],[0,1,0,1,0],[1,0,0,1,0],[1,1,1,1,1],[0,0,0,1,0],[0,0,0,1,0],[0,0,0,0,0]],
					[[0,1,1,1,1],[0,1,0,0,0],[0,1,0,0,0],[0,0,1,1,0],[0,0,0,0,1],[0,0,0,0,1],[0,1,1,1,0],[0,0,0,0,0]],
					[[0,0,1,1,0],[0,1,0,0,0],[0,1,0,0,0],[0,1,0,1,0],[0,1,0,0,1],[0,1,0,0,1],[0,0,1,1,0],[0,0,0,0,0]],
					[[0,1,1,1,1],[0,0,0,0,1],[0,0,0,1,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,1,0,0],[0,0,0,0,0]],
					[[0,0,1,1,0],[0,1,0,0,1],[0,1,0,0,1],[0,0,1,1,0],[0,1,0,0,1],[0,1,0,0,1],[0,0,1,1,0],[0,0,0,0,0]],
					[[0,0,1,1,0],[0,1,0,0,1],[0,1,0,0,1],[0,0,1,1,1],[0,0,0,0,1],[0,1,0,0,1],[0,0,1,1,0],[0,0,0,0,0]]]
		End
		Self.Decorate(n)
	End

	Method Rotate_z:Void(a:Float)
		If(Self.nodeList.IsEmpty())
			Return
		End
		Local cx:Float=Cos((a))
		Local cy:Float=Sin((a))
		Local link:list.Node<Node3d>=Self.nodeList.First().link
		While(link<>Null)
			Local node:Node3d=link.Value()
			Local tx:Float=node.x*cx-node.y*cy
			Local ty:Float=node.x*cy+node.y*cx
			node.y=ty
			node.x=tx
			link=link.NextNode()
		End
	End
	Method Rotate_y:Void(a:Float)
		If(Self.nodeList.IsEmpty())
			Return
		End
		Local cx:Float=Cos((a))
		Local cy:Float=Sin((a))
		Local link:list.Node<Node3d>=Self.nodeList.First().link
		While(link<>Null)
			Local node:Node3d=link.Value()
			Local tz:Float=node.z*cx-node.x*cy
			Local tx:Float=node.z*cy+node.x*cx
			node.z=tz
			node.x=tx
			link=link.NextNode()
		End
	End
	Method Rotate:Void(vx:Float,vy:Float)
		Local roll:Float=Sqrt(vx*vx+vy*vy)
		Local rot:Float=(ATan2(vy,vx))
		Self.Rotate_z(-rot)
		Self.Rotate_y(roll*Self.radius)
		Self.Rotate_z(rot)
	End
	Method Reset:Void()
		If(Self.nodeList.IsEmpty())
			Return
		End
		Local link:list.Node<Node3d>=Self.nodeList.First().link
		While((link)<>Null)
			Local node:Node3d=link.Value()
			node.x=node.sx
			node.y=node.sy
			node.z=node.sz
			link=link.NextNode()
		End
	End
	Method Display:Void(x:Float,y:Float)
		If(Self.nodeList.IsEmpty())
			Return
		End
		Local link:list.Node<Node3d>=Self.nodeList.First().link
		While((link)<>Null)
			Local node:Node3d=link.Value()
			If(node.z>-1.0)
				DrawOval(x+node.x,y+node.y,1.0,1.0)
			End
			link=link.NextNode()
		End
	End
End
Class Node3d
	Field z:Float
	Field y:Float
	Field x:Float
	Field sx:Float
	Field sy:Float
	Field sz:Float
	Field link:list.Node<Node3d>
End