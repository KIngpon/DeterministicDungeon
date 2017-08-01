package model.proxy 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.BitmapFont;
import laya.display.Text;
import laya.net.Loader;
import laya.utils.Handler;
import mvc.Proxy;
/**
 * ...资源数据管理
 * @author ...Kanon
 */
public class ResProxy extends Proxy 
{
	private var resList:Array = [];
	private var resCount:int = 0;
	public static const NAME:String = "ResProxy";
	private var gameBitmapFont:BitmapFont;
	public function ResProxy() 
	{
		this.proxyName = NAME;
	}
	
	override public function initData():void 
	{
		this.resList.push("res/atlas/btn.json");
		this.resList.push("res/atlas/comp.json");
		this.resList.push("res/atlas/frame.json");
		var count:int = this.resList.length;
		for (var i:int = 0; i < count; i++) 
		{
			Laya.loader.load([{url: this.resList[i], type: Loader.ATLAS}], Handler.create(this, loadCompleteHandler));
		}
	}
	
	/**
	 * 初始化字体
	 */
	private function initFont():void
	{
		this.gameBitmapFont = new BitmapFont();
		//这里不需要扩展名，外部保证fnt与png文件同名
		this.gameBitmapFont.loadFont("font/GameFont.fnt", Handler.create(this, loadFontComplete));
	}
	
	/**
	 * 加载字体结束
	 */
	private function loadFontComplete():void
	{
		this.gameBitmapFont.setSpaceWidth(10);
		Text.registerBitmapFont(GameConstant.GAME_FONT_NAME, this.gameBitmapFont);
		this.sendNotification(MsgConstant.INIT_FIGHT_STAGE);
	}
	
	private function loadCompleteHandler():void
	{
		this.resCount++;
		if (this.resCount == this.resList.length)
		{
			//加载字体
			this.initFont();
		}
	}
	
}
}