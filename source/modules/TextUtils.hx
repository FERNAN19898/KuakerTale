package modules;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

function typeText(textObj:FlxText, content:String, speed:Float, tag:String, onComplete:String->Void, plzCenterIt:Bool = true, playSound:Bool = false,
		soundPath:String = ""):Void
{
	var index:Int = 0;
	var currentText:String = "";
	var timer = new FlxTimer();

	timer.start(speed, function(t:FlxTimer)
	{
		currentText += content.charAt(index);
		textObj.text = currentText;
		// Centrado horizontal y vertical manual (respecto al centro de pantalla)

		if (plzCenterIt)
		{
			textObj.x = (FlxG.width - textObj.width) / 2;
			textObj.y = (FlxG.height - textObj.height) / 2;
		}

		if (playSound)
		{
			if (currentText.charAt(index) != " ")
				FlxG.sound.play(soundPath);
		}
		index++;

		if (index >= content.length)
		{
			// Stop timer to be sure
			t.cancel();
			// Call the callback with the tag
			if (onComplete != null)
				onComplete(tag);
		}
	}, content.length);
}
