package screens
{
import core.Notificator;

import starling.display.Button;
import starling.display.Image;
import starling.events.Event;

import theme.ThemeModel;

public class MenuScreen extends BaseScreen
	{
		private var _btnPlay:Button;

		override protected function init():void 
		{
			_bg = new Image(_theme.getTexture("menuScreenBg"));
			_bg.touchable = false;
			addChild(_bg);
		
			_btnPlay = new Button(_theme.getTexture("startBtnBg"));
			_btnPlay.text = "play";
			_btnPlay.fontSize = 35;
			_btnPlay.addEventListener(Event.TRIGGERED, onPlayClick);
			_btnPlay.x = (_stage.stageWidth - _btnPlay.width)/2;
			_btnPlay.y = _stage.stageHeight / 2 + 130;
			addChild(_btnPlay);
		}
		
		private function onPlayClick(e:Event):void 
		{
			_theme.playSound(ThemeModel.SOUND_CLICK);

			Notificator.broadcast(ScreenNavigator.SHOW_SCREEN, ScreenNavigator.GAME_SCREEN_ID);
		}
		
		override public function dispose():void
		{
			_btnPlay.removeEventListener(Event.TRIGGERED, onPlayClick);
			super.dispose();
		}
	}

}