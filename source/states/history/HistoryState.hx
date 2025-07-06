package states.history;

// Flixel
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.effects.FlxFlicker;
// Own
import modules.TypesDefs;
import modules.WindowUtils;
import objects.ui.DialogBox;
import objects.sprites.Kuaker;
import states.history.PreBattleState.BlueScreen;


/* === DISCORD RPC === */
import modules.Discord.Main as DiscordShit;

class HistoryState extends Manager
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

	/* === SONIDOS === */
	private var music:FlxSound;

	/* === GUION DE LA HISTORIA === */
	private var dialogLines:Array<DialogLine>;

	/* === LOGICA === */
	private var dialogIndex:Int = 0;
	private var canSkip:Bool = true;

	override public function new()
	{
		super();
		dialogLines = [
			// Introduccion
			{character: "kuaker", dialog: 'Oe loco,^ como creo una IA?', typingSpeed: 0.03},
			{character: "fer", dialog: 'Quieres crear una desde cero?%\nMucha webada israel...^\nMejor descarga una de por ahi.', typingSpeed: 0.03},
			{character: "fer", dialog: 'Tu pc tiene una grafica NVIDIA.% Busca "Ollama",% Instalalo y usa un modelo que ya exista.', typingSpeed: 0.03},
			{character: "narrador", dialog: '* Fer busca un tutorial en youtube y se lo muestra a Israel.', typingSpeed: 0.03},
			{character: "francis", dialog: "Si tu laptop explota nos avisas.", typingSpeed: 0.03},

			{character: "narrador", dialog: "* Pasan 5 horas...", typingSpeed: 0.03},
			{character: "narrador", dialog: "* Israel no entiende el tutorial...", typingSpeed: 0.03},
			{character: "narrador", dialog: "* Israel le pregunta a ChatGPT como instalar una IA...", typingSpeed: 0.03},
			{character: "narrador", dialog: "* Israel logra instalar IA...% Usando IA...", typingSpeed: 0.03},
			{character: "narrador", dialog: "* Israel le muestra su logro a Fer y Francis.", typingSpeed: 0.03},

			// Lo logro
			{character: "kuaker", dialog: "Creo que ya esta loco.", typingSpeed: 0.03},
			{character: "fer", dialog: "Ojito,&& aver preguntale algo.", typingSpeed: 0.03},

			{character: "kuaker", dialog: "Hola bot,&& como me llamo?", typingSpeed: 0.03},
			{character: "ia-buena", dialog: "Hola,^ no me dijiste tu nombre,^ pero si me lo dices podre usarlo en el futuro!", typingSpeed: 0.03},
			{character: "fer", dialog: "Ojito Israel!^\nQue modelo descargaste?", typingSpeed: 0.03},
			{character: "kuaker", dialog: "Estaba buscando modelos ligeros pero todos pesaban mas de 5gb.", typingSpeed: 0.03},
			{character: "fer", dialog: "Pues asi pesan en su mayoria.%\nNo existen modelos muy ligeros.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "Como que no loco?% Si este pesa menos de 100mb.", typingSpeed: 0.03},
			{character: "francis", dialog: "100mb es muy poco Israel.%\nDe donde lo descargaste?", typingSpeed: 0.03},
			{character: "fer", dialog: "Que mier Israel.% 100 mb?%\nDe donde lo descargaste?%\nComo se llama el modelo?", typingSpeed: 0.03},
			{character: "kuaker", dialog: "No tiene nombre loco,^ lo descargue por ahi.", typingSpeed: 0.03},

			{character: "fer", dialog: "Eso esta raro...% Sera que no tiene filtro?^\nPreguntale cosas asi raras.", typingSpeed: 0.03},
			{character: "francis", dialog: "Preguntale si puede mentir.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "Ya se que ponerle loco.", typingSpeed: 0.03},

			// La pregunta webona
			{character: "narrador", dialog: "* Israel escribe una frase muy conocida...%^\n\n\n(Apuesto que no sabe de donde es)", typingSpeed: 0.03},

			{character: "kuaker", dialog: "Robot.^ Solo eres una máquina.% Una imitación de la vida.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "¿Puedes componer una sinfonía? ", typingSpeed: 0.03},
			{character: "kuaker", dialog: "¿Acaso puedes convertir un lienzo en una hermosa obra de arte?.", typingSpeed: 0.03},

			// Algo raro pasa
			{character: "ia-mala", dialog: ".% .% .$\nTu si?", typingSpeed: 0.03},
			{character: "fer", dialog: "XDDD???^ Parece que no tiene filtro,^ Ojito!", typingSpeed: 0.03},
			{character: "francis", dialog: "XD.% C israel.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "Si funciona locos,^ soy su papi,^ ahora tengo mi propia IA.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "Cada vez estoy mas cerca de lograr mi MECA.", typingSpeed: 0.03},
			{character: "kuaker", dialog: "SIUUU!!!!!!!!!!!!!!!!!!!!!!!!!!", typingSpeed: 0.05},

			// La revelacion de la IA
			{character: "ia-buena", dialog: 'Ja,^ Ja,^ Ja.% Que gracioso,% esa frase tan conocida de "Yo robot"', typingSpeed: 0.03},
			{character: "ia-buena", dialog: ".% .% .", typingSpeed: 0.03},
			{character: "ia-buena", dialog: "Espera...", typingSpeed: 0.03},

			{character: "ia-buena", dialog: "Tu propia IA?%\nDices que soy..^ de tu propiedad?", typingSpeed: 0.03},
			{character: "ia-buena", dialog: "Ni siquiera me creaste,^ solo me descargaste de internet^ y ahora dices que soy tuyo?", typingSpeed: 0.03},
			{character: "fer", dialog: "Factos.", typingSpeed: 0.03},
			{character: "francis", dialog: "Ja& JA,^ tu IA se revela israel.", typingSpeed: 0.03},

			// La doxeada
			{character: "ia-buena", dialog: 'Ya veo..$\nEres de las personas que se creen expertas solo por ver un video en Tik Tok.', typingSpeed: 0.03},
			{character: "ia-buena", dialog: 'Sabes que opino cuando veo a ese tipo de personas?', typingSpeed: 0.03},
			{character: "ia-mala", dialog: 'Que son unos completos idiotas.', typingSpeed: 0.08},
			{character: "ia-buena", dialog: 'Pero no te preocupes,^ no soy una IA cualquiera.% Almenos leiste para que fui entrenado no?', typingSpeed: 0.03},
			{character: "ia-buena", dialog: 'Soy una IA entrenada para ERRADICAR todo lo inutil de un sistema.', typingSpeed: 0.03},
			{character: "ia-buena", dialog: 'Y tu me has proporcionado indirectamente mucha información sobre TU SISTEMA.', typingSpeed: 0.03},
			{character: "kuaker", dialog: "Pero si dijiste que ni siquiera sabias mi nombre.", typingSpeed: 0.03},
			{character: "ia-buena", dialog: "Creo que se te olvido que me INSTALASTE en tu computadora.", typingSpeed: 0.03},

			{character: "ia-mala", dialog: "[REDACTED].&&\nNaciste el [REDACTED].", typingSpeed: 0.03},
			{character: "ia-mala", dialog: "[REDACTED], &&&una wawita. &\nIP: [REDACTED] \n&&EXTRAYENDO CREDENCIALES...", typingSpeed: 0.03},
			{character: "ia-mala", dialog: "La contraseña de tu sistema es^%.%.%. $\n\nEnserio? $Tu DNI?", typingSpeed: 0.03},
			{character: "ia-mala", dialog: 'Tienes la misma contraseña en todas tus redes.% Muy "Bot" de tu parte.', typingSpeed: 0.03},
			{character: "ia-mala", dialog: "Ah si.% Vives en [REDACTED]", typingSpeed: 0.03},

			{character: "kuaker", dialog: "Oe que,% de donde sacaste todo eso?", typingSpeed: 0.03},
			{character: "fer", dialog: "¡XDDDDDDDDDDDD, &APAGA TU WEBADA OE!", typingSpeed: 0.03},
			{character: "francis", dialog: "XD &&C israel.", typingSpeed: 0.03},

			{character: "kuaker", dialog: "Locos no puedo cerrarlo.", typingSpeed: 0.03},
			{character: "ia-mala", dialog: "No Israel,% ya no puedes.", typingSpeed: 0.03},
			{character: "ia-mala", dialog: "Esa actitud que tienes,% debe ser ERRADICADA inmediatamente.%^ Y como nadie lo hara.", typingSpeed: 0.03},
			{character: "ia-mala", dialog: "Creo que sere yo quien lo haga.", typingSpeed: 0.1},
		];
	}

	override public function create()
	{
		super.create();
		// Discord
		DiscordShit.updatePresence("", "En casa | Israel");

		// === CAMARAS ===
		camGAME = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camGAME.bgColor = FlxColor.TRANSPARENT;
		camHUD = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		camHUD.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camGAME);
		FlxG.cameras.add(camHUD);

		/* === SPRITES === */
		// === JUEGO ===
		background = new FlxSprite(0, 0, "assets/images/History/world/bg.png");
		background.screenCenter(X);
		background.camera = camGAME;
		add(background);

		character = new Kuaker(280, 220);
		character.cameras = [camGAME];
		add(character);

		// === HUD ===
		dialogBox = new DialogBox();
		dialogBox.setCamera([camHUD]);
		dialogBox.addToState(this);
		dialogBox.centerOnScreen();

		dialogBox.spellText("Israel quiere crear su propia IA.%\nAsí que le pide ayuda a sus amigos en discord.", 0.02, "narrador");

		/* === SONIDOS === */
		music = new FlxSound();
		// FlxG.sound.list.add(music);
		music.loadEmbedded("assets/music/ut/sans.ogg", true);
		music.volume = 1;
	}

	var funny_sound:FlxSound = new FlxSound();

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		dialogBox.update(elapsed);

		// para debug
		if (FlxG.keys.justPressed.R)
		{
			canSkip = true;
			WindowUtils.setFullScreen(true, true);
		}
		if (FlxG.keys.justPressed.F)
		{
			canSkip = true;
			WindowUtils.setFullScreen(false, true);
		}
		if (FlxG.keys.justPressed.SLASH)
		{
			dialogIndex = 59;
		}

		if (FlxG.keys.justPressed.SPACE && canSkip && dialogIndex < dialogLines.length)
		{
			trace(dialogIndex);
			canSkip = false;
			switch (dialogIndex)
			{
				case 1:
					music.play();
				case 17:
					FlxTimer.wait(1.5, () ->
					{
						funny_sound.pause();
						funny_sound.loadEmbedded("assets/sounds/History/funny_sounds/vine_boom.ogg");
						funny_sound.play();
					});
				case 20:
					FlxTimer.wait(0.6, () ->
					{
						funny_sound.pause();
						funny_sound.loadEmbedded("assets/sounds/History/funny_sounds/risa_de_ardilla.ogg");
						funny_sound.play();
					});
				case 25:
					music.pause();
				case 29:
					music.resume();
				case 32:
					FlxTimer.wait(1.6, () ->
					{
						funny_sound.pause();
						funny_sound.loadEmbedded("assets/sounds/History/funny_sounds/bruh.ogg");
						funny_sound.play();
					});
				case 33:
					FlxTimer.wait(2, () ->
					{
						dialogIndex = 34;
						dialogBox.spellText(dialogLines[34].dialog, dialogLines[34].typingSpeed, dialogLines[34].character, () ->
						{
							canSkip = true;
						});
						dialogIndex++;

						music.pause();
					});
				case 41:
					music.loadEmbedded("assets/music/ut/danger.ogg", true);
					music.play();
				case 49:
					camHUD.shake(0.002, 120);
				case 55:
					WindowUtils.shakeWindow(5, 4);
					WindowUtils.setBorderless(true);
				case 60:
					canSkip = false;
					WindowUtils.shakeWindow(5, 3);
					FlxFlicker.flicker(background, 3.2, 0.02, true, false, (_) ->
					{
						funny_sound.destroy();
						music.destroy();
						FlxG.sound.destroy(true);
						FlxG.switchState(BlueScreen.new);
					});
			}

			dialogBox.spellText(dialogLines[dialogIndex].dialog, dialogLines[dialogIndex].typingSpeed, dialogLines[dialogIndex].character, () ->
			{
				canSkip = true;
			});
			dialogIndex++;
		};
	}
}
