package backend;
import openfl.Lib;

class SystemStuff {
    //For now this stuff just uses trace()

	public static function popup(title, message):Void
	{
		trace(title + "\n" + message);
	}

	public static function notification(title, message):Void
	{
		trace(title + "\n" + message);
	}

    public static function crash(reallyCrash:Bool = false, showPopUp:Bool = false, title:String = "Title", message:String = "Message") {
        if (reallyCrash) {
            if (showPopUp) popup(title, message);
            Lib.application.window.close();
        }
    }
}