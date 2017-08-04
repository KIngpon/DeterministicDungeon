package model.po 
{
/**
 * ...关卡配置
 * @author ...Kanon
 */
public class StagePo 
{
	//关卡id
	public var id:int;
	//名字
	public var name:String;
	//出现敌人id列表
	public var enemyIds:Array;
	//掉落id
	public var dropId:int;
	//此关卡是否出boss的id
	public var bossId:Boolean;	
	//层级
	public var level:int;
	//2级层级
	public var points:int;
	public function StagePo() 
	{
		
	}
	
}
}