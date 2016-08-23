package core {
import flash.utils.Dictionary;

final public class Notificator
{
    static private var _eventTypeToListenersMap:Dictionary = new Dictionary(true);

    static public function broadcast(eventType:String, vo:Object=null):void
    {
        var listeners:Vector.<Function> = _eventTypeToListenersMap[eventType];
        if(listeners && listeners.length)
        {
            for(var i:int=listeners.length-1; i>=0; i--)
            {
                if(vo) listeners[i](vo);
                else listeners[i]();
            }
        }
    }

    static public function subscribe(eventType:String, listener:Function):void
    {
        var listeners:Vector.<Function> = _eventTypeToListenersMap[eventType];
        if(!listeners)
        {
            listeners = new <Function>[];
            _eventTypeToListenersMap[eventType] = listeners;
        }

        if(listeners.indexOf(listener) == -1)
            listeners[listeners.length] = listener;
    }

    static public function unsubscribe(eventType:String, listener:Function):void
    {
        var listeners:Vector.<Function> = _eventTypeToListenersMap[eventType] as Vector.<Function>;
        if(!listeners)
            return;

        var index:int = listeners.indexOf(listener);
        if(index != -1)
        {
            listeners.splice(index, 1);
            trace(listeners);
        }
    }
}
}
