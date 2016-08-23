package core {
import flash.utils.Dictionary;

import starling.events.EventDispatcher;

public class Command extends EventDispatcher
{
    private var _vo:Object;
    private var _commandType:String;
    private var _isInitialized:Boolean;
    private var _isPaused:Boolean;
    final public function get vo():Object {return _vo;}
    final public function get commandType():String {return _commandType;}

    public function Command()
    {
        super ();
        if(Object(this).constructor == Command) throw new Error("Command is abstract class!");
    }

    //--------------------------------------------------------------------------
    //
    //  STATIC
    //
    //--------------------------------------------------------------------------

    static private var _commandTypeToCommandClassMap:Dictionary = new Dictionary(true);

    static public function register(commandType:String, command:Class):void
    {
        if(_commandTypeToCommandClassMap[commandType]) throw new Error("This Command type already has Command class mapping!");
        _commandTypeToCommandClassMap[commandType] = command;
    }

    static public function execute(commandType:String, vo:Object=null):void
    {
        var commandClass:Class = _commandTypeToCommandClassMap[commandType];
        if(!commandClass) throw new Error("This Command type has not Command class mapping!");

        var command:Command = Command(new commandClass());
        command.initInternal(commandType, vo);
    }

    //--------------------------------------------------------------------------
    //
    //  INITIALIZATION
    //
    //--------------------------------------------------------------------------

    internal function initInternal(commandType:String, vo:Object=null):void
    {
        if(!_isInitialized)
        {
            _isInitialized = true;
            _commandType = commandType;
            _vo = vo;
            execute();
            dispose();
        }
        else throw new Error("Command already initialized!");
    }

    protected function execute():void
    {
        throw new Error("Method must be override!");
    }

    protected function onComplete():void
    {
        //throw new Error("Method must be override!");
    }

    final protected function pauseCommand():void {
        _isPaused = true;
    }
    final protected function completeCommand():void {
        _isPaused = false;
        dispose();
    }

    //--------------------------------------------------------------------------
    //
    //  DISPOSE
    //
    //--------------------------------------------------------------------------

    private function dispose():void
    {
        if(!_isPaused && _isInitialized)
        {
            onComplete();
            _vo = null;
            _commandType = null;
            _isInitialized = false;
        }
    }
}
}
