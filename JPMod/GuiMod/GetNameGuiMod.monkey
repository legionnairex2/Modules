Strict

Import mojo
Import JPMod.GuiMod
Import JPMod.VectorMod

Class TextFieldGui
	Field pos:PVector2D
	Field x:Int
	Field y:Int
	Field image:Image
	Field cancelBtn:Button2
	Field okBtn:Button2
	Field textField:TextField
	Method New(x:Int,y:Int,txt:String,p:PVector2D,blinkDelay:Int)
		If( Not p)
			Self.pos=New PVector2D()
			Self.pos.x=(x)
			Self.pos.y=(y)
			Self.x=0
			Self.y=0
		Else
			Self.pos=p
			Self.x=x
			Self.y=y
		End
		Self.image=media.getNameImg
		Self.cancelBtn=New Button2(media.smallBtnImg,50,110,"Cancel",Self.pos)
		Self.okBtn=New Button2(media.smallBtnImg,200,110,"Ok",Self.pos)
		Self.textField=New TextField(30.0,72.0,txt,15,Null,Self.pos,blinkDelay)
	End
	
	Method Update:Int()
		Self.textField.Update()
		Self.cancelBtn.Update()
		Self.okBtn.Update()
		Local t_1:Bool=True
		If(((t_1))=Self.cancelBtn.GetState())
			Return -1
		Else
			If(((t_1))=Self.okBtn.GetState())
				If(Self.textField.GetText()="")
					Return 1
				End
				Return 0
			End
		End
		Return 1
	End
	Method GetText:String()
		Local t_:String=Self.textField.GetText()
		Return t_
	End
	Method Render:Void()
		DrawImage(Self.image,Self.pos.x+(Self.x),Self.pos.y+(Self.y),0)
		Self.textField.Render()
		Self.cancelBtn.Render()
		Self.okBtn.Render()
	End
End


#Rem
Class TextFieldGui
	Field x				:Int
	Field y				:Int
	Field pos			:PVector2D
	Field textField		:TextField
	Field text			:String
	Field cancelBtn		:Button2
	Field okBtn			:Button2
	Field image			:Image
	
	Method New(aFont:AngelFont,x:Int,y:Int,txt:String,p:PVector2D = Null,blinkDelay:Int = 200)
		If p = Null
			Self.pos = New PVector2D
			Self.pos.x = x
			Self.pos.y = y
			Self.x = 0
			Self.y = 0
		Else
			pos = p
			Self.x = x
			Self.y = y
		Endif
		
		Self.image = media.getNameImg
		Self.cancelBtn = New Button2(media.smallBtnImg,50,110,"Cancel",pos)
		Self.okBtn = New Button2(media.smallBtnImg,200,110,"Ok",pos)
		Self.textField = New TextField(30,72,txt,15,Null,pos,blinkDelay)
		
	End Method
	
	Method GetText:String()
		Return textField.GetText()
	End Method
	
	Method Update:Int()
		textField.Update()
		cancelBtn.Update()
		okBtn.Update()
		Select True
			Case cancelBtn.GetState()
				Return -1
			Case okBtn.GetState()
				If textField.GetText() = ""
					Return 1
				Endif
				Return 0
		End Select
		Return 1
	End Method
	
	Method Render:Void()
		DrawImage image,pos.x+x,pos.y+y
		textField.Render()
		cancelBtn.Render()
		okBtn.Render()	
	End Method
	
End Class

#End
			
