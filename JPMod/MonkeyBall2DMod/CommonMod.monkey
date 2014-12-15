Strict
Import ShapesMod

Const ATR:Float = 180.0/PI
Const RTA:Float = PI/180.0
Const INVALID_DISTANCE:Float = 100000000


'***********************************************************************************
'
'		renders a circle at a distance relative to a ball current position
'
'***********************************************************************************

Function RenderAtDistance:Void(ball:Ball,distance:Float)
	If Not ball.image
		RenderCircle(ball.P.x+ball.V.x*distance,ball.P.y+ball.V.y*distance,ball.radius)
	Else
		DrawImage image,ball.P.x+ball.V.x*distance,ball.P.y+ball.V.y*distance
	Endif
End Function

''***********************************************************************************
'
'		renders an arc at position x,y and radius,
'		starting angle, and ending angle.
'
'************************************************************************************

Function RenderArc:Void(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float)
	
	'If angles are equal nothing to draw
	If startAngle = endAngle Then Return
	
	'make the arc clockwise
	If startAngle > endAngle
		' swap angles if order is counter-clockwise
		Local ta:Float = endAngle
		endAngle = startAngle
		startAngle = ta
	Endif
	
	'number of degrees to render
	Local angle:Float = endAngle - startAngle
	
	' no more than 360 degrees to render
	If angle > 360.0 angle = 360.0
	
	' set the step to advance one unit at a tme
	Local stp:Float = 1.0/(RTA * radius)
	
	'set the accumulator to the starting angle
	Local AccumAngle:Float = startAngle
	
	' repeat until the arc is completely drawn
	While AccumAngle < (startAngle+angle)
		
		'draw a pixel around the arc
		DrawPoint x + Cos(AccumAngle) * radius, y + Sin(AccumAngle) * radius
		
		'advance to next angle
		AccumAngle += stp
	
	Wend
End Function 

'***********************************************************************************
'
'		draws a circle at x,y and radius
'
'***********************************************************************************

Function RenderCircle:Void(x:Float,y:Float,radius:Float)
		'start angle
		Local angle:Float = 0.0
		
		' distance between each point
		Local stp:Float = 1.0/(RTA * radius)
	
		'rotate upto 360 degrees
		While angle < 360.0
	
			DrawPoint x + Cos(angle) * radius, y + Sin(angle) * radius
			
			'increment the position to draw the next point
			angle += stp
	
		Wend

End Function

'***********************************************************************************
'
'	Draws a line with of specific width
'
'
'***********************************************************************************

Function DrawLine_W:Void(XPos:Float,YPos:Float,XPos2:Float,YPos2:Float,Thickness:Float=3,roundedEnds:Int=False)
	
	Local Coords:Float[8]
	
	Local vx:Float = XPos2 - XPos
	Local vy:Float = YPos2 - YPos
	
	Local Angle:Float = ATan2(vy,vx)
	
	Local c:Float = Cos(Angle)
	Local s:Float = Sin(Angle)
	Local LineLength:Float=vx*c+vy*s
	
	Local cl:Float = LineLength*c
	Local sl:Float = LineLength*s
	
	Local r:Float = Thickness/2.0
	
	Local sr:Float = s*r
	Local cr:Float = c*r
	
	'Left top coords
	Coords[0]=XPos+sr
	Coords[1]=YPos-cr
	
	'Right top coords
	Coords[2]=cl+XPos+sr
	Coords[3]=sl+YPos-cr
	
	'Right bottom coords
	Coords[4]=cl-sr+XPos
	Coords[5]=sl+cr+YPos
	
	'Left bottom coords
	Coords[6]=XPos-sr
	Coords[7]=YPos+cr
	
	DrawPoly(Coords)	
	
	If roundedEnds = True	
		DrawCircle(XPos,YPos,r)
		DrawCircle(XPos2,YPos2,r)
	Endif

End Function

