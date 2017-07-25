package model.vo 
{
/**
 * ...装备数据
 * @author Kanon
 */
public class EquipVo 
{
	public var id:int;
	//名字
	public var name:String;
	//攻击力数组
	public var atk:Array;
	//防御力
	public var def:int;
	//类型1.武器 2.盾牌 3.头盔
	public var type:int;
	//图片资源
	public var pic:String;
	public function EquipVo() 
	{
		
	}
	
}
}