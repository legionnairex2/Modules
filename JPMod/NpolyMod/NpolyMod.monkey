Import mojo

' nPoly - Polygonal Collision Library
' By Jocelyn 'GoSsE' Perreault, <a href="http://www.nuloen.com/" target="_blank">http://www.nuloen.com/</a>
' Last Updated: July 8 2004
' Version: 1.0.0

' This source code is copyrighted (c) To Jocelyn Perreault.
' It is FreeWare. You have no limitiations in regard To 
' applications/games that you Release/create with it, either
' they be freeware Or commercial. However, you cannot Release
' this source code under another name Or Release a similar
' library with it. It cannot be redistributed. The code may be 
' modified To be tweaked but you cannot distribute it. If you
' made a modification that you think the community would
' benifit, please let me know.
' If you make tons of money with a commercial project,
' a free copy wouldn't hurt ')
' I would love To have an e-mail And a place in the credits
' of your projects, but it is up To you.
' Thanks,
'                 Jocelyn "GoSsE Korupted" Perreault
'                  <a href="mailto:gosse@nuloen.com">gosse@nuloen.com</a>
'                  Nuclear Loaded Entertainment
'                  <a href="http://www.nuloen.com/" target="_blank">http://www.nuloen.com/</a>
' Several modifications made by Me Jesse 'JumpMan' Perez
'
' ======================================================================
' Globals And Constants
' ======================================================================
Const nP_MAX:Int = 32			' Maximum number of vertices For a poly

' ======================================================================
' Different objects
' ======================================================================
Class PVect
	Field x:Float
	Field y:Float
	
	Method New(x:Float,y:Float)
		Self.x = x
		Self.y = y
	End Method
End Class

' Polygon

