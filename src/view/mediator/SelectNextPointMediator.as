package view.mediator 
{
import config.MsgConstant;
import model.proxy.StageProxy;
import mvc.Mediator;
import mvc.Notification;
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
	private var stageProxy:StageProxy;
	public function SelectNextPointMediator()
	{
		this.mediatorName = NAME;
		this.stageProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.SHOW_SELECT_NEXT_POINT_LAYER);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.SHOW_SELECT_NEXT_POINT_LAYER:
				this.createUI();
			break;
		}
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
		this.selectNextPointLayer.initPointPass(this.stageProxy.pointsAry);
		this.selectNextPointLayer.initSlotsBg(this.stageProxy.getCurStagePo());
		this.selectNextPointLayer.updateCurPointView(this.stageProxy.curPointVo);
	}
}
}