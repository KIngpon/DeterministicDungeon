package view.ui 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Button;
import laya.ui.Image;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Timer;
import laya.utils.Tween;
import model.po.StagePo;
import model.proxy.StageProxy;
import model.vo.PointVo;
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
	private var bossImg:Image;
	private var bossRewardBox:Image;
	private var flashingTimer:Timer;
	private var timer:Timer;
	private var curSelectIndex:int;
	private var curSelectValue:int;
	private var step:int;
	//总步数
	private var maxStep:int;
	//已选择的数组
	private var numAry:Array;
	//当前关卡点
	private var isBossPoints:Boolean;
	private var isFirstPoints:Boolean;
	private var flashingIndex:int;
	private var isStop:Boolean;
	//回调
	private var flashingCallBackHandler:Handler;
	public function SelectStageLayer() 
	{
		this.panel = new SelectStageLayerUI();
		this.addChild(this.panel);
		this.initUI();
	}
	
	/**
	 * 初始化关卡数据
	 */
	public function initStageData(sProxy:StageProxy):void
	{
		this.isBossPoints = sProxy.isBossPoint();
		this.isFirstPoints = sProxy.isFirstPoint();
		if (this.isBossPoints) this.maxStep = 4;
		else if (this.isFirstPoints) this.maxStep = 3;
		else this.maxStep = 2;
		this.initData();
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this.step = 0;
		this.flashingIndex = 0;
		this.curSelectIndex = 0;
		this.curSelectValue = 1;
		this.isStop = true;
		this.numAry = [1, 2, 3, 4, 5, 6, 7, 8, 9];
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
		this.selectedBtn = this.panel.selectBtn;
		this.handImg = this.panel.handImg;
		this.skipBtn = this.panel.skipBtn;
		this.upStage = this.panel.upStage;
		this.bossImg = this.panel.bossImg;
		this.bossRewardBox = this.panel.bossRewardBox;

		this.downStage = this.panel.downStage;
		this.rewardBox = this.panel.rewardBox;
		
		this.upStage.pivotX = this.upStage.width / 2;
		this.upStage.pivotY = this.upStage.height / 2;
		
		this.downStage.pivotX = this.downStage.width / 2;
		this.downStage.pivotY = this.downStage.height / 2;
		
		this.rewardBox.pivotX = this.rewardBox.width / 2;
		this.rewardBox.pivotY = this.rewardBox.height / 2;
		
		this.bossImg.pivotX = this.bossImg.width / 2;
		this.bossImg.pivotY = this.bossImg.height / 2;
		
		this.bossRewardBox.pivotX = this.bossRewardBox.width / 2;
		this.bossRewardBox.pivotY = this.bossRewardBox.height / 2;
		
		this.upStage.visible = false;
		this.downStage.visible = false;
		this.rewardBox.visible = false;
		this.bossImg.visible = false;
		this.bossRewardBox.visible = false;
		this.handMoveComplete2();
	}
	
	/**
	 * 初始化背景图片
	 * @param	stagePo	关卡数据
	 */
	public function initSlotsBg(stagePo:StagePo):void
	{
		if (!stagePo) return;
		var bg:Image = new Image();
		bg.skin = "stage/" + "stage" + stagePo.level + "/stageSlotsBg.png";
		bg.skin = "stage/" + "stage2" + "/stageSlotsBg.png";
		bg.x = this.panel.bgSpt.width / 2 - bg.width / 2;
		bg.y = this.panel.bgSpt.height / 2 - bg.height / 2;
		this.panel.bgSpt.addChild(bg);
		var maskBg:Image = new Image("bg/bgMask.png");
		maskBg.x = (bg.width - this.panel.bgSpt.width) / 2;
		maskBg.y = (bg.height - this.panel.bgSpt.height) / 2;
		bg.mask = maskBg;
	}
	
	/**
	 * 重置UI
	 */
	public function resetUI():void
	{
		for (var i:int = 1; i <= GameConstant.POINTS_NUM_MAX; i++) 
		{
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + i) as Sprite;
			var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
			var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
			var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
			var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			var goodImg:Image = stageIcon.getChildByName("goodImg") as Image;
			var badImg:Image = stageIcon.getChildByName("badImg") as Image;
			leftSpt.visible = false;
			rightSpt.visible = false;
			upSpt.visible = false;
			downSpt.visible = false;
			selectImg.visible = false;
			goodImg.visible = false;
			badImg.visible = false;
		}
		this.setDes("选择房间通道。");
	}
	
	/**
	 * 开启
	 * @param	delay	间隔
	 */
	public function start(delay:int):void
	{
		if (!this.timer) this.timer = new Timer();
		this.timer.clear(this, loopHandler);
		this.timer.loop(delay, this, loopHandler);
		if (!this.flashingTimer) this.flashingTimer = new Timer();
	}
	
	/**
	 * 停止
	 */
	public function stop():void
	{
		this.timer.clear(this, loopHandler);
		this.flashingTimer.clear(this, flashingLoopHandler);
	}
	
	/**
	 * 更新当前选择框位置
	 */
	private function updateSelectImg():void
	{
		var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + this.curSelectValue) as Sprite;
		if (!stageIcon) return;
		var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
		selectImg.visible = false;
		if (this.step == 0)
		{
			//选择路径
			var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
			var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
			var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
			var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
			this.upStage.visible = false;
			this.downStage.visible = false;
			this.rewardBox.visible = false;
			this.bossImg.visible = false;
			this.bossRewardBox.visible = false;
			selectImg.visible = true;
			if (this.curSelectValue <= 3)
			{
				rightSpt.visible = !rightSpt.visible;
				if (this.curSelectValue < 3) downSpt.visible = !rightSpt.visible;
				if (this.curSelectValue > 1) upSpt.visible = !rightSpt.visible;
			}
			else if (this.curSelectValue >= 4 && this.curSelectValue <= 6)
			{
				rightSpt.visible = !rightSpt.visible;
				leftSpt.visible = !rightSpt.visible;
				if (this.curSelectValue < 6) downSpt.visible = !rightSpt.visible;
				if (this.curSelectValue > 4) upSpt.visible = !leftSpt.visible;
			}
			else
			{
				leftSpt.visible = !leftSpt.visible;
				if (this.curSelectValue < 9) downSpt.visible = !leftSpt.visible;
				if (this.curSelectValue > 7) upSpt.visible = !leftSpt.visible;
			}
		}
		else if (this.step == 1)
		{
			//选择上层楼梯
			this.upStage.x = stageIcon.x + selectImg.width / 2;
			this.upStage.y = stageIcon.y + selectImg.height / 2;
			this.upStage.visible = true;
			this.setDes("选择上层楼梯。");
		}
		else if (this.step == 2)
		{
			//选择下层楼梯
			this.downStage.x = stageIcon.x + selectImg.width / 2;
			this.downStage.y = stageIcon.y + selectImg.height / 2;
			this.downStage.visible = true;
			this.setDes("选择下层楼梯。");

		}
		else if (this.step == 3)
		{
			//选择奖励宝箱位置
			if (this.isBossPoints)
			{
				this.bossRewardBox.x = stageIcon.x + selectImg.width / 2;
				this.bossRewardBox.y = stageIcon.y + selectImg.height / 2;
				this.bossRewardBox.visible = true;
			}
			else if(this.isFirstPoints)
			{
				this.rewardBox.x = stageIcon.x + selectImg.width / 2;
				this.rewardBox.y = stageIcon.y + selectImg.height / 2;
				this.rewardBox.visible = true;
			}
			this.setDes("选择宝箱房间。");
		}
		else if (this.step == 4)
		{
			if (this.isBossPoints)
			{
				this.bossImg.x = stageIcon.x + selectImg.width / 2;
				this.bossImg.y = stageIcon.y + selectImg.height / 2;
				this.bossImg.visible = true;
			}
			this.setDes("选择boss房间。");
		}
	}
	
	/**
	 * 闪烁
	 * @param	handler
	 */
	public function flashing(handler:Handler = null):void
	{
		if (!this.isStop) return;
		if (this.step <= this.maxStep)
		{
			this.flashingTimer.clear(this, flashingLoopHandler);
			this.flashingTimer.loop(40, this, flashingLoopHandler);
			this.isStop = false;
			this.flashingCallBackHandler = handler;
		}
		else
		{
			handler.run();
		}
	}
	
	public function skip():void
	{
		if (this.step == 0)
			this.step++;
		else
			this.step = this.maxStep + 1;
	}
	
	/**
	 * 下一步
	 */
	public function nextStep():void
	{
		trace("ui step", this.step);
		if (this.step == 0)
		{
			this.resetAllSelectImg();
			trace("this.curSelectValue", this.curSelectValue);
			//全部格子选择完 下一步
			if (this.curSelectValue >= GameConstant.POINTS_NUM_MAX)
				this.step++;
			else
				this.curSelectValue++; //下一个格子
		}
		else if (this.step <= this.maxStep)
		{
			this.curSelectValue = 0;
			this.numAry.splice(this.curSelectIndex, 1);
			this.curSelectIndex = 0;
			this.curSelectValue = this.numAry[this.curSelectIndex];
			this.step++;
		}
		else
		{
			this.setDes("关卡完成！点击进入。");
			this.step++;
			//this.initData();
			//this.downStage.visible = false;
			//this.rewardBox.visible = false;
		}
	}
	
	/**
	 * 更新关卡点路径显示
	 * @param	pVo	关卡点数据
	 */
	public function updatePointView(pVo:PointVo):void
	{
		//trace("pVo.index", pVo.index);
		if (this.step > 0) return;
		if (!pVo) return;
		var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + pVo.index) as Sprite;
		if (!stageIcon) return;
		var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
		var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
		var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
		var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
		var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
		selectImg.visible = false;
		upSpt.visible = pVo.up;
		downSpt.visible = pVo.down;
		leftSpt.visible = pVo.left;
		rightSpt.visible = pVo.right;	
	}
	
	/**
	 * 更新所有点的显示
	 * @param	pointAry	点数组
	 */
	public function updateAllPointPassView(pointAry:Array):void
	{
		if (!pointAry) return;
		var count:int = pointAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = pointAry[i];
			this.updatePointView(pVo);
		}
	}
	
	/**
	 * 更新所有点的类型显示
	 * @param	pointsAry	点数组
	 */
	public function updateAllPointTypeView(pointAry:Array):void 
	{
		if (!pointAry) return;
		var count:int = pointAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = pointAry[i];
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + pVo.index) as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			
			trace("pVo.index", pVo.index);
			trace("pVo.type", pVo.type);
			
			if (pVo.type == PointVo.UP_FLOOR)
			{
				this.upStage.x = stageIcon.x + selectImg.width / 2;
				this.upStage.y = stageIcon.y + selectImg.height / 2;
				this.upStage.visible = true;
			}
			
			if (pVo.type == PointVo.DOWN_FLOOR)
			{
				this.downStage.x = stageIcon.x + selectImg.width / 2;
				this.downStage.y = stageIcon.y + selectImg.height / 2;
				this.downStage.visible = true;
			}
			
			if (pVo.type == PointVo.REWARD_BOX)
			{
				this.rewardBox.x = stageIcon.x + selectImg.width / 2;
				this.rewardBox.y = stageIcon.y + selectImg.height / 2;
				this.rewardBox.visible = true;
			}
			
			if (pVo.type == PointVo.BOSS_REWARD_BOX)
			{
				this.bossRewardBox.x = stageIcon.x + selectImg.width / 2;
				this.bossRewardBox.y = stageIcon.y + selectImg.height / 2;
				this.bossRewardBox.visible = true;
			}
			
			if (pVo.type == PointVo.BOSS)
			{
				this.bossImg.x = stageIcon.x + selectImg.width / 2;
				this.bossImg.y = stageIcon.y + selectImg.height / 2;
				this.bossImg.visible = true;
			}
		}
	}
	
	/**
	 * 显示关卡点是否违反规则的状态
	 * @param	pointAry	可行的关卡点数组
	 */
	public function updatePointValidView(openList:Array):void
	{
		if (!openList) return;
		this.resetAllSelectImg();
		for (var i:int = 1; i <= GameConstant.POINTS_NUM_MAX; i++) 
		{
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + i) as Sprite;
			var badImg:Image = stageIcon.getChildByName("badImg") as Image;
			badImg.visible = true;
		}
		
		var count:int = openList.length;
		for (i = 0; i < count; i++)
		{
			var pVo:PointVo = openList[i];
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + pVo.index) as Sprite;
			var goodImg:Image = stageIcon.getChildByName("goodImg") as Image;
			var badImg:Image = stageIcon.getChildByName("badImg") as Image;
			goodImg.visible = true;
			badImg.visible = !goodImg.visible;
		}
	}
	
	/**
	 * 是否是最后一步
	 * @return
	 */
	public function isLastStep():Boolean
	{
		return this.step > this.maxStep + 1;
	}

	private function flashingLoopHandler():void 
	{
		var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + this.curSelectValue) as Sprite;
		if (!stageIcon) return;
		var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
		selectImg.visible = !selectImg.visible;
		this.flashingIndex++;
		if (this.flashingIndex >= 10)
		{
			this.isStop = true;
			this.flashingIndex = 0;
			this.flashingTimer.clear(this, flashingLoopHandler);
			if(this.flashingCallBackHandler)
				this.flashingCallBackHandler.runWith(this.curSelectValue);
		}
	}
	
	/**
	 * 重置所有选中
	 */
	public function resetAllSelectImg():void
	{
		for (var i:int = 1; i <= GameConstant.POINTS_NUM_MAX; i++) 
		{
			var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + i) as Sprite;
			var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
			selectImg.visible = false;
		}
	}
	
	/**
	 * 帧循环
	 */
	private function loopHandler():void 
	{
		if (!this.isStop) return;
		if (this.step > 0)
		{
			this.curSelectIndex++;
			if (this.curSelectIndex > this.numAry.length - 1) 
				this.curSelectIndex = 0;
			this.curSelectValue = this.numAry[this.curSelectIndex];
		}
		this.updateSelectImg();
	}
}
}