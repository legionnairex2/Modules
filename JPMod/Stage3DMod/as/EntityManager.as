// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// EntityManager.as
// The entity manager handles a list of all known game entities.
// This object pool will allow for reuse (respawning) of
// sprites: for example, when enemy ships are destroyed,
// they will be re-spawned when needed as an optimization 
// that increases fps and decreases ram use.

import flash.display.Bitmap;
import flash.display3D.*;
import flash.geom.Point;
import flash.geom.Rectangle;

class EntityManager
{
	// a particle system class that updates our sprites
	public var particles:GameParticles;
	
	// so that explosions can be played
	public var sfx:GameSound;
	
	// the sprite sheet image
	public var spriteSheet : LiteSpriteSheet;
	protected var SpritesPerRow:int;
	protected var SpritesPerCol:int;
	

	// the general size of the player and enemies
	private const shipScale:Number = 1.5;
	// how fast player bullets go per second
	public var bulletSpeed:Number = 250;

	// for framerate-independent timings
	public var currentFrameSeconds:Number = 0;
	
	// sprite IDs (indexing the spritesheet)
	public const spritenumFireball:uint = 63;
	public const spritenumFireburst:uint = 62;
	public const spritenumShockwave:uint = 61;
	public const spritenumDebris:uint = 60;
	public const spritenumSpark:uint = 59;
	public const spritenumBullet3:uint = 58;
	public const spritenumBullet2:uint = 57;
	public const spritenumBullet1:uint = 56;
	public const spritenumPlayer:uint = 10;
	public const spritenumOrb:uint = 17;

	// reused for calculation speed
	public const DEGREES_TO_RADIANS:Number = Math.PI / 180;
	public const RADIANS_TO_DEGREES:Number = 180 / Math.PI;
	
	// the player entity - a special case
	public var thePlayer:Entity;
	// a "power orb" that orbits the player
	public var theOrb:Entity;
	
	// a reusable pool of entities
	// this contains every known Entity
	// including the contents of the lists below
	public var entityPool : Vector.<Entity>;
	// these pools contain only certain types
	// of entity as an optimization for smaller loops 
	public var allBullets : Vector.<Entity>;
	public var allEnemies : Vector.<Entity>;
	
	// all the polygons that make up the scene
	public var batch : LiteSpriteBatch;
	
	// for statistics
	public var numCreated : int = 0;
	public var numReused : int = 0;
	
	public var maxX:int;
	public var minX:int;
	public var maxY:int;
	public var minY:int;
	
	public function EntityManager(view:Rectangle)
	{
		entityPool = new Vector.<Entity>();
		allBullets = new Vector.<Entity>();
		allEnemies = new Vector.<Entity>();
		particles = new GameParticles(this);
		setPosition(view);	
	}
	
	public function setPosition(view:Rectangle):void 
	{
		// allow moving fully offscreen before
		// automatically being culled (and reused)
		maxX = view.width + 64;
		minX = view.x - 64;
		maxY = view.height + 64;
		minY = view.y - 64;
	}
	
	// this XOR based fast random number generator runs 4x faster
	// than Math.random() and also returns a number from 0 to 1
	// see http://www.calypso88.com/?cat=7
	private const FASTRANDOMTOFLOAT:Number = 1 / uint.MAX_VALUE;
	private var fastrandomseed:uint = Math.random() * uint.MAX_VALUE;
	public function fastRandom():Number
	{
		fastrandomseed ^= (fastrandomseed << 21);
		fastrandomseed ^= (fastrandomseed >>> 35);
		fastrandomseed ^= (fastrandomseed << 4);
		return (fastrandomseed * FASTRANDOMTOFLOAT);
	}

	public function createBatch(context3D:Context3D,bitmap:Bitmap,spritesA:Number,spritesD:Number) : LiteSpriteBatch 
	{
		SpritesPerRow = spritesA;
		SpritesPerCol = spritesD;
		var sourceBitmap:Bitmap = bitmap //new SourceImage();

		// create a spritesheet with 8x8 (64) sprites on it
		spriteSheet = new LiteSpriteSheet(sourceBitmap.bitmapData, SpritesPerRow, SpritesPerCol);
		
		// Create new render batch 
		batch = new LiteSpriteBatch(context3D, spriteSheet);
		
		return batch;
	}
	
