package objects.ui;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
import objects.ui.BattleBox;

class Soul extends FlxSprite
{
	public var speed:Float = 5;
	public var isMoving:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y, "assets/images/Battle/souls/g-soul.png");
		scale.set(2, 2);
		updateHitbox();
	}

	public function updateMovement(battleBox:BattleBox):Void
	{
		// Movimiento base
		if (FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN)
			{ isMoving = true; y -= speed; }
		if (FlxG.keys.pressed.DOWN && !FlxG.keys.pressed.UP)
			{ isMoving = true; y += speed; }
		if (FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
			{ isMoving = true; x -= speed; }
		if (FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT)
			{ isMoving = true; x += speed; }

		if (!FlxG.keys.pressed.UP && !FlxG.keys.pressed.DOWN && !FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
			isMoving = false;

		// Limitar dentro del interior de la caja de batalla
		var minX = battleBox.inner.x;
		var maxX = battleBox.inner.x + battleBox.inner.width - width;
		var minY = battleBox.inner.y;
		var maxY = battleBox.inner.y + battleBox.inner.height - height;

		x = FlxMath.bound(x, minX, maxX);
		y = FlxMath.bound(y, minY, maxY);

		// if (isMoving)
			// trace("Da plaller is muvin");
	}

	// Centrar el alma dentro de la caja de batalla
	public function centerInBox(battleBox:BattleBox):Void
	{
		x = battleBox.inner.x + (battleBox.inner.width - width) / 2;
		y = battleBox.inner.y + (battleBox.inner.height - height) / 2;
	}
}