Class Poly
	Field iN:PVect[nP_MAX]	' Vertices X position Y position
	Field fX:PVect[nP_MAX]	' Scaled And rotated X and Y position
	Field iVertexCount:Int		' Number of vertices
	Field fScaleX:Float			' X-Scale
	Field fScaleY:Float			' Y-Scale
	Field fAngle:Float			' Angle rotation
	Field iMinX:Int				' Bounding box
	Field iMinY:Int				' Bounding box
	Field iMaxX:Int				' Bounding box
	Field iMaxY:Int				' Bounding box
	Field lateBoundingBoxCheck:Int =False
	' ======================================================================
	' Functions
	' ======================================================================

	' Creates a New empty polygon
	Method New()
		fScaleX = 1
		fScaleY = 1
	End Method

	' ----------------------------------------------------------------------
	
	' Adds a vertex To a polygon
	Method AddVertex:Void(x:Float, y:Float, bUpdate:Int = True)
		If iVertexCount > nP_MAX Then
			Error "Cannot add one more vertex to polygon!"
		Else
			iN[iVertexCount] = New PVect
			fX[iVertexCount] = New PVect
			iN[iVertexCount].x = x
			iN[iVertexCount].y = y
			iVertexCount += 1
			If bUpdate Then
				Update()
			End If
		End If
	End Method

	' ----------------------------------------------------------------------
	' Checks If 2 polygons overlap each other
	
	Method Overlap:Int(x1:Float, y1:Float, poly2:Poly, x2:Float, y2:Float, bCheckBounding:Int = True)
	
		'Temp positions
		Local tx1:Float, ty1:Float, tx2:Float, ty2:Float, tx3:Float, ty3:Float, tx4:Float, ty4:Float
		Local xi:Float,yi:Float,xj:Float,yj:Float,nx:Float,ny:Float
		Local i:Int, j:Int, k:Int, c:Int
		' Checks bounding box first (If specified)
		If bCheckBounding Then	
			tx1 = x1 + iMinX
			ty1 = y1 + iMinY
			tx2 = x1 + iMaxX
			ty2 = y1 + iMaxY
			tx3 = x2 + poly2.iMinX
			ty3 = y2 + poly2.iMinY
			tx4 = x2 + poly2.iMaxX
			ty4 = y2 + poly2.iMaxY
			If Not (tx3 >= tx1 And ty3 >= ty1 And tx3 <= tx2 And ty3 <= ty2) Then
				If Not (tx4 >= tx1 And ty4 >= ty1 And tx4 <= tx2 And ty4 <= ty2) Then
					If Not (tx3 >= tx1 And ty4 >= ty1 And tx3 <= tx2 And ty4 <= ty2) Then
						If Not (tx4 >= tx1 And ty3 >= ty1 And tx4 <= tx2 And ty3 <= ty2) Then
							Return False
						End If
					End If
				End If
			End If
		End If
		For k = 0 To poly2.iVertexCount -1
			nx = poly2.fX[k].x+x2
			ny = poly2.fX[k].y+y2
			j = iVertexCount -1
			For i = 0 To iVertexCount - 1
   	    		xi = fX[i].x + x1
				yi = fX[i].y + y1
				xj = fX[j].x + x1
				yj = fX[j].y + y1
				If ((((yi<=ny) And (ny<yj)) Or ((yj<=ny) And (ny<yi))) And 
					(nx < (xj - xi) * (ny - yi) / (yj - yi) + xi))
					c = Not c
				Endif
				j = i
   		 	Next
   		 	If c Return c
		Next
		For k=0 To iVertexCount -1
			nx = fX[k].x+x1
			ny = fX[k].y+y1
			j = poly2.iVertexCount - 1
			For i = 0 To poly2.iVertexCount - 1
    	   		xi = poly2.fX[i].x + x2
				yi = poly2.fX[i].y + y2
				xj = poly2.fX[j].x + x2
				yj = poly2.fX[j].y + y2
				If ((((yi<=ny) And (ny<yj)) Or ((yj<=ny) And (ny<yi))) And
					(nx < (xj - xi) * (ny - yi) / (yj - yi) + xi)) c = Not c
				j = i
    		Next
    		If c Return c
		Next
		Return False
	End Method

	' ----------------------------------------------------------------------

	Method OverlapsCircle:Int(X:Float, Y:Float, iCircleX:Float, iCircleY:Float, iCircleRadius:Float, bCheckBounding:Int = True)
		' Temp positions
		Local tx1:Float, ty1:Float, tx2:Float, ty2:Float, tx3:Float, ty3:Float, tx4:Float, ty4:Float
		Local CX1:Float, CY1:Float, CX2:Float, CY2:Float, pX1:Float, pY1:Float, pX2:Float, pY2:Float, pXT:Float, pYT:Float
		' Delta calculations
		Local d1:Float, d2:Float, dX:Float, dY:Float, dSqr:Float
		' Checks bounding box first (If specified)
		If bCheckBounding Then
			tx1 = X + iMinX
			ty1 = Y + iMinY
			tx2 = X + iMaxX
			ty2 = Y + iMaxY
			tx3 = iCircleX - iCircleRadius
			ty3 = iCircleY - iCircleRadius
			tx4 = iCircleX + iCircleRadius
			ty4 = iCircleY + iCircleRadius
			If Not (tx3 >= tx1 And ty3 >= ty1 And tx3 <= tx2 And ty3 <= ty2) Then
				If Not (tx4 >= tx1 And ty4 >= ty1 And tx4 <= tx2 And ty4 <= ty2) Then
					If Not (tx3 >= tx1 And ty4 >= ty1 And tx3 <= tx2 And ty4 <= ty2) Then
						If Not (tx4 >= tx1 And ty3 >= ty1 And tx4 <= tx2 And ty3 <= ty2) Then
							Return False
						End If
					End If
				End If
			End If
		End If
		' Store the last vertex & circle
		Local lx:Float = fX[0].x + X
		Local ly:Float = fX[0].y + Y
		CX2 = iCircleX
		CY2 = iCircleY
		' Cycle through all other vertices
		For Local i:Int = 0 To iVertexCount - 1	
			CX1 = fX[i].x + X
			CY1 = fX[i].y + Y
			pX1 = lx - CX1
			pY1 = ly - CY1
			pX2 = CX2 - CX1
			pY2 = CY2 - CY1
			d1 = pX1 * pX2 + pY1 * pY2
			If d1 <= 0 Then
				dX = CX2 - CX1
				dY = CY2 - CY1
				dSqr = dX * dX + dY * dY
			Else
				d2 = pX1 * pX1 + pY1 * pY1
				If (d2 <= d1) Then
					dX = CX2 - lx
					dY = CY2 - ly
					dSqr = dX * dX + dY * dY
				Else
					d1 = d1 / d2
					pXT = CX1 + d1 * pX1
					pYT = CY1 + d1 * pY1
					dX = CX2 - pXT
					dY = CY2 - pYT
					dSqr = dX * dX + dY * dY
				End If
			End If
			If dSqr < iCircleRadius * iCircleRadius Then
				Return True
			End If
			lx = CX1
			ly = CY1
		Next
		Return False	
	End Method

	' ----------------------------------------------------------------------
	Method  PointInPoly:Int(polyx:Float,polyy:Float,pointx:Float,pointy:Float,bCheckBounding:Int = True)
      
      	Local tx1:Float, ty1:Float, tx2:Float, ty2:Float
		Local xi:Float,yi:Float,xj:Float,yj:Float,nx:Float,ny:Float
		Local i:Int, j:Int, k:Int
		' Checks bounding box first (If specified)
		If bCheckBounding Then	
			tx1 = polyx + iMinX
			ty1 = polyy + iMinY
			tx2 = polyx + iMaxX
			ty2 = polyy + iMaxY
			If Not (pointx >= tx1 And pointy >= ty1 And pointx <= tx2 And pointy <= ty2) Then
				If Not (pointx >= tx1 And pointy >= ty1 And pointx <= tx2 And pointy <= ty2) Then
					If Not (pointx >= tx1 And pointy >= ty1 And pointx <= tx2 And pointy <= ty2) Then
						If Not (pointx >= tx1 And pointy >= ty1 And pointx <= tx2 And pointy <= ty2) Then
							Return False
						End If
					End If
				End If
			End If
		End If
		j = iVertexCount -1
		Local collided:Int = False
		For i = 0 To iVertexCount - 1
      	   	xi = fX[i].x + polyx
			yi = fX[i].y + polyy
			xj = fX[j].x + polyx
			yj = fX[j].y + polyy    
			If ((((yi<=pointy) And (pointy<yj)) Or ((yj<=pointy) And (pointy<yi))) And
				(pointx < (xj - xi) * (pointy - yi) / (yj - yi) + xi)) collided = Not collided
			j = i
      	Next
      	Return collided
		
	End Method
	
	' ---------------------------------------------------------------------- 	
	
	' Scales the polygon by the specified scale
	Method Scale:Void(sx:Float, sy:Float, bUpdate:Int = True)
		fScaleX = fScaleX * sx
		fScaleY = fScaleY * sy
		If bUpdate Then
			Update()
		End If
	End Method
	
	' ----------------------------------------------------------------------
	
	' Resizes the polygon To the specieid scale
	Method Resize:Void(sx:Float, sy:Float, bUpdate:Float = True)
		fScaleX = sx
		fScaleY = sy
		If bUpdate Then
			Update()
		End If
	End Method

	' ----------------------------------------------------------------------
	
	' Rotates the polygon by the specified rotation angle
	Method Rotate:Void(fRot:Float, bUpdate:Int = True)
		fAngle += fRot
		If bUpdate Then
			Update()
		End If
	End Method

	' ----------------------------------------------------------------------
	
	' Turns the polygon To the specified angle
	Method FreeRotate:Void(fAngle:Float, bUpdate:Int = True)
		Self.fAngle = fAngle
		If bUpdate Then
			Update()
		End If
	End Method
	
	' ----------------------------------------------------------------------
	
	' Updates the polygon according To scale And rotation
	Method Update:Void()
		
		Local fX:Float, fY:Float, f1:Float, f2:Float
		Local i:Int
		' Set up big extremums
		iMinX = 9999999
		iMinY = 9999999
		iMaxX = -9999999
		iMaxY = -9999999
		' Find a valid collision setting
		For i = 0 To iVertexCount - 1
			' Standard data
			fX = iN[i].x
			fY = iN[i].y
			' Scale
			fX = fX * fScaleX
			fY = fY * fScaleY
			' Rotation
			If fAngle <> 0 Then
				f1 = Cos(fAngle) * fX - Sin(fAngle) * fY
				f2 = Sin(fAngle) * fX + Cos(fAngle) * fY
				fX = f1
				fY = f2
			End If
			' Final Values
			Self.fX[i].x = fX
			Self.fX[i].y = fY
			' Check For bounding box
			If fX < iMinX Then
				iMinX = fX
			End If
			If fY < iMinY Then
				iMinY = fY
			End If
			If fX > iMaxX Then
				iMaxX = fX
			End If
			If fY > iMaxY Then
				iMaxY = fY
			End If
		Next
	End Method
	
	' ----------------------------------------------------------------------
	
	' Draws the polygon on screen at the specified location
	Method Draw:Void(x:Float, y:Float, r:Int=255, g:Int=255, b:Int=255, bDrawBoundingBox:Int = True, br:Int=255, bg:Int=255, bb:Int=255)
		Local i:Int, lx:Float, ly:Float
		' Draw bounding box (If specified)
		If bDrawBoundingBox Then
			SetColor br, bg, bb
			Local x1:Int = iMinX + x
			Local y1:Int = iMinY + y
			Local x2:Int = iMaxX + x
			Local y2:Int = iMaxY + y
			DrawLine x1,y1,x2,y1
			DrawLine x1,y1,x1,y2
			DrawLine x1,y2,x2,y2
			DrawLine x2,y1,x2,y2
	'		DrawRect nPoly.iMinX + x, nPoly.iMinY + y, nPoly.iMaxX - nPoly.iMinX + 1, nPoly.iMaxY - nPoly.iMinY + 1
		End If	
		' Draw all the lines	
		SetColor r, g, b
		lx = fX[0].x + x
		ly = fX[0].y + y
		For i = 1 To iVertexCount - 1
			DrawLine lx, ly, fX[i].x + x, fX[i].y + y
			lx = fX[i].x + x
			ly = fX[i].y + y
		Next
	End Method
	
	' ----------------------------------------------------------------------
	
	' Copies a polygon And Return the newly created poly
	Method Copy:Poly()
		Local newPoly:Poly = New Poly
		Local i:Float
		' Copy point data
		For i = 0 To iVertexCount - 1
			newPoly.iN[i] = New PVect
			newPoly.fX[i] = New PVect
			newPoly.iN[i].x = iN[i].x
			newPoly.iN[i].y = iN[i].y
			newPoly.fX[i].x = fX[i].x
			newPoly.fX[i].y = fX[i].y
		
		Next
		' Copy all data
		newPoly.iVertexCount = iVertexCount
		newPoly.fScaleX = fScaleX
		newPoly.fScaleY = fScaleY
		newPoly.fAngle = fAngle
		newPoly.iMinX = iMinX
		newPoly.iMinY = iMinY
		newPoly.iMaxX = iMaxX
		newPoly.iMaxY = iMaxY
		Return newPoly
	End Method
	
	
End Class

' ----------------------------------------------------------------------
' Returns True If both circles overlap

Function CirclesOverlap:Int(x1:Float, y1:Float, rad1:Float, x2:Float, y2:Float, rad2:Float)
	
	Local dx:Float = x2 - x1
	Local dy:Float = y2 - y1
	Local rsqr:Float = rad1 + rad2
	rsqr = rsqr*rsqr
	Return (dx*dx+dy*dy < rsqr)

End Function




