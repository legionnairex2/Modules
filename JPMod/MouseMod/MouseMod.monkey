Strict
Import mojo

Const	BUTTONDEACTIVATED		:Int =  3
Const 	BUTTONDOWN				:Int =  2
Const	BUTTONPRESSED			:Int =  1
Const	BUTTONFREE				:Int =  0
Const	REPEATTIME				:Int =250 'in milliseconds

Global	mouse					:Mouse = New Mouse

Class Mouse

	Field 	x					:Int,
			y					:Int,
			pressed				:Int[3],
			released			:Int[3],
			doublePressed		:Int[3],
			mousewheel			:Int	
	
	Field	oldx				:Int,
			oldy				:Int,
			oldpressed			:Int[3],
			oldReleased			:Int[3],
			oldmousewheel		:Int

	Field	turnDifference		:Int,
			selected			:Int
	
	Field	state				:Int[3],
			clickCount			:Int[3],
			endTime				:int[3]

	Field	called				:Int

	' Update needs to be called in the main OnUpdate method 
	' before any other use of the mouse methods. 

	Method Update:void() 
		called = True 
		oldx = x
		oldy = y
		oldmousewheel = mousewheel
		x = MouseX()
		y = MouseY()
		
		For Local b:Int = 0 To 2
			
			oldpressed[b] = pressed[b]
			pressed[b] = MouseDown(b)  
			
			If oldpressed[b]
			
				If pressed[b]
					state[b] = BUTTONDOWN
				Else
					state[b] = BUTTONDEACTIVATED
				EndIf
			
			ElseIf pressed[b]
				state[b] = BUTTONPRESSED
			Else
				state[b] = BUTTONFREE
			EndIf
		
			doublePressed[b] = False
		
			If state[b] = BUTTONPRESSED
			
				If clickCount[b] = 0
			
					clickCount[b] = 1 'first click
					endTime[b] = Millisecs() + REPEATTIME
			
				Else'second click
			
					If Millisecs() < endTime[b] 
						doublePressed[b] = True 
					EndIf
					clickCount[b] = 0
			
				EndIf
			ElseIf Millisecs() > endTime[b]
			
				clickCount[b] = 0
			
			EndIf
		Next
	End Method
	' checks if mouse cursor is with in a specified area
	' h = start x
	' v = start y
	' width of area
	' height of area
	' returns true if in area false if not	

	Method InArea:bool(h:Int, v:Int, width:Int, height:Int)	

		If x < h Return False
		If x > (h+width) Return False
		If y < v Return False
		If y > (v + height) Return False
		Return True

	End Method
	
	' returns mouse x and y position
	' through input variables a and d.

	'returns true if a mouse "double click" was completed with in current cycle frame. 	

	Method DoubleClick:Int(selected:Int = 0)
		selected &= 3
		
		Return DoublePressed[selected]

	End Method
	
	' returns true if a specified mouse button is still pressed based on previos frame.
	
	Method ButtonInUse:Int(selected:Int = 0)
		selected &= 3

		If state[selected] = BUTTONDOWN 
			Return True
		EndIf
		Return False

	End Method
	
	' returns true if the pre-specified mouse button was pressed on current frame.
	
	Method ButtonActivated:Int(selected:Int = 0)
		selected &= 3 

		If state[selected] = BUTTONPRESSED
			Return True
		EndIf
		Return False

	End Method
	
	'returns true if a pre-specified buttone was released in current cycle
	
	Method ButtonReleased:Int(selected:Int = 0)
		selected &= 3
		
		If state[selected] = BUTTONDEACTIVATED
			Return True
		EndIf
		
		Return False

	End Method
	
	Method ButtonFreed:Int(selected:Int = 1)
		selected &= 3
		
		If state[selected] = BUTTONFREE
			Return True
		EndIf
		
		Return True
	
	End Method
	
	'return true if the mouse button was moved based on previos frame and current frame.
	
	Method moved:Int()

		If oldx <> x Return True
		If oldy <> y Return True
		Return False

	End Method
	
	' same as above but for x only
	
	Method MovedX:Int()

		If oldx <> x Return True
		Return False

	End Method 
	
	' same as above but for y only
	
	Method movedy:Int()

		If oldy <> y Return True
		Return False

	End Method
	
	' returns mouse speed(difference between current frame x and previous frame x
	
	Method Thrustx:Int()

		Return x - oldx

	End Method
	
	' returns mouse speed(difference between current frame y and previous frame y
	
	Method Thrusty:Int()

		Return y - oldy

	End Method
	
	' returns mouse wheel speed based on current frame and prvious frame position.
	
	Method wheelThrust:Int() 
		
		Return mouseWheel - oldMouseWheel		

	End Method

End Class




