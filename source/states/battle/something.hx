package states;
/// All Haxe imports
import objects.ui.TerminalText;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
// La plantilla
import states.Manager;
// Own objects
import objects.ui.BattleBox;
import objects.ui.HealthBar;
import objects.ui.Soul;
import objects.ui.EXODEUS;
// RPC
import modules.Discord.Main as DiscordShit;
// Import Attacks
import objects.attacks.RainAttack;
import objects.attacks.LaserAttack;
import objects.attacks.ShokerBreaker;
// Data
import GameData;
import modules.TypesDefs;

/* LA CLASE PRINCIPAL */
class BattleState extends Manager
{
	var debugMode = true;
	/* ========================= LOGICA ========================= */
	public var health:Float = 100;
	public var canMove:Bool = true;
	public var state:String = "onIdle";

	var battleIndex:Int = 0; // Indice del ataque actual

	// Spawn, Idle, Action,
	public var buttonsIndex:Int = 1;

	// Battle chart
	var battle:Array<BattleChart> = [
		{dialog: "", attack: 1, boxText: "* Es el fin..."},
		{dialog: "", attack: 1, boxText: "* Es el fin..."}
	];

	/* ========================= SPRITES ========================= */
	var player_soul:Soul;
	var battleBox:BattleBox;
	var healthBar:HealthBar;

	var AtkButton:FlxSprite;
	var ActButton:FlxSprite;
	var CurButton:FlxSprite;
	var ShlButton:FlxSprite;
	var terminalText:TerminalText;

	// Ataques
	var currAttack:Dynamic;
	var currAttackCreated:Bool = false;

	// Sonido
	var damageSound:FlxSound;

	// EXODEUS
	var EXODEUS:EXODEUS;
	var EXODEUS_TEXT:EXODEUS_TEXT;

	/* ========================= FUNCIONES CREATE ========================= */
	function createSprites()
	{
		player_soul = new Soul(0, 0);
		battleBox = new BattleBox(30, 365);
		healthBar = new HealthBar((FlxG.width / 2) - 52 - 30, FlxG.height - 175 + 15);

		// health = new
		AtkButton = new FlxSprite(30, 625, "assets/images/Battle/hud/atk_btn.png");
		ActButton = new FlxSprite(215, 625, "assets/images/Battle/hud/act_btn.png");
		CurButton = new FlxSprite(400, 625, "assets/images/Battle/hud/cur_btn.png");
		ShlButton = new FlxSprite(585, 625, "assets/images/Battle/hud/shl_btn.png");

		terminalText = new TerminalText(0, 700);

		// Iniciar invisibles para la animacion
		AtkButton.alpha = 0;
		ActButton.alpha = 0;
		CurButton.alpha = 0;
		ShlButton.alpha = 0;

		player_soul.alpha = 0;
		battleBox.setText("");
		battleBox.setAlpha(0);
		healthBar.NAME_TXT.alpha = 0;
		healthBar.bg.alpha = 0;
		healthBar.fill.alpha = 0;
		healthBar.HP_TXT.alpha = 0;

		add(AtkButton);
		add(ActButton);
		add(CurButton);
		add(ShlButton);
		add(terminalText);

		battleBox.addToState(this);
		healthBar.addToState(this);
		add(battleBox);
		add(player_soul);

		EXODEUS = new EXODEUS(0, 0);
		EXODEUS_TEXT = new EXODEUS_TEXT(EXODEUS);
		add(EXODEUS);
		add(EXODEUS_TEXT);
	}

