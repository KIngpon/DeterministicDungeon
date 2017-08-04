package model.vo 
{
import model.po.EnemyPo;
import model.po.EquipPo;
/**
 * ...敌人动态数据
 * @author ...Kanon
 */
public class EnemyVo 
{
	//唯一id
	public var id:int = 0;
	//静态配置id
	public var no:int;
	//血量
	public var hp:int;
	//武器
	public var weapon:EquipPo;
	//敌人静态数据
	public var enemyPo:EnemyPo;
	public function EnemyVo() 
	{
		
	}
}
}