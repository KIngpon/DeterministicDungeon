package utils 
{
import config.GameConstant;
import model.po.EnemyPo;
import model.proxy.EnemyProxy;
import mvc.Facade;
/**
 * ...游戏内的一些快捷工具类
 * @author Kanon
 */
public class GameUtils 
{
	

	/**
	 * 根据敌人的id获取敌人icon地址
	 * @param	id	敌人id
	 * @return	icon地址
	 */
	public static function getEnemyIconById(id:int):String
	{
		var eProxy:EnemyProxy = Facade.getInstance().retrieveProxy(EnemyProxy.NAME) as EnemyProxy;
		var ePo:EnemyPo = eProxy.getEnemyPoById(id);
		if (!ePo) return "";
		return GameConstant.ENEMY_ICON + ePo.icon + ".png";
	}
}
}