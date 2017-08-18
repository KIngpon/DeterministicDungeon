package model.proxy 
{
import config.GameConstant;
import laya.utils.Handler;
import model.po.DropPo;
import model.po.EnemyPo;
import model.po.EquipPo;
import model.po.StagePo;
import model.vo.PointVo;
import mvc.Proxy;
import utils.Random;

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
	public var curPoints:int = 3;
	//当前需要随机的关卡点索引
	public var curPointIndex:int = 0;
	//当前步数
	public var step:int = 0;
	//总步数
	private var maxStep:int;
	//总关卡数
	private var _totalLevel:int;
	//关卡列表
	private var stageAry:Array;
	private var eProxy:EnemyProxy;
	private var equipProxy:EquipProxy;
	private var dProxy:DropProxy;
	//关卡点数据列表
	public var pointsAry:Array;
	public var openList:Array;
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
	public function get totalLevel():int {return _totalLevel; }
	
	/**
	 * 初始化关卡点数组
	 */
	public function initPointsAry():void
	{
		this.pointsAry = [];
		this.step = 0;
		this.curPointIndex = 0;
		if (this.isBossPoint) this.maxStep = 4;
		else if (this.isFirstPoint) this.maxStep = 3;
		else this.maxStep = 2;
		for (var i:int = 0; i < GameConstant.POINTS_NUM_MAX; i++) 
		{
			var pVo:PointVo = new PointVo();
			pVo.index = i + 1;
			pVo.up = true;
			pVo.down = true;
			pVo.left = true;
			pVo.right = true;
			pVo.type = PointVo.NONE;
			if (pVo.index <= 3) pVo.left = false;
			if (pVo.index >= 7) pVo.right = false;
			if (pVo.index == 1 || 
				pVo.index == 4 || 
				pVo.index == 7)
				pVo.up = false;
			if (pVo.index == 3 || 
				pVo.index == 6 || 
				pVo.index == 9)
				pVo.down = false;
			pVo.passAry = [];
			if (pVo.up) pVo.passAry.push(PointVo.UP_PASS);
			if (pVo.down) pVo.passAry.push(PointVo.DOWN_PASS);
			if (pVo.left) pVo.passAry.push(PointVo.LEFT_PASS);
			if (pVo.right) pVo.passAry.push(PointVo.RIGHT_PASS);
			this.pointsAry.push(pVo);
		}
	}
	
	/**
	 * 根据索引获取点数据
	 * @param	index	索引 0 - 8
	 * @return	点数据
	 */
	public function getPointVoByIndex(index:int):PointVo
	{
		if (!this.pointsAry) return null;
		if (index < 0 || index > this.pointsAry.length - 1) return null;
		return this.pointsAry[index];
	}
	
	/**
	 * 随机关卡点的通过
	 * @param	index	索引 0 - 8
	 */
	public function randomPointPassByIndex(index:int):void
	{
		if (!this.pointsAry) return;
		if (index < 0 || index > this.pointsAry.length - 1) return;
		var pVo:PointVo = this.pointsAry[index];
		//先随机通过的数量
		var count:int = pVo.passAry.length;
		if (count == 4 || count == 3) count = 2;
		count = Random.randint(1, count);
		pVo.passAry = Random.sample(pVo.passAry, count);
		pVo.up = false;
		pVo.down = false;
		pVo.left = false;
		pVo.right = false;
		count = pVo.passAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			if (pVo.passAry[i] == PointVo.UP_PASS)
				pVo.up = true;
			else if (pVo.passAry[i] == PointVo.DOWN_PASS)
				pVo.down = true;
			else if (pVo.passAry[i] == PointVo.LEFT_PASS)
				pVo.left = true;
			else if (pVo.passAry[i] == PointVo.RIGHT_PASS)
				pVo.right = true;
		}
	}
	
	/**
	 * 随机当前关卡点
	 */
	public function randomCurPointPass():void
	{
		if (this.curPointIndex > this.pointsAry.length - 1) return;
		this.randomPointPassByIndex(this.curPointIndex);
		this.curPointIndex++;
	}
	
	/**
	 * 随机所有关卡点的通道
	 */
	public function randomAllPointPass():void
	{
		for (var i:int = this.curPointIndex; i < GameConstant.POINTS_NUM_MAX; i++)
		{
			this.randomCurPointPass();
		}
	}
	
	/**
	 * 随机关卡点的类型
	 */
	public function randomPointType():void
	{
		var typeAry:Array = [PointVo.UP_FLOOR, PointVo.DOWN_FLOOR];
		if (this.isFirstPoint()) typeAry = [PointVo.UP_FLOOR, PointVo.DOWN_FLOOR, PointVo.REWARD_BOX];
		if (this.isBossPoint()) typeAry = [PointVo.UP_FLOOR, PointVo.DOWN_FLOOR, PointVo.BOSS_REWARD_BOX, PointVo.BOSS];
		//根据当前已经选择好的步数，剔除不需要随机的位置
		trace("typeAry", typeAry);
		if (this.step > 1) typeAry.splice(0, this.step - 1);
		trace("typeAry", typeAry);
		var sampleCount:int = typeAry.length;
		var count:int = this.pointsAry.length;
		var arr:Array = [];
		for (var i:int = 0; i < count; i++)
		{
			var pVo:PointVo = this.pointsAry[i];
			if (pVo.type == PointVo.NONE)
				arr.push(pVo);
		}
		arr = Random.sample(arr, sampleCount);
		count = arr.length;
		for (var i:int = 0; i < count; i++)
		{
			var pVo:PointVo = arr[i];
			pVo.type = typeAry[i];
		}
	}
	
	/**
	 * 跳过手动随机
	 */
	public function skip():void
	{
		if (this.step == 0) 
		{
			this.randomAllPointPass();
			this.step++;
		}
		else if (this.step <= this.maxStep)
		{
			trace("this.step", this.step);
			this.randomPointType();
			this.step = this.maxStep + 1;
		}
	}
	
	/**
	 * 下一步
	 */
	public function nextStep(index:int):void
	{
		var pVo:PointVo;
		switch (this.step) 
		{
			case 0:
				//this.randomCurPointPass();
				if (index >= this.pointsAry.length - 1 && this.checkStagePointValid()) 
				{
					//TODO 判断是否有孤立的格子
					this.step++;
				}
			break;
			case 1:
				pVo = this.pointsAry[index];
				pVo.type = PointVo.UP_FLOOR;
				this.step++;
			break;
			case 2:
				pVo = this.pointsAry[index];
				pVo.type = PointVo.DOWN_FLOOR;
				this.step++;
			break;
			case 3:
				pVo = this.pointsAry[index];
				if (this.isFirstPoint())
				{
					pVo.type = PointVo.REWARD_BOX;
				}
				else if (this.isBossPoint())
				{
					pVo.type = PointVo.BOSS_REWARD_BOX;
				}
				this.step++;
			break;
			case 4:
				if (this.isBossPoint())
				{
					pVo = this.pointsAry[index];
					pVo.type = PointVo.BOSS;
					this.step++;
				}
			break;
		}
	}
	
	/**
	 * 是否是boss层
	 * @return	
	 */
	public function isBossPoint():Boolean
	{
		return this.curPoints == this.getCurStagePointsCount();
	}
	
	/**
	 * 是否是第一层
	 * @return
	 */
	public function isFirstPoint():Boolean
	{
		return this.curPoints == 1;
	}
	
	/**
	 * 补完可通过的点
	 */
	private function fixPassPoint():void
	{
		var count:int = this.pointsAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = this.pointsAry[i];
			if (pVo.up)
			{
				if (i != 0 && i != 3 && i != 6)
				{
					var upVo:PointVo = this.pointsAry[i - 1];
					upVo.down = true;
				}
			}
			if (pVo.down)
			{
				if (i != 2 && i != 5 && i != 8)
				{
					var downVo:PointVo = this.pointsAry[i + 1];
					downVo.up = true;
				}
			}
			if (pVo.left)
			{
				if (i != 0 && i != 1 && i != 2)
				{
					var leftVo:PointVo = this.pointsAry[i - 3];
					leftVo.right = true;
				}
			}
			if (pVo.right)
			{
				if (i != 6 && i != 7 && i != 8)
				{
					var rightVo:PointVo = this.pointsAry[i + 3];
					rightVo.left = true;
				}
			}
		}
	}
	
	/**
	 * 测试数据
	 */
	public function testPoints():void
	{
		this.pointsAry = [];
		var pVo:PointVo;
		pVo = new PointVo();
		pVo.right = true;
		pVo.down = true;
		pVo.index = 1;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.up = true;
		pVo.right = true;
		pVo.index = 2;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.right = true;
		pVo.index = 3;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.left = true;
		pVo.down = true;
		pVo.index = 4;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.left = true;
		pVo.up = true;
		pVo.index = 5;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.right = true;
		pVo.index = 6;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.down = true;
		pVo.index = 7;
		this.pointsAry.push(pVo);
		
		pVo = new PointVo();
		pVo.down = true;
		pVo.index = 8;
		this.pointsAry.push(pVo);
				
		pVo = new PointVo();
		pVo.up = true;
		pVo.index = 9;
		this.pointsAry.push(pVo);
	}
	
	
	/**
	 * 判断关卡点是否合法
	 */
	public function checkStagePointValid():Boolean
	{
		//将通路补全
		this.fixPassPoint();
		this.openList = [];
		this.seach(this.getPointVoByIndex(0), this.openList);
		return this.openList.length == GameConstant.POINTS_NUM_MAX;
	}
	
	/**
	 * 搜索整个地图查看是否有孤岛
	 * @param	pVo			关卡点数据
	 * @param	openList	存放通过的关卡点列表
	 */
	private function seach(pVo:PointVo, openList:Array):void
	{
		if (!pVo || !openList) return;
		var i:int = pVo.index - 1;
		pVo.isSeached = true;
		openList.push(pVo);
		//trace("---------------curPVo.index--" + pVo.index + "------------------");
		//trace("up", pVo.up);
		//trace("down", pVo.down);
		//trace("left", pVo.left);
		//trace("right", pVo.right);
		var passVoList:Array = [];
		if (pVo.up)
		{
			if (i != 0 && i != 3 && i != 6)
			{
				var upVo:PointVo = this.pointsAry[i - 1];
				passVoList.push(upVo);
			}
		}
		if (pVo.down)
		{
			if (i != 2 && i != 5 && i != 8)
			{
				var downVo:PointVo = this.pointsAry[i + 1];
				passVoList.push(downVo);
			}
		}
		if (pVo.left)
		{
			if (i != 0 && i != 1 && i != 2)
			{
				var leftVo:PointVo = this.pointsAry[i - 3];
				passVoList.push(leftVo);
			}
		}
		if (pVo.right)
		{
			if (i != 6 && i != 7 && i != 8)
			{
				var rightVo:PointVo = this.pointsAry[i + 3];
				passVoList.push(rightVo);
			}
		}
		var count:int = passVoList.length;
		for (i = 0; i < count; i++) 
		{
			var passVo:PointVo = passVoList[i];
			if (!passVo.isSeached)
			{
				//trace("passVo", passVo.index);
				this.seach(passVo, openList);
			}
		}
	}
	
	/**
	 * 重置点数据的搜索状态
	 */
	private function resetPointSeach():void
	{
		var count:int = this.pointsAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = this.pointsAry[i];
			pVo.isSeached = false;
		}
	}
	
	/**
	 * 根据类型获取关卡点数据
	 * @param	type	类型
	 */
	public function getPointVoByType(type:int):PointVo
	{
		if (!this.pointsAry) return null;
		var count:int = this.pointsAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var pVo:PointVo = this.pointsAry[i];
			if (pVo.type == type)
				return pVo;
		}
		return null;
	}
}
}