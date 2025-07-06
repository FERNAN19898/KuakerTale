package objects.attacks;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.ui.Soul;
import states.BattleState;
import objects.ui.BattleBox;
import modules.TypesDefs;

class Light extends FlxSprite
{
	override public function new(x:Float)
	{
		super(x, -82, "assets/images/Battle/attacks/shoker-breaker/light.png");
		this.scale.set(1.6, 1.6);
		this.updateHitbox();

		var startHue = FlxG.random.float(0, 360);
		FlxTween.num(startHue, startHue + 360, 0.6, {}, function(h:Float)
		{
			var c = hsvToRgb(h, 1, 1);
			this.color = c;
		});

		new FlxTimer().start(0.2, function(_)
		{
			FlxTween.num(1, 0, 0.2, {
				onComplete: function(_)
				{
					this.destroy();
				}
			}, function(alpha:Float)
			{
				this.alpha = alpha;
			});
		});
	}
}

class HitZone extends FlxSprite
{
	override public function new(hislight:Light)
	{
		super(hislight.x + 30, hislight.y, "");
		this.makeGraphic(26, 640, FlxColor.WHITE);

		new FlxTimer().start(0.1, function(_)
		{
			FlxTween.num(1, 0, 0.1, {
				onComplete: function(_)
				{
					this.destroy();
				}
			}, function(alpha:Float)
			{
				this.alpha = alpha;
			});
		});
	};
}

class Alert extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y, "");
		this.loadGraphic("assets/images/Battle/attacks/shoker-breaker/warning.png", true, 40, 40);
		this.animation.add("loop", [0, 1], 12, true);
		this.animation.play("loop");
	}
}

class ShokerBreaker
{
	var curBattle:BattleState;
	var curPlayer:Soul;
	var curBattleBox:BattleBox;

	var hitZones:Array<HitZone> = [];
	var trackPlayer:Bool = false;

	public function new(battleContext:BattleState, playerContext:Soul, battleBoxContext:BattleBox)
	{
		curBattle = battleContext;
		curPlayer = playerContext;
		curBattleBox = battleBoxContext;
	}

	public function spawnLight(x:Float, soundIndex:Int = 1, lightVolume:Float = 0.4):Void
	{
		var lighting:FlxGroup = new FlxGroup();
		var cods = [x, 524];
		var alert = new Alert(cods[0], cods[1] - 8);

		curBattle.add(alert);
		alert.animation.play("loop", true);

		new FlxTimer().start(0.6, function(_)
		{
			FlxTween.tween(alert, {alpha: 0}, 0.25);

			var bg = new Light(cods[0] - 54 + 26);
			var zone = new HitZone(bg);

			lighting.add(bg);
			lighting.add(zone);

			hitZones.push(zone);

			curBattle.add(lighting);

			FlxG.sound.play("assets/sounds/attacks/shoker-breaker/light_" + soundIndex + ".ogg", lightVolume);
			FlxG.camera.shake(0.007, 0.1);
		});

		new FlxTimer().start(1.5, function(_)
		{
			lighting.destroy();
		});
	}

	public function LightSeries(etapa:Int)
	{
		var cords:Array<Float> = [0, 100, 200, 300, 400, 500, 600];

		if (etapa == 2)
		{
			cords = [650, 550, 450, 350, 250, 150, 50];
		}

		for (i in 0...cords.length)
		{
			new FlxTimer().start(0.025 * i, function(_)
			{
				spawnLight(cords[i]);
			});
		}
	}

	public function lastPhase()
	{
		var cords:Array<Float> = [33.33, 106.66, 180.00, 253.33, 326.66];

		for (i in 0...cords.length)
		{
			new FlxTimer().start(0.55 * i, function(_)
			{
				spawnLight(cords[i] + 160, i + 1, 0.8);
			});
		}
	}

	public function runAttack()
	{
		/* Cambiar de tamano el battlebox */
		curBattleBox.resizeBox(400, 200, 0.2);

		LightSeries(1);
		new FlxTimer().start(0.5, function(_)
		{
			LightSeries(2);
		});

		new FlxTimer().start(1.0, function(_)
		{
			LightSeries(1);
		});

		new FlxTimer().start(1.7, function(_)
		{
			trackPlayer = true;
		});

		new FlxTimer().start(2.2, function(_)
		{
			trackPlayer = false;
		});

		new FlxTimer().start(2.5, function(_)
		{
			trackPlayer = false;
			lastPhase();
		});

		new FlxTimer().start(6.0, function(_)
		{
			endAttack();
		});
	}

	var lightningTimer:Float = 0;

	public function updateAttack(elapsed:Float, curPlayer:Soul)
	{
		for (hitZone in hitZones)
		{
			if (hitZone != null && hitZone.exists && hitZone.active)
			{
				if (hitZone.overlaps(curPlayer))
				{
					curBattle.addDamage(1);
				}
			}
		}

		if (trackPlayer)
		{
			lightningTimer += elapsed;

			if (lightningTimer >= 0.035)
			{
				spawnLight(curPlayer.x, 2, 0.4);
				lightningTimer = 0; // reinicia el contador
			}
		}
		else
		{
			lightningTimer = 0; // opcional: reset si se desactiva
		}
	}

	public function endAttack()
	{
		for (zone in hitZones)
		{
			if (zone != null)
				zone.destroy();
		}
		hitZones = [];
	}
}
