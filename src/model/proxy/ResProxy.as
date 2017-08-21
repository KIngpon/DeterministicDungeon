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
	private var fontList:Array = [];
	private var bgList:Array = [];
	private var resCount:int = 0;
	private var fontCount:int = 0;
	private var levelCount:int = 0;
	private var bgCount:int = 0;
	public static const NAME:String = "ResProxy";
	private var gameBitmapFont:BitmapFont;
	private var sProxy:StageProxy;
	public function ResProxy() 
	{
		this.proxyName = NAME;
	}
	
	override public function initData():void 
	{
		this.sProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
		this.resCount = 0;
		this.resList = [];
		this.resList.push("res/atlas/btn.json");
		this.resList.push("res/atlas/comp.json");
		this.resList.push("res/atlas/frame.json");
		this.resList.push("res/atlas/icon/enemy.json");
		this.resList.push("res/atlas/bar.json");
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
		this.fontCount = 0;
		this.fontList = [];
		this.fontList.push([GameConstant.GAME_FONT_NAME, "font/GameFont.fnt"]);
		this.fontList.push([GameConstant.GAME_RED_FONT_NAME, "font/GameFontRed.fnt"]);
		//this.fontList.push([GameConstant.GAME_SMALL_FONT_NAME, "font/GameSmallFont.fnt"]);
		var count:int = this.fontList.length;
		for (var i:int = 0; i < count; i++) 
		{
			var bmpFont:BitmapFont = new BitmapFont();
			//这里不需要扩展名，外部保证fnt与png文件同名
			bmpFont.loadFont(this.fontList[i][1], Handler.create(this, loadFontComplete, [bmpFont]));
			Text.registerBitmapFont(this.fontList[i][0], bmpFont);
		}
	}
	
	/**
	 * 初始化大背景图
	 */
	private function initBgImage():void
	{
		this.bgCount = 0;
		this.levelCount = 0;
		this.bgList = [];
		var count:int = this.sProxy.totalLevel;
		count = 8;
		for (var i:int = 1; i <= count; i++) 
		{
			var arr:Array = [];
			arr.push("stage/" + "stage" + i + "/stageBg.png");
			arr.push("stage/" + "stage" + i + "/stageBg1.png");
			arr.push("stage/" + "stage" + i + "/stageBg2.png");
			arr.push("stage/" + "stage" + i + "/stageDownBg.png");
			arr.push("stage/" + "stage" + i + "/stageSlotsBg.png");
			arr.push("stage/" + "stage" + i + "/stageStartBg.png");
			arr.push("stage/" + "stage" + i + "/stageUpBg.png");
			this.bgList.push(arr);
		}
		for (i = 0; i < count; i++)
		{
			var arr:Array = this.bgList[i];
			var arrCount:int = arr.length;
			for (var j:int = 0; j < arrCount; j++) 
			{
				var path:String = arr[j];
				Laya.loader.load(path, Handler.create(this, loadImgComplete, [i]), null, Loader.IMAGE);
			}
		}
	}
	
	/**
	 * 加载字体结束
	 */
	private function loadFontComplete(bmpFont:BitmapFont):void
	{
		bmpFont.setSpaceWidth(10);
		this.fontCount++;
		if (this.fontCount >= this.fontList.length)
		{
			this.initBgImage();
		}
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
		
	/**
	 * 加载图片结束
	 */
	private function loadImgComplete(index:int):void
	{
		var arr:Array = this.bgList[index];
		var arrCount:int = arr.length;
		this.bgCount++;
		if (this.bgCount >= arrCount)
		{
			this.bgCount = 0;
			this.levelCount++;
			if (this.levelCount >= this.bgList.length)
			{
				trace("开始")
				this.sendNotification(MsgConstant.INIT_FIGHT_STAGE);
			}
		}
	}
}
}