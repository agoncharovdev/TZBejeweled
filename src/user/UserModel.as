package user {
import core.Notificator;

import interfaces.ILevel;
import interfaces.IUser;

import levels.FirstLevel;

public class UserModel implements IUser
{
    static public const SCORE_UPDATED:String = "SCORE_UPDATED";

    private var _score:int = 0;
    private var _level:ILevel;

    public function get level():ILevel
    {
        if(!_level)
            _level = new FirstLevel();
        return _level;
    }

    public function increaseScore(value:int):void
    {
        _score += value;
        Notificator.broadcast(SCORE_UPDATED);
    }

    public function get score():int
    {
        return _score;
    }
}
}
