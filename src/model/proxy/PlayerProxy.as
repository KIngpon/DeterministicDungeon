package model.proxy 
{
import laya.utils.Handler;
import model.po.PlayerPo;
import model.vo.PlayerVo;
import mvc.Proxy;

/**
 * ...玩家静态数据
 * @author ...Kanon
 */
public class PlayerProxy extends Proxy 
{
	public static const NAME:String = "PlayerProxy";
	//是否加载完成
	public var isLoaded:Boolean;
	//角色等级数据数组
	private var levelAry:Array;
	//角色动态数据
	public var pVo:PlayerVo;
	//武器数据代理
	private var equipProxy:EquipProxy;
	public function PlayerProxy() 
	{
		this.proxyName = NAME;
		this.equipProxy = this.retrieveProxy(EquipProxy.NAME) as EquipProxy;
	}
	
	/**
	 * 初始化数据
	 */
	override public function initData():void 
	{
		this.levelAry = [];
		this.isLoaded = false;
		Laya.loader.load("data/player.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/player.xml");
			var elementList:Array = xml.getElementsByTagName("player");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var playerPo:PlayerPo = new PlayerPo();
				playerPo.atk = Number(childNode.getAttribute("atk"));
				playerPo.hp = Number(childNode.getAttribute("hp"));
				playerPo.def = Number(childNode.getAttribute("def"));
				playerPo.exp = Number(childNode.getAttribute("exp"));
				playerPo.magic = Number(childNode.getAttribute("magic"));
				playerPo.level = Number(childNode.getAttribute("level"));
				this.levelAry.push(playerPo);
			}
			this.isLoaded = true;
			
			this.pVo = new PlayerVo();
			this.pVo.level = 1;
			var pPo:PlayerPo = this.getPlayerPoByLevel(this.pVo.level);
			this.pVo.maxExp = pPo.exp;
			this.pVo.maxHp = pPo.hp;
			this.pVo.curHp = this.pVo.maxHp;
			this.pVo.curExp = 0;
			this.pVo.isFirstStep = true;
			this.pVo.slotsDelay = 270;
			this.pVo.weaponPo = this.equipProxy.getEquipPoById(1);
			//trace(this.pVo.curHp, this.pVo.level, this.pVo.maxExp);
		}));
	}
	
	/**
	 * 根据等级获取角色数据
	 * @param	level	等级
	 * @return	角色数据
	 */
	public function getPlayerPoByLevel(level:int):PlayerPo
	{
		if (!this.levelAry) return null;
		var count:int = this.levelAry.length;
		for (var i:int = 0; i < count; ++i) 
		{
			var playerPo:PlayerPo = this.levelAry[i];
			if (playerPo.level == level)
				return playerPo;
		}
		return null;
	}
	
	/**
	 * 获取武器攻击力
	 * @return	攻击力数组
	 */
	public function getPlayerAtk():Array
	{
		if (!this.pVo || ! this.pVo.weaponPo) return null;
		return this.pVo.weaponPo.atk;
	}
	
	/**
	 * 增加经验
	 * @param	exp		经验
	 */
	public function addExp(exp:int):void 
	{
		this.pVo.curExp += exp;
		this.checkAddLevel();
	}
	
	/**
	 * 升级
	 */
	public function checkAddLevel():Boolean
	{
		//trace("-----判断是否增加等级----", this.pVo.curExp, "需要经验", this.pVo.maxExp);
		if (this.pVo.curExp >= this.pVo.maxExp)
		{
			this.pVo.level++;
			var pPo:PlayerPo = this.getPlayerPoByLevel(this.pVo.level);
			this.pVo.curExp -= this.pVo.maxExp;
			this.pVo.maxExp = pPo.exp;
			this.pVo.curHp = pPo.hp;
			this.pVo.maxHp = pPo.hp;
			//trace("-----剩余经验----", this.pVo.curExp);
			//trace("-----当前总经验----", this.pVo.maxExp);
			//trace("-----当前等级----", this.pVo.level);
			this.checkAddLevel();
		}
	}
}
}