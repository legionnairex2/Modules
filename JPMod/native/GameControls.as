// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com
// Created for active.tutsplus.com

// GameControls.as
// A simple keyboard input class that supports
// international keyboards (QWERY, AZERTY and DVORAK)

package
{

import flash.display.Stage;
import flash.ui.Keyboard;
import flash.events.*;

public class GameControls
{
	// the current state of the keyboard controls
	public var pressing:Object = 
	{ up:0, down:0, left:0, right:0, fire:0, hasfocus:0 };

	// the game's main stage
	public var stage:Stage;
	
	// class constructor
	public function GameControls(theStage:Stage)	
	{
		stage = theStage;
		// get keypresses and detect the game losing focus
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		stage.addEventListener(Event.DEACTIVATE, lostFocus);
		stage.addEventListener(Event.ACTIVATE, gainFocus);
	}

	private function keyPressed(event:KeyboardEvent):void 
	{
		keyHandler(event, true);
	}

	private function keyReleased(event:KeyboardEvent):void 
	{
		keyHandler(event, false);
	}

	// if the game loses focus, don't keep keys held down
	// we could optionally pause the game here
	private function lostFocus(event:Event):void 
	{
		trace("Game lost keyboard focus.");
		pressing.up = false;
		pressing.down = false;
		pressing.left = false;
		pressing.right = false;
		pressing.fire = false;
		pressing.hasfocus = false;
	}

	// we could optionally unpause the game here
	private function gainFocus(event:Event):void 
	{
		trace("Game received keyboard focus.");
		pressing.hasfocus = true;
	}

	// used only for debugging
	public function textDescription():String
	{
		return ("Controls: " + 
			(pressing.up?"up ":"") + 
			(pressing.down?"down ":"") + 
			(pressing.left?"left ":"") + 
			(pressing.right?"right ":"") + 
			(pressing.fire?"fire":""));
	}
	
	private function keyHandler(event:KeyboardEvent, isDown:Boolean):void 
	{
		//trace('Key code: ' + event.keyCode);
		
		// alternate "fire" buttons
		if (event.ctrlKey || 
			event.altKey || 
			event.shiftKey)
			pressing.fire = isDown;

		// key codes that support international keyboards:
		// QWERTY = W A S D
		// AZERTY = Z Q S D
		// DVORAK = , A O E
			
		switch(event.keyCode)
		{
			case Keyboard.UP:
			case 87: // W
			case 90: // Z
			case 188:// ,
				pressing.up = isDown;
			break;
			
			case Keyboard.DOWN:
			case 83: // S
			case 79: // O
				pressing.down = isDown;
			break;
			
			case Keyboard.LEFT:
			case 65: // A
			case 81: // Q
				pressing.left = isDown;
			break;
			
			case Keyboard.RIGHT:
			case 68: // D
			case 69: // E
				pressing.right = isDown;
			break;
			
			case Keyboard.SPACE:
			case Keyboard.SHIFT:
			case Keyboard.CONTROL:
			case Keyboard.ENTER:
			case 88: // x
			case 67: // c
				pressing.fire = isDown;
			break;
			
		}
	}

} // end class
} // end package
