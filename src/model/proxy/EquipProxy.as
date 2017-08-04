package model.proxy 
{
import laya.utils.Handler;
import model.po.EquipPo;
import mvc.Proxy;

/**
 * ...装备数据代理
 * @author ...Kanon
 */
public class EquipProxy extends Proxy 
{
	public static const NAME:String = "EquipProxy";
	//是否加载完成
	public var isLoaded:Boolean;
	//装备数组
	private var equipAry:Array;
	public function EquipProxy() 
	{
		this.proxyName = NAME;
	}
	
	override public function initData():void 
	{
		this.equipAry = [];
		Laya.loader.load("data/equip.xml", Handler.create(this, function(data:*):void
		{
            var xml:XmlDom = Laya.loader.getRes("data/equip.xml");
			var elementList:Array = xml.getElementsByTagName("equip");
			var count:int = elementList.length;
			for (var i:int = 0; i < count; ++i) 
			{
				var childNode:XmlDom = elementList[i];
				var ePo:EquipPo = new EquipPo();
				ePo.id = childNode.getAttribute("id");
				ePo.type = childNode.getAttribute("type");
				if (ePo.type == EquipPo.WEAPON) ePo.atk = String(childNode.getAttribute("atk")).split(",");
				if (ePo.type != EquipPo.WEAPON) ePo.def = childNode.getAttribute("def");
				ePo.name = childNode.getAttribute("name");
				ePo.pic = childNode.getAttribute("pic");
				ePo.icon = String(childNode.getAttribute("icon"));
				this.equipAry.push(ePo);
			}
			this.isLoaded = true;
		}));
	}
	
	/**
	 * 根据id获取装备数据
	 * @param	id	装备id
	 * @return	装备数据
	 */
	public function getEquipPoById(id:int):EquipPo
	{
		if (!this.equipAry) return null;
		var count:int = this.equipAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var ePo:EquipPo = this.equipAry[i];
			if (ePo.id == id)
				return ePo;
		}
		return null;
	}
}
}