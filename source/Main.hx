package;

import states.battle.TestState;
import states.history.PreBattleState;
import flixel.FlxG;
import flixel.FlxGame;
import lime.app.Application;
import openfl.display.Sprite;
import flixel.system.scaleModes.StageSizeScaleMode;

import states.IntroState;
import modules.WallpaperSetter;

class Game extends FlxGame
{
	override public function new()
	{
		super(0, 0, IntroState, 60, 60, true, false);

		if (Application.current != null)
			Application.current.onExit.add(onApplicationExit);
	}

	private function onApplicationExit(exitCode:Int):Void
		WallpaperSetter.restoreWallpaper();
}

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new Game());

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
		FlxG.scaleMode = new StageSizeScaleMode();
	}
}
