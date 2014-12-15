Import "as/AGALMiniAssembler.as"
Import "as/Entity.as"
Import "as/EntityManager.as"
Import "as/GameBackground.as"
Import "as/GameControls.as"
Import "as/GameGUI.as"
Import "as/GameMenu.as"
Import "as/GameParticles.as"
Import "as/GameSound.as"
Import "as/LiteSprite.as"
Import "as/LiteSpriteBatch.as"
Import "as/LiteSpriteSheet.as"
Import "as/LiteSpriteStage.as"


Extern
'****************************************************
'			The sprite Stage
'****************************************************
Class SpriteStage="LiteSpriteStage"
	Method AddBatch(batch:SpriteBatch)="addBatch"
	Method Render:Void()="render"
End Class

Function CreateSpriteStage:SpriteStage(stage3d:Stage3D,rect:ClampA)


'****************************************************
' 			The entity manager
'****************************************************

Class EntityManager

	Field batch:SpriteBatch
	
	Method CreateBatch:SpriteBatch(context3D:Context3D,bitmap:Bitmap,spritesa:Int=8,spritesD:Int=8)="createBatch"
	Method SpawnEntity:Entity(idNumber)="spawnEntity"
	Method InitEntity(entity:Entity,x:float,y:Float,angle:Float,speed:Float)="initEntity"
	Method Update(n)="update"
	Method SetPosition(view:ClampA)="setPosition"
	Method AddPlayer:Void()="addPlayer"
	
	
End class

Function CreateEntityManager:EntityManager(rect:ClampA)

'****************************************************
'		The game backGround
'****************************************************

Class Background

	Field batch:SpriteBatch
	
	Method CreateBatch:SpriteBatch(context3D:Context3D,bitmap:Bitmap,spritesa:Int=8,spritesD:Int=8)="createBatch"	
	Method InitBackground:Void()="initBackground"
	Method Update:Void(time:Int)="update"
End Class

Function CreateBackground:Background(view:ClampA)

'****************************************************
'			the game menu
'****************************************************

Class Menu
	
	Field batch:SpriteBatch
	
	Method CreateBatch:SpriteBatch(context3D:Context3D,atlasBitmap:Bitmap)="createBatch"
	Method ActivateCurrentMenuItem:Bool(currentTime:Float)="activateCurrentMenuItem"
	Method MouseHighlight:Void(x:Int, y:Int)="mouseHighlight"
	Method UpdateState:Void()="updateState"
	Method Update:Void(time:Float)="update"
End Class

Function CreateMenu:Menu(view:ClampA)

'****************************************************
'			the sprite batch
'****************************************************

Class SpriteBatch="LiteSpriteBatch"

        Method addChild(sprite:LiteSprite, spriteId:Int)
		Method Draw()="draw"
End Class

Function CreateSpriteBatch:SpriteBatch(context3D:Context3D,spritesheet:SpriteSheet)



'****************************************************
'		the sprite sheet
'****************************************************

Class SpriteSheet="LiteSpriteSheet"
End Class

Function CreateLiteSpriteSheet:SpriteSheet(bitmap:Bitmap,numSpritesw:Int=8,numbSpritesH:Int=8)

'****************************************************
'		the GUI
'****************************************************
Class Gui="GameGUI"
	Field statsTarget:EntityManager
End Class

Function CreateGUI:Gui(title:String = "", inX:Float=8, inY:Float=8, inCol:Int = $FFFFFF)

'****************************************************
'			the Rectangle
'****************************************************

Class ClampA="Rectangle"

	Method Rectangle(x:Float,y:Float,width:Float,height:Float)
	
	Field x:Float
	Field y:Float
	Field width:Float
	Field height:Float
End Class



'****************************************************
'			the BBmonkey Class
'****************************************************

Class BBFlashGame

	Global _flashGame:BBFlashGame
	Function AddChild:Void(sprite:Gui)
	
End Class


'****************************************************
'			the game controlls
'****************************************************

Class GameControls
	Field pressing:Pressing
End Class

Class Pressing
	Field up:Bool
	Field down:Bool
	Field left:Bool
	Field right:Bool
	Field fire:Bool
	Field hasfocus:bool
End Class

Function CreateGameControls:GameControls()

'======================================================


Class Entity
	Field speedx:Float="_speedX"
	Field speedy:Float="_speedY"
 	Field sprite:Sprite
 	Method GetPosition:Point()="getPosition"
 	Method setPosition(pt:Point)="setPosition"

End Class

Class Stage

End Class

Class Stage3D
	Field context3D:Context3D
End Class


Class Context3D
End Class

Class Bitmap
	Field bitmapData:BitmapData
End Class

Class BitmapData
End Class

Class Point
	Field x:Float
	Field y:Float
End Class

Class Sprite="LiteSprite"

	Field speedX:Float
	Field speedY:Float
	
	Method GetPosition:Point()="getPosition"
	Method SetRotation(val:Float)="setRotation"
	Method SetScaleX(val:Float) = "setScaleX"
	Method SetScaleY(val:Float) = "setScaleY"
	Method SetAlpha(a:Float) = "setAlpha"
	Method GetAlpha:Float() = "GetAlpha"
	
End Class



Public

Function CreateSpriteSheet:SpriteSheet(path:String,numSpritesA:Int=8,numSpritesD:Int=8)
	Local bitmap:Bitmap = LoadBitmap(path)
	Return CreateLiteSpriteSheet(bitmap,numSpritesA,numSpritesD)
End Function
