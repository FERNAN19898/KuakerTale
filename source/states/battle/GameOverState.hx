package states;

import haxe.macro.Compiler.IncludePosition;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import modules.Discord.Main as DiscordShit;

class GameOverState extends FlxState
{
	// Texto
	var GAMEOVER:FlxText;

	var deathX:Float;
	var deathY:Float;
	var oldRetries:Int;

	// normal and broken heart
	var normalHeart:FlxSprite;
	var brokenHeart:FlxSprite;

	// Parámetros configurables de la explosión
	var explosionForceMin:Float = 900;
	var explosionForceMax:Float = 1000;
	var gravityMin:Float = 500;
	var gravityMax:Float = 600;
	var rotationSpeedMin:Float = 100;
	var rotationSpeedMax:Float = 1280;
	var tweenDuration:Float = 5;

	// logica
	var canRespawn:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();
		deathX = x;
		deathY = y;
	}

	override public function create():Void
	{
		super.create();
		// GAME OVER
		GAMEOVER = new FlxText(0, 100, FlxG.width, "GAME OVER");
		GAMEOVER.setFormat("assets/fonts/8bitoperator.ttf", 160, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
		GAMEOVER.screenCenter(X);
		GAMEOVER.alpha = 0;
		add(GAMEOVER);

		normalHeart = new FlxSprite(deathX - 16, deathY - 16, "assets/images/GameOver/normal.png");
		normalHeart.visible = true;
		add(normalHeart);

		brokenHeart = new FlxSprite(normalHeart.x - 16, normalHeart.y - 16, "assets/images/GameOver/broken.png");
		brokenHeart.visible = false;
		add(brokenHeart);

		DiscordShit.updatePresence("Game Over", "Muerte por Laser", "Modo desarrollador");
		GameData.deads += 1;

		openfl.Lib.current.stage.window.title = "KuakerTale | Game Over...";
		FlxTimer.wait(0.8, () -> broke());

		// FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && canRespawn)
		{
			FlxG.switchState(new BattleState(oldRetries + 1));
		}

		if (FlxG.keys.justPressed.Q)
		{
			brokenHeart.visible = false;
			normalHeart.visible = true;
		}
		if (FlxG.keys.justPressed.I)
		{
			broke();
		}

		if (FlxG.keys.justPressed.O)
		{
			explosion();
		}
	}

	function broke()
	{
		brokenHeart.visible = true;
		normalHeart.visible = false;

		FlxG.sound.play("assets/sounds/ouch.ogg", 1, false);
		FlxTimer.wait(1.25, () -> explosion());
	}

	function explosion()
	{
		FlxTimer.wait(0.2, () -> message());

		FlxG.sound.play("assets/sounds/imissyou.ogg", 1, false);
		brokenHeart.visible = false;
		normalHeart.visible = false;

		for (i in 1...6)
		{
			var piece = new FlxSprite(deathX, deathY, 'assets/images/GameOver/part_' + i + '.png');
			piece.setGraphicSize(Std.int(piece.width));
			piece.updateHitbox();
			add(piece);

			var angle = FlxG.random.float(-Math.PI, Math.PI);
			var force = FlxG.random.float(explosionForceMin, explosionForceMax);
			var dx = Math.cos(angle) * force;
			var dy = Math.sin(angle) * force + FlxG.random.float(gravityMin, gravityMax);

			var rotationAmount = FlxG.random.float(rotationSpeedMin, rotationSpeedMax);
			if (FlxG.random.bool())
				rotationAmount *= -1;

			FlxTween.tween(piece, {
				x: piece.x + dx,
				y: piece.y + dy,
				angle: piece.angle + rotationAmount,
				alpha: 0
			}, tweenDuration, {ease: FlxEase.quadOut, onComplete: function(_) piece.kill()});
		}
	}

	function message()
	{
		FlxTween.tween(GAMEOVER, {alpha: 1}, 2);

		FlxTimer.wait(1.2, () ->
		{
			canRespawn = true;
			FlxG.sound.playMusic("assets/music/game_over.ogg", 1, true);
		});
	}

	override public function destroy()
	{
		super.destroy();
		FlxG.sound.music.stop();
	}
}
