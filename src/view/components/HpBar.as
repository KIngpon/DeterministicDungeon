package view.components 
{
import laya.display.Sprite;
import laya.ui.Image;
/**
 * ...血条
 * @author ...Kanon
 */
public class HpBar extends Sprite 
{
	//当前血
	private var curHp:int;
	//总血
	private var maxHp:int;
	//百分比
	private var p:Number;
	//血条背景
	private var barImg:Image;
	private var barBg:Image;
	public function HpBar() 
	{
		this.curHp = 0;
		this.maxHp = 1;
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		var frame:Image = new Image("bar/hpBarFrameBg.png");
		var bgLight:Image = new Image("bar/hpBarLight.png");
		this.barBg = new Image("bar/hpBarBg.png");
		this.barImg = new Image("bar/hpBar.png");
		this.barImg.anchorX = 1;
		this.addChild(frame);
		this.addChild(this.barBg);
		this.addChild(this.barImg);
		this.addChild(bgLight);
		frame.x = -6.5;
		frame.y = -6;
		this.barImg.x = this.barImg.width;
		this.width = frame.width;
		this.height = frame.height;
	}
	
	/**
	 * 设置总血
	 * @param	hp	总血
	 */
	public function setMaxHp(hp:int):void
	{
		this.maxHp = hp;
	}
	
	/**
	 * 设置当前血
	 * @param	hp	当前血
	 */
	public function setHp(hp:int):void
	{
		this.curHp = hp;
		this.p = Number(this.curHp) / Number(this.maxHp);
		trace("this.p", this.p);
		this.barImg.scaleX = this.p;
	}
}
}