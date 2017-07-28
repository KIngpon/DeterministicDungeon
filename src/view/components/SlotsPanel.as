package view.components 
{
import laya.display.Sprite;
import laya.utils.Timer;
import ui.GameStage.SlotsPanelUI;
/**
 * ...滚动选择界面
 * @author ...Kanon
 */
public class SlotsPanel extends Sprite
{
	private var timer:Timer;
	//当前索引
	private var _index:int;
	//总数
	private var _totalIndex:int;
	//回调
	private var callBack:Function;
	//面板
	private var panel:SlotsPanelUI;
	public function SlotsPanel() 
	{
		this._index = 0;
		this.totalIndex = 0;
		this.callBack = null;
		
		this.panel = new SlotsPanelUI();
		this.addChild(this.panel);
	}
	
	/**
	 * 初始化数据
	 * @param	index		当前索引
	 * @param	totalIndex	总数
	 */
	public function initData(index:int, totalIndex:int):void
	{
		this._index = index;
		this.totalIndex = totalIndex;
	}
	
	/**
	 * 开始
	 * @param	delay	每一格的时间
	 */
	public function start(delay:int, callBack:Function):void
	{
		if (!this.timer) this.timer = new Timer();
		this.timer.clear(this, loopHandler);
		this.timer.loop(delay, this, loopHandler);
		this.callBack = callBack;
	}
	
	/**
	 * 暂停
	 */
	public function stop():void
	{
		if (!this.timer) return;
		this.timer.clear(this, loopHandler);
	}
	
	/**
	 * 循环
	 */
	private function loopHandler():void 
	{
		this._index++;
		if (this._index > this.totalIndex)
			this._index = 0;
		if (this.callBack && this.callBack is Function)
			this.callBack.call();
	}
	
	/**
	 * 当前索引
	 */
	public function get index():int {return _index; }
	
	/**
	 * 总数
	 */
	public function get totalIndex():int {return _totalIndex;}
	public function set totalIndex(value:int):void 
	{
		_totalIndex = value;
	}
}
}