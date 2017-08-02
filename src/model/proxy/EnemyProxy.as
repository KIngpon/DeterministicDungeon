package model.proxy 
{
import laya.net.Loader;
import laya.utils.Dictionary;
import laya.utils.Handler;
import model.vo.EnemyPo;
import mvc.Proxy;

/**
 * ...敌人静态数据
 * @author ...Kanon
 */
public class EnemyProxy extends Proxy 
{
	public static const NAME:String = "EnemyProxy";
	private var enemyDict:Dictionary;
	private var enemyAry:Array;
	//是否加载完成
	public var isLoaded:Boolean;
	public function EnemyProxy() 
	{
		this.proxyName = NAME;
	}
	
	/**
	 * 初始化数据
	 */
	override public function initData():void 
	{
		this.isLoaded = false;
		this.enemyAry = [];
		this.enemyDict = new Dictionary();
		Laya.loader.load("data/enemy.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/enemy.xml");
			var elementList:Array = xml.getElementsByTagName("enemy");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var enemyPo:EnemyPo = new EnemyPo();
				enemyPo.id = childNode.getAttribute("id");
				enemyPo.name = String(childNode.getAttribute("name"));
				enemyPo.hp = childNode.getAttribute("hp");
				enemyPo.atk = Number(childNode.getAttribute("atk"));
				enemyPo.exp = childNode.getAttribute("exp");
				enemyPo.type = childNode.getAttribute("type");
				enemyPo.pic = String(childNode.getAttribute("pic"));
				enemyPo.icon = String(childNode.getAttribute("icon"));
				this.enemyAry.push(enemyPo);
			}
			this.isLoaded = true;
		}));
	}
	
	/**
	 * 根据id获取敌人数据
	 * @param	id	敌人id
	 * @return	敌人数据
	 */
	public function getEnemyPoById(id:int):EnemyPo
	{
		if (!this.enemyAry) return null;
		var count:int = this.enemyAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var ePo:EnemyPo = this.enemyAry[i];
			if (ePo.id == id)
				return ePo;
		}
		return null;
	}
}
}