	// search the entity pool for unused entities and reuse one
	// if they are all in use, create a brand new one
	public function respawn(sprID:uint=0):Entity
	{
		var currentEntityCount:int = entityPool.length;
		var anEntity:Entity;
		var i:int = 0;
		// search for an inactive entity
		for (i = 0; i < currentEntityCount; i++ ) 
		{
			anEntity = entityPool[i];
			if (!anEntity.active && (anEntity.sprite.spriteId == sprID))
			{
				//trace('Reusing Entity #' + i);
				anEntity.active = true;
				anEntity.sprite.visible = true;
				anEntity.recycled = true;
				numReused++;
				return anEntity;
			}
		}
		// none were found so we need to make a new one
		//trace('Need to create a new Entity #' + i);
		var sprite:LiteSprite;
		sprite = batch.createChild(sprID);
		anEntity = new Entity(sprite);
		entityPool.push(anEntity);
		numCreated++;
		return anEntity;
	}
	
	// this entity is the PLAYER
	public function addPlayer(playerController:Function):Entity 
	{
		thePlayer = respawn(spritenumPlayer);
		thePlayer.sprite.position.x = 32;
		thePlayer.sprite.position.y = maxY / 2;
		thePlayer.sprite.rotation = 180 * DEGREES_TO_RADIANS;
		thePlayer.sprite.scaleX = thePlayer.sprite.scaleY = shipScale; 
		thePlayer.speedX = 0;
		thePlayer.speedY = 0;
		thePlayer.active = true;
		thePlayer.aiFunction = playerController;
		thePlayer.leavesTrail = true;
		
		// just for fun, spawn an orbiting "power orb"
		theOrb = respawn(spritenumOrb);
		theOrb.rotationSpeed = 720 * DEGREES_TO_RADIANS;
		theOrb.leavesTrail = true;
		theOrb.collidemode = 1;
		theOrb.collideradius = 12;
		theOrb.isBullet = true;
		theOrb.owner = thePlayer;
		theOrb.orbiting = thePlayer;
		theOrb.orbitingDistance = 180;
		
		return thePlayer;
	}		

	// shoot a bullet (from the player for now)
	public function shootBullet(powa:uint=1):Entity 
	{
		var anEntity:Entity;
		// three possible bullets, progressively larger
		if (powa == 1) 
			anEntity = respawn(spritenumBullet1);
		else if (powa == 2) 
			anEntity = respawn(spritenumBullet2);
		else 
			anEntity = respawn(spritenumBullet3);
		anEntity.sprite.position.x = thePlayer.sprite.position.x + 8;
		anEntity.sprite.position.y = thePlayer.sprite.position.y + 2;
		anEntity.sprite.rotation = 180 * DEGREES_TO_RADIANS;
		anEntity.sprite.scaleX = anEntity.sprite.scaleY = 1; 
		anEntity.speedX = bulletSpeed;
		anEntity.speedY = 0;
		anEntity.owner = thePlayer;
		anEntity.collideradius = 10;
		anEntity.collidemode = 1;
		anEntity.isBullet = true;
		if (!anEntity.recycled)
			allBullets.push(anEntity);
		return anEntity;
	}		


	public function spawnEntity(spriteID:uint):Entity{
		var anEntity:Entity = respawn(spriteID);
		if (!anEntity.recycled)
			allEnemies.push(anEntity);
		return anEntity
	}
	
	public function removeEntity(anEntity:Entity):void{
		anEntity.die();
	}
	
	// for this test, create random entities that move 
	// from right to left with random speeds and scales
	public function initEntity(anEntity:Entity,x:Number,y:Number,angle:Number,speed:Number):void 
	{
		// give it a new position and velocity
		anEntity.sprite.position.x = x;
		anEntity.sprite.position.y = y;
		var rot:Number = angle *DEGREES_TO_RADIANS;
		anEntity.speedX =15*Math.cos(rot)*speed; //15 * ((-1 * fastRandom() * 10) - 2);
		anEntity.speedY =15*Math.sin(rot)*speed; //15 * ((fastRandom() * 5) - 2.5);
		anEntity.sprite.scaleX = shipScale;
		anEntity.sprite.scaleY = shipScale;
		anEntity.sprite.rotation = (rot+180.0*DEGREES_TO_RADIANS); //pointAtRad(anEntity.speedX,anEntity.speedY) - (90*DEGREES_TO_RADIANS);
		anEntity.collidemode = 1;
		anEntity.collideradius = 16;
	}
	
	// returns the angle in radians of two points
	public function pointAngle(point1:Point, point2:Point):Number
	{
		var dx:Number = point2.x - point1.x;
		var dy:Number = point2.y - point1.y;
		return -Math.atan2(dx,dy);
	}		
	
	// returns the angle in degrees of 0,0 to x,y
	public function pointAtDeg(x:Number, y:Number):Number
	{
		return -Math.atan2(x,y) * RADIANS_TO_DEGREES;
	}		

