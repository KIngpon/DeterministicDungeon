package model.proxy 
{
import laya.utils.Dictionary;
import laya.utils.Handler;
import model.po.PicPo;
import mvc.Proxy;

/**
 * ...icon资源数据代理
 * @author ...Kanon
 */
public class PicProxy extends Proxy 
{
	public static const NAME:String = "PicProxy";
	private var picDict:Dictionary;
	public var isLoaded:Boolean;
	public function PicProxy() 
	{
		this.proxyName = NAME;
	}
	
	override public function initData():void 
	{
		this.picDict = new Dictionary();
		this.isLoaded = false;
		Laya.loader.load("data/pic.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/pic.xml");
			var elementList:Array = xml.getElementsByTagName("pic");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var pPo:PicPo = new PicPo();
				pPo.id = childNode.getAttribute("id");
				pPo.bigIcon = childNode.getAttribute("bigIcon");
				pPo.smallIcon = childNode.getAttribute("smallIcon");
				pPo.icon = childNode.getAttribute("icon");
				pPo.img = childNode.getAttribute("img");
				pPo.ani = childNode.getAttribute("ani");
				this.picDict.set(pPo.id, pPo);
			}
			this.isLoaded = true;
		}));
	}
	
	
	/**
	 * 根据id获取图片数据
	 * @param	id	唯一标识
	 * @return	图片数据
	 */
	public function getPicPoById(id:int):PicPo
	{
		if (!this.picDict) return null;
		return this.picDict.get(id);
	}
	
	/**
	 * 根据id获取icon
	 * @param	id	
	 * @return	icon
	 */
	public function getIconById(id:int):String
	{
		var pPo:PicPo = this.getPicPoById(id);
		if (!pPo) return null;
		return pPo.icon;
	}
	
	/**
	 * 根据id获取bigIcon
	 * @param	id	
	 * @return	bigIcon
	 */
	public function getBigIconById(id:int):String
	{
		var pPo:PicPo = this.getPicPoById(id);
		if (!pPo) return null;
		return pPo.bigIcon;
	}
	
	/**
	 * 根据id获取smallIcon
	 * @param	id	
	 * @return	smallIcon
	 */
	public function getSmallIconById(id:int):String
	{
		var pPo:PicPo = this.getPicPoById(id);
		if (!pPo) return null;
		return pPo.smallIcon;
	}
	
	/**
	 * 根据id获取img
	 * @param	id	
	 * @return	img
	 */
	public function getImgById(id:int):String
	{
		var pPo:PicPo = this.getPicPoById(id);
		if (!pPo) return null;
		return pPo.img;
	}
	
	/**
	 * 根据id获取ani
	 * @param	id	
	 * @return	ani
	 */
	public function getAniById(id:int):String
	{
		var pPo:PicPo = this.getPicPoById(id);
		if (!pPo) return null;
		return pPo.ani;
	}
}
}