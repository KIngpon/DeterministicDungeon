package view.ui 
{
import laya.display.Sprite;
import laya.display.Stage;
/**
 * ...游戏层级
 * @author ...Kanon
 */
public class Layer 
{
	public static var STAGE:Sprite;
	//游戏场景
	public static var GAME_STAGE:Sprite;
	//UI
	public static var GAME_UI:Sprite;
	//游戏弹框
	public static var GAME_ALERT:Sprite;

	/**
	 * 初始化层级
	 * @param	root	根
	 */
	public static function init(root:Sprite):void
	{
		STAGE = new Sprite();
		root.addChild(STAGE);
		
		STAGE.graphics.drawRect(0, 0, 1300, Laya.stage.height, "#001542");
		
		GAME_STAGE = new Sprite();
		GAME_UI = new Sprite();
		GAME_ALERT = new Sprite();
		
		STAGE.addChild(GAME_STAGE);
		STAGE.addChild(GAME_UI);
		STAGE.addChild(GAME_ALERT);
	}
	
}
}