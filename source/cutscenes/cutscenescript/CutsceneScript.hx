package cutscenes.cutscenescript;

import states.PlayState;

class CutsceneScript {
    //for now i'll just use this file to think of syntax for this language
    
    //playAnimation(char,animationName)
    //runHaxeCode(code)
    //camera(x,y)
    //getProperty(property)
    //setProperty(property, value)

    public function runCode(string:String)
    {
        var lines:Array<String> = string.split("\n");

        var lineNumber:Int = 1;

        for (line in lines) {
            if (line.startsWith("playAnimation")) {
                var lineCorrect:Bool = correctLine(line, "playAnimation", lineNumber);

                if (lineCorrect)
                {
                    var args:Array<Dynamic> = parseLine(line, "playAnimation", lineNumber);

                    //TODO: ADD SUPPORT FOR ANY LUA SPRITE
                    
                    switch (args[0])
                    {
                        case "dad":
                            PlayState.instance.dad.playAnim(args[1]);
                        
                        case "gf":
                            PlayState.instance.gf.playAnim(args[1]);
                        
                        default:
                            PlayState.instance.dad.playAnim(args[1]);
                    }
                }
                else
                    return;
            }
        lineNumber += 1;
        }
    }

    function errorMessage(message:String, lineNumber:Int)
    {
        trace('ERROR: $message, line $lineNumber');
    }

    function getFirstChar(string:String):String
    {
        return string.substring(0, 0);
    }

    function correctLine(line:String, functionName:String, lineNumber:Int):Bool
    {
        var curLine:String = line.replace(functionName, "");
            if (curLine.startsWith("(")) {
                return true;
            }
            else
            {
                errorMessage("Expected (, got " + getFirstChar(curLine), lineNumber);
                return false;
            }
    }

    function parseLine(line:String, functionName:String, lineNumber:Int):Array<Dynamic>
    {
        var curLine:String = line.replace(functionName + "(", "");
        curLine = line.replace(functionName + ")", "");
        var args:Array<String> = curLine.split(",");
        var dynamicArgs:Array<Dynamic> = new Array();

        var i:Int = 0;

        for (arg in args) {
            args[i] = args[i].trim();

            dynamicArgs.push(Std.parseFloat(args[i]));
            if (!Math.isNaN(dynamicArgs[i]))
            {
                dynamicArgs.pop();
                dynamicArgs.push(args[i]);
            }

            i ++;
        }

        return dynamicArgs;
    }
}