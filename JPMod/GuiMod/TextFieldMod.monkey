Strict
Import mojo
Import JPMod.GuiMod
Import JPMod.VectorMod

Class TextField
	Field x:Int
	Field y:Int
	Field pos:PVector2D
	Field text:String
	Field maxChars:Int
	Field cursorx:Int
	Field textImg:Image
	
	Field blink			:Int
	Field delay			:Int
	Field time			:Int
	
	Method New(x:Float,y:Float,txt:String,maxChr:Int,txtImg:Image=Null,p:PVector2D= Null,blinkDelay:Int = 200)
		If p = Null
			pos = New PVector2D(x,y)
			Self.x = 0
			Self.y = 0
		Else
			Self.pos = p
			Self.x = x
			Self.y = y
			
		Endif
		Self.maxChars = maxChr
		If txtImg = Null
			Self.textImg = GetFont()
		Else
			Self.textImg = txtImg
		Endif
		Self.delay = blinkDelay
		Self.time = Millisecs()
		Self.text = txt
		If text.Length() > maxChr text = text[..maxChr]
		cursorx = text.Length()
	End Method
	
	Method SetFont:Void(image:Image)
		textImg = image
	End Method
	
	Method GetPixelWidth:Int()
		Return (maxChars+1)*textImg.Width()
	End Method
	
	Method GetText:String()
		Return text
	End Method
	
	Method Update:Void()
		Local chr:Int = GetChar()
		If chr
			Select chr
				Case CHAR_TAB
				Case CHAR_BACKSPACE
					If cursorx > 0
						text = text[0..cursorx-1]+text[cursorx..]
						cursorx -= 1
					Endif
				Case CHAR_ENTER

				Case CHAR_ESCAPE
				
				Case CHAR_PAGEUP
					cursorx = 0
				Case CHAR_PAGEDOWN
					cursorx = text.Length()
				Case CHAR_END
					cursorx = text.Length()
				Case CHAR_HOME
					cursorx = 0
				Case CHAR_LEFT
					If cursorx > 0 
						cursorx -= 1
					Endif
				Case CHAR_UP
				Case CHAR_RIGHT
					If cursorx < text.Length()
						cursorx += 1
					Endif
				Case CHAR_DOWN
				Case CHAR_INSERT
				Case CHAR_DELETE
					If cursorx < text.Length()
							text = text[0..cursorx]+text[cursorx+1..]
					Endif				
				Default
					If text.Length()< maxChars
						text = text[0..cursorx]+String.FromChar(chr)+text[cursorx..text.Length()]
						cursorx +=1
					Endif	
			End Select
		Endif
		
		If Millisecs() > time+delay
			blink = Not blink
			time = Millisecs()
		Endif

	End Method

	Method Render:Void()
		DrawText text,pos.x+x,pos.y+y
		If blink
			DrawRect pos.x+x+cursorx*textImg.Width(),pos.y+y+textImg.Height(),8,3
		Endif
	End Method
		

End Class