	// returns the angle in radians of 0,0 to x,y
	public function pointAtRad(x:Number, y:Number):Number
	{
		return -Math.atan2(x,y);
	}		

	public function checkCollisions(checkMe:Entity):Entity
	{
		var anEntity:Entity;
		//for(var i:int=0; i< entityPool.length;i++)
		for(var i:int=0; i< allEnemies.length;i++)
		{
			//anEntity = entityPool[i];
			anEntity = allEnemies[i];
			if (anEntity.active && anEntity.collidemode)
			{
				if (checkMe.colliding(anEntity)) 
				{
					trace('Collision! checkMe.owner == anEntity.owner is ' + (checkMe.owner == anEntity.owner ? "TRUE!" : "FALSE"));

					particles.addExplosion(checkMe.sprite.position);
					if ((checkMe != theOrb) && (checkMe != thePlayer)) 
						checkMe.die(); // the bullet
					if ((anEntity != theOrb) && ((anEntity != thePlayer))) 
						anEntity.die(); // the victim
					return anEntity;
				}
			}
		}
		return null;
	}
	
	// called every frame: used to update the simulation
	// this is where you would perform AI, physics, etc.
	// in this version, currentTime is seconds since the previous frame
	public function update(currentTime:Number) : void
	{		
		var anEntity:Entity;
		var i:int;
		var max:int;
		
		// what portion of a full second has passed since the previous update?
		currentFrameSeconds = currentTime / 1000;
		
		// handle all other entities
		max = entityPool.length;
		for (i = 0; i < max; i++)
		{
			anEntity = entityPool[i];
			if (anEntity.active)
			{
				anEntity.sprite.position.x += anEntity.speedX * currentFrameSeconds;
				anEntity.sprite.position.y += anEntity.speedY * currentFrameSeconds;
				
				// the player follows different rules
				if (anEntity.aiFunction != null)
				{
					anEntity.aiFunction(anEntity);
				}
				else // all other entities use the "demo" logic
				{
				
					// collision detection
					if (anEntity.isBullet && anEntity.collidemode)
					{
						checkCollisions(anEntity);
					}
					
					// entities can orbit other entities 
					// (uses their rotation as the position)
					if (anEntity.orbiting != null)
					{
						anEntity.sprite.position.x = anEntity.orbiting.sprite.position.x + ((Math.sin(anEntity.sprite.rotation/4)/Math.PI) * anEntity.orbitingDistance);
						anEntity.sprite.position.y = anEntity.orbiting.sprite.position.y - ((Math.cos(anEntity.sprite.rotation/4)/Math.PI) * anEntity.orbitingDistance);
					}

					// entities can leave an engine emitter trail
					if (anEntity.leavesTrail)
					{
						// leave a trail of particles
						if (anEntity == theOrb)
							particles.addParticle(63, anEntity.sprite.position.x, anEntity.sprite.position.y, 0.25, 0, 0, 0.6, NaN, NaN, -1.5, -1);
						else // player
							particles.addParticle(63, anEntity.sprite.position.x + 12, anEntity.sprite.position.y + 2, 0.5, 3, 0, 0.6, NaN, NaN, -1.5, -1);
						
					}
					
					if ((anEntity.sprite.position.x > maxX) ||
						(anEntity.sprite.position.x < minX) ||
						(anEntity.sprite.position.y > maxY) ||
						(anEntity.sprite.position.y < minY))							
					{
						// if we go past any edge, become inactive
						// so the sprite can be respawned
						if ((anEntity != thePlayer) && (anEntity != theOrb)) 
							anEntity.die();
					}
				}
				
				if (anEntity.rotationSpeed != 0)
					anEntity.sprite.rotation += anEntity.rotationSpeed * currentFrameSeconds;
					
				if (anEntity.fadeAnim != 0)
				{
					anEntity.sprite.alpha += anEntity.fadeAnim * currentFrameSeconds;
					if (anEntity.sprite.alpha <= 0.001)
					{
						anEntity.die();
					}
					else if (anEntity.sprite.alpha > 1)
					{
						anEntity.sprite.alpha = 1;
					}
				}
				if (anEntity.zoomAnim != 0)
				{
					anEntity.sprite.scaleX += anEntity.zoomAnim * currentFrameSeconds;
					anEntity.sprite.scaleY += anEntity.zoomAnim * currentFrameSeconds;
					if (anEntity.sprite.scaleX < 0 || anEntity.sprite.scaleY < 0)
						anEntity.die();
				}
			}
		}
	}
} // end class

function CreateEntityManager(view:Rectangle):EntityManager{
	return new EntityManager(view);

}