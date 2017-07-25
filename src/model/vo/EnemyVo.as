package model.vo 
{
/**
 * ...敌人数据
 * @author ...Kanon
 */
public class EnemyVo 
{
	//id
	public var id:int;
	//名字
	public var name:String;
	//攻
	public var atk:int;
	//血
	public var hp:int;
	//所在的层级
	public var level:int;
	//提供的经验
	public var exp:int;
	//类型（1普通，2boss）
	public var type:int
	public function EnemyVo() 
	{
		
	}
	
}
}