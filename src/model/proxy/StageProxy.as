package model.proxy 
{
import laya.utils.Handler;
import model.po.DropPo;
import model.po.EnemyPo;
import model.po.EquipPo;
import model.po.StagePo;
import model.vo.EnemyVo;
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
	//总关卡数
	private var _totalLevel:int;
	//关卡列表
	private var stageAry:Array;
	private var eProxy:EnemyProxy;
	private var equipProxy:EquipProxy;
	private var dProxy:DropProxy;
	public function StageProxy() 
	{
		this.proxyName = NAME;
		this.eProxy = this.retrieveProxy(EnemyProxy.NAME) as EnemyProxy;
		this.dProxy = this.retrieveProxy(DropProxy.NAME) as DropProxy;
		this.equipProxy = this.retrieveProxy(EquipProxy.NAME) as EquipProxy;
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
			var prevLevel:int = 0;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var stagePo:StagePo = new StagePo();
				stagePo.id = childNode.getAttribute("id");
				stagePo.name = childNode.getAttribute("name");
				stagePo.bossId = childNode.getAttribute("bossId");
				stagePo.dropId = childNode.getAttribute("dropId");
				stagePo.level = Number(childNode.getAttribute("level"));
				stagePo.points = childNode.getAttribute("points");
				stagePo.enemyIds = String(childNode.getAttribute("enemyIds")).split(",");
				if (stagePo.level != prevLevel)
				{
					prevLevel = stagePo.level;
					this._totalLevel++;
				}
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
	 * 获取当前关卡总关卡点数
	 * @return	关卡点数量
	 */
	public function getCurStagePointsCount():int
	{
		var arr:Array = this.getStagePoListByLevel(this.curLevel);
		if (!arr) return 0;
		return arr.length;
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
	public function getCurStagePoEnemyPoList():Array
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
	
	/**
	 * 获取当前关卡数据的武器掉落列表
	 * @return	武器掉落列表
	 */
	public function getCurStagePoWeaponList():Array
	{
		var arr:Array = [];
		var sPo:StagePo = this.getStagePoByLevelAndPoints(this.curLevel, this.curPoints);
		if (sPo)
		{
			var dPo:DropPo = this.dProxy.getDropPoById(sPo.dropId);
			var count:int = dPo.weaponIds.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var id:int = dPo.weaponIds[i];
				var equipPo:EquipPo = this.equipProxy.getEquipPoById(id);
				arr.push(equipPo);
			}
		}
		return arr;
	}
	
	/**
	 * 获取当前关卡的盾掉落数据列表
	 * @return	盾掉落数据列表
	 */
	public function getCurStagePoShieldList():Array
	{
		var arr:Array = [];
		var sPo:StagePo = this.getStagePoByLevelAndPoints(this.curLevel, this.curPoints);
		if (sPo)
		{
			var dPo:DropPo = this.dProxy.getDropPoById(sPo.dropId);
			var count:int = dPo.shieldIds.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var id:int = dPo.shieldIds[i];
				var equipPo:EquipPo = this.equipProxy.getEquipPoById(id);
				arr.push(equipPo);
			}
		}
		return arr;
	}
	
	/**
	 * 获取当前关卡的盔掉落数据列表
	 * @return	盔掉落数据列表
	 */
	public function getCurStagePoHelmetList():Array
	{
		var arr:Array = [];
		var sPo:StagePo = this.getStagePoByLevelAndPoints(this.curLevel, this.curPoints);
		if (sPo)
		{
			var dPo:DropPo = this.dProxy.getDropPoById(sPo.dropId);
			var count:int = dPo.helmetIds.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var id:int = dPo.helmetIds[i];
				var equipPo:EquipPo = this.equipProxy.getEquipPoById(id);
				arr.push(equipPo);
			}
		}
		return arr;
	}
	
	/**
	 * 根据类型获取掉落数据列表
	 * @param	type		类型1.武器 2.盾牌 3.头盔
	 * @return	掉落数据列表
	 */
	public function getCurStagePoDropEquipListByType(type:int):Array
	{
		switch (type) 
		{
			case EquipPo.WEAPON:
				return this.getCurStagePoWeaponList();
			case EquipPo.SHIELD:
				return this.getCurStagePoShieldList();
			case EquipPo.HELMET:
				return this.getCurStagePoHelmetList();
		}
		return null;
	}
	
	/**
	 * 总关卡数
	 */
	public function get totalLevel():int {return _totalLevel;}
}
}