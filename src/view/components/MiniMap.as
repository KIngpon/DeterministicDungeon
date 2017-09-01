package view.components 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Image;
import model.vo.PointVo;
import ui.GameStage.MiniMapUI;

/**
 * ...小地图
 * @author Kanon
 */
public class MiniMap extends Sprite 
{
	private var ui:MiniMapUI;
	private var upStage:Image;
	private var downStage:Image;
	private var rewardBox:Image;
	private var bossImg:Image;
	private var bossRewardBox:Image;
	public function MiniMap() 
	{
		this.initUI();
	}
	
	private function initUI():void
	{
		this.ui = new MiniMapUI();
		this.addChild(this.ui);
		
		this.handImg = this.ui.handImg;
		this.skipBtn = this.ui.skipBtn;
		this.upStage = this.ui.upStage;
		this.bossImg = this.ui.bossImg;
		this.bossRewardBox = this.ui.bossRewardBox;

		this.downStage = this.ui.downStage;
		this.rewardBox = this.ui.rewardBox;
		
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
		
		//this.resetUI();
	}
	
	/**
	 * 重置UI
	 */
	public function resetUI():void
	{
		for (var i:int = 1; i <= GameConstant.POINTS_NUM_MAX; i++) 
		{
			var stageIcon:Sprite = this.ui.content.getChildByName("r" + i) as Sprite;
			var bg:Sprite = stageIcon.getChildByName("bg") as Sprite;
			var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
			var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
			var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
			var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
			bg.visible = true;
			leftSpt.visible = true;
			rightSpt.visible = true;
			upSpt.visible = true;
			downSpt.visible = true;
			
			var stageIconSelected:Sprite = this.ui.content.getChildByName("sr" + i) as Sprite;
			var sbg:Sprite = stageIconSelected.getChildByName("bg") as Sprite;
			var sleftSpt:Sprite = stageIconSelected.getChildByName("leftSpt") as Sprite;
			var srightSpt:Sprite = stageIconSelected.getChildByName("rightSpt") as Sprite;
			var supSpt:Sprite = stageIconSelected.getChildByName("upSpt") as Sprite;
			var sdownSpt:Sprite = stageIconSelected.getChildByName("downSpt") as Sprite;
			sbg.visible = false;
			sleftSpt.visible = false;
			srightSpt.visible = false;
			supSpt.visible = false;
			sdownSpt.visible = false;
		}
	}
	
	
	/**
	 * 更新关卡点路径显示
	 * @param	pVo			关卡点数据
	 * @param	isSelected	是否当前占据这个格子
	 */
	public function updatePointView(pVo:PointVo, isSelected:Boolean = false):void
	{
		if (!pVo) return;
		var stageIcon:Sprite = this.ui.content.getChildByName("r" + pVo.index) as Sprite;
		var stageIconSelected:Sprite = this.ui.content.getChildByName("sr" + pVo.index) as Sprite;
		if (!stageIcon) return;
		var bg:Sprite = stageIcon.getChildByName("bg") as Sprite;
		var leftSpt:Sprite = stageIcon.getChildByName("leftSpt") as Sprite;
		var rightSpt:Sprite = stageIcon.getChildByName("rightSpt") as Sprite;
		var upSpt:Sprite = stageIcon.getChildByName("upSpt") as Sprite;
		var downSpt:Sprite = stageIcon.getChildByName("downSpt") as Sprite;
		
		var sbg:Sprite = stageIconSelected.getChildByName("bg") as Sprite;
		var sleftSpt:Sprite = stageIconSelected.getChildByName("leftSpt") as Sprite;
		var srightSpt:Sprite = stageIconSelected.getChildByName("rightSpt") as Sprite;
		var supSpt:Sprite = stageIconSelected.getChildByName("upSpt") as Sprite;
		var sdownSpt:Sprite = stageIconSelected.getChildByName("downSpt") as Sprite;
		
		leftSpt.visible = false;
		rightSpt.visible = false;
		upSpt.visible = false;
		downSpt.visible = false;
		bg.visible = false;
		
		sleftSpt.visible = false;
		srightSpt.visible = false;
		supSpt.visible = false;
		sdownSpt.visible = false;
		sbg.visible = false;
		
		bg.visible = !isSelected;
		sbg.visible = isSelected;

		if (!isSelected)
		{
			upSpt.visible = pVo.up;
			downSpt.visible = pVo.down;
			leftSpt.visible = pVo.left;
			rightSpt.visible = pVo.right;
		}
		else
		{
			supSpt.visible = pVo.up;
			sdownSpt.visible = pVo.down;
			sleftSpt.visible = pVo.left;
			srightSpt.visible = pVo.right;
		}
	}
	
	/**
	 * 更新所有点的显示
	 * @param	pointAry	关卡点数组
	 * @param	curPointVo	当前所在的关卡点
	 */
	public function updateAllPointPassView(pointAry:Array, curPointVo:PointVo=null):void
	{
		if (!pointAry) return;
		var count:int = pointAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = pointAry[i];
			var selected:Boolean = curPointVo && curPointVo.index == pVo.index;
			this.updatePointView(pVo, selected);
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
			var stageIcon:Sprite = this.ui.content.getChildByName("r" + pVo.index) as Sprite;
			
			if (pVo.type == PointVo.UP_FLOOR)
			{
				this.upStage.x = stageIcon.x + stageIcon.width / 2;
				this.upStage.y = stageIcon.y + stageIcon.height / 2;
				this.upStage.visible = true;
			}
			
			if (pVo.type == PointVo.DOWN_FLOOR)
			{
				this.downStage.x = stageIcon.x + stageIcon.width / 2;
				this.downStage.y = stageIcon.y + stageIcon.height / 2;
				this.downStage.visible = true;
			}
			
			if (pVo.type == PointVo.REWARD_BOX)
			{
				this.rewardBox.x = stageIcon.x + stageIcon.width / 2;
				this.rewardBox.y = stageIcon.y + stageIcon.height / 2;
				this.rewardBox.visible = true;
			}
			
			if (pVo.type == PointVo.BOSS_REWARD_BOX)
			{
				this.bossRewardBox.x = stageIcon.x + stageIcon.width / 2;
				this.bossRewardBox.y = stageIcon.y + stageIcon.height / 2;
				this.bossRewardBox.visible = true;
			}
			
			if (pVo.type == PointVo.BOSS)
			{
				this.bossImg.x = stageIcon.x + stageIcon.width / 2;
				this.bossImg.y = stageIcon.y + stageIcon.height / 2;
				this.bossImg.visible = true;
			}
		}
	}
	
	/**
	 * 设置标题
	 * @param	str	内容
	 */
	public function setTitle(str:String):void
	{
		if (!this.ui) return;
		this.ui.stageNumTxt.text = str;
	}
	
	override public function get width():Number{ return this.ui.width; }
	override public function set width(value:Number):void 
	{
		this.ui.width = value;
	}
}
}