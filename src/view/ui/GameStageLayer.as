package view.ui 
{
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
	//人物坐标
	private var rolePosY:Number = 380;
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
		this.player.graphics.drawRect(0, -200, 150, 200, "#ff0000");
		this.addChild(this.player);
		this.player.x = 0;
		this.player.y = this.rolePosY;
	}
	
}
}