// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// Entity.as
// The Entity class will eventually hold all game-specific entity stats
// for the spaceships, bullets and effects in our game. For now,
// it simply holds a reference to a gpu sprite and a few demo properties.
// This is where you would add hit points, weapons, ability scores, etc.

import flash.geom.Point;
import flash.geom.Rectangle;

class Entity
{
	private var _speedX : Number;
	private var _speedY : Number;
	private var _sprite : LiteSprite;
	public var active : Boolean = true;

	// if this is set, custom behaviors are run
	public var aiFunction : Function;
	
	// collision detection
	public var isBullet:Boolean = false; // only these check collisions
	public var leavesTrail:Boolean = false; // creates particles as it moves
	public var collidemode:uint = 0; // 0=none, 1=sphere, 2=box, etc.
	public var collideradius:uint = 32; // used for sphere collision		
	// box collision is not implemented (yet)
	public var collidebox:Rectangle = new Rectangle(-16, -16, 32, 32);
	public var collidepoints:uint = 25; // score earned if destroyed
	public var touching:Entity; // what entity just hit us?
	public var owner:Entity; // so your own bullets don't hit you
	public var orbiting:Entity; // entities can orbit (circle) others
	public var orbitingDistance:Number; // how far in px from the orbit center
	
	// used for particle animation (in units per second)
	public var fadeAnim:Number = 0;
	public var zoomAnim:Number = 0;
	public var rotationSpeed:Number = 0;

	// used to mark whether or not this entity was 
	// freshly created or reused from an inactive one
	public var recycled:Boolean = false;
	
	public function Entity(gs:LiteSprite = null)
	{
		_sprite = gs;
		_speedX = 0.0;
		_speedY = 0.0;
	}
	
	public function die() : void
	{
		// allow this entity to be reused by the entitymanager
		active = false;
		// skip all drawing and updating
		sprite.visible = false;
		// reset some things that might affect future reuses:
		leavesTrail = false;
		isBullet = false;
		touching = null;
		owner = null;
		collidemode = 0;
	}
	
	public function get speedX() : Number 
	{
		return _speedX;
	}
	public function set speedX(sx:Number) : void 
	{
		_speedX = sx;
	}
	public function get speedY() : Number 
	{
		return _speedY;
	}
	public function set speedY(sy:Number) : void 
	{
		_speedY = sy;
	}
	public function get sprite():LiteSprite 
	{	
		return _sprite;
	}
	public function set sprite(gs:LiteSprite):void 
	{
		_sprite = gs;
	}

	// used for collision callback performed in GameActorpool
	public function colliding(checkme:Entity):Entity
	{
		if (collidemode == 1) // sphere
		{
			if (isCollidingSphere(checkme))
				return checkme;
		}
		return null;
	}

// simple sphere to sphere collision
public function isCollidingSphere(checkme:Entity):Boolean
{
	// never collide with yourself
	if (this == checkme) return false;
	// only check if these shapes are collidable
	if (!collidemode || !checkme.collidemode) return false;
	// don't check your own bullets
	if (checkme.owner == this) return false;
	// don't check things on the same "team"
	if (checkme.owner == owner) return false;
	// don't check if no radius
	if (collideradius == 0 || checkme.collideradius == 0) return false;
	
	// this is the simpler way to do it, but it runs really slow
	// var dist:Number = Point.distance(sprite.position, checkme.sprite.position);
	// if (dist <= (collideradius+checkme.collideradius))
	
	// this looks wierd but is 6x faster than the above
	// see: http://www.emanueleferonato.com/2010/10/13/as3-geom-point-vs-trigonometry/
	if (((sprite.position.x - checkme.sprite.position.x) * 
		(sprite.position.x - checkme.sprite.position.x) +
		(sprite.position.y - checkme.sprite.position.y) *
		(sprite.position.y - checkme.sprite.position.y))
		<= 
		(collideradius+checkme.collideradius)*(collideradius+checkme.collideradius))
	{
		touching = checkme; // remember who hit us
		return true;
	}
	
	// default: too far away
	// trace("No collision. Dist = "+dist);
	return false;
	
}

} // end class
