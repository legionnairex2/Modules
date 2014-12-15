Strict

Import mojo
Import JPMod.GuiMod

Class GuiTextBox
	
	Field yOffset:Int = 0	
	Field slist:List<StringLine>
	Field align:Int
	
	Const ALIGN:Int = AngelFont.ALIGN_LEFT
	Const lineGap:Int = 5
	
	Method New(text:String,x:Int,y:Int,width:Int,alignment:Int = ALIGN)
		slist = New List<StringLine>
		Local thisLine:String = ""
		Local charOffset:Int = 0
		
		Local wordLen:Int = 0
		Local word:String = ""
		
		align = alignment
		
		yOffset = 0
		For Local i := 0 Until text.Length
			If y+yOffset > DeviceHeight()
				Return
			Endif		
		
			Local asc:Int = text[i]
			Select asc
				Case 32	' space
					wordLen = ATextWidth(word)
					If charOffset + wordLen > width
						slist.AddLast(New StringLine(thisLine,x,y+yOffset))
						yOffset += lineGap+AFontHeight()
						thisLine = ""
						charOffset = 0
					Endif
					charOffset += wordLen+GetChars()[32].xAdvance
					thisLine += word + " "
					
					word = ""
				Case 10' newline
					wordLen = ATextWidth(word)
					If charOffset + wordLen > width
						slist.AddLast(New StringLine(thisLine,x,y+yOffset))
						yOffset += lineGap+AFontHeight()
						thisLine = ""
					Endif
					thisLine += word
				
					slist.AddLast(New StringLine(thisLine,x,y+yOffset))
					yOffset += lineGap+AFontHeight()
					thisLine = ""
					charOffset = 0
					word = ""
				Default
					Local ch:Char = GetChars()[asc]
					word += String.FromChar(asc)
			End Select
		Next

		If word <> ""
			wordLen = ATextWidth(word)
			If charOffset + wordLen > width
				slist.AddLast(New StringLine(thisLine,x,y+yOffset))
				yOffset += lineGap+AFontHeight()
				thisLine = ""
			Endif
			thisLine += word
		Endif
		If thisLine <> ""
			slist.AddLast(New StringLine(thisLine,x,y+yOffset))
			yOffset += lineGap+AFontHeight()
		Endif
	End Method
		
	method Render:Void()
		Local node:list.Node<StringLine> = slist.FirstNode()
		graphics.SetColor 255,255,0
		While node
			node.Value().Render()
			node = node.NextNode()
		Wend
		graphics.SetColor 255,255,255	
	End
	
End Class
