package objects.ui;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class HealthBar
{
	public var bg:FlxSprite; // Fondo rojo
	public var fill:FlxSprite; // Barra amarilla dinámica

	public var HP_TXT:FlxText;
    public var NAME_TXT:FlxText;

	var maxWidth:Int;
	var height:Int;

	public function new(x:Float = 0, y:Float = 0, width:Int = 105, height:Int = 30)
	{
		this.maxWidth = width;
		this.height = height;

		// Fondo rojo
		bg = new FlxSprite(x, y);
		bg.makeGraphic(width, height, FlxColor.RED);

		// Barra amarilla encima
		fill = new FlxSprite(x, y);
		fill.makeGraphic(width, height, FlxColor.YELLOW);

		NAME_TXT = new FlxText(48, y - 6, 400, "ISRAEL");
		NAME_TXT.setFormat("assets/fonts/8bitoperator.ttf", 25, FlxColor.WHITE);
		NAME_TXT.letterSpacing = 0.1;

		HP_TXT = new FlxText(x + 100 + 25, y - 6, 400, "100/100 HP");
		HP_TXT.setFormat("assets/fonts/8bitoperator.ttf", 25, FlxColor.WHITE);
		HP_TXT.letterSpacing = 0.1;
	}

	// Agrega ambos elementos al estado
	public function addToState(state:flixel.FlxState):Void
	{
		state.add(bg);
		state.add(fill);
		state.add(HP_TXT);
        state.add(NAME_TXT);
	}

	// Actualiza el porcentaje de vida (0.0 a 1.0) con tween suave
	public function setPercent(percent:Float):Void
	{
		percent = Math.max(0, Math.min(1, percent)); // Clamp entre 0 y 1
		FlxTween.tween(fill.scale, {x: percent}, 0.1, {ease: FlxEase.quadOut});
		fill.updateHitbox();
	}

	// Posicionar ambos elementos
	public function setPosition(x:Float, y:Float):Void
	{
		bg.x = x;
		bg.y = y;
		fill.x = x;
		fill.y = y;
	}
}
