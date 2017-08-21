package view.ui 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.display.Stage;
import laya.display.Text;
import laya.ui.Label;
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
	//loading
	public static var GAME_LOADNG:Sprite;
	//飘字层
	public static var GAME_DAMAGE:Sprite;
	//调试用文本
	public static var debugTxt:Label;
	/**
	 * 初始化层级
	 * @param	root	根
	 */
	public static function init(root:Sprite):void
	{
		STAGE = new Sprite();
		root.addChild(STAGE);
		
		//STAGE.graphics.drawRect(0, 0, GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT, "#0F1312");
		
		GAME_STAGE = new Sprite();
		GAME_UI = new Sprite();
		GAME_ALERT = new Sprite();
		GAME_DAMAGE = new Sprite();
		GAME_LOADNG = new Sprite();
		
		STAGE.addChild(GAME_STAGE);
		STAGE.addChild(GAME_UI);
		STAGE.addChild(GAME_ALERT);
		STAGE.addChild(GAME_DAMAGE);
		STAGE.addChild(GAME_LOADNG);
		
		if (GameConstant.DEBUG)
		{
			debugTxt = new Label();
			debugTxt.color = "#ff0000";
			debugTxt.mouseEnabled = false;
			debugTxt.width = Laya.stage.width;
			debugTxt.height = Laya.stage.height;
			debugTxt.fontSize = 22;
			STAGE.addChild(debugTxt);
		}
	}
}
}