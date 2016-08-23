package command {
import core.Command;
import core.Model;

import interfaces.IUser;

public class UserCommand extends Command
{
    static public const INCRESE_SCORE:String = "UserCommand.INCRESE_SCORE";

    private var _user:IUser;

    override protected function execute():void
    {
        _user = Model.getModel(IUser) as IUser;

        switch (commandType)
        {
            case INCRESE_SCORE:
                _user.increaseScore(int(vo));
                break;
        }
    }
}
}
