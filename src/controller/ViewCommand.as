package controller 
{
import mvc.Command;
import mvc.Notification;
import view.mediator.GameStageMediator;
/**
 * ...视图command
 * @author Kanon
 */
public class ViewCommand extends Command 
{
	override public function execute(notification:Notification):void 
	{
		this.facade.registerMediator(new GameStageMediator());
	}
}
}