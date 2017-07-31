package view.components 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Button;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Handler;
import laya.utils.Timer;
import ui.GameStage.SlotsPanelUI;
/**
 * ...滚动选择界面
 * @author ...Kanon
 */
public class SlotsPanel extends Sprite
{
	private var timer:Timer;
	//闪烁计时器
	private var flashingTimer:Timer;
	//当前索引
	private var _index:int;
	//总数
	private var _totalIndex:int;
	//回调
	private var flashingCallBackHandler:Handler;
	//面板
	private var panel:SlotsPanelUI;
	//内容容器
	private var contentSpt:Sprite;
	private var bgSpt:Sprite;
	private var frameSpt:Sprite;
	//选中框
	private var selectedImg:Image;
	private var flashingIndex:int;
	//选择按钮
	public var selectedBtn:Button;
	//标题
	public var titleTxt:Label;
	public function SlotsPanel() 
	{
		this._index = 0;
		this.totalIndex = 0;
		this.flashingIndex = 0;
		
		this.panel = new SlotsPanelUI();
		this.addChild(this.panel);
		
		this.selectedBtn = this.panel.selectBtn;
		this.titleTxt = this.panel.titleTxt;
		this.contentSpt = this.panel.contentSpt;
		this.frameSpt = this.panel.frameSpt;
		this.bgSpt = this.panel.bgSpt;
		this.flashingCallBackHandler = null;
		this.selectedImg = this.panel.selectedImg;
	}
	
	/**
	 * 初始化numUI
	 * @param	imgAry	图片数组
	 */
	public function initIcon(imgAry:Array):void
	{
		if (!imgAry) return;
		this.clearIcon();
		var count:int = imgAry.length;
		if (count > GameConstant.NUM_MAX) count = GameConstant.NUM_MAX;
		for (var i:int = 0; i < count; ++i)
		{
			var icon:Sprite = this.contentSpt.getChildByName("m" + (i + 1)) as Sprite;
			var image:Image = new Image(imgAry[i]);
			icon.addChild(image);
		}
	}
	
	/**
	 * 清空数字icon
	 */
	public function clearIcon():void
	{
		for (var i:int = 0; i < GameConstant.NUM_MAX; ++i) 
		{
			var icon:Sprite = this.contentSpt.getChildByName("m" + (i + 1)) as Sprite;
			icon.removeChildren(0, 1);
		}
	}
	
	/**
	 * 初始化iconbg
	 */
	public function initIconBg(name:String):void
	{
		this.clearIconBg();
		for (var i:int = 0; i < this._totalIndex; ++i)
		{
			var img:Image = this.bgSpt.getChildByName("bg" + (i + 1)) as Image;
			var frameImg:Image = this.frameSpt.getChildByName("frame" + (i + 1)) as Image;
			img.skin = name;
			frameImg.skin = "frame/slotsUnselectedBg.png";
		}
	}
	
	/**
	 * 清楚icon背景
	 */
	public function clearIconBg():void
	{
		for (var i:int = 0; i < GameConstant.NUM_MAX; i++) 
		{
			var img:Image = this.bgSpt.getChildByName("bg" + (i + 1)) as Image;
			var frameImg:Image = this.frameSpt.getChildByName("frame" + (i + 1)) as Image;
			img.skin = "";
			frameImg.skin = "";
		}
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
	public function start(delay:int):void
	{
		if (!this.timer) this.timer = new Timer();
		this.timer.clear(this, loopHandler);
		this.timer.loop(delay, this, loopHandler);
		if (!this.flashingTimer) this.flashingTimer = new Timer();
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
	 * 闪烁
	 */
	public function flashing(handler:Handler = null):void
	{
		if (!this.flashingTimer) this.flashingTimer = new Timer();
		this.flashingTimer.clear(this, flashingLoopHandler);
		this.flashingTimer.loop(80, this, flashingLoopHandler);
		this.flashingCallBackHandler = handler;
	}
	
	/**
	 * 循环
	 */
	private function flashingLoopHandler():void 
	{
		this.selectedImg.visible = !this.selectedImg.visible;
		this.flashingIndex++;
		if (this.flashingIndex >= 10)
		{
			this.flashingIndex = 0;
			this.flashingTimer.clear(this, flashingLoopHandler);
			if (this.flashingCallBackHandler)
				this.flashingCallBackHandler.run();
		}
	}
	
	/**
	 * 循环
	 */
	private function loopHandler():void 
	{
		this._index++;
		if (this._index > this.totalIndex - 1)
			this._index = 0;
			
		var frameImg:Image = this.frameSpt.getChildByName("frame" + (this._index + 1)) as Image;
		this.selectedImg.x = frameImg.x;
		this.selectedImg.y = frameImg.y;
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