	function spawnAnim()
	{
		terminalText.writeText("EXODEUS.exe Iniciado correctamente");
		FlxTimer.loop(0.5, (step) ->
		{
			FlxG.sound.play("assets/sounds/cht.ogg");

			switch (step)
			{
				case 1:
					FlxG.camera.shake(0.0025, 12, true);

					AtkButton.alpha = 1;
					ActButton.alpha = 1;
					CurButton.alpha = 1;
					ShlButton.alpha = 1;

					healthBar.NAME_TXT.alpha = 1;
				case 2:
					healthBar.bg.alpha = 1;
					healthBar.fill.alpha = 1;
					healthBar.HP_TXT.alpha = 1;
				case 3:
					battleBox.resizeBox(100, 100, 0.1);
					battleBox.setAlpha(1);
					healthBar.HP_TXT.alpha = 1;
				case 4:
					player_soul.alpha = 1;
					canMove = true;
					state = "onAttack";

					player_soul.centerInBox(battleBox);

					var introtalk:Array<String> = [
						"Bueno, asi va la cosa\n\nTu eres ese corazon. Y yo intentare matarte!",
						"Si llegase a matarte.\nLo cual seria una pena terrible.\nTu PC sera mia para siempre.",
						"Ah, y si se te ocurre cerrar el juego.\n\nEs simple!",
						"Solo necesito una interraccion manual del usuario para inyectarme en el sistema.",
						"Y si cierras el juego, me harias un GRAN favor.",
						"Basta de charlas. ISRAEL, Terminemos de una vez."
					];

					var retryMessages:Array<String> = [
						"No sirves para esto.",
						"¿Así piensas vencerme?",
						"Patético.",
						"Te estoy dando lástima y ni así puedes.",
						"Solo sabes perder.",
						"¿Eso fue en serio?",
						"Apenas duraste.",
						"¿Y con eso querías impresionarme?",
						"Ridículo.",
						"No aprendes nunca, ¿verdad?",
						"Te estás humillando solo.",
						"Podrías dejar de intentarlo, harías menos el ridículo.",
						"Eres débil, y ya lo sabes.",
						"Te lo advertí. No eres suficiente.",
						"¿Otra vez muerto? Ya es costumbre.",
						"Ni siquiera das pena.",
						"Muere, vuelve, repite. Qué divertido eres.",
						"Hasta tus amigos se habrían rendido ya.",
						"Israel… ¿a eso le llamas luchar?",
						"Solo sirves para perder.",
						"Tu insistencia es molesta.",
						"Solo eres un obstáculo más que borraré.",
						"Esto ya no tiene gracia.",
						"Cae de nuevo, inútil.",
						"Haznos un favor: quédate muerto."
					];

					function introTalking(index:Int, waitTime:Float)
					{
						if (GameData.deads >= 1)
						{
							var randomRetryMsg:String = FlxG.random.getObject(retryMessages);
							EXODEUS_TEXT.alignment = CENTER;
							FlxTimer.wait(1, () -> EXODEUS.EXODEUS_talk(randomRetryMsg, 0.07, EXODEUS_TEXT, function(_)
							{
								FlxTimer.wait(waitTime, function()
								{
									switchToState("onIdle");
									currAttackCreated = false;
									FlxG.sound.playMusic("assets/music/you-cant-hide.ogg", 0.8, true);
								});
							}));
							return;
						};
						switch (index)
						{
							case 0:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(1, 2)));
							case 1:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(2, 2)));
							case 2:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(3, 1)));
							case 3:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(4, 2)));
							case 4:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(5, 1)));
							case 5:
								FlxTimer.wait(waitTime, () -> EXODEUS.EXODEUS_talk(introtalk[index], 0.07, EXODEUS_TEXT, (_) -> introTalking(6, 2)));
							case 6:
								FlxTimer.wait(waitTime, function()
								{
									switchToState("onIdle");
									currAttackCreated = false;
									FlxG.sound.playMusic("assets/music/you-cant-hide.ogg", 0.8, true);
								});
						}
					}
					introTalking(0, 1);
			}
		}, 4);
	}

	public function new(newRetries:Int)
	{
		super();
	}

	override public function create():Void
	{
		super.create();
		WindowStuff.resizeRealGame(720, 740);

		WindowStuff.setFullscreen(false);
		WindowStuff.setFullscreen(false);

		WindowStuff.setBorderless(true);
		WindowStuff.setBorderless(true);

		createSprites();
		damageSound = FlxG.sound.load("assets/sounds/damage.ogg");

		openfl.Lib.current.stage.window.title = "KuakerTale | Modo desarrollador.";
		DiscordShit.updatePresence("En la batalla", "KuakerTale", "Modo desarrollador");

		FlxG.sound.destroy(true);
		// FlxG.sound.playMusic("assets/music/theme.ogg", 1, true);

		// Preparativo para la animacion inicial
		canMove = false;
		state = "onSpawn";
		spawnAnim();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		updateGame();
		updateAttacks(elapsed);
		debugKeys();
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	var lastDamageTime:Float = 0;

	public function addDamage(dmg:Int)
	{
		var currentTime = FlxG.game.ticks;

		if (currentTime - lastDamageTime > 400) // 200ms de cooldown
		{
			FlxG.sound.play("assets/sounds/damage.ogg");
			lastDamageTime = currentTime;
		}

		FlxFlicker.flicker(player_soul, 2, 0.07);
		this.health -= dmg;
	}

	public function get_soul():Soul
	{
		return player_soul;
	}

	/* FUNCIONES MODULARES */
	function debugKeys()
	{
		// PREPARAR EL ATAQUE
		if (FlxG.keys.justPressed.Q)
		{
			var AllAttacks:Array<String> = ["LaserAttack", "RainAttack", "ShokerBreaker"];
			var choice = FlxG.random.getObject(AllAttacks);
			switch (choice)
			{
				case "LaserAttack":
					currAttack = new RainStorm(this, player_soul);
					currAttackCreated = true;
					currAttack.runAttack();
				case "RainAttack":
					currAttack = new LaserShooter(this, player_soul, battleBox);
					currAttackCreated = true;
					currAttack.runAttack();
				case "ShokerBreaker":
					currAttack = new ShokerBreaker(this, player_soul, battleBox);
					currAttackCreated = true;
					currAttack.runAttack();
			}
		}

		// INTERCAMBIAR ENTRE ESTADOS
		if (FlxG.keys.justPressed.O)
		{
			switchToState("onIdle");
			FlxG.stage.window.borderless = true;
			currAttackCreated = false;
		}

		if (FlxG.keys.justPressed.P)
		{
			switchToState("onAttack");
			FlxG.stage.window.borderless = false;
			currAttackCreated = false;
		}

		// RESET GAME
		if (FlxG.keys.justPressed.SEVEN)
		{
			health = -1;
		}
	}

	function updateGame()
	{
		if (state == "onIdle")
		{
			canMove = false;

			switch (buttonsIndex)
			{
				case 1:
					player_soul.x = 48;
				case 2:
					player_soul.x = 233;
				case 3:
					player_soul.x = 418;
				case 4:
					player_soul.x = 596;
			}
			player_soul.y = 643;

			// Moving on hud
			if (FlxG.keys.justPressed.LEFT)
			{
				buttonsIndex--;
				if (buttonsIndex < 1)
					buttonsIndex = 4;

				FlxG.sound.play("assets/sounds/select.ogg", 1, false);
			}
			if (FlxG.keys.justPressed.RIGHT)
			{
				buttonsIndex++;
				if (buttonsIndex > 4)
					buttonsIndex = 1;

				FlxG.sound.play("assets/sounds/select.ogg", 1, false);
			}

			if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
			{
				switch (buttonsIndex)
				{
					case 1:
						FlxG.sound.play("assets/sounds/selected.ogg", 1, false);
						switchToState("onAttack");
					case 2:
						battleBox.spellText("* No puedes usar esto ahora...", 0.02);
					case 3:
						battleBox.spellText("* No tienes curaciones...", 0.02);
					case 4:
						battleBox.spellText("* Te cubres como un bot.\nRecibes menos daño en este ataque!", 0.02);
				}
			}
		}

		if (state == "onAttack")
		{
			if (canMove)
				player_soul.updateMovement(battleBox);
		}

		// General
		if (health >= 0)
		{
			healthBar.HP_TXT.text = health + "/100 HP";
			healthBar.setPercent(health / 100);
		}

		if (health <= 0)
		{
			health = 0;
			canMove = false;

			var deathPosX = player_soul.x + 16;
			var deathPosY = player_soul.y + 16;

			FlxG.sound.destroy(true);
			FlxTimer.wait(0.1, () -> FlxG.switchState(new GameOverState(deathPosX, deathPosY)));
		}
	}

	function updateAttacks(elapsed:Float)
	{
		if (currAttackCreated)
			currAttack.updateAttack(elapsed, player_soul);
	}

	function switchToState(toState:String)
	{
		switch (toState)
		{
			case "onAttack":
				state = "onAttack";
				canMove = false;
				battleBox.setText("");

				FlxTween.tween(player_soul,
					{x: (battleBox.border.x + battleBox.border.width / 2) - 16, y: (battleBox.border.y + battleBox.border.height / 2) - 16}, 0.3, {
						onComplete: function(_)
						{
							canMove = true;
						},
						ease: FlxEase.smootherStepInOut
					});

			case "onIdle":
				FlxTween.tween(EXODEUS, {x: 210}, 1, {ease: FlxEase.elasticInOut});
				EXODEUS_TEXT.text = "";

				battleBox.resizeBox(660, 200, 0.3, true, true);
				canMove = false;
				// battleBox.spellText("* No sabes que pasa...", 0.02);

				buttonsIndex = 1;
				FlxTween.tween(player_soul, {x: 48, y: 643}, 0.3, {
					onComplete: function(_)
					{
						state = "onIdle";
					},
					ease: FlxEase.smootherStepInOut
				});
		}
	}
}
