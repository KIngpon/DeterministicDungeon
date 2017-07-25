package controller 
{
import model.proxy.EnemyProxy;
import model.proxy.PlayerProxy;
import mvc.Command;
import mvc.Notification;
/**
 * ...初始化数据代理
 * @author Kanon
 */
public class ModelCommand extends Command 
{
	override public function execute(notification:Notification):void 
	{
		this.facade.registerProxy(new PlayerProxy());
		this.facade.registerProxy(new EnemyProxy());
	}
}
}