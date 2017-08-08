package view.components 
{
import laya.display.Sprite;
import laya.display.Stage;
import laya.display.Text;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Timer;
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
	public var nameTxt:Label;
	private var flashingTimer:Timer;
	private var flashingIndex:int;
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
		this.addChild(this.barBg);
		this.addChild(this.barImg);
		this.addChild(bgLight);
		this.addChild(hpIcon);
		this.addChild(this.deadIcon);
		this.addChild(hpIconFrame);
		hpIconFrame.x = 86;
		hpIconFrame.y = -3;
		this.deadIcon.x = 91.2;
		this.deadIcon.y = 2.5;
		this.deadIcon.visible = false;
		
		this.barImg.x = this.barImg.width;
		this.barImg.y = 10;
		this.barBg.y = 10;
		bgLight.y = 10;
		
		this.width = hpIcon.width;
		this.height = hpIcon.height;
		
		this.nameTxt = new Label();
		this.nameTxt.font = "Microsoft YaHei";
		this.nameTxt.name = "nameLabel";
		this.nameTxt.color = "#FFFFFF";
		this.nameTxt.fontSize = 18;
		this.nameTxt.anchorX = 1;
		this.nameTxt.align = Stage.ALIGN_RIGHT;
		this.nameTxt.width = 240;
		this.nameTxt.x = hpIcon.x + hpIcon.width;
		this.nameTxt.y = hpIconFrame.y + hpIconFrame.height;
		this.addChild(this.nameTxt);
		
		
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
		if (hp <= 0)
		{
			hp = 0;
			this.deadEffectShow();
		}
		this.curHp = hp;
		this.p = Number(this.curHp) / Number(this.maxHp);
		this.barImg.scaleX = this.p;
	}
	
	/**
	 * 死亡效果
	 */
	public function deadEffectShow():void
	{
		if (!this.flashingTimer) this.flashingTimer = new Timer();
		this.flashingTimer.clear(this, flashingLoopHandler);
		this.flashingTimer.loop(80, this, flashingLoopHandler);
	}
	
	/**
	 * 循环
	 */
	private function flashingLoopHandler():void 
	{
		this.deadIcon.visible = !this.deadIcon.visible;
		this.flashingIndex++;
		if (this.flashingIndex >= 10)
		{
			this.flashingIndex = 0;
			this.flashingTimer.clear(this, flashingLoopHandler);
			this.deadIcon.visible = true;
		}
	}
}
}