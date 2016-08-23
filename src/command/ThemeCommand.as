package command {
import core.Command;
import core.Model;

import interfaces.ITheme;

public class ThemeCommand extends Command
{
    static public const INIT_ASSETS:String = "INIT_ASSETS";

    override protected function execute():void
    {
        ITheme(Model.getModel(ITheme)).initAssets();
    }
}
}
