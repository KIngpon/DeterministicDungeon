package view.mediator 
{
import config.GameConstant;
import config.MsgConstant;
import laya.events.Event;
import laya.utils.Handler;
import model.proxy.PlayerProxy;
import model.proxy.StageProxy;
import mvc.Mediator;
import mvc.Notification;
import view.ui.Layer;
import view.ui.SelectStageLayer;

/**
 * ...选择地形中介
 * @author Kanon
 */
public class SelectStageMediator extends Mediator 
{
	//关卡数据代理
	private var playerProxy:PlayerProxy;
	private var stageProxy:StageProxy;
	private var selectStageLayer:SelectStageLayer;
	public static const NAME:String = "SelectStageMediator";
	private var flashingIsStop:Boolean;
	public function SelectStageMediator() 
	{
		this.mediatorName = NAME;
		this.stageProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
		this.playerProxy = this.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.START_FIGHT);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.START_FIGHT:
				this.initData();
				this.initUI();
				break;
		}
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void 
	{
		this.flashingIsStop = false;
		this.stageProxy.initPointsAry();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		if (!this.selectStageLayer)
		{
			this.selectStageLayer = new SelectStageLayer();
			this.selectStageLayer.selectedBtn.on(Event.CLICK, this, selectedBtnClickHandler);
			this.selectStageLayer.skipBtn.on(Event.CLICK, this, skipBtnClickHandler);
			Layer.GAME_STAGE.addChild(selectStageLayer);
		}
		this.selectStageLayer.resetUI();
		this.selectStageLayer.initStageData(this.stageProxy);
		this.selectStageLayer.start(this.playerProxy.pVo.slotsDelay);
	}
	
	private var aa:Boolean = false;
	private function skipBtnClickHandler():void 
	{
		trace("this.stageProxy.step", this.stageProxy.step);
		if (this.stageProxy.step == 0)
		{
			this.initData();
			this.initUI();
			this.stageProxy.skip();
			if (!aa) this.stageProxy.testPoints();
			aa = true;
			this.selectStageLayer.updateAllPointPassView(this.stageProxy.pointsAry);
			if (!this.stageProxy.checkStagePointValid())
			{
				this.selectStageLayer.stop();
				this.selectStageLayer.updatePointValidView(this.stageProxy.openList);
				this.selectStageLayer.setDes("上天对你的选择不满意,让你重选。");
				this.initData();
			}
			else
			{
				this.selectStageLayer.skip();
			}
		}
		else 
		{
			this.stageProxy.skip();
			this.selectStageLayer.updateAllPointTypeView(this.stageProxy.pointsAry);
			this.selectStageLayer.skip();
		}
	}
	
	private function selectedBtnClickHandler():void 
	{
		if (this.stageProxy.step == 0 && !this.flashingIsStop) 
		{
			if (this.stageProxy.curPointIndex == GameConstant.POINTS_NUM_MAX && 
				!this.stageProxy.checkStagePointValid())
			{
				this.initData();
				this.initUI();
				return;
			}
			this.stageProxy.randomCurPointPass();
			this.selectStageLayer.updatePointView(this.stageProxy.getPointVoByIndex(this.stageProxy.curPointIndex - 1));
		}
		this.flashingIsStop = true;
		this.selectStageLayer.flashing(Handler.create(this, flashingCompleteHandler));
	}
	
	private function flashingCompleteHandler(indexValue:int):void 
	{
		this.flashingIsStop = false;
		var index:int = indexValue - 1;
		if (this.stageProxy.step == 0 && indexValue == GameConstant.POINTS_NUM_MAX) 
		{
			//this.stageProxy.testPoints();
			//this.selectStageLayer.updateAllPointView(this.stageProxy.pointsAry);
			if (!this.stageProxy.checkStagePointValid())
			{
				this.selectStageLayer.stop();
				this.selectStageLayer.updatePointValidView(this.stageProxy.openList);
				this.selectStageLayer.setDes("上天对你的选择不满意,让你重选。");
				return;
			}
		}
		this.selectStageLayer.nextStep();
		this.stageProxy.nextStep(index);
		if (this.selectStageLayer.isLastStep())
		{
			this.selectStageLayer.removeSelf();
			this.selectStageLayer = null;
			this.sendNotification(MsgConstant.SELECT_STAGE_COMPLETE);
		}
	}
	
}
}