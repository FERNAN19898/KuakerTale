package states.battle;

import flixel.FlxG;
import flixel.util.FlxColor;
import objects.ui.FakeTerminal;
import states.Manager;

class TestState extends Manager
{
    var fakeTerminal:FakeTerminal;

    override public function create()
    {
        super.create();

        // Crear y configurar el terminal
        fakeTerminal = new FakeTerminal(10, 10);
        fakeTerminal.addToState(this);
        fakeTerminal.setCameras([FlxG.camera]);

        fakeTerminal.clear(); // Mostrar texto inicial del CMD
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ONE)
        {
            fakeTerminal.parseCommand("ver");
        }

        if (FlxG.keys.justPressed.TWO)
        {
            fakeTerminal.parseCommand("echo hola mundo");
        }

        if (FlxG.keys.justPressed.THREE)
        {
            fakeTerminal.parseCommand("run EXODEUS");
        }

        if (FlxG.keys.justPressed.C)
        {
            fakeTerminal.parseCommand("cls"); // más fiel al CMD
        }
    }
}
