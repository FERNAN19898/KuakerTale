package modules;

import flixel.util.FlxTimer;
import lime.system.Display;
import lime.ui.Window;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import openfl.Lib;
import sys.io.Process;
import sys.FileSystem;

class WindowUtils
{
	static var shaking:Bool = false;
	static var shakeIntensity:Float = 0.1;
	static var baseX:Int = 0;
	static var baseY:Int = 0;

	public static var window:Window;
	public static var screen:Display;
	public static var screenWidth:Int;
	public static var screenHeight:Int;

	static var baseWindowX:Int;
	static var baseWindowY:Int;

	public static function init(win:Window)
	{
		window = win;
		screen = window.display;
		screenWidth = screen.currentMode.width;
		screenHeight = screen.currentMode.height;

		baseWindowX = window.x;
		baseWindowY = window.y;

		baseX = window.x;
		baseY = window.y;
	}

	/* === ESCALAS / REDIMENSIONADO === */
	public static function resizeRealGame(width:Int, height:Int, centerToScreen:Bool = true):Void
	{
		FlxG.resizeGame(width, height);
		FlxG.resizeWindow(width, height);

		FlxG.game.width = width;
		FlxG.game.height = height;
		FlxG.stage.window.width = width;
		FlxG.stage.window.height = height;
		FlxG.stage.nativeWindow.width = width;
		FlxG.stage.nativeWindow.height = height;
		FlxG.game.scaleX = 1;
		FlxG.game.scaleY = 1;

		FlxG.scaleMode.horizontalAlign = LEFT;
		FlxG.scaleMode.verticalAlign = TOP;

		if (centerToScreen)
		{
			var x = Std.int((screenWidth - width) / 2);
			var y = Std.int((screenHeight - height) / 2);
			moveWindow(x, y);
		}
	}

	public static function setFullScreen(?value:Bool = true, ?animated = false)
	{
		if (animated)
		{
			if (value)
			{
				setBorderless(true);

				var w = screen.currentMode.width;
				var h = screen.currentMode.height;

				tweenWindow(0, 0, 0.3);
				FlxTween.tween(FlxG.game.stage.window, {width: w, height: h}, 0.15, {
					onComplete: function(_)
					{
						FlxG.game.stage.window.fullscreen = true;
					}
				});
			}
			else
			{
				FlxG.game.stage.window.fullscreen = false;
				FlxTimer.wait(0.1, function()
				{
					setBorderless(false);
					resizeRealGame(720, 720);
					moveWindowToCenter();
				});
			}
		}
		else
		{
			FlxG.game.stage.window.fullscreen = value;
		}
	}

	/* === Minimizado y Maximisado / visibilidad === */
	public static function minimizeGameWindow():Void
		runScript("minimize.ps1");

	public static function maximizeGameWindow():Void
		runScript("restore.ps1");

	public static function setWindowVisible(?value:Bool = true):Void
		Lib.current.stage.window.visible = value;

	public static function hideAllWindows(?includeGame:Bool = false):Void
	{
		new Process("powershell", ["-Command", "(New-Object -ComObject Shell.Application).MinimizeAll()"]);
		if (!includeGame)
		{
			maximizeGameWindow();
		}
	}

	/* === APARIENCIA | BORDES | MOUSE === */
	public static function setBorderless(?value:Bool = true):Void
		FlxG.game.stage.window.borderless = value;

	public static function setWindowTittle(?tittle:String = "KuakerTale")
		FlxG.game.stage.window.title = tittle;

	public static function setMouseVisible(value:Bool)
		FlxG.mouse.visible = value;

	/* === MOVIMIENTO DE LA VENTANA === */
	public static function moveWindow(x:Int, y:Int)
	{
		baseX = x;
		baseY = y;
		FlxG.game.stage.window.x = x;
		FlxG.game.stage.window.y = y;
	}

	public static function moveWindowToCenter(?animated:Bool = false, ?duration:Float = 0.1):Void
	{
		var screenWidth = FlxG.stage.window.display.currentMode.width;
		var screenHeight = FlxG.stage.window.display.currentMode.height;
		var windowWidth = FlxG.game.stage.window.width;
		var windowHeight = FlxG.game.stage.window.height;

		var x = Math.floor((screenWidth - windowWidth) / 2);
		var y = Math.floor((screenHeight - windowHeight) / 2);

		if (animated)
			tweenWindow(x, y, duration);
		else
			moveWindow(x, y);
	}

	public static function tweenWindow(targetX:Int, targetY:Int, duration:Float = 0.1, easing:Dynamic = null)
	{
		var tweenData = {x: baseX, y: baseY};

		FlxTween.tween(tweenData, {x: targetX, y: targetY}, duration, {
			ease: easing,
			onUpdate: function(_)
			{
				moveWindow(Std.int(tweenData.x), Std.int(tweenData.y));
			},
			onComplete: function(_)
			{
				moveWindow(targetX, targetY);
			}
		});
	}

	public static function shakeWindow(intensity:Float = 1, ?duration:Float)
	{
		shakeIntensity = intensity;
		shaking = true;
		baseX = FlxG.game.stage.window.x;
		baseY = FlxG.game.stage.window.y;

		if (duration != null)
		{
			FlxTimer.wait(duration, function()
			{
				stopShakeWindow();
			});
		}
	}

	public static function stopShakeWindow()
	{
		shaking = false;
		FlxG.game.stage.window.x = baseX;
		FlxG.game.stage.window.y = baseY;
	}

	/* === UPDATE Y DEMAS FUNCIONES === */
	public static function update(elapsed:Float)
	{
		var stageWindow = FlxG.game.stage.window;

		if (shaking)
		{
			var offsetX = Std.int(Math.random() * shakeIntensity - shakeIntensity / 2);
			var offsetY = Std.int(Math.random() * shakeIntensity - shakeIntensity / 2);

			stageWindow.x = baseX + offsetX;
			stageWindow.y = baseY + offsetY;
		}
		else if (playingInfinite)
		{
			infiniteT += elapsed * infiniteSpeed;

			var offsetX = Math.sin(infiniteT) * infiniteAmplitude;
			var offsetY = Math.sin(infiniteT) * Math.cos(infiniteT) * infiniteAmplitude;

			var centerX = Std.int((stageWindow.display.currentMode.width - stageWindow.width) / 2);
			var centerY = Std.int((stageWindow.display.currentMode.height - stageWindow.height) / 2);

			moveWindow(centerX + Std.int(offsetX), centerY + Std.int(offsetY));
		}
		else
		{
			// No animaciones: simplemente actualiza baseX/baseY por si el usuario mueve la ventana
			baseX = stageWindow.x;
			baseY = stageWindow.y;
		}
	}

	private static function runScript(fileName:String):Void
	{
		var path = "assets/data/secret/scripts/" + fileName;

		if (!FileSystem.exists(path))
		{
			trace("Script not found: " + path);
			return;
		}

		try
		{
			var process = new Process("powershell", ["-ExecutionPolicy", "Bypass", "-File", path]);
			process.close();
		}
		catch (e:Dynamic)
		{
			trace("Error ejecutando script: " + e);
		}
	}

	/* === Animación infinita (forma de 8) === */
	static var infiniteT:Float = 0;
	static var playingInfinite:Bool = false;
	static var infiniteAmplitude:Int = 120;
	static var infiniteSpeed:Int = 5;

	public static function playInfinite(move:Bool = true, speed:Int = 1, ?amplitude:Int = 120):Void
	{
		infiniteAmplitude = amplitude;
		infiniteSpeed = speed;

		playingInfinite = move;
		if (!move)
			infiniteT = 0;
	}
}
