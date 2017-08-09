package model.proxy 
{
import laya.net.Loader;
import laya.utils.Dictionary;
import laya.utils.Handler;
import model.po.EnemyPo;
import model.vo.EnemyVo;
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
	//当前关卡敌人数据列表
	public var enemyVoList:Array;
	//动态数组的唯一id
	private var id:int = 0;
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
				enemyPo.hp = Number(childNode.getAttribute("hp"));
				enemyPo.atk = Number(childNode.getAttribute("atk"));
				enemyPo.exp = Number(childNode.getAttribute("exp"));
				enemyPo.type = childNode.getAttribute("type");
				enemyPo.pic = String(childNode.getAttribute("pic"));
				enemyPo.icon = childNode.getAttribute("icon");
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
	
	/**
	 * 创建敌人动态数据
	 * @param	ePo		敌人静态数据
	 * @return	敌人动态数据
	 */
	public function createEnemyVo(ePo:EnemyPo):EnemyVo
	{
		if (!ePo) return null;
		var eVo:EnemyVo = new EnemyVo();
		eVo.id = this.id++;
		eVo.no = ePo.id;
		eVo.hp = ePo.hp;
		eVo.enemyPo = ePo;
		this.enemyVoList.push(eVo);
		return eVo;
	}
	
	/**
	 * 清除当前关卡的敌人列表
	 */
	public function clearStageEnemyList():void
	{
		this.enemyVoList = [];
	}
	
	/**
	 * 根据索引获取敌人数据
	 * @param	index	索引
	 * @return	敌人数据
	 */
	public function getEnemyVoByIndex(index:int):EnemyVo
	{
		if (!this.enemyVoList) return null;
		if (index < 0 || index > this.enemyVoList.length - 1) return null;
		return this.enemyVoList[index];
	}
	
	/**
	 * 获取本关当前敌人数量
	 * @return	敌人数量
	 */
	public function getCurStageEnemyCount():int
	{
		if (!this.enemyVoList) return 0;
		return this.enemyVoList.length;
	}
	
	/**
	 * 根据id删除敌人数据
	 * @param	id	敌人id
	 */
	public function removeEnemyVoById(id:int):void
	{
		trace("remove id", id);
		var count:int = this.enemyVoList.length;
		for (var i:int = 0; i < count; ++i) 
		{
			var eVo:EnemyVo = this.enemyVoList[i];
			if (id == eVo.id)
			{
				trace("remove", eVo.enemyPo.name);
				this.enemyVoList.splice(i, 1);
				break;
			}
		}
	}
}
}