package screens.gameScreen
{
import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.animation.Tween;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;

public class TimerBar extends Sprite
{
	static public const TIMER_END:String = "timer_end";

	private var _bar:Quad;
	private var _time:Number;
	private var _timeTxt:TextField;
	private var _barWidth:Number;
	private var _barHeight:Number;

	private var _delay:Number = 1000;
	private var _timer:Timer;
	private var _barTween:Tween;

	public function TimerBar(time:Number, width:int, height:int)
	{
		super();
		_time = time;
		_barWidth = width;
		_barHeight = height;

		init();
	}

	private function init():void
	{
		var scale:Number = Starling.contentScaleFactor;
		var padding:Number = _barHeight * 0.2;
		var cornerRadius:Number = padding * scale * 2;

		var bgShape:Shape = new Shape();
		bgShape.graphics.beginFill(0x0, 0.6);
		bgShape.graphics.drawRoundRect(0, 0, _barWidth*scale, _barHeight*scale, cornerRadius, cornerRadius);
		bgShape.graphics.endFill();

		var bgBitmapData:BitmapData = new BitmapData(_barWidth*scale, _barHeight*scale, true, 0x0);
		bgBitmapData.draw(bgShape);
		var bgTexture:Texture = Texture.fromBitmapData(bgBitmapData, false, false, scale);

		_bar = new Quad(_barWidth - 2*padding, _barHeight - 2*padding, 0xeeeeee);
		_bar.setVertexColor(2, 0xaaaaaa);
		_bar.setVertexColor(3, 0xaaaaaa);
		_bar.x = padding;
		_bar.y = padding;
		_bar.scaleX = 1;
		addChild(_bar);

		_timeTxt = new TextField(50, 30, String(_time), "Verdana", 20, 0xffffff);
		_timeTxt.x = 0;
		_timeTxt.y = - _bar.height - 20;
		addChild(_timeTxt);
	}

	public function start():void
	{
		if (_timer)
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTime);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}

		_timeTxt.text = String(_time);
		_timer = new Timer(_delay, _time);
		_timer.addEventListener(TimerEvent.TIMER, onTime);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		_timer.start();
		scaleX = 1;

		Starling.juggler.removeTweens(_barTween);
		Starling.juggler.remove(_barTween);
		_bar.width = _barWidth;

		_barTween = new Tween(_bar, _time);
		_barTween.animate("width", .01);
		Starling.juggler.add(_barTween);
	}

	private function onTimerComplete(e:TimerEvent):void
	{
		dispatchEventWith(TIMER_END);
	}

	private function onTime(e:TimerEvent):void
	{
		var timePassed:Number = e.target.currentCount;
		var timeToString:String = String(Math.round(_time - timePassed));
		if (timeToString != _timeTxt.text)
			_timeTxt.text = timeToString;
	}
}
}