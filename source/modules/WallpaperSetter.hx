package modules;

import sys.FileSystem;
import haxe.io.Path;

class WallpaperSetter
{
	public static final OLD_WALLPAPER_PATH:String = "assets/data/secret/bmp/old_wallpaper.bmp";

	// Solo copia el fondo actual (sin scripts)
	public static function getWallpaper():Void
	{
		final userDir = Sys.getEnv("USERPROFILE");
		if (userDir == null) {
			trace("No se pudo obtener USERPROFILE");
			return;
		}

		final source = Path.join([
			userDir,
			"AppData", "Roaming", "Microsoft", "Windows", "Themes", "TranscodedWallpaper"
		]);

		final destFolder = Path.directory(OLD_WALLPAPER_PATH);
		if (!FileSystem.exists(destFolder))
			FileSystem.createDirectory(destFolder);

		try {
			sys.io.File.copy(source, OLD_WALLPAPER_PATH);
			trace("Fondo actual guardado desde: " + source);
		} catch (e) {
			trace("Error al guardar fondo: " + e);
		}
	}

	public static function setWallpaper(imagePath:String):Void
	{
		final absPath = Path.normalize(Sys.getCwd() + "/" + imagePath);
		final scriptPath = Path.normalize(Sys.getCwd() + "/assets/data/secret/scripts/set_wallpaper.ps1");

		runScript(scriptPath, [absPath]);
	}

	public static function restoreWallpaper():Void
	{
		setWallpaper(OLD_WALLPAPER_PATH);
	}

	// Ejecuta cualquier script con argumentos
	public static function runScript(script:String, args:Array<String>):Void
	{
		var cmd = 'powershell -ExecutionPolicy Bypass -File "' + script + '"';
		for (arg in args) cmd += ' "' + arg + '"';

		try {
			final result = Sys.command(cmd);
			trace("Script ejecutado: " + script + " | Código: " + result);
		} catch (e) {
			trace("Error al ejecutar script: " + e);
		}
	}
}
