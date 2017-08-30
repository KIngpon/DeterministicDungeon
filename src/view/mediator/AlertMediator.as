package view.mediator 
{
import adobe.utils.CustomActions;
import config.MsgConstant;
import laya.events.Event;
import model.vo.AlertVo;
import mvc.Mediator;
import mvc.Notification;
import ui.GameStage.AlertLayerUI;
import view.ui.Layer;

/**
 * ...alert中介
 * @author Kanon
 */
public class AlertMediator extends Mediator 
{
	public static const NAME:String = "AlertMediator";
	private var alertUI:AlertLayerUI;
	private var aVo:AlertVo;
	public function AlertMediator() 
	{
		this.mediatorName = NAME;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.SHOW_ALERT);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.SHOW_ALERT:
				this.aVo = notification.body as AlertVo;
				this.createUI(this.aVo.content);
			break;
		}
	}

	/**
	 * 创建UI
	 */
	private function createUI(str:String):void
	{
		if (!this.alertUI)
		{
			this.alertUI = new AlertLayerUI();
			Layer.GAME_ALERT.addChild(this.alertUI);
		}
		this.alertUI.contentTxt.text = str;
		this.alertUI.closeBtn.on(Event.CLICK, this, closeBtnClickHandler);
		this.alertUI.okBtn.on(Event.CLICK, this, okBtnClickHandler);
	}
	
	/**
	 * 删除UI
	 */
	private function removeUI():void
	{
		if (this.alertUI) this.alertUI.removeSelf();
		this.alertUI = null;
	}
	
	private function closeBtnClickHandler():void 
	{
		this.removeUI();
		this.sendNotification(MsgConstant.CLOSE_ALERT);
	}
	
	private function okBtnClickHandler():void 
	{
		this.removeUI();
		this.sendNotification(MsgConstant.ALERT_CONFIRM, this.aVo);
	}
}
}