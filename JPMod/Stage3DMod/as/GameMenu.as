// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// GameMenu.as
// A simple title screen / logo screen and menu
// that is displayed during the idle "attract mode"

import flash.display.Bitmap;
import flash.display3D.*;
import flash.geom.Point;
import flash.geom.Rectangle;

class Menu
{
	// the sprite sheet image
	public var spriteSheet : LiteSpriteSheet;
	
	// all the polygons that make up the scene
	public var batch : LiteSpriteBatch;
	
	// which menu item is active (0=none)
	public var menuState:int = 0;
	
	// pixel regions of the buttons
	public var menuWidth:int = 128;
	public var menuItemHeight:int = 32;
	public var menuY1:int = 0;
	public var menuY2:int = 0;
	public var menuY3:int = 0;
	
	// the sprites
	public var logoSprite:LiteSprite;
	// menu items when idle
	public var menuPlaySprite:LiteSprite;
	public var menuControlsSprite:LiteSprite;
	public var menuAboutSprite:LiteSprite;
	// menu items when active
	public var amenuPlaySprite:LiteSprite;
	public var amenuControlsSprite:LiteSprite;
	public var amenuAboutSprite:LiteSprite;
	// info screens
	public var aboutSprite:LiteSprite;
	public var controlsSprite:LiteSprite;
	
	public var showingAbout:Boolean = false;
	public var showingControls:Boolean = false;
	public var showingControlsUntil:Number = 0;
	public var showingAboutUntil:Number = 0;
		
	// where everything goes
	public var logoX:int = 0;
	public var logoY:int = 0;
	public var menuX:int = 0;
	public var menuY:int = 0;
	
	public function Menu(view:Rectangle)
	{
		trace("Init the game menu..");
		setPosition(view);	
	}
	
	public function setPosition(view:Rectangle):void 
	{
		logoX = view.width / 2;
		logoY = view.height / 2 - 64;
		menuX = view.width / 2;
		menuY = view.height / 2 + 64;
		menuY1 = menuY - (menuItemHeight / 2);
		menuY2 = menuY - (menuItemHeight / 2) + menuItemHeight;
		menuY3 = menuY - (menuItemHeight / 2) + (menuItemHeight * 2);
	}
	
	public function createBatch(context3D:Context3D,atlasBitmap:Bitmap) : LiteSpriteBatch 
	{
		var sourceBitmap:Bitmap = atlasBitmap;
		// create a spritesheet using the titlescreen image
		spriteSheet = new LiteSpriteSheet(sourceBitmap.bitmapData, 0, 0);
		
		// Create new render batch 
		batch = new LiteSpriteBatch(context3D, spriteSheet);

		// set up all required sprites right now
		var logoID:uint = spriteSheet.defineSprite(0, 0, 512, 256);
		logoSprite = batch.createChild(logoID);
		logoSprite.position.x = logoX;
		logoSprite.position.y = logoY;

		var menuPlaySpriteID:uint = spriteSheet.defineSprite(0, 256, menuWidth, 48);
		menuPlaySprite = batch.createChild(menuPlaySpriteID);
		menuPlaySprite.position.x = menuX;
		menuPlaySprite.position.y = menuY;

		var amenuPlaySpriteID:uint = spriteSheet.defineSprite(0, 256+128, menuWidth, 48);
		amenuPlaySprite = batch.createChild(amenuPlaySpriteID);
		amenuPlaySprite.position.x = menuX;
		amenuPlaySprite.position.y = menuY;
		amenuPlaySprite.alpha = 0;

		var menuControlsSpriteID:uint = spriteSheet.defineSprite(0, 304, menuWidth, 32);
		menuControlsSprite = batch.createChild(menuControlsSpriteID);
		menuControlsSprite.position.x = menuX;
		menuControlsSprite.position.y = menuY + menuItemHeight;

		var amenuControlsSpriteID:uint = spriteSheet.defineSprite(0, 304+128, menuWidth, 32);
		amenuControlsSprite = batch.createChild(amenuControlsSpriteID);
		amenuControlsSprite.position.x = menuX;
		amenuControlsSprite.position.y = menuY + menuItemHeight;
		amenuControlsSprite.alpha = 0;

		var menuAboutSpriteID:uint = spriteSheet.defineSprite(0, 336, menuWidth, 48);
		menuAboutSprite = batch.createChild(menuAboutSpriteID);
		menuAboutSprite.position.x = menuX;
		menuAboutSprite.position.y = menuY + menuItemHeight + menuItemHeight;

		var amenuAboutSpriteID:uint = spriteSheet.defineSprite(0, 336+128, menuWidth, 48);
		amenuAboutSprite = batch.createChild(amenuAboutSpriteID);
		amenuAboutSprite.position.x = menuX;
		amenuAboutSprite.position.y = menuY + menuItemHeight + menuItemHeight;
		amenuAboutSprite.alpha = 0;

		var aboutSpriteID:uint = spriteSheet.defineSprite(128, 256, 384, 128);
		aboutSprite = batch.createChild(aboutSpriteID);
		aboutSprite.position.x = menuX;
		aboutSprite.position.y = menuY + 64;
		aboutSprite.alpha = 0;

		var controlsSpriteID:uint = spriteSheet.defineSprite(128, 384, 384, 128);
		controlsSprite = batch.createChild(controlsSpriteID);
		controlsSprite.position.x = menuX;
		controlsSprite.position.y = menuY + 64;
		controlsSprite.alpha = 0;

		return batch;
	}
	
