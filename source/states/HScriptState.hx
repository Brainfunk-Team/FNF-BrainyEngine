package states;

import backend.MusicBeatState;
import psychlua.HScript;

import backend.Mods;

import sys.io.File;
class HScriptState extends MusicBeatState
{
    var stateFile:String; //state file under modsfolder/states
    var state:HScript;
    var code:String;

    public function hasFunction(func:String)
        return code.contains(func); //lazy...   TODO: MAKE THIS FUNCTION BETTER

    public function callFunction(func:String, ?args:Array<Dynamic>=null):Dynamic {

        if hasFunction(func) //this just prevents those annoying errors in the console
        {
            if (args == null)
                return state.call(func, []);
            else
                return state.call(func, args);
        }
        else
            return null; //bozo tried to run a non existing function lol
    }

    override public function new(stateFile)
    {
        this.stateFile = stateFile;

        var directories:Array<String> = Mods.directoriesWithFile("", "states/" + stateFile, true);

        code = File.getContent(directories[0]);

        state = new HScript(null, directories[0], null, false);
        state.set("state", this);

        super();
    }

    override function create()
    {
        super.create();
        callFunction("onCreate");
        //create logic here
        callFunction("onCreatePost");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        callFunction("onUpdate", [elapsed]);
        //update logic here
        callFunction("onUpdatePost", [elapsed]);
    }
}