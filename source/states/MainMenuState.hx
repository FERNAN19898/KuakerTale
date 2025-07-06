package states;

import states.history.HistoryState;
import modules.TypesDefs.hsvToRgb;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;

/* === DISCORD RPC === */
import modules.Discord.Main as DiscordShit;

class MainMenuState extends Manager
{
	var title(default, null):FlxSprite;
	var titleText(default, null):FlxText;

	var startButton(default, null):FlxSprite;
	var optionsButton(default, null):FlxSprite;
	var helpButton(default, null):FlxSprite;

	var version(default, null):FlxText;
	var dev(default, null):FlxText;

	// Para la nieve
	var snowflakes:Array<FlxSprite> = [];
	var snowCount:Int = 50;

	// Musica
	var music:FlxSound;
	override public function new()
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		DiscordShit.updatePresence("", "En el menu principal");

		title = new FlxSprite(0, 120, "assets/images/MainMenu/titles.png");
		title.screenCenter(X);
		add(title);

		titleText = new FlxText(0, 0, FlxG.width, "LA BATALLA DEL KUAKER Y LA IA");
		titleText.setFormat("assets/fonts/8bitoperator.ttf", 24, 0xFFF2FF00, RIGHT, 0);
		titleText.x = (FlxG.width - titleText.width) - 20;
		titleText.y = 250;
		add(titleText);

		startButton = new FlxSprite(0, 0, "assets/images/MainMenu/buttons/button1.png");
		optionsButton = new FlxSprite(0, 0, "assets/images/MainMenu/buttons/button2.png");
		helpButton = new FlxSprite(0, 0, "assets/images/MainMenu/buttons/button3.png");

		startButton.screenCenter(X);
		optionsButton.screenCenter(X);
		helpButton.screenCenter(X);

		startButton.y = 320;
		optionsButton.y = 400;
		helpButton.y = 480;

		add(startButton);
		add(optionsButton);
		add(helpButton);

		version = new FlxText(0, 0, FlxG.width, "VERSION 1.0");
		version.x = FlxG.width - version.width - 20;
		version.y = FlxG.height - 40;
		version.setFormat("assets/fonts/8bitoperator.ttf", 20, 0xFFFFFFFF, RIGHT, 0);
		add(version);

		dev = new FlxText(0, 0, FlxG.width, "Coded by: @FERNAN19898");
		dev.x = 20;
		dev.y = FlxG.height - 40;
		dev.setFormat("assets/fonts/8bitoperator.ttf", 20, 0xFFFFFFFF, LEFT, 0);
		add(dev);

		FlxG.camera.fade(0xFFFFFFFF, 2, true);
		FlxG.camera.shake(0.0025, 1, true);

		music = new FlxSound();
		music.loadEmbedded("assets/music/intro.ogg", true, true);
		music.play();
		music.pause();
		music.time = 19720;
		music.resume();
		FlxG.sound.list.add(music);

		for (i in 0...snowCount)
		{
			var flake = new FlxSprite();
			flake.makeGraphic(2, 2, 0xFFFFFFFF);
			flake.x = FlxG.random.float(0, FlxG.width);
			flake.y = FlxG.random.float(0, FlxG.height);
			flake.velocity.y = FlxG.random.float(20, 60);
			flake.alpha = FlxG.random.float(0.2, 0.8);
			add(flake);
			snowflakes.push(flake);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		for (flake in snowflakes)
		{
			flake.y += flake.velocity.y * elapsed;

			if (flake.y > FlxG.height)
			{
				flake.y = -2;
				flake.x = FlxG.random.float(0, FlxG.width);

				var startHue = FlxG.random.float(0, 360);
				FlxTween.num(startHue, startHue + 360, 1, {}, function(h:Float)
				{
					titleText.color = hsvToRgb(h, 1, 1);
				});
			}
		}

		checkButtonClicked();
	}

	function checkButtonClicked()
	{
		if (FlxG.mouse.overlaps(startButton) && FlxG.mouse.justPressed)
		{
			trace("Start");

			// Para evitar conflictos, paramos música y destruimos aquí antes del switch
			if (music != null)
			{
				music.stop();
				music.destroy();
				FlxG.sound.list.remove(music);
				music = null;
			}

			FlxG.sound.play("assets/sounds/rise_up.ogg");
			FlxG.camera.fade(0xFFFFFFFF, 5, false, function()
			{
				FlxG.switchState(new HistoryState());
			});
		};
		if (FlxG.mouse.overlaps(optionsButton) && FlxG.mouse.justPressed)
		{
			trace("Options");
		};
		if (FlxG.mouse.overlaps(helpButton) && FlxG.mouse.justPressed)
		{
			trace("Help");
		};
	}

	override public function destroy():Void
	{
		super.destroy();

		// Limpieza nieve
		for (flake in snowflakes)
		{
			flake.destroy();
		}
		snowflakes = [];

		if (music != null)
		{
			music.stop();
			music.destroy();
			music = null;
		}

		title.destroy();
		titleText.destroy();
		startButton.destroy();
		optionsButton.destroy();
		helpButton.destroy();
		version.destroy();
		dev.destroy();
	}
}
