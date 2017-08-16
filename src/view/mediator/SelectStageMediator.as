package view.mediator 
{
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
	public static const NAME:String = "SelectStageMediator"
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
			this.selectStageLayer.selectedBtn.on(Event.CLICK, this, selectedStageBtnClickHandler);
			Layer.GAME_STAGE.addChild(selectStageLayer);
		}
		this.selectStageLayer.initStageData(this.stageProxy);
		this.selectStageLayer.start(this.playerProxy.pVo.slotsDelay);
	}
	
	private function selectedStageBtnClickHandler():void 
	{
		if (this.stageProxy.step == 0) 
		{
			this.stageProxy.randomCurPointPass();
			this.selectStageLayer.updatePathView(this.stageProxy.getPointVoByIndex(this.stageProxy.curPointIndex - 1));
		}
		this.selectStageLayer.flashing(Handler.create(this, flashingCompleteHandler));
	}
	
	private function flashingCompleteHandler(indexValue:int):void 
	{
		var index:int = indexValue - 1;
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