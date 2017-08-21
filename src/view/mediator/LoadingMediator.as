package view.mediator 
{
import config.MsgConstant;
import mvc.Mediator;
import mvc.Notification;
/**
 * ...loading 中介
 * @author ...Kanon
 */
public class LoadingMediator extends Mediator 
{
	public static const NAME:String = "LoadingMediator";
	public function LoadingMediator() 
	{
		this.mediatorName = NAME;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.LOAD_PROGRESS_FIGHT_STAGE);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.LOAD_PROGRESS_FIGHT_STAGE:
				
			break;
			default:
		}
	}
}
}