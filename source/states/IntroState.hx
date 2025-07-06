package states;

import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import modules.TextUtils;
import states.MainMenuState;

class IntroState extends Manager
{
	var logo:FlxSprite;
	var introText(default, null):FlxText;
	var music:FlxSound;

	var inIntro:Bool = false;

	var introEvents:Array<{time:Int, action:Void->Void}> = [];
	var currentEventIndex:Int = 0;

	override public function create():Void
	{
		super.create();
		logo = new FlxSprite(0, 0, "assets/images/MainMenu/logo.png");
		logo.setGraphicSize(200, 200);
		logo.updateHitbox();
		logo.screenCenter();
		add(logo);
		FlxG.sound.load("assets/sounds/vine-boom.ogg").play();

		introText = new FlxText(50, 50, 620, "", 30);
		introText.screenCenter(XY);
		introText.alignment = "center";
		introText.setFormat("assets/fonts/8bitoperator.ttf", 30, 0xFFFFFFFF, "center");
		add(introText);

		music = new FlxSound();
		music.loadEmbedded("assets/music/intro.ogg", false, true);
		music.volume = 0.8;
		FlxG.sound.list.add(music);

		introEvents = [
			{
				time: 0,
				action: function()
				{
					var text = "De los creadores de\n\nLas flipantes aventuras del corazon responte preguntas\n\n\n          Y porque estaba aburrido!";
					typeText(introText, text, 0.05, "" + music.time, (_) -> {});
				}
			},
			{
				time: 9940,
				action: function()
				{
					FlxG.camera.shake(0.0025, 5, true);
					FlxG.camera.fade(0xFFFFFFFF, 2, true);
					var text = "Dedicado a un kuaker\nQue ni sabe en que carrera estamos\n\nRecontra visionario\n\nY fan del fri fayer!";
					typeText(introText, text, 0.04, "" + music.time, (_) -> {});
				}
			},
			{
				time: 14680,
				action: function()
				{
					FlxG.camera.shake(0.0025, 2, true);
					FlxG.camera.fade(0xFFFFFFFF, 2, true);
					var text = "FERNAN19898 presenta...";
					typeText(introText, text, 0.05, "" + music.time, (_) -> {});
				}
			},
			{
				time: 16980,
				action: function()
				{
					FlxG.camera.shake(0.0025, 3, true);
					FlxG.camera.fade(0xFFFFFFFF, 0.8, true);
					introText.y -= 75;
					introText.text = "Otro FanGame de UNDERTALE:\n\n!! KuakerTale !!";
				}
			},
			{
				time: 18520,
				action: function()
				{
					FlxG.camera.flash(0xFFFFFFFF, 0.2, true);
				}
			},
			{
				time: 18780,
				action: function()
				{
					FlxG.camera.flash(0xFFFFFFFF, 0.2, true);
				}
			},
			{
				time: 19080,
				action: function()
				{
					FlxG.camera.flash(0xFFFFFFFF, 0.2, true);
				}
			},
			{
				time: 19360,
				action: function()
				{
					FlxG.camera.flash(0xFFFFFFFF, 0.2, true);
				}
			},
			{
				time: 19720,
				action: function()
				{
					trace("Intro ended");
					FlxG.sound.destroy(true);
					FlxG.switchState(MainMenuState.new);
				}
			}
		];

		FlxTimer.wait(2, playIntro);
	}

	function playIntro()
	{
		FlxTween.tween(logo, {alpha: 0}, 2, {
			ease: FlxEase.elasticInOut,
			onComplete: function(_)
			{
				logo.destroy();
				music.play();
				inIntro = true;
			}
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inIntro && currentEventIndex < introEvents.length)
		{
			var event = introEvents[currentEventIndex];
			if (Std.int(music.time) >= event.time)
			{
				event.action();
				currentEventIndex++;
			}
		}

		// DEBUG 
		if (FlxG.keys.justPressed.SPACE)
		{
			trace("Intro ended");
			FlxG.sound.destroy(true);
			FlxG.switchState(MainMenuState.new);
		}
	}
}
