package model.proxy 
{
import mvc.Proxy;

/**
 * ...敌人静态数据
 * @author ...Kanon
 */
public class EnemyProxy extends Proxy 
{
	public static const NAME:String = "EnemyProxy";
	public function EnemyProxy() 
	{
		this.proxyName = NAME;
	}
	
	/**
	 * 初始化数据
	 */
	override public function initData():void 
	{
		
	}
}
}