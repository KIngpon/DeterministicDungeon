package model.vo 
{
import model.po.EquipPo;
/**
 * ...角色动态数据
 * @author ...Kanon
 */
public class PlayerVo 
{
	//当前血量
	public var curHp:int;
	public var maxHp:int;
	//当前经验
	public var curExp:int;
	public var maxExp:int;
	//等级
	public var level:int;
	//滚动间隔
	public var slotsDelay:int;
	//武器数据
	public var weaponPo:EquipPo;
	//玩家名字
	public var name:String = "玩家名字";
	//攻击加成buff
	private var atkAddBuff:int = 0;
	private var defAddBuff:int = 0;
	private var magicAddBuff:int = 0;
	private var hpAddBuff:int = 0;
	public function PlayerVo() 
	{
		
	}
	
	/**
	 * 获取血量基础值
	 * @return	攻击力
	 */
	public function getBaseHp():int
	{
		return this.level + this.hpAddBuff;
	}
	
	/**
	 * 获取攻击基础值
	 * @return	攻击力
	 */
	public function getBaseAtk():int
	{
		return this.level + this.atkAddBuff;
	}
	
	/**
	 * 获取防御基础值
	 * @return	防御
	 */
	public function getBaseDef():int
	{
		return this.level + this.defAddBuff;
	}
	
	/**
	 * 获取魔法基础值
	 * @return	魔法
	 */
	public function getBaseMagic():int
	{
		return this.level + this.magicAddBuff;
	}
}
}