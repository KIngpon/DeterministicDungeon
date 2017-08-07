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
	private var deadIcon:Image;
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
		//var frame:Image = new Image("bar/hpBarFrameBg.png");
		var bgLight:Image = new Image("bar/hpBarLight.png");
		var hpIcon:Image = new Image("bar/hpIcon.png");
		var hpIconFrame:Image = new Image("bar/hpIconFrame.png");
		this.barBg = new Image("bar/hpBarBg.png");
		this.barImg = new Image("bar/hpBar.png");
		this.deadIcon = new Image("bar/hpIconDeadIcon.png");
		this.barImg.anchorX = 1;
		//this.addChild(frame);
		this.addChild(this.barBg);
		this.addChild(this.barImg);
		this.addChild(bgLight);
		this.addChild(hpIcon);
		this.addChild(this.deadIcon);
		this.addChild(hpIconFrame);
		//frame.x = -6.5;
		//frame.y = -6;
		hpIcon.y = -7;
		hpIconFrame.x = 58;
		hpIconFrame.y = -10;
		this.deadIcon.x = 61.5;
		this.deadIcon.y = -6.4;
		
		this.barImg.x = this.barImg.width;
		this.width = hpIcon.width;
		this.height = hpIcon.height;
		this.scale(1.5, 1.5);
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