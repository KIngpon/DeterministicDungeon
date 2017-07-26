package view.ui 
{
import config.GameConstant;
import laya.display.Sprite;
/**
 * ...战斗场景
 * @author ...
 */
public class GameStageLayer extends Sprite 
{
	//玩家
	public var player:Sprite;
	//敌人列表
	public var enemyAry:Array;

	public function GameStageLayer() 
	{
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	public function initUI():void
	{
		this.player = new Sprite();
		this.player.graphics.drawRect(0, -120, 70, 120, "#ff0000");
		this.addChild(this.player);
		this.player.x = 160;
		this.player.y = GameConstant.ROLE_POS_Y;
		
		var gap:Number = 30;
		for (var i:int = 0; i < GameConstant.ENEMY_NUM; i++) 
		{
			var enemy:Sprite = new Sprite();
			enemy.graphics.drawRect(0, -120, 70, 120, "#ff00ff");
			enemy.x = 600 + i * (70 + gap);
			enemy.y = GameConstant.ROLE_POS_Y;
			this.addChild(enemy);
			trace(enemy.x);
		}
	}
	
}
}