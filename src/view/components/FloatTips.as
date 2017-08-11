package view.components 
{
import view.ui.Layer;
/**
 * ...飘字
 * @author ...Kanon
 */
public class FloatTips 
{
	public static var txtAry:Array = [];
	public function FloatTips() 
	{
		
	}
	
	/**
	 * 显示
	 * @param	str			内容
	 * @param	x			x坐标
	 * @param	y			y坐标
	 * @param	targetY		目标
	 * @param	ease		缓动系数
	 */
	public static function show(str:String, x:Number, y:Number, targetY:Number, ease:Number=.15):void
	{
		var txt:FloatTxt = new FloatTxt();
		txt.x = x;
		txt.y = y;
		txt.setFloatStr(str, targetY, ease);
		Layer.GAME_DAMAGE.addChild(txt);
		txtAry.push(txt);
	}
	
	/**
	 * 帧循环
	 */
	public static function update():void
	{
		for (var i:int = 0; i < txtAry.length; i++) 
		{
			var txt:FloatTxt = txtAry[i];
			txt.update();
		}
		
		for (var i:int = 0; i < txtAry.length; i++) 
		{
			var txt:FloatTxt = txtAry[i];
		}
	}
}
}

import config.GameConstant;
import laya.display.Sprite;
import laya.display.Text;
import laya.utils.Timer;
class FloatTxt extends Sprite
{
	private var ease:Number = .15;
	private var targetY:Number;
	private var flashingTimer:Timer;
	private var flashingIndex:int;
	private var isStop:Boolean;
	/**
	 * 根据文本内容显示文字
	 * @param	str		内容
	 */
	public function setFloatStr(str:String, targetY:Number, ease:Number):void
	{
		var txt:Text = new Text();
		txt.font = GameConstant.GAME_FONT_NAME;
		txt.text = str;
		txt.scale(1.5, 1.5);
		this.targetY = targetY;
		this.ease = ease;
		this.addChild(txt);
		this.flashingIndex = 0;
		this.isStop = false;
		if (!this.flashingTimer) this.flashingTimer = new Timer();
		this.flashingTimer.clear(this, flashingLoopHandler);
		this.flashingTimer.loop(50, this, flashingLoopHandler);
	}
	
	private function flashingLoopHandler():void 
	{
		if (!this.isStop) return;
		this.visible = !this.visible;
		this.flashingIndex++;
		if (this.flashingIndex == 8)
		{
			this.flashingTimer.clear(this, flashingLoopHandler);
			this.removeSelf();
		}
	}
	
	/**
	 * 帧循环
	 */
	public function update():void
	{
		var vy:Number = (this.targetY - this.y) * this.ease;
		this.y += vy;
		var dis:Number = Math.abs(this.y - this.targetY);
		if (dis <= 1) 
		{
			this.y = this.targetY;
			this.isStop = true;
		}
	}
}