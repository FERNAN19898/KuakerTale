package objects.ui;

import modules.TextUtils.typeText;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class FakeTerminal {
	private var thisX:Float;
	private var thisY:Float;
	private var thisCameras:Array<FlxCamera>;
	private var thisState:FlxState;

	private var lines:Array<FlxText>;
	private var username:String;

	public function new(x:Float, y:Float) {
		thisX = x;
		thisY = y;
		lines = [];

		#if sys
		username = Sys.getEnv("USERNAME");
		if (username == null || username == "")
			username = "User";
		#else
		username = "User";
		#end
	}

	public function addToState(state:FlxState):Void {
		thisState = state;
	}

	public function setCameras(cameras:Array<FlxCamera>):Void {
		thisCameras = cameras;
	}

	/**
	 * Simula enviar un comando como en el CMD
	 */
	public function sendCommand(cmd:String, response:String, size:Int = 18, speed:Float = 0.02):Void {
		var prompt = "C:\\Users\\" + username + ">";

		// Mostrar la línea con el comando (ya escrito)
		makeLine(prompt + cmd, FlxColor.LIME, size);

		// Si hay respuesta, escribirla letra por letra
		if (response != null && response != "") {
			var respLine = makeLine("", FlxColor.WHITE, size);
			typeText(respLine, response, speed, "respLine", (_) -> {
				makeLine(prompt, FlxColor.LIME, size);
			});
		} else {
			makeLine(prompt, FlxColor.LIME, size);
		}
	}

	/**
	 * Procesa el texto del usuario como un comando real
	 */
	public function parseCommand(cmd:String, size:Int = 18, speed:Float = 0.02):Void {
		var normalized = cmd.toLowerCase();

		switch (normalized) {
			case "cls":
				clear();

			case "dir":
				var now = Date.now();
				var dirOutput = ' El volumen de la unidad C no tiene etiqueta.\n' +
								' El número de serie del volumen es 1234-ABCD\n\n' +
								' Directorio de C:\\Users\\' + username + '\n\n' +
								"${now.toString().substr(0, 10)}  <DIR>          Desktop\n" +
								"${now.toString().substr(0, 10)}  <DIR>          Documents\n" +
								"${now.toString().substr(0, 10)}  <DIR>          Downloads\n" +
								"${now.toString().substr(0, 10)}  <DIR>          Music\n\n" +
								"               0 archivos              0 bytes\n" +
								"               4 dirs";
				sendCommand(cmd, dirOutput, size, speed);

			case "":
				sendCommand(cmd, "", size, speed);

			default:
				var error = "'" + cmd + "' no se reconoce como un comando interno o externo,\nprograma o archivo por lotes ejecutable.";
				sendCommand(cmd, error, size, speed);
		}
	}

	/**
	 * Crea una línea nueva y la posiciona debajo de las anteriores
	 */
	private function makeLine(text:String, color:FlxColor, size:Int):FlxText {
		var lineY = thisY + (lines.length * (size + 4)); // espaciado estándar
		var newLine = new FlxText(thisX, lineY, 720, text, size);
		newLine.setFormat("assets/fonts/CONSOLA.ttf", size, color, LEFT);
		newLine.cameras = thisCameras;
		thisState.add(newLine);
		lines.push(newLine); // se añade al final
		return newLine;
	}

	/**
	 * Simula el comando cls
	 */
	public function clear():Void {
		for (line in lines)
			line.destroy();
		lines = [];

		makeLine("Microsoft Windows [Versión 10.0.26100.4946]", FlxColor.WHITE, 18);
		makeLine("(c) Microsoft Corporation. Todos los derechos reservados.", FlxColor.WHITE, 18);
		makeLine("", FlxColor.WHITE, 18);
		makeLine("C:\\Users\\" + username + ">", FlxColor.LIME, 18);
	}
}
