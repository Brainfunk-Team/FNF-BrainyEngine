package states;

import backend.MusicBeatState;
import psychlua.HScript;

import backend.Mods;

class HScriptState extends MusicBeatState
{
    var stateFile:String; //state file under modsfolder/states
    var state:HScript;

    public function callFunction(func:String, ?args:Array<Dynamic>=null):Dynamic {
        if (args == null)
            return state.call(func, []);
        else
            return state.call(func, args);
    }

    override public function new(stateFile)
    {
        this.stateFile = stateFile;

        var directories:Array<String> = Mods.directoriesWithFile("", "states/" + stateFile, true);

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