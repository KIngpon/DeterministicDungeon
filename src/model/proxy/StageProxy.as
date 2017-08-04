package model.proxy 
{
import laya.utils.Handler;
import model.po.EnemyPo;
import model.po.StagePo;
import mvc.Proxy;

/**
 * ...关卡数据代理
 * @author Kanon
 */
public class StageProxy extends Proxy 
{
	public static const NAME:String = "StageProxy";
	//是否加载完成
	public var isLoaded:Boolean;
	//当前关卡
	public var curLevel:int = 1;
	//当前关卡点
	public var curPoints:int = 1;
	//关卡列表
	private var stageAry:Array;
	private var eProxy:EnemyProxy;
	public function StageProxy() 
	{
		this.proxyName = NAME;
		this.eProxy = this.retrieveProxy(EnemyProxy.NAME) as EnemyProxy;
	}
	
	override public function initData():void 
	{
		this.isLoaded = false;
		this.stageAry = [];
		Laya.loader.load("data/stage.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/stage.xml");
			var elementList:Array = xml.getElementsByTagName("stage");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var stagePo:StagePo = new StagePo();
				stagePo.id = childNode.getAttribute("id");
				stagePo.name = childNode.getAttribute("name");
				stagePo.bossId = childNode.getAttribute("bossId");
				stagePo.dropId = childNode.getAttribute("dropId");
				stagePo.level = childNode.getAttribute("level");
				stagePo.points = childNode.getAttribute("points");
				stagePo.enemyIds = String(childNode.getAttribute("enemyIds")).split(",");
				this.stageAry.push(stagePo);
			}
			this.isLoaded = true;
		}));
	}
	
	/**
	 * 根据关卡获取关卡列表数据
	 * @param	level	关卡
	 * @return	关卡列表数据
	 */
	public function getStagePoListByLevel(level:int):Array
	{
		var arr:Array = [];
		var count:int = this.stageAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var sPo:StagePo = this.stageAry[i];
			if (sPo.level == level)
				arr.push(sPo);
		}
		return arr;
	}
	
	/**
	 * 根据关卡和关卡点获取某一关的数据
	 * @param	level		关卡
	 * @param	points		关卡点
	 * @return	关卡数据
	 */
	public function getStagePoByLevelAndPoints(level:int, points:int):StagePo
	{
		var count:int = this.stageAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var sPo:StagePo = this.stageAry[i];
			if (sPo.level == level && sPo.points == points)
				return sPo;
		}
		return null;
	}
	
	/**
	 * 获取当前关卡列表数据
	 * @return	当前关卡列表数据
	 */
	public function getCurStagePoList():Array
	{
		return this.getStagePoListByLevel(this.curLevel);
	}
	
	/**
	 * 获取当前关卡数据
	 * @return	当前关卡数据
	 */
	public function getCurStagePo():StagePo
	{
		return this.getStagePoByLevelAndPoints(this.curLevel, this.curPoints);
	}
	
	/**
	 * 获取当前关卡数据的敌人列表
	 * @return	敌人数据列表
	 */
	public function getCurStagePoEnemyList():Array
	{
		var arr:Array = [];
		var sPo:StagePo = this.getStagePoByLevelAndPoints(this.curLevel, this.curPoints);
		if (sPo)
		{
			var count:int = sPo.enemyIds.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var id:int = sPo.enemyIds[i];
				var ePo:EnemyPo = this.eProxy.getEnemyPoById(id);
				arr.push(ePo);
			}
		}
		return arr;
	}
}
}