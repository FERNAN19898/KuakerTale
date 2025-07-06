package objects.ui;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class BattleBox extends FlxSprite
{
	public var border:FlxSprite;
	public var inner:FlxSprite;
	public var text:FlxText;

	var boxWidth:Int;
	var boxHeight:Int;
	var boxBorder:Int;

	var fullText:String = "";
	var textIndex:Int = 0;
	var spellTimer:Float = 0;
	var spellSpeed:Float = 0.05;
	var isSpelling:Bool = false;

	public function new(x:Float, y:Float, boxWidth:Int = 660, boxHeight:Int = 200, boxBorder:Int = 8)
	{
		super(x, y);
		this.visible = false;

		this.boxWidth = boxWidth;
		this.boxHeight = boxHeight;
		this.boxBorder = boxBorder;

		// Crear borde
		border = new FlxSprite(x, y);
		border.makeGraphic(boxWidth, boxHeight, FlxColor.WHITE);

		// Crear interior
		var innerWidth = boxWidth - boxBorder * 2;
		var innerHeight = boxHeight - boxBorder * 2;
		inner = new FlxSprite(x + boxBorder, y + boxBorder);
		inner.makeGraphic(innerWidth, innerHeight, FlxColor.BLACK);

		// Crear texto
		text = new FlxText(inner.x + 15, inner.y + 10, "", this.boxWidth - 15);
		text.setFormat("assets/fonts/8bitoperator.ttf",28, FlxColor.WHITE, LEFT);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		syncInner(); // Siempre sigue al borde

		if (isSpelling)
		{
			spellTimer += elapsed;
			if (spellTimer >= spellSpeed)
			{
				spellTimer = 0;
				textIndex++;
				if (textIndex <= fullText.length)
				{
					text.text = fullText.substr(0, textIndex);
					FlxG.sound.play("assets/sounds/box_text.ogg");
				}
				else
				{
					isSpelling = false;
				}
			}
		}
	}

	// Agrega ambos sprites a un estado
	public function addToState(state:flixel.FlxState):Void
	{
		state.add(border);
		state.add(inner);
		state.add(text);
	}

	public function resizeBox(newWidth:Int, newHeight:Int, duration:Float, autoX:Bool = true, autoY:Bool = true):Void
	{
		var newX:Float = 720 - newWidth;
		var newY:Float = 740 - newHeight;

		var startW = boxWidth;
		var startH = boxHeight;
		var deltaW = newWidth - startW;
		var deltaH = newHeight - startH;

		if (autoX)
			newX = (FlxG.width / 2) - (newWidth / 2);

		if (autoY)
			newY = FlxG.height - 175 - newHeight;

		moveTo(newX, newY, duration);

		FlxTween.num(0, 1, duration, function(value:Float)
		{
			var currentW = Std.int(startW + deltaW * value);
			var currentH = Std.int(startH + deltaH * value);

			boxWidth = currentW;
			boxHeight = currentH;

			border.makeGraphic(boxWidth, boxHeight, FlxColor.WHITE);
			inner.makeGraphic(boxWidth - boxBorder * 2, boxHeight - boxBorder * 2, FlxColor.BLACK);
		});
	}

	// Centrar la caja en pantalla
	public function centerX():Void
	{
		border.screenCenter(X);
	}

	public function centerY():Void
	{
		border.screenCenter(Y);
	}

	// Mover la caja con tween
	public function moveTo(newX:Float, newY:Float, duration:Float):Void
	{
		FlxTween.tween(border, {x: newX, y: newY}, duration);
	}

	// Opacidad
	public function setAlpha(newAlpha:Float)
	{
		border.alpha = newAlpha;
		inner.alpha = newAlpha;
	}

	// Asegura que el interior siempre esté correctamente alineado con el borde
	private function syncInner():Void
	{
		inner.x = border.x + boxBorder;
		inner.y = border.y + boxBorder;
		
		text.x = inner.x + 15;
		text.y = inner.y + 10;
	}

	// Funciones para el texto
	public function setText(newText:String)
	{
		text.text = newText;
		isSpelling = false;
	}

	public function spellText(newText:String, typingSpeed:Float = 0.05):Void
	{
		fullText = newText;
		textIndex = 0;
		spellTimer = 0;
		spellSpeed = typingSpeed;
		isSpelling = true;
		text.text = "";
	}
}
