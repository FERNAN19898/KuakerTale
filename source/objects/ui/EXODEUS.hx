package objects.ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import modules.TextUtils.typeText;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

class EXODEUS extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, 30, "assets/images/Battle/EXODEUS/feliz.png");
		this.screenCenter(X);
	}

	function changeFace(face:String)
	{
		this.loadGraphic("assets/images/Battle/EXODEUS/" + face + ".png");
	}

	public function EXODEUS_talk(dialog:String, speed:Float, object:EXODEUS_TEXT, ?onComplete:String->Void)
	{
		FlxTween.tween(this, {x: 30}, 0.6, {ease: FlxEase.quadInOut});
		typeText(object, dialog, speed, "somting", function(_)
		{
			if (onComplete != null)
				onComplete(dialog);
		}, false, true, "assets/sounds/dialog/ia-mala.ogg");
	}
}

class EXODEUS_TEXT extends FlxText
{
	public function new(hisexodeus:EXODEUS)
	{
		super(340, hisexodeus.y + 20, 320, "", 16, true);
		this.setFormat("assets/fonts/exodeus.ttf", 32, FlxColor.WHITE, LEFT, null, FlxColor.BLACK, true);
	}
}
