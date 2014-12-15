Import mojo
Global atlasImg:Image
Global media:Media

Class Media
	Field titleImg:Image = Null
	Field tableImg:Image = Null
	Field railImg:Image = Null
	Field ballImg:Image = Null
	Field stickImg:Image = Null
	Field ghostImg:Image = Null
	Field arrowsImg:Image = Null
	Field rotatorImg:Image = Null
	Field buttonImg:Image = Null
	Field smallBtnImg:Image = Null
	Field stripImg:Image = Null
	
	Field getNameImg:Image
	
	Field logoImg:Image = Null
	Field frameTopImg:Image = Null
	Field frameBotImg:Image = Null
	Field topImg:Image = Null
	Field botImg:Image = Null
	Field lrImg:Image = Null
	Field rectImg:Image = Null
	Field meterImg:Image = Null
	Field stretchImg:Image = Null
	Field sliderImg:Image = Null
	Field ballCol:Sound[4]
	Field shootCol:Sound = Null
	Field railCol:Sound[2]
	Field rackUp:Sound = Null
	Field applause:Sound = Null
	Field pocketCol:Sound = Null
	Field scratchSnd:Sound = Null
	Field completionSnd:Sound = Null
	Field beepSnd:Sound = Null
	Field beepBSnd:Sound = Null
	
	Method New(atlasImg:Image)
		
		If(atlasImg = Null)
			Error("unable to load GameAtlas.png")
		Endif
		titleImg = atlasImg.GrabImage(0,544,640,480,1,Image.DefaultFlags)
		tableImg = atlasImg.GrabImage(0,0,640,360,1,Image.DefaultFlags)
		If(tableImg = Null)
			Error("Unable to load table.png")
		Endif
		railImg = atlasImg.GrabImage(640,0,384,41,1,Image.DefaultFlags)
		If(railImg = Null)
			Error("unable to load Table.png")
		Endif
		ballImg = atlasImg.GrabImage(994,103,24,24,1,Image.DefaultFlags)
		If(ballImg = Null)
			Error("unable to load ball.png")
		Endif
		ballImg.SetHandle(11.0,11.0)
		stickImg = atlasImg.GrabImage(1,501,392,9,1,Image.DefaultFlags)
		If(stickImg = Null)
			Error("Unable to load stickImg.png")
		Endif
		stickImg.SetHandle(393.0,5.0)
		ghostImg = atlasImg.GrabImage(640,140,22,22,3,Image.DefaultFlags)
		If(ghostImg = Null)
			Error("unable to load ghostImg.Png")
		Endif
		ghostImg.SetHandle(11.0,11.0)
		arrowsImg = atlasImg.GrabImage(890,141,47,47,1,Image.DefaultFlags)
		If(arrowsImg = Null)
			Error("Unble to load arrowsImg.png")
		Endif
		arrowsImg.SetHandle(23.0,23.0)
		rotatorImg = atlasImg.GrabImage(510,401,98,67,1,Image.DefaultFlags)
		If(rotatorImg = Null)
			Error("Unable to load rotatorImg.png")
		Endif
		rotatorImg.SetHandle(49.0,47.0)
		buttonImg = atlasImg.GrabImage(640,41,190,62,2,Image.DefaultFlags)
		If(buttonImg = Null)
			Error("Unable to load buttonImg.png")
		Endif
		smallBtnImg = atlasImg.GrabImage(643,289,130,50,2,Image.DefaultFlags)
		stripImg = atlasImg.GrabImage(1015,130,1,3,1,Image.DefaultFlags)
		If(stripImg = Null)
			Error("unable to load stripImg.png")
		Endif
		stripImg.SetHandle(0.0,2.0)
		getNameImg = atlasImg.GrabImage(641,848,383,176,1,Image.DefaultFlags)
		logoImg = atlasImg.GrabImage(640,545,255,275,1,Image.DefaultFlags)
		frameTopImg = atlasImg.GrabImage(997,128,4,4,2,Image.DefaultFlags)
		frameBotImg = atlasImg.GrabImage(997,132,4,4,2,Image.DefaultFlags)
		topImg = atlasImg.GrabImage(1000,128,1,4,1,Image.DefaultFlags)
		botImg = atlasImg.GrabImage(1000,132,1,4,1,Image.DefaultFlags)
		lrImg = atlasImg.GrabImage(997,131,4,1,2,Image.DefaultFlags)
		rectImg = atlasImg.GrabImage(1011,131,1,1,1,Image.DefaultFlags)
		meterImg = atlasImg.GrabImage(640,103,346,36,1,Image.DefaultFlags)
		stretchImg = atlasImg.GrabImage(988,103,1,36,1,Image.DefaultFlags)
		sliderImg = atlasImg.GrabImage(990,103,4,36,1,Image.DefaultFlags)
		ballCol[0] = LoadSound("hit03.mp3")
		If ballCol[0] = Null
			Print("unable to load hit03.ogg")
		Endif
		ballCol[1] = LoadSound("hit04.mp3")
		If ballCol[1] = Null
			Print("unable to load hti04.ogg")
		Endif
		ballCol[2] = LoadSound("hit05.mp3")
		If ballCol[2]  =  Null
			Print("unable to lead hit05.ogg")
		Endif
		ballCol[3]  =  LoadSound("hit06.mp3")
		If ballCol[3] = Null
			Print("unable to load hit06.ogg")
		Endif
		shootCol = LoadSound("shoot.mp3")
		railCol[0] = LoadSound("bank01.mp3")
		railCol[1] = LoadSound("bank02.mp3")
		rackUp = LoadSound("rackup.mp3")
		applause = LoadSound("applause.mp3")
		pocketCol = LoadSound("pocket1.mp3")
		scratchSnd = LoadSound("fail.mp3")
		completionSnd = LoadSound("completion.mp3")
		If completionSnd = Null
			Error("unable to load completionSnd")
		Endif
		beepSnd = LoadSound("beep.mp3")
		If beepSnd = Null
			Print("unable to load beep sound")
		Endif
		beepBSnd = LoadSound("beep2.mp3")
		If beepBSnd  =  Null
			Error("unable to load beep2.mp3 sound")
		Endif
		
	End Method
	
	Field arcImg:Image = Null
	Field lineImg:Image = Null
	Field channeltime:Int[8]
	Field colChan:Int = 0
	Field colLastChan:Int = 3
	Field colFirstChan:Int = 0
	Method UpdateChannel:Void()
		
		colChan += 1
		If(colChan> = colLastChan)
			colChan = colFirstChan
		Endif
		
	End Method
	Method PlayPocketCol:Void()
		
		Local t:Int = Millisecs()-channeltime[colChan]
		If(t>200)
			channeltime[colChan] = Millisecs()
			PlaySound(pocketCol,7,0)
			UpdateChannel()
		Endif
		
	End Method
	
	Method PlayScratch:Void()
		
		PlaySound(scratchSnd,4,0)
		
	End Method
	
	Method PlayBallCol:Void(n:Int)
		
		If(n>3)
			n = 3
		Endif
		If(n<0)
			n = 0
		Endif
		Local t:Int = Millisecs()-channeltime[colChan]
		If(t>200)
			channeltime[colChan] = Millisecs()
			PlaySound(ballCol[n],colChan,0)
			UpdateChannel()
		Endif
		
	End Method
	
	Method PlayRailCol:Void(n:Int)
		
		Local t:Int = Millisecs()-channeltime[colChan]
		If(t>200)
			channeltime[colChan] = Millisecs()
			PlaySound(railCol[n],colChan,0)
			UpdateChannel()
		Endif
		
	End Method
	
	Field scoreChan:Int = 5
	Field scoreLastChan:Int = 6
	
	Method updateScoreChan:Void()
		
		scoreChan += 1
		If(scoreChan >= scoreLastChan)
			scoreChan = colFirstChan
		Endif
		
	End Method
	
	Method PlayBeep:Void()
		
		Local t:Int = Millisecs()-channeltime[scoreChan]
		channeltime[scoreChan] = Millisecs()
		PlaySound(beepSnd,scoreChan,0)
		updateScoreChan()
		
	End Method
	
	Method PlayBeepB:Void()
		
		Local t:Int = Millisecs()-channeltime[scoreChan]
		channeltime[scoreChan] = Millisecs()
		PlaySound(beepBSnd,scoreChan,0)
		updateScoreChan()
		
	End Method
	
	Method PlayShootCol:Void()
		
		Local t:Int = Millisecs()-channeltime[colChan]
		If(t>200)
			channeltime[colChan] = Millisecs()
			PlaySound(shootCol,colChan,0)
			UpdateChannel()
		End If
		
	End Method
	
End Class
