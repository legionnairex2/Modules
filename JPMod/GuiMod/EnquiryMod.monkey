Import JPMod.GuiMod

Class Enquiry

	Field x:Int
	Field y:Int
	Field frame:GuiFrame
	Field txtBox:GuiTextBox
	Field okBtn:Button
	Field cancelBtn:Button
	Field startBtn:Button
	Method New(font:AngelFont,txt:String,x:Int,y:Int,width:Int,height:Int)
		frame = New GuiFrame(x-5,y-5,width+5,height+5,$4444AA)
		txtBox = New GuiTextBox(txt,x,y,width,height)
		Local btnImage:Image = GetBtnAtlas().GrabImage(0,62,120,62,2)
		okBtn = New Button(font,btnImage,x,y+height-70,"OK")
		cancelBtn = New Button(font,btnImage,x+130,y+height - 70,"Cancel")
		startBtn = New Button(font,btnImage,x+260,y+height - 70,"Restart")
	End Method
	
	Method Update:Void()
		okBtn.Update()
		cancelBtn.Update()
		startBtn.Update()
	End Method
	
	Method IsCanceled:Int()
		Return cancelBtn.GetState() = True
	End Method
	
	Method IsOK:Int()
		Return okBtn.GetState() = True
	End Method
	
	Method IsRestart:Int()
		Return startBtn.GetState() = True
	End Method
	
	Method Render:Void()
		frame.Render()
		txtBox.Render()
		okBtn.Render()
		cancelBtn.Render()
		startBtn.Render()
	End Method
End Class

Class StringLine
	Field x:Int
	Field y:Int
	Field txt:String
	
	Method New(txt:String,x:Int,y:Int)
		Self.txt = txt
		Self.x = x
		Self.y = y
	End Method
	
	Method Render:Void()
		RenderText(txt,x,y)
	End Method
End Class


