package {
import command.ThemeCommand;
import command.UserCommand;

import core.Command;
import core.Model;
import core.Notificator;

import screens.BaseScreen;
import screens.GameScreen;
import screens.MenuScreen;
import screens.ScoreScreen;

import starling.display.Sprite;

import interfaces.ITheme;
import theme.ThemeModel;

import interfaces.IUser;
import user.UserModel;

public class ScreenNavigator extends Sprite
{
	static public const SHOW_SCREEN:String = "SHOW_SCREEN";
	static public const GAME_SCREEN_ID:String = "GAME_SCREEN_ID";
	static public const MENU_SCREEN_ID:String = "MENU_SCREEN_ID";
	static public const SCORE_SCREEN_ID:String = "SCORE_SCREEN_ID";

	private var _activeScreen:BaseScreen;

	public function ScreenNavigator()
	{
		super();

		Model.register(ITheme, ThemeModel);
		Model.register(IUser, UserModel);
		Command.register(ThemeCommand.INIT_ASSETS, ThemeCommand);
		Command.register(UserCommand.INCRESE_SCORE, UserCommand);

		Notificator.subscribe(ThemeModel.THEME_CREATED, onThemeInitHandler);
		Notificator.subscribe(SHOW_SCREEN, showScreenHandler);

		Command.execute(ThemeCommand.INIT_ASSETS);
	}

	private function onThemeInitHandler():void
	{
		showScreenHandler(MENU_SCREEN_ID);
	}

	private function showScreenHandler(screenID:String):void
	{
		if(_activeScreen)
		{
			_activeScreen.disposeScreen();
		}

		switch (screenID)
		{
			case GAME_SCREEN_ID:
				_activeScreen = new GameScreen();
				break;

			case MENU_SCREEN_ID:
				_activeScreen = new MenuScreen();
				break;

			case SCORE_SCREEN_ID:
				_activeScreen = new ScoreScreen();
				break;
		}
		addChild(_activeScreen);
	}
}
}