package view.mediator 
{
import config.MsgConstant;
import mvc.Mediator;
import mvc.Notification;
import view.ui.GameStageLayer;
import view.ui.Layer;

/**
 * ...战斗系统中介
 * @author ...Kanon
 */
public class GameStageMediator extends Mediator 
{
	private var gameStage:GameStageLayer;
	public function GameStageMediator() 
	{
		super();
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
				if (!this.gameStage)
				{
					trace("ininin")
					this.gameStage = new GameStageLayer();
					Layer.GAME_STAGE.addChild(this.gameStage);
				}
			break;
			default:
		}
	}
}
}