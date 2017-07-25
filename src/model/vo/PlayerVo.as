package model.vo 
{
/**
 * ...角色数据
 * @author ...Kanon
 */
public class PlayerVo 
{
	//---基础数据----
	//血
	public var hp:int;
	//攻
	public var atk:Number;
	//防
	public var def:Number;
	//魔攻
	public var magic:Number;
	//----------------
	//升级经验
	public var exp:int;
	//当前血量
	public var curHp:int;
	//当前经验
	public var curExp:int;
	//等级
	public var level:int;
	public function PlayerVo() 
	{
		
	}
}
}