	// our game will call these based on user input
	public function nextMenuItem():void
	{
		menuState++;
		if (menuState > 3) menuState = 1;
		updateState();
	}
	public function prevMenuItem():void
	{
		menuState--;
		if (menuState < 1) menuState = 3;
		updateState();
	}
	
	public function mouseHighlight(x:int, y:int):void
	{
		//trace('mouseHighlight ' + x + ',' + y);
		
		// when mouse moves, assume it moved OFF all items
		menuState = 0;
		
		var menuLeft:int = menuX - (menuWidth / 2);
		var menuRight:int = menuX + (menuWidth / 2);
		if ((x >= menuLeft) && (x <= menuRight))
		{
			//trace('inside ' + menuLeft + ',' + menuRight);
			if ((y >= menuY1) && (y <= (menuY1 + menuItemHeight)))
			{
				menuState = 1;
			}
			if ((y >= menuY2) && (y <= (menuY2 + menuItemHeight)))
			{
				menuState = 2;
			}
			if ((y >= menuY3) && (y <= (menuY3 + menuItemHeight)))
			{
				menuState = 3;
			}
		}
		updateState();
	}
	
	// adjust the opacity of menu items
	public function updateState():void
	{
		// ignore if menu is not visible:
		if (showingAbout || showingControls) return;
		// user clicked or pressed fire on a menu item:
		switch (menuState)
		{
			case 0: // nothing selected
				menuAboutSprite.alpha = 1;
				menuControlsSprite.alpha = 1;
				menuPlaySprite.alpha = 1;
				amenuAboutSprite.alpha = 0;
				amenuControlsSprite.alpha = 0;
				amenuPlaySprite.alpha = 0;
				break;
			case 1: // play selected
				menuAboutSprite.alpha = 1;
				menuControlsSprite.alpha = 1;
				menuPlaySprite.alpha = 0;
				amenuAboutSprite.alpha = 0;
				amenuControlsSprite.alpha = 0;
				amenuPlaySprite.alpha = 1;
				break;
			case 2: // controls selected
				menuAboutSprite.alpha = 1;
				menuControlsSprite.alpha = 0;
				menuPlaySprite.alpha = 1;
				amenuAboutSprite.alpha = 0;
				amenuControlsSprite.alpha = 1;
				amenuPlaySprite.alpha = 0;
				break;
			case 3: // about selected
				menuAboutSprite.alpha = 0;
				menuControlsSprite.alpha = 1;
				menuPlaySprite.alpha = 1;
				amenuAboutSprite.alpha = 1;
				amenuControlsSprite.alpha = 0;
				amenuPlaySprite.alpha = 0;
				break;
		}
	}

	// activate the currently selected menu item
	// returns true if we should start the game
	public function activateCurrentMenuItem(currentTime:Number):Boolean
	{
		// ignore if menu is not visible:
		if (showingAbout || showingControls) return false;
		// activate the proper option:
		switch (menuState)
		{
			case 1: // play selected
				return true;
				break;
			case 2: // controls selected
				menuAboutSprite.alpha = 0;
				menuControlsSprite.alpha = 0;
				menuPlaySprite.alpha = 0;
				amenuAboutSprite.alpha = 0;
				amenuControlsSprite.alpha = 0;
				amenuPlaySprite.alpha = 0;
				controlsSprite.alpha = 1;
				showingControls = true;
				showingControlsUntil = currentTime + 5000;
				break;
			case 3: // about selected
				menuAboutSprite.alpha = 0;
				menuControlsSprite.alpha = 0;
				menuPlaySprite.alpha = 0;
				amenuAboutSprite.alpha = 0;
				amenuControlsSprite.alpha = 0;
				amenuPlaySprite.alpha = 0;
				aboutSprite.alpha = 1;
				showingAbout = true;
				showingAboutUntil = currentTime + 5000;
				break;
		}
		return false;
	}
	
	// called every frame: used to update the animation
	public function update(currentTime:Number) : void
	{		
		logoSprite.position.x = logoX;
		logoSprite.position.y = logoY;
		var wobble:Number = (Math.cos(currentTime / 500.0) / Math.PI) * 0.2;
		logoSprite.scaleX = 1 + wobble;
		logoSprite.scaleY = 1 + wobble;
		wobble = (Math.cos(currentTime / 777) / Math.PI) * 0.1;
		logoSprite.rotation = wobble;
		// pulse the active menu item
		wobble = (Math.cos(currentTime / 150) / Math.PI) * 0.1;
		amenuAboutSprite.scaleX = 1.1 + wobble;
		amenuAboutSprite.scaleY = 1.1 + wobble;
		amenuControlsSprite.scaleX = 1.1 + wobble;
		amenuControlsSprite.scaleY = 1.1 + wobble;
		amenuPlaySprite.scaleX = 1.1 + wobble;
		amenuPlaySprite.scaleY = 1.1 + wobble;
		//	1.1 + wobble;
		
		// show the about/controls for a while
		if (showingAbout)
		{
			if (showingAboutUntil > currentTime)
			{
				aboutSprite.alpha = 1;
			}
			else
			{
				aboutSprite.alpha = 01;
				showingAbout = false;
				updateState();
			}
		}

		if (showingControls)
		{
			if (showingControlsUntil > currentTime)
			{
				controlsSprite.alpha = 1;
			}
			else
			{
				controlsSprite.alpha = 0;
				showingControls = false;
				updateState();
			}
		}		}
} // end class

function CreateMenu(view:Rectangle):Menu{
	return new Menu(view);
}