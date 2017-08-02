package view.components 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Button;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Timer;
import laya.utils.Tween;
import ui.GameStage.SlotsPanelUI;
import utils.Random;
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
	private var _indexValue:int;
	//总数
	private var _totalCount:int;
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
	//icon数组
	private var iconAry:Array;
	//icon索引数组
	private var indexAry:Array;
	//手
	private var handImg:Image;
	private var titleTxt:Label;
	//选择按钮
	public var selectedBtn:Button;
	//标题
	public function SlotsPanel() 
	{
		this._index = 0;
		this.totalCount = 0;
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
		this.handImg = this.panel.handImg;
		this.handMoveComplete2();
	}
	
	private function handMoveComplete1():void
	{
		Tween.to(this.handImg, {y:this.handImg.y + 10}, 250, Ease.linearNone, Handler.create(this, handMoveComplete2));
	}
	
	private function handMoveComplete2():void
	{
		Tween.to(this.handImg, {y:this.handImg.y - 10}, 250, Ease.linearNone, Handler.create(this, handMoveComplete1));
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
			image.x = (icon.width -image.width) / 2;
			image.y = (icon.height -image.height) / 2;
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
	 * @param	name	图片路径
	 * @param	count	数量
	 */
	public function initIconBg(name:String, count:int):void
	{
		this.clearIconBg();
		for (var i:int = 0; i < count; ++i)
		{
			var img:Image = this.bgSpt.getChildByName("bg" + (i + 1)) as Image;
			img.skin = name;
			
			var frameImg:Image = this.frameSpt.getChildByName("frame" + (i + 1)) as Image;
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
			var icon:Sprite = this.contentSpt.getChildByName("m" + (i + 1)) as Sprite;
			img.skin = "";
			frameImg.skin = "";
			img.alpha = 1;
			frameImg.alpha = 1;
			icon.alpha = 1;
		}
	}
	
	/**
	 * 初始化数据
	 * @param	index		当前索引
	 * @param	totalCount	总数
	 */
	public function initData(totalCount:int):void
	{
		this._index = 0;
		this._totalCount = totalCount;
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
		
		for (var i:int = 0; i < this._totalCount; ++i)
		{
			if (i == this._index) continue;
			var img:Image = this.bgSpt.getChildByName("bg" + (i + 1)) as Image;
			var frameImg:Image = this.frameSpt.getChildByName("frame" + (i + 1)) as Image;
			var icon:Sprite = this.contentSpt.getChildByName("m" + (i + 1)) as Sprite;
			img.alpha = .3;
			frameImg.alpha = .3;
			icon.alpha = .3;
		}
	}
	
	
	/**
	 * 根据数字数组初始化数字icon的Slots
	 * @param	numAry		数字数组
	 * @param	delay		滚动间隔
	 */
	public function initNumSlotsByAry(numAry:Array, delay:int):void
	{
		var count:int = numAry.length;
		this.initData(count);
		this.initIconBg("frame/slotsNumBg.png", count);
		this.iconAry = [];
		this.indexAry = [];
		for (var i:int = 0; i < count; i++) 
		{
			var num:int = numAry[i];
			this.indexAry.push(num);
		}
		Random.shuffle(this.indexAry);
		count = this.indexAry.length;
		for (i = 0; i < count; ++i) 
		{
			var index:int = this.indexAry[i];
			this.iconAry.push("comp/num" + index +".png");
		}
		this.initIcon(this.iconAry);
		this.start(delay);
	}
	
	
	/**
	 * 根据数字初始化数字icon的Slots
	 * @param	num			数字 包含0
	 * @param	delay		滚动间隔
	 */
	public function initNumSlotsByNum(num:int, delay:int):void
	{
		this.initData(num);
		this.initIconBg("frame/slotsNumBg.png", num);
		this.iconAry = [];
		this.indexAry = [];
		for (var i:int = 0; i < num; i++) 
		{
			this.indexAry.push(i);
		}
		Random.shuffle(this.indexAry);
		var count:int = this.indexAry.length;
		for (i = 0; i < count; ++i) 
		{
			var index:int = this.indexAry[i];
			this.iconAry.push("comp/num" + index +".png");
		}
		this.initIcon(this.iconAry);
		this.start(delay);
	}
	
	/**
	 * 初始化图片Slots
	 * @param	imgAry		图片路径列表
	 * @param	frameBg		框的背景色路径
	 * @param	delay		滚动间隔
	 */
	public function initImageSlots(imgAry:Array, frameBg:String, delay:int):void
	{
		var count:int = imgAry.length;
		this.initData(count);
		this.initIconBg(frameBg, count);
		this.iconAry = [];
		this.indexAry = [];
		for (var i:int = 0; i < count; i++) 
		{
			this.indexAry.push(i);
		}
		Random.shuffle(this.indexAry);
		count = this.indexAry.length;
		for (i = 0; i < count; ++i) 
		{
			var index:int = this.indexAry[i];
			this.iconAry.push(imgAry[index]);
		}
		this.initIcon(this.iconAry);
		this.start(delay);
	}
	
	/**
	 * 设置标题
	 * @param	str		标题内容
	 */
	public function setTitle(str:String):void
	{
		this.titleTxt.text = str;
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
		if (this._index > this._totalCount - 1) this._index = 0;
		this._indexValue = this.indexAry[this._index];
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
	public function get totalCount():int {return _totalCount;}
	public function set totalCount(value:int):void 
	{
		_totalCount = value;
	}
	
	/**
	 * 选中的值
	 */
	public function get indexValue():int {return _indexValue; }
}
}