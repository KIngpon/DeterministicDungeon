package view.ui 
{
import laya.display.Sprite;
import laya.ui.Button;
import laya.ui.Image;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Timer;
import laya.utils.Tween;
import ui.GameStage.SelectStageLayerUI;

/**
 * ...选择地图
 * @author ...Kanon
 */
public class SelectStageLayer extends Sprite 
{
	//手
	private var handImg:Image;
	//选择按钮
	public var selectedBtn:Button;
	public var skipBtn:Button;
	private var panel:SelectStageLayerUI;
	private var upStage:Image;
	private var downStage:Image;
	private var rewardBox:Image;
	private var flashingTimer:Timer;
	private var timer:Timer;
	private var curSelectIndex:int;
	private var step:int;
	private var totalNum:int = 9;
	//已选择的数组
	private var selectAry:Array;
	public function SelectStageLayer() 
	{
		this.panel = new SelectStageLayerUI();
		this.addChild(this.panel);
		this.handImg = this.panel.handImg;
		this.selectedBtn = this.panel.selectBtn;
		this.skipBtn = this.panel.skipBtn;
		this.handMoveComplete2();
		this.step = 0;
		this.curSelectIndex = 2;
		this.selectAry = [];
		this.initUI();
		this.start();
	}
	
	private function handMoveComplete1():void
	{
		Tween.to(this.handImg, {y:this.handImg.y + 10}, 250, Ease.linearNone, Handler.create(this, handMoveComplete2));
	}
	
	private function handMoveComplete2():void
	{
		Tween.to(this.handImg, {y:this.handImg.y - 10}, 250, Ease.linearNone, Handler.create(this, handMoveComplete1));
	}
	
	/**
	 * 设置标题
	 * @param	str	内容
	 */
	public function setTitle(str:String):void
	{
		if (!this.panel) return;
		this.panel.stageNumTxt.text = str;
	}
	
	/**
	 * 设置描述
	 * @param	str	内容
	 */
	public function setDes(str:String):void
	{
		if (!this.panel) return;
		this.panel.selectDesTxt.text = str;
	}
	
	/**
	 * 初始化UI
	 */
	public function initUI():void
	{
		this.upStage = this.panel.upStage;

		this.downStage = this.panel.downStage;
		this.rewardBox = this.panel.rewardBox;
		
		this.upStage.pivotX = this.upStage.width / 2;
		this.upStage.pivotY = this.upStage.height / 2;
		
		this.downStage.pivotX = this.downStage.width / 2;
		this.downStage.pivotY = this.downStage.height / 2;
		
		this.rewardBox.pivotX = this.rewardBox.width / 2;
		this.rewardBox.pivotY = this.rewardBox.height / 2;
		
		this.upStage.visible = false;
		this.downStage.visible = false;
		this.rewardBox.visible = false;
		for (var i:int = 1; i <= this.totalNum; i++) 
		{
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + i) as Sprite;
			var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
			var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
			var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
			var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			leftSpt.visible = false;
			rightSpt.visible = false;
			upSpt.visible = false;
			downSpt.visible = false;
			selectImg.visible = false;
		}
	}
	
	public function start():void
	{
		if (!this.timer) this.timer = new Timer();
		this.timer.clear(this, loopHandler);
		this.timer.loop(80, this, loopHandler);
		if (!this.flashingTimer) this.flashingTimer = new Timer();
	}
	
	/**
	 * 更新当前选择框位置
	 */
	private function updateSelectImg():void
	{
		var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + this.curSelectIndex) as Sprite;
		if (!stageIcon) return;
		if (this.step == 0)
		{
			var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
			var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
			var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
			var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			selectImg.visible = true;
			if (this.curSelectIndex <= 3)
			{
				rightSpt.visible = !rightSpt.visible;
				if (this.curSelectIndex < 3) downSpt.visible = !rightSpt.visible;
				if (this.curSelectIndex > 1) upSpt.visible = !rightSpt.visible;
			}
			else if (this.curSelectIndex >= 4 && this.curSelectIndex <= 6)
			{
				
			}
			else
			{
				
			}
		}
		else if (this.step == 1)
		{
			this.upStage.x = stageIcon.x + stageIcon.width / 2;
			this.upStage.y = stageIcon.y + stageIcon.height / 2;
			this.upStage.visible = true;
		}
		else if (this.step == 2)
		{
			this.downStage.x = stageIcon.x + stageIcon.width / 2;
			this.downStage.y = stageIcon.y + stageIcon.height / 2;
			this.downStage.visible = true;
		}
		else if (this.step == 3)
		{
			this.rewardBox.x = stageIcon.x + stageIcon.width / 2;
			this.rewardBox.y = stageIcon.y + stageIcon.height / 2;
			this.rewardBox.visible = true;
		}
	}
	
	/**
	 * 下一步
	 */
	public function nextStep():void
	{
		if (this.step == 0)
		{
			this.resetAllSelectImg();
			if (this.curSelectIndex > this.totalNum)
				this.step++;
			else
				this.curSelectIndex++;
		}
	}
	
	/**
	 * 重置所有选中
	 */
	private function resetAllSelectImg():void
	{
		for (var i:int = 1; i <= this.totalNum; i++) 
		{
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + i) as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			selectImg.visible = false;
		}
	}
	
	private function loopHandler():void 
	{
		if (this.step > 0)
		{
			this.curSelectIndex++;
			if (this.curSelectIndex > this.totalNum) this.curSelectIndex = 1;
		}
		this.updateSelectImg();
	}
}
}