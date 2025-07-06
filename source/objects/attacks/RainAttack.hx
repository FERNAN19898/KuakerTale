package objects.attacks;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.ui.Soul;
import states.BattleState;

class RainDrop extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		this.makeGraphic(16, 16, FlxColor.WHITE);
		this.velocity.x = FlxG.random.float(-30, 30);
		this.velocity.y = FlxG.random.float(120, 240);
	}

	public function updateDrop(soul:Soul, battle:BattleState)
	{
		this.x += FlxG.random.float(-0.5, 0.5);
		this.angle += FlxG.random.float(-10, 10);

		if (this.overlaps(soul) && battle.state != "onIdle")
		{
			battle.addDamage(3);
			this.kill();
		}

		if (this.y > FlxG.height)
			this.kill();
	}
}

class RainStorm
{
	var battle:BattleState;
	var soul:Soul;
	var rainGroup:FlxGroup;

	public function new(battle:BattleState, soul:Soul)
	{
		this.battle = battle;
		this.soul = soul;
		rainGroup = new FlxGroup();
	}

	public function runAttack():Void
	{
		for (i in 0...60)
		{
			new FlxTimer().start(i * 0.05, function(_)
			{
				var rx = FlxG.random.float(0, 640); // asume 640 de ancho
				var drop = new RainDrop(rx, -20);
				rainGroup.add(drop);
				battle.add(drop);
			});
		}

		new FlxTimer().start(8, function(_) endAttack());
	}

	public function updateAttack(elapsed:Float, soul:Soul):Void
	{
		for (d in rainGroup.members)
		{
			if (d != null && d.exists)
			{
				cast(d, RainDrop).updateDrop(soul, battle);
			}
		}
	}

	public function endAttack():Void
	{
		for (d in rainGroup.members)
			if (d != null)
				d.kill();

		rainGroup.clear();
	}
}
