package objects.ui;

import modules.TextUtils.typeText;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class TerminalText
{
	// PROPIEDADES
	private var thisX:Float;
	private var thisY:Float;
	private var thisCameras:Array<FlxCamera>;
	private var thisState:FlxState;

	private var lines:Array<FlxText>;

	public function new(x, y)
	{
		thisX = x;
		thisY = y;

		lines = [];
	}

	public function update(elapsed:Float) {}

	public function addToState(state:FlxState)
		thisState = state;

	public function setCameras(cameras:Array<FlxCamera>)
		thisCameras = cameras;

	public function makeText(text:String = "", color:FlxColor = FlxColor.WHITE, size:Int = 24, speed:Float = 0.05, screenTime:Float = 2, destroyTime:Float = 1)
	{
		// Crear nuevo texto en la posición base
		var newLine = new FlxText(thisX, thisY, 720, "", size);
		newLine.setFormat("assets/fonts/CONSOLA.ttf", size, color, LEFT);
		newLine.cameras = thisCameras;
		thisState.add(newLine);

		// Mostrar animacion letra por letra
		typeText(newLine, text, speed, "sumtin", (_) ->
		{
			// Correr timer para destruirlo
			FlxTimer.wait(screenTime, () ->
			{
				FlxTween.tween(newLine, {alpha: 0}, destroyTime, {
					onComplete: (_) ->
					{
						newLine.destroy();
						lines.remove(newLine);
					}
				});
			});
		}, false, false);

		// Mover todos los textos existentes una línea hacia abajo
		for (idx in 0...lines.length)
		{
			lines[idx].y += size;
		}

		// Guardar el nuevo texto en la lista
		lines.insert(0, newLine);
	}
}
