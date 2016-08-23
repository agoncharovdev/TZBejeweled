package screens
{
import core.Notificator;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

import theme.ThemeModel;

public class ScoreScreen extends BaseScreen
{
	private var _scoreTxt:TextField;
	private var _exitBtn:Button;

	override protected function init():void
	{
		_bg = new Image(_theme.getTexture("scoreScreenBg"));
		addChild(_bg);

		_scoreTxt = new TextField(200, 200, "0", "Verdana", 50, 0x0080C0, true);
		_scoreTxt.x = (_stage.stageWidth - _scoreTxt.width)/ 2;
		_scoreTxt.y = _stage.stageHeight / 2 - _scoreTxt.height;
		_scoreTxt.text = "Score: "+String(_user.score);
		addChild(_scoreTxt);

		_exitBtn = new Button(_theme.getTexture("startBtnBg"));
		_exitBtn.text = "exit";
		_exitBtn.fontSize = 35;
		_exitBtn.addEventListener(Event.TRIGGERED, onExitClick);
		_exitBtn.x = (_stage.stageWidth - _exitBtn.width)/2;
		_exitBtn.y = _stage.stageHeight / 2 + 130;
		addChild(_exitBtn);
	}

	private function onExitClick(e:Event):void
	{
		_theme.playSound(ThemeModel.SOUND_CLICK);

		Notificator.broadcast(ScreenNavigator.SHOW_SCREEN, ScreenNavigator.MENU_SCREEN_ID);
	}

	override public function dispose():void
	{
		_exitBtn.removeEventListener(Event.TRIGGERED, onExitClick);
		super.dispose();
	}
}
}