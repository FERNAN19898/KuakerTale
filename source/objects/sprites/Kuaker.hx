package objects.sprites;

import flixel.FlxG;
import flixel.FlxSprite;

class Kuaker extends FlxSprite
{
	/* === VARIABLES === */
	var cordX:Float;
	var cordY:Float;
	var speed:Float = 5;

	public var canMove:Bool = true;

	/* === BOUNDS === */
	// Estos valores definen los límites del movimiento del Kuaker
	var topY:Float = 110;
	var bottomY:Float = 350 - 90;

	var leftX:Float = 180;
	var rightX:Float = 485 - 60;

	override public function new(x:Float, y:Float)
	{
		super(x, y);

		cordX = x;
		cordY = y;

		loadGraphic("assets/images/History/world/characters/kuaker_assets.png", true, 40, 60);
		scale.set(1.5, 1.5);
		updateHitbox();

		animation.add("view_up", [4], 0, false);
		animation.add("walk_up", [5, 6, 7, 4], 6, true);

		animation.add("view_down", [0], 0, false);
		animation.add("walk_down", [1, 2, 3, 0], 6, true);

		animation.add("view_left", [8], 0, false);
		animation.add("walk_left", [9, 8], 6, true);

		animation.add("view_right", [10], 0, false);
		animation.add("walk_right", [11, 10], 6, true);

		animation.play("view_down");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		updateMove();
	}

	private function updateMove()
	{
		x = cordX;
		y = cordY;

		if (canMove)
		{
			var movingUp = FlxG.keys.pressed.UP;
			var movingDown = FlxG.keys.pressed.DOWN;
			var movingLeft = FlxG.keys.pressed.LEFT;
			var movingRight = FlxG.keys.pressed.RIGHT;

			// Movimiento (todas las combinaciones posibles)
			if (movingUp && cordY >= topY)
				cordY -= 1 * speed;
			if (movingDown && cordY <= bottomY)
				cordY += 1 * speed;
			if (movingLeft && cordX >= leftX)
				cordX -= 1 * speed;
			if (movingRight && cordX <= rightX)
				cordX += 1 * speed;

			// Lógica de animaciones con prioridad horizontal
			if (movingLeft || movingRight)
			{
				// Prioridad a animaciones horizontales
				if (movingLeft && movingRight)
				{
					// Si ambas están presionadas, mantenemos la última dirección
					if (FlxG.keys.justPressed.LEFT)
						animation.play("view_right");
					else if (FlxG.keys.justPressed.RIGHT)
						animation.play("view_left");
				}
				else if (movingLeft)
				{
					animation.play("walk_left");
				}
				else if (movingRight)
				{
					animation.play("walk_right");
				}
			}
			else if (movingUp || movingDown)
			{
				// Solo animaciones verticales si no hay movimiento horizontal
				if (movingUp && movingDown)
				{
					if (FlxG.keys.justPressed.UP)
						animation.play("view_down");
					else if (FlxG.keys.justPressed.DOWN)
						animation.play("view_up");
				}
				else if (movingUp)
				{
					animation.play("walk_up");
				}
				else if (movingDown)
				{
					animation.play("walk_down");
				}
			}
			// Animaciones al soltar teclas
			else
			{
				if (FlxG.keys.justReleased.UP)
					animation.play("view_up");
				else if (FlxG.keys.justReleased.DOWN)
					animation.play("view_down");
				else if (FlxG.keys.justReleased.LEFT)
					animation.play("view_left");
				else if (FlxG.keys.justReleased.RIGHT)
					animation.play("view_right");
			}
		}
	}
	public function setVelocity(i:Int) {
		speed = i;
	}
	

	public function setLimits(vtopY:Float, vleftX:Float, vbottomY:Float, vrightX:Float)
	{
		topY = vtopY;
		bottomY = vbottomY - 90;

		leftX =vleftX;
		rightX = vrightX - 60;
	}
}
