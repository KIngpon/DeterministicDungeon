package view.components 
{
import laya.display.Sprite;
import ui.GameStage.MiniMapUI;

/**
 * ...小地图
 * @author Kanon
 */
public class MiniMap extends Sprite 
{
	private var ui:MiniMapUI;
	public function MiniMap() 
	{
		this.initUI();
	}
	
	private function initUI():void
	{
		this.ui = new MiniMapUI();
		this.addChild(this.ui);
	}
	
	override public function get width():Number{ return this.ui.width; }
	override public function set width(value:Number):void 
	{
		this.ui.width = value;
	}
}
}