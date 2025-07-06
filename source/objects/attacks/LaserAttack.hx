package objects.attacks;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import objects.ui.BattleBox;
import objects.ui.Soul;
import states.BattleState;

class LaserShooter
{
	var curBattle:BattleState;
	var curSoul:Soul;
	var curBattleBox:BattleBox;

	var laser:FlxSprite;
	var tracking:Bool = false;
	var times:Int = 0;

	public function new(battle:BattleState, soul:Soul, box:BattleBox)
	{
		curBattle = battle;
		curSoul = soul;
		curBattleBox = box;

		laser = new FlxSprite(0, 0);
		laser.makeGraphic(720, 2, FlxColor.WHITE);
		laser.origin.set(0, laser.height / 2);
		laser.visible = false;

		curBattle.add(laser);
	}

	public function runAttack():Void
	{
		laser.x = curBattleBox.inner.x + (curBattleBox.inner.width / 2);
		laser.y = curBattleBox.inner.y - 3;
		laser.scale.set(1, 1);

		spawnNextAttack();
	}

	function spawnNextAttack():Void
	{
		if (times >= 5)
		{
			endAttack();
			return;
		}

		var type = FlxG.random.int(1, 2);
		alert(type);

		FlxTimer.wait(0.7, () ->
		{
			attack(type);

			FlxTimer.wait(1.3, () -> // espera total = 2s por ataque
			{
				times++;
				spawnNextAttack();
			});
		});
	}

	public function updateAttack(elapsed:Float, updatedSoul:Soul)
	{
		curSoul = updatedSoul;
		if (tracking)
			trackPlayer(curSoul);
	}

	public function endAttack()
	{
		tracking = false;
		laser.visible = false;
		times = 0;
	}

	function alert(type:Int)
	{
		tracking = true;

		switch (type)
		{
			case 1:
				laser.pixels.fillRect(laser.pixels.rect, FlxColor.LIME);
			case 2:
				laser.pixels.fillRect(laser.pixels.rect, FlxColor.RED);
		}

		laser.dirty = true;

		function sound(loop:Int)
		{
			laser.visible = !laser.visible;
			FlxG.sound.play("assets/sounds/alert_1.ogg");
		}

		FlxTimer.loop(0.1, loop -> sound(loop), 8);
	}

	function attack(type:Int)
	{
		tracking = false;
		laser.visible = true;
		FlxG.sound.play("assets/sounds/laser_sended.ogg");

		switch (type)
		{
			case 1: // Verde: castiga si se mueve
				laser.scale.set(1, 24);
				laser.pixels.fillRect(laser.pixels.rect, FlxColor.fromRGB(0, 0, 0, 100));
				laser.dirty = true;

				curBattleBox.inner.pixels.fillRect(curBattleBox.inner.pixels.rect, FlxColor.WHITE);
				curBattleBox.inner.dirty = true;

				if (curSoul.isMoving)
					curBattle.addDamage(5);

			case 2: // Rojo: castiga si no se mueve
				laser.scale.set(1, 8);
				laser.pixels.fillRect(laser.pixels.rect, FlxColor.WHITE);
				laser.dirty = true;

				curBattleBox.inner.pixels.fillRect(curBattleBox.inner.pixels.rect, FlxColor.BLACK);
				curBattleBox.inner.dirty = true;

				if (!curSoul.isMoving)
					curBattle.addDamage(5);
		}

		FlxTimer.wait(0.5, () ->
		{
			curBattleBox.inner.pixels.fillRect(curBattleBox.inner.pixels.rect, FlxColor.BLACK);
			curBattleBox.inner.dirty = true;

			laser.visible = false;
			laser.color = FlxColor.WHITE;
		});
	}

	function trackPlayer(soul:Soul)
	{
		var fromAngle = laser.angle;
		var toAngle = Math.atan2((soul.y + soul.height / 2) - laser.y, (soul.x + soul.width / 2) - laser.x) * 180 / Math.PI;

		laser.scale.set(1, 4);
		FlxTween.angle(laser, fromAngle, toAngle, 0.05);
	}
}
