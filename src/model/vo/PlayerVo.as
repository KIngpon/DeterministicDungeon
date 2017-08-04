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
	//当前层数
	public var curLevelNum:int;
	//当前关卡输
	public var curStageNum:int;
	//是否是当前层里的第一步
	public var isFirstStep:Boolean;
	//滚动间隔
	public var slotsDelay:int;
	//武器数据
	public var weaponPo:EquipPo;
	public function PlayerVo() 
	{
		
	}
}
}