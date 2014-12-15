Strict

Import mojo
Import JPMod.GuiMod

Class GuiFrame
	Field x:Float
	Field y:Float
	Field lft:Float
	Field top:Float
	Field right:Float
	Field bottom:Float
	Field width:Float
	Field height:Float
	Field color:Float
	
	Field leftTopImg:Image
	Field leftBotImg:Image
	Field rightTopImg:Image
	Field rightBotImg:Image
	
	Field topImg:Image
	Field botImg:Image
	Field leftImg:Image
	Field rightImg:Image
	Field areaImg:Image
	
	Method New(x:Float,y:Float,width:Float,height:Float,color:Int = $FFFFFF)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.color = color
		
		Local atlas:Image = GetAtlas()
		Self.leftTopImg = atlas.GrabImage(0, 0,16,16)
		Self.leftBotImg = atlas.GrabImage(0,16,16,16)
		Self.rightTopImg = atlas.GrabImage(16,0,16,16)
		Self.rightBotImg = atlas.GrabImage(16,16,16,16)
		
		Self.topImg = atlas.GrabImage(15, 0, 1,16)
		Self.botImg = atlas.GrabImage(15,16, 1,16)
		Self.leftImg = atlas.GrabImage(0,15,16, 1)
		Self.rightImg = atlas.GrabImage(16,15,16,1)
		Self.areaImg = atlas.GrabImage(16,16,1,1)
		
		Self.lft = x - 8
		Self.top = y - 8
		Self.bottom = y+height
		Self.right  = x+width
		
	End Method
	
	Method Setxy:Void(x:Float,y:Float)

		Self.x = x
		Self.y = y
		Self.lft = x - 8
		Self.top = y - 8
		Self.bottom = y+height
		Self.right  = x+width
	
	End Method
	
	Method SetArea:Void(w:Float,h:Float)
		width = w
		height = h
		Self.bottom = y + height
		Self.right = x + width
	End Method
	
	Method Render:Void()
		Local oldColor:Float[] = GetColor()
		GuiMod.SetColor(color)
		
		DrawImage leftTopImg, lft, top,0,.5,.5
		DrawImage rightTopImg, right, top,0,0.5,0.5
		DrawImage leftBotImg, lft, bottom,0,0.5,0.5
		DrawImage rightBotImg, right, bottom,0,0.5,0.5
		
		DrawImage topImg, x, top,0,width,.5
		DrawImage botImg, x, bottom,0,width,.5
		DrawImage leftImg,lft,y,0,.5,height
		DrawImage rightImg,right,y,0,.5,height
		DrawImage areaImg,x,y,0,width,height
		mojo.SetColor(oldColor[0],oldColor[1],oldColor[2])
		
	End Method

End Class

