package controller 
{
import model.proxy.EnemyProxy;
import model.proxy.EquipProxy;
import model.proxy.PlayerProxy;
import model.proxy.ResProxy;
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
		this.facade.registerProxy(new EquipProxy());
		this.facade.registerProxy(new EnemyProxy());
		this.facade.registerProxy(new PlayerProxy());
		this.facade.registerProxy(new ResProxy());
	}
}
}