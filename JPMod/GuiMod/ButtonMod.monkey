Strict
Import JPMod.GuiMod
Import JPMod.VectorMod

Class Button
	Field pos:PVector2D
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
	Field text:String
	Field offx:Float
	Field offy:Float
	Field activated:Int
	Field selected:Int
	Field oldDown:Int
	Field image:Image
	Field font:AngelFont

	Method New(font:AngelFont,img:Image,x:Int,y:Int,str:String,p:PVector2D=Null)
		Self.font= font
		If p = Null
			Self.pos = New PVector2D(x,y)
			Self.x = 0
			Self.y = 0
		Else
			pos = p
			Self.x = x
			Self.y = y
		End If
		Self.text = str
		Self.width = img.Width()
		Self.height = img.Height()
		Self.offx = offx
		Self.offy = offy
		Self.image = img
		Self.SetText(str)
	End Method
	
	Method SetText:Void(str:String)
		text = str
		If text.Length > 0
			offx = (image.Width() - font.TextWidth(str))/2.0
			offy = (image.Height() - font.TextHeight(str))/2.0
		Endif
	End Method
	
	Method Update:Void()
		Local thisDown := mouse.ButtonActivated()
		If thisDown
			If Not oldDown And inArea()
				selected = True
			Endif
		Elseif oldDown
			If selected = True
				If activated = False
					If inArea()
						activated = True
						selected = False
					Else
						selected = False
					Endif
				Endif
			Elseif activated
				activated = False
			Endif
		Else
			activated = False
		Endif
		oldDown = thisDown
	End Method
	
	Method GetState:Int()
		Local state:Int = activated
		activated = False
		Return state
	End Method

	Method inArea:Int()
		Local tx := mouse.x
		Local ty := mouse.y
		If tx < pos.x+x Return False
		If ty < pos.y+y Return False
		If tx > pos.x+x+width Return False
		If ty > pos.y+y+height Return False
		Return True	
	End Method

	Method Render:Void()
		Local index:Int = 0
		If selected Or inArea() Then index = 1
		mojo.SetColor 255,255,255
		DrawImage image,pos.x+x,pos.y+y,index
		If text.Length() > 0
			font.RenderText text,pos.x+x+offx+index,pos.y+y+offy+index	
		Endif
	End Method


End Class


Class Button2 
	Field pos:PVector2D=Null
	Field x:Float
	Field y:Float
	Field text:String=""
	Field width:Float
	Field height:Float
	Field offx:Float
	Field offy:Float
	Field image:Image

	Method SetText:Void(tstr:String)
		text=tstr
		Local tw:Int=tstr.Length*Text.CharWidth()
		offx=(image.Width()-tw)/2.0
		Local th:Int=image.Height()-Text.CharHeight()
		offy=(th)/2.0
	End Method

	Method New(timg:Image,tx:Int,ty:Int,tstr:String,tp:PVector2D=Null)
		If(tp=Null)
			pos=New PVector2D
			pos.x=(tx)
			pos.y=(ty)
			x=0.0
			y=0.0
		Else
			pos=tp
			x=(tx)
			y=(ty)
		Endif
		text=tstr
		width=(timg.Width())
		height=(timg.Height())
		offx=offx
		offy=offy
		image=timg
		SetText(tstr)
		
	End Method
	
	Field oldDown:Int=0

	Method inArea:Int()
	
		Local ttx:Float=mouse.x
		Local tty:Float=mouse.y
		If(ttx<pos.x+x)
			Return 0
		End
		If(tty<pos.y+y)
			Return 0
		End
		If(ttx>pos.x+x+width)
			Return 0
		End
		If(tty>pos.y+y+height)
			Return 0
		End
		Return 1
		 
	End Method
	
	Field selected:Int=0
	Field activated:Int=0
	
	Method Update:Void()

		Local tSelfDown:Int=mouse.ButtonInUse()

		If((tSelfDown)<>0)
			If(Not(oldDown) And inArea())
				selected=1
			End
		Elseif((oldDown)<>0)
			If(selected=1)
				If(activated=0)
					If((inArea())<>0)
						activated=1
						selected=0
					Else
						selected=0
					End
				End
			Else
				If((activated)<>0)
					activated=0
				End
			End
		End
		oldDown=tSelfDown
	End Method

	Method GetState:Int()
		Local tstate:Int=activated
		activated=0
		Return tstate
	End Method

	Method Render:Void()
		Local tindex:Int=0
		If((selected)<>0)
			tindex=1
		End
		mojo.SetColor(255.0,255.0,255.0)
		DrawImage(image,pos.x+x,pos.y+y,tindex)
		Text.Draw(text,((pos.x+x+offx+(tindex))|0),((pos.y+y+offy+(tindex))|0))
	End Method
	
End Class
