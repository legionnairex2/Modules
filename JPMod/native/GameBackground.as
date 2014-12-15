// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// GameBackground.as
// A very simple batch of background stars that scroll
// with a subtle vertical parallax effect

import flash.display.Bitmap;
import flash.display3D.*;
import flash.geom.Point;
import flash.geom.Rectangle;

class GameBackground extends EntityManager
{
	// how fast the stars move
	public var bgSpeed:int = -1;
	// the sprite sheet image
	public const bgSpritesPerRow:int = 1;
	public const bgSpritesPerCol:int = 1;
	public var bgSourceImage : Class;
	
	// since the image is larger thanthe screen we have some extra pixels to play with
	public var yParallaxAmount:Number = (512 - 400);
	public var yOffset:Number = 0;

	public function GameBackground(view:Rectangle)
	{
		// run the init functions of the EntityManager class
		super(view);
	}
	
	override public function createBatch(context3D:Context3D,atlasBitmap:Bitmap) : LiteSpriteBatch 
	{
		var bgsourceBitmap:Bitmap = atlasBitmap;

		// create a spritesheet with single giant sprite
		spriteSheet = new LiteSpriteSheet(bgsourceBitmap.bitmapData, bgSpritesPerRow, bgSpritesPerCol);
		
		// Create new render batch 
		batch = new LiteSpriteBatch(context3D, spriteSheet);
		
		return batch;
	}

	override public function setPosition(view:Rectangle):void 
	{
		// allow moving fully offscreen before looping around
		maxX = 256+512+512;
		minX = -256;
		maxY = view.height;
		minY = view.y;
		yParallaxAmount = (512 - maxY) / 2;
		yOffset = maxY / 2;
	}
	
	// for this test, create random entities that move 
	// from right to left with random speeds and scales
	public function initBackground():void 
	{
		trace("Init background...");
		// we need three 512x512 sprites
		var anEntity1:Entity = respawn(0)
		anEntity1 = respawn(0);
		anEntity1.sprite.position.x = 256;
		anEntity1.sprite.position.y = maxY / 2;
		anEntity1.speedX = bgSpeed;
		var anEntity2:Entity = respawn(0)
		anEntity2.sprite.position.x = 256+512;
		anEntity2.sprite.position.y = maxY / 2;
		anEntity2.speedX = bgSpeed;
		var anEntity3:Entity = respawn(0)
		anEntity3.sprite.position.x = 256+512+512;
		anEntity3.sprite.position.y = maxY / 2;
		anEntity3.speedX = bgSpeed;
	}
	
	// scroll slightly up or down to give more parallax
	public function yParallax(OffsetPercent:Number = 0) : void
	{
		yOffset = (maxY / 2) + (-1 * yParallaxAmount * OffsetPercent);
	}
	
	// called every frame: used to update the scrolling background
	override public function update(currentTime:Number) : void
	{		
		var anEntity:Entity;
		
		// handle all other entities
		for(var i:int=0; i<entityPool.length;i++)
		{
			anEntity = entityPool[i];
			if (anEntity.active)
			{
				anEntity.sprite.position.x += anEntity.speedX;
				anEntity.sprite.position.y = yOffset;

				if (anEntity.sprite.position.x >= maxX)
				{
					anEntity.sprite.position.x = minX;
				}
				else if (anEntity.sprite.position.x <= minX)
				{
					anEntity.sprite.position.x = maxX;
				}
			}
		}
	}
} // end class
