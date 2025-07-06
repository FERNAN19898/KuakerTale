package states.history;

import flixel.math.FlxPoint;
import objects.ui.TerminalText;
import modules.WallpaperSetter;
import modules.TextUtils.typeText;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import modules.WindowUtils;
import flixel.FlxG;
import modules.TypesDefs.DialogLine;
import flixel.FlxSprite;
import objects.sprites.Kuaker;
import flixel.sound.FlxSound;
import objects.ui.DialogBox;
import flixel.FlxCamera;
/* === DISCORD RPC === */
import modules.Discord.Main as DiscordShit;

class BlueScreen extends Manager
{
	override public function new()
	{
		super();

		WindowUtils.resizeRealGame(WindowUtils.screenWidth, WindowUtils.screenHeight);
		WindowUtils.setFullScreen(true);
		WindowUtils.setBorderless(false);
		WindowUtils.setMouseVisible(false);
	}

	override function create()
	{
		super.create();
		// Discord
		DiscordShit.updatePresence("???", "???");

		var bsod = new FlxSprite(0, 0, "assets/data/secret/png/BSOD.png");
		add(bsod);

		var terminalText = new FlxText(0, WindowUtils.screenHeight - 32, 1000, "", 24);
		add(terminalText);

		FlxG.sound.play("assets/data/secret/sounds/aaaaa-glitch.ogg", 1, false, null, false, function()
		{
			typeText(terminalText, "> RUN COMMAND inject Exodeus to System32........................ Success!!!.", 0.04, "text", function(_) {}, false);
			FlxFlicker.flicker(bsod, 3, 0.02, false, true, function(_)
			{
				WindowUtils.setWindowVisible(false);
				WindowUtils.hideAllWindows(true);
				FlxTimer.wait(4, () ->
				{
					WindowUtils.setWindowVisible(true);
					WindowUtils.maximizeGameWindow();
					FlxG.switchState(PreBattleState.new);
				});
			});
		});

		FlxTimer.wait(2, () -> WallpaperSetter.setWallpaper("assets/data/secret/bmp/i_see_you.bmp"));
	}

	override function destroy()
	{
		super.destroy();
	}
}

class PreBattleState extends Manager
{
	/* === CAMARAS === */
	private var camGAME:FlxCamera;
	private var camHUD:FlxCamera;

	/* === SPRITES === */
	// Juego
	private var background:FlxSprite;
	private var character:Kuaker;

	// HUD
	private var dialogBox:DialogBox;
	private var terminalText:TerminalText;

	/* === SONIDOS === */
	private var bgMusic:FlxSound;

	/* === GUION DE LA HISTORIA === */
	private var dialogLines:Array<DialogLine>;

	/* === LOGICA === */
	private var dialogIndex:Int = 0;
	private var canSkip:Bool = true;

	override public function new()
	{
		super();
		WindowUtils.resizeRealGame(720, 720);
		WindowUtils.setFullScreen(false);
		WindowUtils.setBorderless(false);
		WindowUtils.setWindowTittle("Kuakertale...??");
		WindowUtils.moveWindowToCenter();
	}

	override public function create()
	{
		super.create();
		// Discord
		DiscordShit.updatePresence("STATE_NAME_INVALID -> EXODEUS?", "En WORLD_ID_INVALID");

		// Inicializar camaras
		camGAME = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camGAME.bgColor = FlxColor.TRANSPARENT;
		camGAME.zoom = 1;
		camHUD = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camHUD.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(camGAME);
		FlxG.cameras.add(camHUD);

		// Inicializar sprites
		background = new FlxSprite(0, -1440, "assets/images/History/world/bg-idonou.png");
		// background.makeGraphic(360, 2160, FlxColor.BROWN); // Fondo
		background.cameras = [camGAME];
		add(background);

		character = new Kuaker(FlxG.width / 2, FlxG.height / 2);
		character.cameras = [camGAME];
		character.setLimits(-1295, 180, 720, 540);
		character.setVelocity(2);

		// DEBUG
		if (GameData.debugMode)
			character.setVelocity(10);

		character.screenCenter(X);
		add(character);

		// Ajustar camara
		camGAME.follow(character, FlxCameraFollowStyle.LOCKON, 1.5);
		camGAME.setScrollBounds(0, 720, -1440, 720);
		camGAME.deadzone = new FlxRect(0, FlxG.height / 2, FlxG.width, FlxG.height / 4);

		// Inicializar HUD
		dialogBox = new DialogBox();
		dialogBox.centerOnScreen();
		dialogBox.setCamera([camHUD]);
		dialogBox.addToState(this);
		dialogBox.setVisible(false);

		terminalText = new TerminalText(10, 10);
		terminalText.setCameras([camHUD]);
		// add(terminalText);

		// Sonido
		bgMusic = new FlxSound();
		bgMusic.loadEmbedded("assets/music/ch_trigger/breath_of_lavos.ogg", true, true);
		bgMusic.play(true);
		FlxG.sound.list.add(bgMusic);
	}

	var onlyOneTime:Bool = false;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		dialogBox.update(elapsed);

		if (character.y <= -1295 && (character.x >= 300 && character.x <= 340) && onlyOneTime == false)
		{ // Personaje
			character.canMove = false;
			character.animation.play("view_up", true);
			FlxTween.tween(character, {x: 325, y: -1300}, 0.5);
			onlyOneTime = true;

			// Camara
			camGAME.follow(null);
			camGAME.setScrollBounds(0, 720, -2160, -720);
			playTransition();
		}

		if (FlxG.mouse.justPressed)
		{
			var mousePos = FlxPoint.get();
			FlxG.mouse.getWorldPosition(camGAME, mousePos);
			trace("Click en: " + mousePos);
		}
	}

	/* === LA CINEMATICA DE TRANSICION === */
	public function playTransition()
	{
		// Bajar el volumen de la musica progresivamente
		bgMusic.fadeOut(5, 0);

		FlxFlicker.flicker(background, 0.7, 0.015, false, true, (_) -> {}, (_) ->
		{
			FlxG.sound.pause();
			FlxG.sound.play("assets/sounds/chit.ogg");
		});

		WindowUtils.shakeWindow(10, 0.7);
		WindowUtils.setWindowTittle("Estas Jodido Israel...");

		camGAME.shake(0.005, 0.7, () ->
		{
			background.alpha = 0;
			WindowUtils.setWindowTittle("???");
			WindowUtils.setBorderless(false);

			FlxTween.tween(camGAME.scroll, {y: -1800}, 4, {
				ease: FlxEase.smoothStepIn,
				onComplete: (_) ->
				{
					// terminalText.writeText("INICIANDO......\n
					// FROM modules.ui IMPORT ", 0.1);
				}
			});
		});
	}
}
