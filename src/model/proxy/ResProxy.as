package model.proxy 
{
import config.MsgConstant;
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
	public function ResProxy() 
	{
		super();
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
	
	private function loadCompleteHandler():void
	{
		this.resCount++;
		if (this.resCount == this.resList.length)
		{
			this.sendNotification(MsgConstant.INIT_FIGHT_STAGE);
		}
	}
	
}
}