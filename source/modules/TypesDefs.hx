package modules;

import flixel.util.FlxColor;

typedef DialogLine =
{
	character:String,
	dialog:String,
	typingSpeed:Float
};

typedef BattleChart =
{
	dialog:String, // Dialogo del personaje
	attack:Int, // ID del ataque en ese turno, -1 para uno random
	boxText:String, // Dialogo en el cuadro
}

function hsvToRgb(h:Float, s:Float, v:Float):Int
{
	var c = v * s, x = c * (1 - Math.abs((h / 60) % 2 - 1)), m = v - c;
	var r = 0.0, g = 0.0, b = 0.0;
	if (h < 60)
	{
		r = c;
		g = x;
	}
	else if (h < 120)
	{
		r = x;
		g = c;
	}
	else if (h < 180)
	{
		g = c;
		b = x;
	}
	else if (h < 240)
	{
		g = x;
		b = c;
	}
	else if (h < 300)
	{
		r = x;
		b = c;
	}
	else
	{
		r = c;
		b = x;
	}

	return FlxColor.fromRGB(Math.round((r + m) * 255), Math.round((g + m) * 255), Math.round((b + m) * 255));
}

function cleanDialog(str:String):String
	return str.split("[").join("").split("^").join("").split("&").join("");
