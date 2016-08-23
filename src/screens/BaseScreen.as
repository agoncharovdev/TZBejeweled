package screens
{
import core.Model;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.Event;

import interfaces.ITheme;

import interfaces.IUser;

public class BaseScreen extends Sprite
{
	protected var _bg:Image;
	protected var _stage:Stage;

	protected var _user:IUser;
	protected var _theme:ITheme;

	public function BaseScreen()
	{
		super();
		addEventListener(Event.ADDED, onAddedToParent);

		_stage = Starling.current.stage;
		_user = Model.getModel(IUser) as IUser;
		_theme = Model.getModel(ITheme) as ITheme;
	}

	private function onAddedToParent(e:Event):void
	{
		removeEventListener(Event.ADDED, onAddedToParent);

		animate();
		init();
	}

	protected function animate():void
	{
		alpha = 0;
		var tween:Tween = new Tween(this, 0.5);
		tween.fadeTo(1);
		Starling.juggler.add(tween);
	}

	protected function init():void
	{
		throw new Error("Method need to be implemented!");
	}

	final public function disposeScreen():void
	{
		removeFromParent(true);
	}
}
}