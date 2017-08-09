package view.components 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.display.Text;
import laya.ui.Image;
import model.vo.PlayerVo;

/**
 * ...角色进度条
 * @author ...Kanon
 */
public class PlayerBar extends Sprite 
{
	//底层颜色
	private var bg:Image;
	//框
	private var bar:Image;
	//遮罩
	private var maskBg:Image;
	private var maskWidth:Number;
	//数字
	private var numTxt:Text;
	//当前值
	private var curValue:int;
	//总值
	private var maxValue:int;
	public function PlayerBar() 
	{
		this.curValue = 0;
		this.maxValue = 1;
	}
	
	/**
	 * 初始化UI
	 * @param	bgName		底
	 * @param	barName		条框
	 */
	public function initUI(bgName:String, barName:String):void
	{
		if (!this.bg)
		{
			this.bg = new Image();
			this.bg.x = 32;
			this.bg.y = 16;
			this.addChild(this.bg);
		}
		
		if (!this.maskBg)
		{
			this.maskBg = new Image("bar/barMask.png");
			if (this.bg) this.bg.mask = this.maskBg
			this.maskWidth = this.maskBg.width;
		}
		
		if(!this.numTxt)
		{
			this.numTxt = new Text();
			this.numTxt.font = GameConstant.GAME_FONT_NAME;
			this.numTxt.color = "#FFFFFF";	
			this.numTxt.x = 55;
			this.numTxt.y = 17;
			this.numTxt.scale(.6, .6);
			this.numTxt.text = "0/0";
			this.addChild(this.numTxt);
		}
		
		if (!this.bar)
		{
			this.bar = new Image();
			this.addChild(this.bar);
		}
		
		this.bg.skin = bgName;
		this.bar.skin = barName;
	}
	
	/**
	 * 设置当前值
	 * @param	value	当前值
	 */
	public function setValue(value:int):void
	{
		if (value < 0) value = 0;
		this.curValue = value;
		var p:Number = Number(this.curValue) / Number(this.maxValue);
		if (this.maskBg) this.maskBg.width = p * this.maskWidth;
		if (this.numTxt) this.numTxt.text = Math.round(this.curValue) + "/" + this.maxValue;
	}
	
	/**
	 * 设置总值
	 * @param	maxValue	总值
	 */
	public function setMaxValue(maxValue:int):void
	{
		this.maxValue = maxValue;
		if (this.numTxt) this.numTxt.text = Math.round(this.curValue) + "/" + this.maxValue;
	}
}
}