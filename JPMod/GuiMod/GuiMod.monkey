Import mojo
Import JPMod.GUiMod.ButtonMod
Import JPMod.GUiMod.bitmapFont
Import JPMod.GUiMod.varyFontMod
Import JPMod.GUiMod.FrameAnimMod
Import JPMod.GUiMod.TextFieldMod
Import JPMod.GUiMod.GetNameGuiMod
Import JPMod.GUiMod.EnquiryMod
Import JPMod.GUiMod.FrameMod
Import JPMod.GUiMod.TextBoxMod
Import JPMod.FontMod
Import JPMod.MouseMod

Import "data/frame.png"
Import "data/button.png"

Global __atlas:Image
Global __btnAtlas:Image

Function GetAtlas:Image()
	If __atlas = Null
		__atlas = LoadImage("frame.png")
	Endif
	Return __atlas
End Function

Function GetBtnAtlas:Image()
	If __btnAtlas = Null
		__btnAtlas = LoadImage("button.png")	
	Endif
	Return __btnAtlas
End Function

Function SetColor:Void(color:Int)
	mojo.SetColor color Shr 16 & $FF,color Shr 8 & $FF,color & $FF
End Function

Function SetColor:Void(r:Int,g:Int,b:Int)
	mojo.SetColor r,g,b
End Function

Function CombineColors:Int(r:Int,g:Int,b:Int)
		Return (r & $FF) Shl 16 | (g & $FF) Shl 8 | (b & $FF)
End Function 