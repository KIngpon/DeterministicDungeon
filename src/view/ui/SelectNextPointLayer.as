package view.ui 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.maths.Point;
import laya.ui.Image;
import model.po.StagePo;
import model.vo.PointVo;
import ui.GameStage.SelectStageLayerUI;

/**
 * ...选择下一关界面
 * @author ...Kanon
 */
public class SelectNextPointLayer extends Sprite 
{
	//UI
	public var panel:SelectStageLayerUI;
	private var upStage:Image;
	private var downStage:Image;
	private var rewardBox:Image;
	private var bossImg:Image;
	private var bossRewardBox:Image;
	public function SelectNextPointLayer() 
	{
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		if (!this.panel)
		{
			this.panel = new SelectStageLayerUI();
			this.addChild(this.panel);
		}
		this.panel.handImg.visible = false;
		this.panel.selectBtn.visible = false;
		this.panel.skipBtn.visible = false;
		this.panel.skipWord.visible = false;
		
		this.upStage = this.panel.upStage;
		this.bossImg = this.panel.bossImg;
		this.bossRewardBox = this.panel.bossRewardBox;
		this.downStage = this.panel.downStage;
		this.rewardBox = this.panel.rewardBox;
		
		this.upStage.visible = false;
		this.bossImg.visible = false;
		this.bossRewardBox.visible = false;
		this.downStage.visible = false;
		this.rewardBox.visible = false;
		
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
			
			upSpt.width = 20;
			upSpt.height = 20;
			
			downSpt.width = 20;
			downSpt.height = 20;
			
			leftSpt.width = 20;
			leftSpt.height = 20;
			
			rightSpt.width = 20;
			rightSpt.height = 20;
			
			selectImg.visible = false;
			goodImg.visible = false;
			badImg.visible = false;
		}
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
	 * 设置标题
	 * @param	str	内容
	 */
	public function setTitle(str:String):void
	{
		if (!this.panel) return;
		this.panel.stageNumTxt.text = str;
	}
	
	/**
	 * 初始化可通过的点
	 * @param	pointAry	点数据数组
	 */
	public function initPointPass(pointAry:Array):void
	{
		if (!pointAry) return;
		var count:int = pointAry.length;
		for (var i:int = 0; i < count; ++i) 
		{
			var pVo:PointVo = pointAry[i];
			this.updatePointView(pVo);
		}
	}
	
	
	/**
	 * 初始化背景图片
	 * @param	stagePo	关卡数据
	 */
	public function initSlotsBg(stagePo:StagePo):void
	{
		if (!stagePo) return;
		var bg:Image = new Image();
		var maskBg:Image = new Image("bg/bgMask.png");
		bg.skin = "stage/" + "stage" + stagePo.level + "/stageSlotsBg.png";
		bg.skin = "stage/" + "stage8" + "/stageSlotsBg.png";
		bg.x = this.panel.bgSpt.width / 2 - bg.width / 2;
		bg.y = this.panel.bgSpt.height / 2 - bg.height / 2;
		this.panel.bgSpt.addChild(bg);
		maskBg.x = (bg.width - this.panel.bgSpt.width) / 2;
		maskBg.y = (bg.height - this.panel.bgSpt.height) / 2;
		bg.mask = maskBg;
	}
	
	/**
	 * 更新关卡点路径显示
	 * @param	pVo	关卡点数据
	 */
	public function updatePointView(pVo:PointVo):void
	{
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
	
	/**
	 * 更新当前关卡点的显示
	 */
	public function updateCurPointView(pVo:PointVo):void
	{
		if (!pVo) return;
		var stageIcon:Sprite = this.panel.mapSpt.getChildByName("r" + pVo.index) as Sprite;
		var selectImg:Image = stageIcon.getChildByName("selectImg") as Image;
		var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
		var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
		var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
		var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
		selectImg.visible = true;
		var arrow:Image;
		if (pVo.up)
		{		
			arrow = new Image("comp/arrow.png");
			arrow.name = "upArrow";
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.x = upSpt.x + upSpt.width / 2 + stageIcon.x;
			arrow.y = upSpt.y + upSpt.height / 2 + stageIcon.y;
			this.panel.mapSpt.addChild(arrow);
		}
		
		if (pVo.left)
		{		
			arrow = new Image("comp/arrow.png");
			arrow.name = "leftArrow";
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.rotation = -90;
			arrow.x = leftSpt.x + leftSpt.width / 2 + stageIcon.x;
			arrow.y = leftSpt.y + leftSpt.height / 2 + stageIcon.y;
			this.panel.mapSpt.addChild(arrow);
		}
		
		if (pVo.right)
		{		
			arrow = new Image("comp/arrow.png");
			arrow.name = "rightArrow";
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.rotation = 90;
			arrow.x = rightSpt.x + rightSpt.width / 2 + stageIcon.x;
			arrow.y = rightSpt.y + rightSpt.height / 2 + stageIcon.y;
			this.panel.mapSpt.addChild(arrow);
		}
		
		if (pVo.down)
		{		
			arrow = new Image("comp/arrow.png");
			arrow.name = "downArrow";
			arrow.pivotX = arrow.width / 2;
			arrow.pivotY = arrow.height / 2;
			arrow.rotation = -180;
			arrow.x = downSpt.x + downSpt.width / 2 + stageIcon.x;
			arrow.y = downSpt.y + downSpt.height / 2 + stageIcon.y;
			
			this.panel.mapSpt.addChild(arrow);
		}
	}
}
}