package model.po 
{
/**
 * ...敌人数据
 * @author ...Kanon
 */
public class EnemyPo 
{
	//id
	public var id:int;
	//名字
	public var name:String;
	//攻
	public var atk:int;
	//血
	public var hp:int;
	//提供的经验
	public var exp:int;
	//类型（1普通，2boss）
	public var type:int;
	//图片或动画名称
	public var pic:String;
	//icon
	public var icon:String;
	public function EnemyPo() 
	{
		
	}
	
}
}