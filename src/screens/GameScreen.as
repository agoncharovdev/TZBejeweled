package screens
{
import core.Notificator;

import screens.gameScreen.Field;
import screens.gameScreen.TimerBar;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

import user.UserModel;

public class GameScreen extends BaseScreen
{
	private var _field:Field;
	private var _btnRestart:Button;
	private var _btnMenu:Button;
	private var _scoreBg:Image;
	private var _scoreBgTxt:TextField;
	private var _timerBar:TimerBar;

	override protected function init():void
	{
		_bg = new Image(_theme.getTexture("gameScreenBg"));
		_bg.touchable = false;
		addChild(_bg);

		_field = new Field(_user.level);
		_field.x = _stage.stageWidth - _field.width - 50;
		_field.y = 70;
		addChild(_field);

		_scoreBg = new Image(_theme.getTexture("scoreBg"));
		_scoreBg.alignPivot();
		_scoreBg.x = 150;
		_scoreBg.y = 100;
		_scoreBg.touchable = false;
		addChild(_scoreBg);

		_scoreBgTxt = new TextField(50, 50, "0");
		_scoreBgTxt.alignPivot();
		_scoreBgTxt.color = 0xffffff;
		_scoreBgTxt.fontSize = 18;
		_scoreBgTxt.x = _scoreBg.x;
		_scoreBgTxt.y = _scoreBg.y - 10;
		_scoreBgTxt.touchable = false;
		_scoreBgTxt.text = "0";
		addChild(_scoreBgTxt);

		var imgButtonsBg:Image = new Image(_theme.getTexture("buttonsBg"));
		imgButtonsBg.alignPivot();
		imgButtonsBg.x = 150;
		imgButtonsBg.y = 450;
		imgButtonsBg.touchable = false;
		addChild(imgButtonsBg);

		_btnRestart = new Button(_theme.getTexture("resetBtnBg"));
		_btnRestart.alignPivot();
		_btnRestart.fontColor = 0xffffff;
		_btnRestart.text = "restartGame";
		_btnRestart.fontSize = 35;
		_btnRestart.addEventListener(Event.TRIGGERED, restartGame);
		_btnRestart.x = imgButtonsBg.x;
		_btnRestart.y = imgButtonsBg.y - 30;
		addChild(_btnRestart);

		_btnMenu = new Button(_theme.getTexture("menuBtnBg"));
		_btnMenu.alignPivot();
		_btnMenu.fontColor = 0xffffff;
		_btnMenu.text = "MENU";
		_btnMenu.x = imgButtonsBg.x;
		_btnMenu.fontSize = 20;
		_btnMenu.addEventListener(Event.TRIGGERED, exitToMenu);
		_btnMenu.y = imgButtonsBg.y + 80;
		addChild(_btnMenu);

		_timerBar = new TimerBar(30, _field.width, 10);
		_timerBar.x = _field.x;
		_timerBar.y = 40;
		addChild(_timerBar);

		// запускаем таймер окончания игры
		_timerBar.addEventListener(TimerBar.TIMER_END, onTimerEnd);
		restartGame();

		Notificator.subscribe(UserModel.SCORE_UPDATED, onScoreUpdated);
	}

	private function onScoreUpdated():void
	{
		_scoreBgTxt.text = String(_user.score);
	}

	private function onTimerEnd(e:Event):void
	{
		Notificator.broadcast(ScreenNavigator.SHOW_SCREEN, ScreenNavigator.SCORE_SCREEN_ID);
	}

	private function exitToMenu(e:Event):void
	{
		Notificator.broadcast(ScreenNavigator.SHOW_SCREEN, ScreenNavigator.MENU_SCREEN_ID);
	}

	private function restartGame(e:Event=null):void
	{
		_field.restart();
		_timerBar.start();

		onScoreUpdated();
	}
}
}