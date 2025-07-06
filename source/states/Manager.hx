package states;

// Flixel
import openfl.ui.Mouse;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxState;
// Own
import GameData;
import modules.WindowUtils;
import modules.WallpaperSetter;
/* === DISCORD RPC === */
import modules.Discord.Main as DiscordShit;

class Manager extends FlxState
{
	override public function create():Void
	{
		super.create();
		WindowUtils.init(Lib.application.window);

		// Discord Presence
		if (GameData.discordCreated == false)
		{
			WallpaperSetter.getWallpaper();
			GameData.setdiscordCreated(true);
			DiscordShit.main();
			DiscordShit.updatePresence("", "");
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		WindowUtils.update(elapsed);

		/* Activar el modo debug con F12 */
		if (FlxG.keys.justPressed.F12 && !GameData.debugMode)
		{
			GameData.debugMode = true;
			trace("Modo debug activado");
		}

		if (GameData.debugMode)
		{
			/* BINDS PARA EL MODO DEBUG */
		}
	}

	override public function destroy():Void
	{
		super.destroy();
	}
}
