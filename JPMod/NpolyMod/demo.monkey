Strict
Import mojo
Import NpolyMod

Function Main:Int()
	New Demo
	Return True
End Function


Class Demo Extends App
	Field gear1:Poly
	Field gear2:Poly
	Field lever:Poly
	Field Rectangle:Poly[]
	Field ry:Int[]
	Field box:Poly
	Field rad:Int
	
	Field maxRect:Int
	
	Method OnCreate:Int()

		rad = 15
		maxRect = 4

		gear1 = CreateGear()

		gear2 = gear1.Copy()
		gear2.Scale(0.7, 0.7)
		
		lever = CreateLever()

		Rectangle = New Poly[4]
		ry = New Int[maxRect]
		
		Rectangle[0] = CreateRectangle()
		ry[0] = 100

		For Local i:Int = 1 Until maxRect
			Rectangle[i] = Rectangle[0].Copy()
			ry[i] = ry[0]
		Next
		
		box = CreateBox()

		SetUpdateRate(30)

		Return True

	End Method
	
	Method OnUpdate:Int()

		' Gears
		gear1.Rotate(1)
		While gear1.Overlap(150, 150, gear2, 212, 150, False)
			gear2.Rotate(-1)
		Wend
	
		' Gear And lever
		If Not gear2.Overlap(212, 150, lever, 320, 130, False)
			lever.Rotate(-1)
		End If
		While gear2.Overlap(212, 150, lever, 320, 130, False)
			lever.Rotate(1)
		Wend
		
		' Rectangles with lever
		For Local i:Int = 0 Until maxRect
			If Not Rectangle[i].Overlap(230 + 22 * i, ry[i], lever, 320, 130, False)
				ry[i] = ry[i] + 3
			End If	
			While Rectangle[i].Overlap(230 + 22 * i, ry[i], lever, 320, 130, False)
				ry[i] = ry[i] - 1
			Wend
		Next
	
		If KeyDown(KEY_UP) Then
			box.Scale(1.01, 1.01)
		End If
		If KeyDown(KEY_DOWN) Then
			box.Scale(0.99, 0.99)
		End If
		If KeyDown(KEY_LEFT) Then
			box.Rotate(3)
		End If
		If KeyDown(KEY_RIGHT) Then
			box.Rotate(-3)
		End If

			
		Return True
	End Method
	
	Method OnRender:Int()
		Cls
	
		Local mx:Int = MouseX()
		Local my:Int = MouseY()
	
		gear1.Draw(150, 150, 255, 0, 0, False)
		gear2.Draw(212, 150, 255, 0, 0, False)
		lever.Draw(320, 130, 255, 0, 0, False)
		For Local i:Int = 0 Until maxRect
			Rectangle[i].Draw(230 + 22 * i, ry[i], 255, 0, 0, False)
		Next

		box.Draw(400, 50, 255, 255, 0, False)

		DrawText "Hover mouse about this box",400, 5
		DrawText "Arrow keys",400, 20

		If box.OverlapsCircle(400, 50, mx, my, rad, False) Or box.PointInPoly(400,50,mx,my,True)
			SetColor 0, 0, 255
		Else
			SetColor 255, 255, 255
		End If
		DrawOval mx - rad, my - rad, rad*2, rad*2
	
		Return True
	End Method


	Method CreateGear:Poly()
		Local gear:Poly = New Poly
		gear.AddVertex(0, -50, False)
		gear.AddVertex(10, -10, False)
		gear.AddVertex(50, 0, False)
		gear.AddVertex(10, 10, False)
		gear.AddVertex(0, 50, False)
		gear.AddVertex(-10, 10, False)
		gear.AddVertex(-50, 0, False)
		gear.AddVertex(-10, -10, False)
		gear.AddVertex(0, -50)
		Return gear
	End Method
	
	Method CreateLever:Poly()
		Local lever:Poly = New Poly
		lever.AddVertex(-100, 5, False)
		lever.AddVertex(0, 5, False)
		lever.AddVertex(0, -5, False)
		lever.AddVertex(-100, -5, False)
		lever.AddVertex(-100, 5)
		Return lever
	End Method
	
	Method CreateRectangle:Poly()
		Local Rectangle:Poly = New Poly
		Rectangle.AddVertex(-9, 20, False)
		Rectangle.AddVertex(9, 20, False)
		Rectangle.AddVertex(9, -20, False)
		Rectangle.AddVertex(-9, -20, False)
		Rectangle.AddVertex(-9, 20)
		Return Rectangle
	End Method	

	Method CreateBox:Poly()
		Local box:Poly = New Poly()
		box.AddVertex(0, 0, False)
		box.AddVertex(200, 0, False)
		box.AddVertex(170, 70, False)
		box.AddVertex(200, 200, False)
		box.AddVertex(30, 200, False)
		box.AddVertex(65, 130, False)
		box.AddVertex(0, 180, False)
		box.AddVertex(0, 0)
		Return box
	End Method	
	
End Class











