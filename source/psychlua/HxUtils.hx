package psychlua;

#if HSCRIPT_ALLOWED
import psychlua.HScript;

class HxUtils
{
    public static function callFunction(state:HScript, func:String, code:String, ?args:Array<Dynamic>=null):Dynamic {

        if (hasFunction(code, func))
        {
            if (args == null)
                return state.call(func, []);
            else
                return state.call(func, args);
        }
        else
            return null;
    }

    public static function hasFunction(code:String, func:String)
        return code.contains(func); //lazy...   TODO: MAKE THIS FUNCTION BETTER

    public static function inject(state:HScript, variableName:String, actualVariable:Dynamic)
    {
        state.set(variableName, actualVariable);
    }

    public static function multipleInjections(state:HScript, vars:Array<String>, actVars:Array<Dynamic>)
    {
        if (vars.length != actVars.length)
        {
            trace('Length mismatch! ${vars.length}, ${actVars.length}');
            return;
        }

        var i:Int = 0;

        for (variable in vars)
        {
            inject(state, variable, actVars[i]);
            i ++;
        }
    }
}
#end