package model.proxy 
{
import laya.utils.Handler;
import model.po.DropPo;
import mvc.Proxy;
/**
 * ...掉落数据代理
 * @author Kanon
 */
public class DropProxy extends Proxy
{
	public static const NAME:String = "DropProxy";
	//掉落数据列表
	private var dropAry:Array;
	public var isLoaded:Boolean;
	public function DropProxy() 
	{
		this.proxyName = NAME;
	}
	
	override public function initData():void 
	{
		this.dropAry = [];
		Laya.loader.load("data/drop.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/drop.xml");
			var elementList:Array = xml.getElementsByTagName("drop");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var dPo:DropPo = new DropPo();
				dPo.id = childNode.getAttribute("id");
				dPo.weaponIds = String(childNode.getAttribute("weaponIds")).split(",");
				dPo.shieldIds = String(childNode.getAttribute("shieldIds")).split(",");
				dPo.helmetIds = String(childNode.getAttribute("helmetIds")).split(",");
				dPo.magicIds = String(childNode.getAttribute("magicIds")).split(",");
				this.dropAry.push(dPo);
			}
			this.isLoaded = true;
		}));
	}
	
	/**
	 * 根据掉落id获取掉落数据
	 * @param	id	掉落id
	 * @return	掉落数据
	 */
	public function getDropPoById(id:int):DropPo
	{
		if (!this.dropAry) return null;
		var count:int = this.dropAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var dPo:DropPo = this.dropAry[i];
			if (dPo.id == id)
				return dPo;
		}
		return null;
	}
	
}
}