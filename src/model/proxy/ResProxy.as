package model.proxy 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.BitmapFont;
import laya.display.Text;
import laya.events.Event;
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
	private var stageBgList:Array = [];
	private var resCount:int = 0;
	private var fontCount:int = 0;
	private var levelCount:int = 1;
	private var stageBgCount:int = 0;
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
		this.levelCount = 1;
		this.loadStageBgByLevel(this.levelCount);
	}
	
	/**
	 * 根据关卡数加载背景
	 * @param	level		关卡数
	 */
	public function loadStageBgByLevel(level:int):void
	{
		this.stageBgCount = 0;
		this.stageBgList = [];
		this.stageBgList.push("stage/" + "stage" + level + "/stageBg.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageBg1.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageBg2.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageDownBg.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageSlotsBg.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageStartBg.png");
		this.stageBgList.push("stage/" + "stage" + level + "/stageUpBg.png");
		Laya.loader.load(this.stageBgList[this.stageBgCount], Handler.create(this, loadStageImgComplete), Handler.create(this, loadImgProgress), Loader.IMAGE);
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
	 * 加载关卡背景图成功
	 * @param	level
	 */
	private function loadStageImgComplete(level:int):void
	{
		this.stageBgCount++;
		if (this.stageBgCount < this.stageBgList.length)
		{
			Laya.loader.load(this.stageBgList[this.stageBgCount], Handler.create(this, loadStageImgComplete), Handler.create(this, loadImgProgress), Loader.IMAGE);
		}
		else
		{
			//加载完毕
			this.levelCount++;
			if (this.levelCount > 8)
				this.sendNotification(MsgConstant.INIT_FIGHT_STAGE);
			else
				this.loadStageBgByLevel(this.levelCount);
		}
	}
	
	private function loadImgProgress(pro:Number):void
	{
		var per:Number = this.levelCount / 8;
		this.sendNotification(MsgConstant.LOAD_PROGRESS_FIGHT_STAGE, per);
	}
}
}