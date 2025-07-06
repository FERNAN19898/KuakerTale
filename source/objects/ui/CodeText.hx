package objects.ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class CodeText extends FlxGroup
{
    public var code:String;
    public var fontSize:Int;
    public var maxWidth:Float;

    private var tokens:Array<{text:String,color:Int}>;
    private var fullText:String;
    private var charColors:Array<Int>;

    private var currentCharIndex:Int = 0;
    private var typeDelay:Float = 0.05;
    private var typeTimer:Float = 0;
    private var isTyping:Bool = false;

    private var displayedTexts:Array<FlxText>;

    private var startX:Float;
    private var startY:Float;
    private var lineHeight:Float;

    public function new(X:Float, Y:Float, Width:Float, code:String, fontSize:Int = 16)
    {
        super();
        startX = X;
        startY = Y;
        maxWidth = Width;
        this.fontSize = fontSize;
        lineHeight = fontSize + 6;

        this.code = code;

        tokens = [];
        displayedTexts = [];

        parseCode();
        buildColorArrays();
        buildTextObjects();
        startTyping();
    }

    private function parseCode():Void
    {
        tokens = [];
        var regex = ~/(\bimport\b|\bfinal_attack\b|\bwallpaper\b|\bcamera\b|\brun\b|"[^"]*"|\(|\)|\.|:|,)/gi;
        var lastIndex = 0;
        var match;

        while ((match = regex.match(code, lastIndex)) != null)
        {
            var start = match.pos;
            var end = start + match.matchedString.length;

            if (start > lastIndex)
            {
                var before = code.substr(lastIndex, start - lastIndex);
                if (before.length > 0)
                    tokens.push({text: before, color: FlxColor.WHITE});
            }

            var token = match.matchedString;
            var color = detectColor(token);
            tokens.push({text: token, color: color});

            lastIndex = end;
        }

        if (lastIndex < code.length)
        {
            tokens.push({text: code.substr(lastIndex), color: FlxColor.WHITE});
        }
    }

    private function detectColor(token:String):Int
    {
        var tokenLower = token.toLowerCase();
        switch (tokenLower)
        {
            case "import": return FlxColor.parseColor("0xFF569CD6"); // azul
            case "final_attack": return FlxColor.parseColor("0xFF4EC9B0"); // cian claro
            case "wallpaper", "camera": return FlxColor.parseColor("0xFFDCDCAA"); // amarillo pálido
            case "run": return FlxColor.parseColor("0xFFB5CEA8"); // verde claro
            default:
                if (token.startsWith("\"") && token.endsWith("\""))
                    return FlxColor.parseColor("0xFFD69D85"); // naranja cadenas
                if (token == "(" || token == ")" || token == "." || token == ":" || token == ",")
                    return FlxColor.parseColor("0xFFB4B4B4"); // gris claro
        }
        return FlxColor.WHITE;
    }

    private function buildColorArrays():Void
    {
        fullText = "";
        charColors = [];
        for (token in tokens)
        {
            fullText += token.text;
            for (i in 0...token.text.length)
            {
                charColors.push(token.color);
            }
        }
    }

    private function buildTextObjects():Void
    {
        // Limpia textos previos
        for (txt in displayedTexts)
        {
            this.remove(txt, true);
        }
        displayedTexts = [];
    }

    public function startTyping():Void
    {
        currentCharIndex = 0;
        typeTimer = 0;
        isTyping = true;
        redrawText();
    }

    override public function update(elapsed:Float):Void
    {
        if (!isTyping) return;

        typeTimer -= elapsed;
        if (typeTimer <= 0 && currentCharIndex < fullText.length)
        {
            currentCharIndex++;
            typeTimer = typeDelay;
            redrawText();

            if (currentCharIndex >= fullText.length)
            {
                isTyping = false;
            }
        }
    }

    private function redrawText():Void
    {
        buildTextObjects();

        var posX = startX;
        var posY = startY;

        var i = 0;
        while (i < currentCharIndex)
        {
            var currentColor = charColors[i];
            var startI = i;

            while (i < currentCharIndex && charColors[i] == currentColor && fullText.charAt(i) != '\n')
            {
                i++;
            }

            var substr = fullText.substr(startI, i - startI);

            if (substr.length > 0)
            {
                var txt = new FlxText(posX, posY, maxWidth - (posX - startX), substr);
                txt.setFormat(null, fontSize, null, "left");
                txt.color = currentColor;
                txt.scrollFactor.x = 0;
                txt.scrollFactor.y = 0;
                this.add(txt);
                displayedTexts.push(txt);

                posX += txt.width;
                if (posX >= startX + maxWidth)
                {
                    posX = startX;
                    posY += lineHeight;
                }
            }

            // Salto de línea
            if (i < currentCharIndex && fullText.charAt(i) == '\n')
            {
                posX = startX;
                posY += lineHeight;
                i++;
            }
        }
    }

    public function setCode(newCode:String):Void
    {
        code = newCode;
        parseCode();
        buildColorArrays();
        startTyping();
    }

    public function setSpeed(newSpeed:Float):Void
    {
        typeDelay = newSpeed;
    }
}
