package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.system.Capabilities;
import ScreenNavigator;
import starling.core.Starling;

[SWF(width="1024", height="600", frameRate="60", backgroundColor="0x8080C0")]
public class Main extends Sprite
{
    public function Main():void
    {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    //--------------------------------------------------------------------------
    //
    //  STARLING INITIALIZATION
    //
    //--------------------------------------------------------------------------

    private function init(e:Event = null):void
    {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        var engine:Starling = new Starling(ScreenNavigator, stage);
        engine.showStats = true;
        engine.stage.stageWidth  = stage.stageWidth;
        engine.stage.stageHeight = stage.stageHeight;
        engine.simulateMultitouch  = false;
        engine.enableErrorChecking = Capabilities.isDebugger;
        engine.start();
    }
}

























}