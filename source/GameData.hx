import Date;

class GameData
{
	/* VARIABLES DEL JUEGO IMPORTADAS DESDE GUARDADO */
	public static var muertes:Int;

	/* VARIABLES DEL JUEGO DINAMICAS */
	public static var debugMode:Bool = false;

	/* VARIABLES DEL JUEGO DE UN SOLO USO*/
	public static var gameStartedTime:cpp.Int64;
	public static var discordCreated:Bool = false;

	/* FUNCIONES */
	public static function setdiscordCreated(value:Bool)
	{
		gameStartedTime = Math.floor(Date.now().getTime() / 1000);
		trace("Game started at: " + Date.now().getTime() / 1000 + " seconds since epoch");
		discordCreated = value;
		return discordCreated;
	}
}
