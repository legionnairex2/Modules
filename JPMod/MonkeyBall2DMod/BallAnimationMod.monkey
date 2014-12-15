Strict

Import MonkeyBall2DMod
Import JPMod.VectorMod


Class ObjectAnimation
	Field P:PVector2D
	Field color:Color

	Method Reset:Void() Abstract

	Method Render:Void() Abstract

End



Class AImageLineStained Extends ObjectAnimation
	Field angle:Float=.0
	Field Length:Float=.0
	Field image:Image
	
	Method New(t_P:PVector2D,vx:Float,vy:Float,image:Image,color:Int)
		Self.P=t_P
		Self.angle=-(ATan2(vy,vx))
		Self.Length=Sqrt(vx*vx+vy*vy)
		Self.image=image
		Self.color=New BallAnimationMod.Color(color)
	End

	Method Reset:Void()
	End

	Method Render:Void()
		Self.color.Set()
		DrawImage(Self.image,Self.P.x,Self.P.y,Self.angle,Self.Length,1.0,0)
	End
End

Class Color

	Field red:Int
	Field green:Int
	Field blue:Int
	
	Method New(color:Int)
		red  =(color & $FF0000 ) Shr 16
		green=(color & $FF00) Shr 8
		blue = color & $FF
	End Method

	Method Set:Void()
		SetColor red,green,blue
	End Method
	
End Class

Class APixelLine Extends ObjectAnimation
	Field vx:Float=.0
	Field vy:Float=.0

	Method New(P:PVector2D,vx:Float,vy:Float,color:Int)
		self.P = P
		self.vx= vx
		self.vy= vy
		self.color=New Color(color)
	End Method
	
	Method Reset:Void()
	End Method

	Method Rotate:Void(vx:Float,vy:float)
	End Method
	
	Method Render:Void()
		self.color.Set()
		DrawLine(self.P.x,self.P.y,self.P.x+self.vx,self.P.y+self.vy)
	End Method
	
End Class

Class AImageArcStained Extends ObjectAnimation
	Field image:Image

	Method New(P:PVector2D,image:Image,color:Int)

		self.P=P
		self.image=image
		self.color = New Color(color)
		
	End Method
	
	Method Reset:Void()
	End Method
	
	Method Rotate:Void(vx:Float,vy:float)
	End Method
	
	Method Render:Void()
		self.color.Set()
		DrawImage(image,P.x,P.y,0)
	End Method

End Class

Class APixelArc Extends ObjectAnimation
	Field radius:Float=.0
	Field startAngle:Float=.0
	Field endAngle:Float=.0
	Field stp:Float=.0

	Method New(P:PVector2D,radius:Float,startAngle:Float,endAngle:Float,color:Int)

		self.P=P
		self.radius=radius
		self.startAngle=startAngle
		self.endAngle=endAngle
		self.color = New Color(color)
		Self.stp=1.0/(0.017453292500000002 * radius)
	End Method
	
	Method Reset:Void()
	End Method
	
	Method Rotate:Void(vx:Float,vy:float)
	End method
	
	Method Render:Void()
	
		self.color.Set()
		
		If(self.startAngle = self.endAngle)
			Return
		Endif
		
		Local angle:Float=self.endAngle-self.startAngle
		Local AccumAngle:Float=self.startAngle
		Local rad2:Float=self.radius*2.0
		
		While(AccumAngle < self.startAngle+angle)
			DrawRect(self.P.x+Cos(AccumAngle)*self.radius-0.5,self.P.y+Sin(AccumAngle) * self.radius-0.5,1.0,1.0)
			AccumAngle += self.stp
		Wend
		
	End Method
	
End Class

Class Vec2D
	Field x:Float=.0
	Field y:Float=.0
	Field len:Float=.0
	Field dx:Float=.0
	Field dy:Float=.0

	Method New(x1:Float, y1:Float, x2:Float, y2:Float)
		x = x1
		y = y1
		
		Local vx:Float = x2 - x1
		Local vy:Float = y2 - y1
		
		If (vx<>0.0) Or (vy <> 0.0)
			len = Sqrt(vx*vx + vy*vy)
			dx = vx / len
			dy = vy / len
		Else
			len = 0.0
			dx  = 0.0
			dy  = 0.0
		Endif
		
	End Method
	
End Class


Class Wall

	Field name:String=""
	Field image:Image
	Field x1:Float=.0
	Field y1:Float=.0
	Field color:Int=0
End
Class Arc Extends Wall
	Field radius:Float=.0
	Field startAngle:Float=.0
	Field endAngle:Float=.0
	Field cx:Float=.0
	Field cy:Float=.0
	Method New(x1:Float,y1:Float,radius:Float,startAngle:Float,endAngle:Float,colx:Float,coly:Float,image:Image,color:Int)
		Self.name="Arc"
		Self.image=image
		Self.radius=radius
		Self.startAngle=startAngle
		Self.endAngle=endAngle
		Self.x1=x1
		Self.y1=y1
		Self.cx=colx
		Self.cy=coly
		Self.color=color
	End

End
Class Line Extends Wall
	Field x2:Float=.0
	Field y2:Float=.0
	
	Method New(x1:Float,y1:Float,x2:Float,y2:Float,image:Image,color:Int)
		Self.name="Line"
		Self.image=image
		Self.x1=x1
		Self.y1=y1
		Self.x2=x2
		Self.y2=y2
		Self.color=color
	End

End
