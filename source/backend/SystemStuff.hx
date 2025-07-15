package backend;

import openfl.Lib;
import sys.io.Process;

class SystemStuff {
    public static function popup(title:String, message:String):Void {
        #if windows
        var script = 'Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show("' + message + '", "' + title + '")';
        var p = new Process("powershell", ["-Command", script]);
        p.close();
        #elseif mac
        var script = 'display dialog "' + message + '" with title "' + title + '" buttons {"OK"} default button 1';
        var p = new Process("osascript", ["-e", script]);
        p.close();
        #elseif linux
        var p = new Process("zenity", ["--info", "--title=" + title, "--text=" + message]);
        p.close();
        #else
        trace(title + "\n" + message);
        #end
    }

    public static function notification(title:String, message:String):Void {
        #if windows
        var script = '$app = New-Object -ComObject WScript.Shell; $app.Popup("' + message + '", 0, "' + title + '", 0)';
        var p = new Process("powershell", ["-Command", script]);
        p.close();
        #elseif mac
        var script = 'display notification "' + message + '" with title "' + title + '"';
        var p = new Process("osascript", ["-e", script]);
        p.close();
        #elseif linux
        var p = new Process("notify-send", [title, message]);
        p.close();
        #else
        trace(title + "\n" + message);
        #end
    }

    public static function crash(reallyCrash:Bool = false, showPopUp:Bool = false, title:String = "Title", message:String = "Message"):Void {
        if (reallyCrash) {
            if (showPopUp) popup(title, message);
            Lib.application.window.close();
        }
    }
}
