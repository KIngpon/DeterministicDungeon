package model.proxy 
{
import mvc.Proxy;

/**
 * ...玩家静态数据
 * @author ...Kanon
 */
public class PlayerProxy extends Proxy 
{
	public static const NAME:String = "PlayerProxy";
	public function PlayerProxy() 
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