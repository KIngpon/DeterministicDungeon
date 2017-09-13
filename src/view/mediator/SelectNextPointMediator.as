package view.mediator 
{
import config.MsgConstant;
import laya.events.Event;
import laya.ui.Image;
import laya.utils.Handler;
import model.po.StagePo;
import model.proxy.StageProxy;
import model.vo.PointVo;
import mvc.Mediator;
import mvc.Notification;
import ui.GameStage.SelectStageLayerUI;
import view.ui.Layer;
import view.ui.SelectNextPointLayer;
/**
 * ...选择下一个关卡点的ui中介
 * @author ...Kanon
 */
public class SelectNextPointMediator extends Mediator 
{
	public static const NAME:String = "SelectNextPointMediator";
	private var selectNextPointLayer:SelectNextPointLayer;
	private var panel:SelectStageLayerUI;
	private var stageProxy:StageProxy;
	//当前关卡点
	private var curPointVo:PointVo;
	private var curStagePo:StagePo;
	//是否已经选择了下一个点
	private var isSelected:Boolean;
	public function SelectNextPointMediator()
	{
		this.mediatorName = NAME;
		this.stageProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.SHOW_SELECT_NEXT_POINT_LAYER);
		vect.push(MsgConstant.SELECT_NEXT_POINT);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.SHOW_SELECT_NEXT_POINT_LAYER:
				this.initData();
				this.createUI();
				break;
			case MsgConstant.SELECT_NEXT_POINT:
				this.removeUI();
				break;
		}
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this.curStagePo = this.stageProxy.getCurStagePo();
		this.curPointVo = this.stageProxy.curPointVo;
		this.isSelected = false;
	}
	
	/**
	 * 创建UI
	 */
	private function createUI():void
	{
		if (!this.selectNextPointLayer)
		{
			this.selectNextPointLayer = new SelectNextPointLayer();
			Layer.GAME_UI.addChild(this.selectNextPointLayer);
		}
		this.panel = this.selectNextPointLayer.panel;
		this.selectNextPointLayer.initPointPass(this.stageProxy.pointsAry);
		this.selectNextPointLayer.initSlotsBg(this.stageProxy.getCurStagePo());
		this.selectNextPointLayer.updateCurPointView(this.stageProxy.curPointVo);
		this.selectNextPointLayer.setDes("点击箭头移动");
		this.selectNextPointLayer.setTitle(this.curStagePo.name + " " + 
										   this.curStagePo.points + "-" + 
										   this.stageProxy.getCurStagePointsCount());
		var upArrow:Image = this.panel.mapSpt.getChildByName("upArrow") as Image;
		var leftArrow:Image = this.panel.mapSpt.getChildByName("leftArrow") as Image;
		var rightArrow:Image = this.panel.mapSpt.getChildByName("rightArrow") as Image;
		var downArrow:Image = this.panel.mapSpt.getChildByName("downArrow") as Image;
		
		if (upArrow) upArrow.on(Event.CLICK, this, upArrowClickHandler);
		if (leftArrow) leftArrow.on(Event.CLICK, this, leftArrowClickHandler);
		if (rightArrow) rightArrow.on(Event.CLICK, this, rightArrowClickHandler);
		if (downArrow) downArrow.on(Event.CLICK, this, downArrowClickHandler);
	}
	
	/**
	 * 删除UI
	 */
	private function removeUI():void
	{
		if (this.selectNextPointLayer)
			this.selectNextPointLayer.removeSelf();
		this.selectNextPointLayer = null;
	}
	
	private function downArrowClickHandler():void 
	{
		if (this.isSelected) return;
		this.stageProxy.curPointVo =
				this.stageProxy.getPointVoByDir(this.curPointVo.index - 1, PointVo.DOWN);
		//保存
		this.stageProxy.savePointData();
		this.stageProxy.isFirstPointVo = false;
		//选中后闪烁几下
		this.selectNextPointLayer.flashing(this.stageProxy.curPointVo.index, 
										   Handler.create(this, flashingCompleteHandler));
		this.isSelected = true;
	}
	
	private function rightArrowClickHandler():void 
	{
		if (this.isSelected) return;
		this.stageProxy.curPointVo =
				this.stageProxy.getPointVoByDir(this.curPointVo.index - 1, PointVo.RIGHT);
		//保存
		this.stageProxy.savePointData();
		this.stageProxy.isFirstPointVo = false;
		this.selectNextPointLayer.flashing(this.stageProxy.curPointVo.index, 
										   Handler.create(this, flashingCompleteHandler));
		this.isSelected = true;
	}
	
	private function leftArrowClickHandler():void 
	{
		if (this.isSelected) return;
		this.stageProxy.curPointVo = 
				this.stageProxy.getPointVoByDir(this.curPointVo.index - 1, PointVo.LEFT);
		//保存
		this.stageProxy.savePointData();
		this.stageProxy.isFirstPointVo = false;
		this.selectNextPointLayer.flashing(this.stageProxy.curPointVo.index, 
										   Handler.create(this, flashingCompleteHandler));
		this.isSelected = true;
	}
	
	private function upArrowClickHandler():void 
	{
		if (this.isSelected) return;
		this.stageProxy.curPointVo =
				this.stageProxy.getPointVoByDir(this.curPointVo.index - 1, PointVo.UP);
		//保存
		this.stageProxy.savePointData();
		this.stageProxy.isFirstPointVo = false;
		this.selectNextPointLayer.flashing(this.stageProxy.curPointVo.index,
										   Handler.create(this, flashingCompleteHandler));
		this.isSelected = true;
	}
	
	private function flashingCompleteHandler():void
	{
		this.sendNotification(MsgConstant.SELECT_NEXT_POINT);
	}
}
}