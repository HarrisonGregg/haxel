
package haxel;

import flash.Lib;
import haxe.EnumFlags;
import haxe.Timer;

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
//                                                                          //
//   Because of the nature of this project, please PLEASE test any change   //
//   on HTML5, Flash, AND native. Any changes made for compatibility or     //
//   optimization ABSOLUTELY NEED to be fully documented: reasons, effects  //
//   and changes made. -Aaron                                               //
//                                                                          //
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//

class Time
{
    public static var framerate:Float = 60;
    public static var maxElapsed = 0.0333;
    public static var maxFrameSkip = 5;
    public static var tickRate = 4;

    public static var callbackFunction:Float->Void;
    public static var postCallbackFunction:Int->Void;


    private static var delta = 0;
    private static var rate(get,null):Float;
    private static var get_rate():Float
    {
        return 1000 / framerate;
    }
    private static var skip(get,null):Float;
    {
        skip = rate * (maxFrameSkip + 1);
    }
    private static var last:Float;
    private static var timer:Timer;

    public static function init()
    {
        last = Lib.getTimer();
        timer = new Timer(tickRate);
        timer.run = onTimer;
    }

    private function onTimer()
    {
        var time = Lib.getTimer();
        delta += (time - last);
        last = time;

        if (delta < rate) return;
        if (delta > skip) delta = skip;

        var framesCalled = 0;

        while (delta >= rate)
        {
            if(callbackFunction != null)
            {
                var time = delta
                if(time > rate)
                {
                    time = rate;
                }
                callbackFunction(time);
            }
            delta -= rate;
            framesCalled += 1;
        }

        if(postCallbackFunction != null)
        {
            postCallbackFunction(framesCalled);
        }
    }
}