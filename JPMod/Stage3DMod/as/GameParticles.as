// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// GameParticles.as
// A simple particle system class that is
// used by the EntityManager for explosions, etc.

	import flash.geom.Point;

	class GameParticles
	{	
		public var allParticles : Vector.<Entity>;
		public var gfx:EntityManager;
	
		public function GameParticles(entityMan:EntityManager)
		{
			allParticles = new Vector.<Entity>();
			gfx = entityMan;
		}
		
		// a cool looking explosion effect with a big fireball,
		// a blue fast shockwave, smaller bursts of fire,
		// a bunch of small sparks and pieces of hull debris
		public function addExplosion(pos:Point):void
		{
			addShockwave(pos);
			addDebris(pos,6,12);
			addFireball(pos);
			addBursts(pos,10,20);
			addSparks(pos,8,16);
		}
		
		public function addParticle(
			spr:uint,					// sprite ID
			x:int, y:int,				// starting location
			startScale:Number = 0.01,	// initial scale
			spdX:Number = 0, 			// horizontal speed in px/sec
			spdY:Number = 0, 			// vertical speed in px/sec
			startAlpha:Number = 1, 		// initial transparency (1=opaque)
			rot:Number = NaN,			// starting rotation in degrees/sec
			rotSpd:Number = NaN,		// rotational speed in degrees/sec
			fadeSpd:Number = NaN, 		// fade in/out speed per second
			zoomSpd:Number = NaN 		// growth speed per second
			):Entity 
		{
			// Defaults tell us to to randomize some properties
			// Why NaN? Can't put fastRandom() inside a function declaration
			if (isNaN(rot)) rot = gfx.fastRandom() * 360; 
			if (isNaN(rotSpd)) rotSpd = gfx.fastRandom() * 360 - 180;
			if (isNaN(fadeSpd)) fadeSpd = -1 * (gfx.fastRandom() * 1 + 1);
			if (isNaN(zoomSpd)) zoomSpd = gfx.fastRandom() * 2 + 1;
			
			var anEntity:Entity;
			anEntity = gfx.respawn(spr);
			anEntity.sprite.position.x = x;
			anEntity.sprite.position.y = y;
			anEntity.speedX = spdX;
			anEntity.speedY = spdY;
			anEntity.sprite.rotation = rot * gfx.DEGREES_TO_RADIANS;
			anEntity.rotationSpeed = rotSpd * gfx.DEGREES_TO_RADIANS;
			anEntity.collidemode = 0;
			anEntity.fadeAnim = fadeSpd;
			anEntity.zoomAnim = zoomSpd;
			anEntity.sprite.scaleX = startScale;
			anEntity.sprite.scaleY = startScale;
			anEntity.sprite.alpha = startAlpha;
			if (!anEntity.recycled)
				allParticles.push(anEntity);
			return anEntity;
		}

		// one big spinning ball of fire
		public function addFireball(pos:Point):void
		{
			addParticle(gfx.spritenumFireball, pos.x, pos.y, 0.01, 0, 0, 1, NaN, NaN, NaN, 4);
		}
		
		// a shockwave ring that expands quickly
		public function addShockwave(pos:Point):void
		{
			addParticle(gfx.spritenumShockwave, pos.x, pos.y, 0.01, 0, 0, 1, NaN, NaN, -3, 20);
		}

		// several small fireballs that move and spin
		public function addBursts(pos:Point, mincount:uint, maxcount:uint):void
		{
			var nextparticle:int = 0;
			var numparticles:int = gfx.fastRandom() * mincount + (maxcount-mincount);
			for (nextparticle = 0; nextparticle < numparticles; nextparticle++)
			{
				addParticle(gfx.spritenumFireburst, 
					pos.x + gfx.fastRandom() * 16 - 8, 
					pos.y + + gfx.fastRandom() * 16 - 8,
					0.02, 
					gfx.fastRandom() * 200 - 100,
					gfx.fastRandom() * 200 - 100, 
					0.75);
			}
		}

		// several small bright glowing sparks that move quickly
		public function addSparks(pos:Point, mincount:uint, maxcount:uint):void
		{
			var nextparticle:int = 0;
			var numparticles:int = gfx.fastRandom() * mincount + (maxcount-mincount);
			for (nextparticle = 0; nextparticle < numparticles; nextparticle++)
			{
				// small sparks that stay bright but get smaller
				addParticle(gfx.spritenumSpark, pos.x, pos.y, 1, 
					gfx.fastRandom() * 320 - 160, 
					gfx.fastRandom() * 320 - 160, 
					1, NaN, NaN, 0, -1.5);
			}
		}
			
		// small pieces of destroyed spaceship debris, moving on average slightly forward
		public function addDebris(pos:Point, mincount:uint, maxcount:uint):void
		{
			var nextparticle:int = 0;
			var numparticles:int = gfx.fastRandom() * mincount + (maxcount-mincount);
			for (nextparticle = 0; nextparticle < numparticles; nextparticle++)
			{
				addParticle(gfx.spritenumDebris, pos.x, pos.y, 1, 
				gfx.fastRandom() * 180 - 120, 
				gfx.fastRandom() * 180 - 90, 
				1, NaN, NaN, -1, 0);
			}
		}

	} // end class
