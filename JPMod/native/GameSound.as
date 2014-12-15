// Stage3D Shoot-em-up Tutorial Part 3
// by Christer Kaitila - www.mcfunkypants.com

// GameSound.as
// A simple sound and music system for our game


import flash.media.Sound;
import flash.media.SoundChannel;

class GameSound
{
	
	// to reduce .swf size these are mono 11khz
	[Embed (source = "../assets/sfxmusic.mp3")]
	private var _musicMp3:Class;
	private var _musicSound:Sound = (new _musicMp3) as Sound;
	private var _musicChannel:SoundChannel;

	[Embed (source = "../assets/sfxgun1.mp3")]
	private var _gun1Mp3:Class;
	private var _gun1Sound:Sound = (new _gun1Mp3) as Sound;
	[Embed (source = "../assets/sfxgun2.mp3")]
	private var _gun2Mp3:Class;
	private var _gun2Sound:Sound = (new _gun2Mp3) as Sound;
	[Embed (source = "../assets/sfxgun3.mp3")]
	private var _gun3Mp3:Class;
	private var _gun3Sound:Sound = (new _gun3Mp3) as Sound;
	
	[Embed (source = "../assets/sfxexplosion1.mp3")]
	private var _explode1Mp3:Class;
	private var _explode1Sound:Sound = (new _explode1Mp3) as Sound;
	[Embed (source = "../assets/sfxexplosion2.mp3")]
	private var _explode2Mp3:Class;
	private var _explode2Sound:Sound = (new _explode2Mp3) as Sound;
	[Embed (source = "../assets/sfxexplosion3.mp3")]
	private var _explode3Mp3:Class;
	private var _explode3Sound:Sound = (new _explode3Mp3) as Sound;

	// the different phaser shooting sounds
	public function playGun(num:int):void
	{
		switch (num)
		{
			case 1 : _gun1Sound.play(); break;
			case 2 : _gun2Sound.play(); break;
			case 3 : _gun3Sound.play(); break;
		}
	}
	
	// the looping music channel
	public function playMusic():void
	{
		trace("Starting the music...");
		// stop any previously playing music
		stopMusic();
		// start the background music looping
		_musicChannel = _musicSound.play(0,9999); 
	}
	
	public function stopMusic():void
	{
		if (_musicChannel) _musicChannel.stop();
	}

	public function playExplosion(num:int):void
	{
		switch (num)
		{
			case 1 : _explode1Sound.play(); break;
			case 2 : _explode2Sound.play(); break;
			case 3 : _explode3Sound.play(); break;
		}
	}
	
} // end class
