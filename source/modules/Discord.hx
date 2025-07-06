package modules;

#if cpp
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class Main
{
    static var appID:String = "1382939453844361286";
    
	public static function main():Void
	{
		Sys.println('Initializing Discord RPC...');

		final handlers:DiscordEventHandlers = new DiscordEventHandlers();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(appID, cpp.RawPointer.addressOf(handlers), false, null);

        Discord.RunCallbacks();
	}

	private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final username:String = request[0].username;
		final globalName:String = request[0].username;
		final discriminator:Int = Std.parseInt(request[0].discriminator);

		if (discriminator != 0)
			trace('Discord: Connected to user ${username}#${discriminator} ($globalName)');
		else
			trace('Discord: Connected to user @${username} ($globalName)');

	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord: Disconnected ($errorCode:$message)');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Discord: Error ($errorCode:$message)');
	}

    public static function updatePresence(state:String, details:String, largeImageText:String = "KuakerTale", smallImageText:String = "Que miras chismoso?"):Void
    {
        final discordPresence:DiscordRichPresence = new DiscordRichPresence();
        discordPresence.type = DiscordActivityType_Playing;

        discordPresence.largeImageKey = "icon";
        discordPresence.smallImageKey = "icon";

        discordPresence.largeImageText = largeImageText;
        discordPresence.smallImageText = smallImageText;

        discordPresence.state = state;
        discordPresence.details = details;
        discordPresence.startTimestamp = GameData.gameStartedTime; // Unix timestamp in seconds

        Discord.UpdatePresence(cpp.RawConstPointer.addressOf(discordPresence));
    }

    public static function shutDown():Void
    {
        Discord.Shutdown();
        trace('Discord RPC shutdown.');
    }
}
#end