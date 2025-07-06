package objects.ui;

import flixel.sound.FlxSound;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxSprite;

class DialogBox
{
	private var background:FlxSprite;
	private var charIcon:FlxSprite;
	private var text:FlxText;

	private var spellSound:FlxSound = new FlxSound();

	public function new(x:Float = 0, y:Float = 460)
	{
		background = new FlxSprite(x, y, "assets/images/History/hud/DialogBox/box.png");

		charIcon = new FlxSprite(x + 8, y + 8, "assets/images/History/hud/charIcons/mylove.png");

		text = new FlxText(x + 217, y + 20, background.width - 40, "", 24);
		text.setFormat("assets/fonts/8bitoperator.ttf", 24, 0xFFFFFFFF, "left");
	}

	public function addToState(state:FlxState)
	{
		state.add(background);
		state.add(charIcon);
		state.add(text);
	}

	public function setVisible(value:Bool) {
		background.visible = value;
		charIcon.visible = value;
		text.visible = value;
		
	}

	public function setCamera(camera:Array<FlxCamera>):Void
	{
		background.cameras = camera;
		charIcon.cameras = camera;
		text.cameras = camera;
	}

	/* === Metodos === */
	public function setText(newText:String):Void
	{
		text.text = newText;
	}

	public function setCharacterIcon(character:String):Void
	{
		charIcon.loadGraphic("assets/images/History/hud/DialogBox/charIcons/" + character + ".png");
		charIcon.updateHitbox();
	}

	var fullText:String = "";
	var currentIndex:Int = 0;
	var typeDelay:Float = 0.1;
	var typeTimer:Float = 0.0;
	var isTyping:Bool = false;

	var currentCharacter:String;
	var onComplete:Void->Void = null;

	public function spellText(textToSpell:String, ?speed:Float = 0.1, ?character:String, ?onComplete:Void->Void):Void
	{
		/*
			Caracteres especiales:

			$ -> Delay de 1.0 segundos
			% -> Delay de 0.5 segundos
			^ -> Delay de 0.25 segundos
			& -> Delay de 0.1 segundos
		 */

		fullText = textToSpell;
		currentIndex = 0;
		typeDelay = speed;
		typeTimer = 0;
		text.text = "";
		isTyping = true;

		currentCharacter = character != null ? character : "mylove";
		setCharacterIcon(currentCharacter);

		this.onComplete = onComplete;

		if (character == "narrador")
		{
			charIcon.visible = false;
			text.fieldWidth = background.width - 40;
			text.x = background.x + 20;
		}
		else
		{
			charIcon.visible = true;
			text.fieldWidth = background.width - 214 - 16 - 10;
			text.x = background.x + 8 + 204 + 10;
		}
	}

	public function update(elapsed:Float):Void
	{
		if (isTyping)
		{
			typeTimer -= elapsed;

			if (typeTimer <= 0 && currentIndex < fullText.length)
			{
				var char = fullText.charAt(currentIndex);
				currentIndex++;

				switch (char)
				{
					case "$":
						typeTimer = 1.0;
						return;
					case "%":
						typeTimer = 0.5;
						return;
					case "^":
						typeTimer = 0.25;
						return;
					case "&":
						typeTimer = 0.1;
						return;
					default:
						text.text += char;
						typeTimer = typeDelay;

						if (char != " " && char != "\n")
						{
							spellSound.pause();
							spellSound.loadEmbedded("assets/sounds/History/dialog/" + currentCharacter + ".ogg", false, false);
							spellSound.play();
						}
				}

				if (currentIndex >= fullText.length)
				{
					isTyping = false;
					if (onComplete != null)
						onComplete();
				}
			}
		}
	}

	// Del sprite
	public function setPosition(x:Float, y:Float):Void
	{
		background.setPosition(x, y);
		charIcon.setPosition(x + 8, y + 8);
		text.setPosition(x + 217, y + 20);
	}

	public function centerOnScreen(where:String = "X")
	{
		switch (where)
		{
			case "X":
				background.x = FlxG.width / 2 - background.width / 2;
				charIcon.x = background.x + 8;
				text.x = background.x + 217;
			case "Y":
				background.y = FlxG.height / 2 - background.height / 2;
				charIcon.y = background.y + 8;
				text.y = background.y + 20;
			case "XY":
				centerOnScreen("X");
				centerOnScreen("Y");
		}
	}
}
