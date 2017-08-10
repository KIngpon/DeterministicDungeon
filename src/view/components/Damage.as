package view.components 
{
import laya.display.Sprite;
import laya.display.Text;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
import utils.Random;
import view.ui.Layer;
/**
 * ...伤害或者加经验（跳数字）特效
 * @author ...Kanon
 */
public class Damage 
{
	//伤害列表
	private static var damageAry:Array = [];
	
	/**
	 * 显示伤害
	 * @param	num		伤害数字
	 * @param	x		x位置
	 * @param	y		y位置
	 * @param	scale	缩放
	 * @param	flag	true增加或false减少
	 */
	public static function show(num:int, x:Number, y:Number, scale:int=1, flag:Boolean = false):void
	{
		var spt:DamageNum = new DamageNum();
		spt.setDamageByNum(num, flag);
		Layer.GAME_DAMAGE.addChild(spt);
		spt.x = x;
		spt.y = y;
		spt.scale(scale, scale);
		spt.vx = Random.randnum(-2, 2);
		spt.vy = -5 + Random.randnum(-1, 1);
		damageAry.push(spt);
	}
	
	/**
	 * 根据字符串显示伤害
	 * @param	str		字符串
	 * @param	x		x位置
	 * @param	y		y位置
	 * @param	scale	缩放
	 */
	public static function showDamageByStr(str:String, x:Number, y:Number, scale:int = 1):void
	{
		var spt:DamageNum = new DamageNum();
		spt.setDamageByStr(str);
		Layer.GAME_DAMAGE.addChild(spt);
		spt.x = x;
		spt.y = y;
		spt.scale(scale, scale);
		spt.vx = Random.randnum(-2, 2);
		spt.vy = -5 + Random.randnum(-1, 1);
		damageAry.push(spt);
	}
	
	/**
	 * 飘字
	 * @param	str		内容
	 * @param	x		x位置
	 * @param	y		y位置
	 * @param	scale	缩放
	 * @param	d		运行时间
	 */
	public static function floatStr(str:String, x:Number, y:Number, scale:int = 1, d:int = 1200):void
	{
		var txt:Text = new Text();
		txt.font = GameConstant.GAME_FONT_NAME;
		txt.text = str;
		Layer.GAME_DAMAGE.addChild(txt);
		txt.x = x;
		txt.y = y;
		txt.scale(scale, scale);
		Tween.to(txt, { y: txt.y - 70 }, d, Ease.expoOut, Handler.create(this, function():void
		{
			Tween.to(txt, { alpha: 0 }, 300, Ease.expoOut, Handler.create(this, function():void
			{
				txt.removeSelf();
			}));
		}));
	}
	
	/**
	 * 更新
	 */
	public static function update():void
	{
		for (var i:int = 0; i < damageAry.length; i++) 
		{
			var spt:DamageNum = damageAry[i];
			spt.update();
		}
		
		for (var i:int = 0; i < damageAry.length; i++) 
		{
			var spt:DamageNum = damageAry[i];
			if (spt.y >= GameConstant.GAME_HEIGHT)
			{
				spt.removeSelf();
				damageAry.splice(i, 1);
			}
		}
	}
	
}
}
import config.GameConstant;
import laya.display.Sprite;
import laya.display.Text;
import laya.filters.ColorFilter;

class DamageNum extends Sprite
{
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var g:Number = .6;
	public function DamageNum():void
	{
		
	}
	
	/**
	 * 根据文本内容显示文字
	 * @param	str		内容
	 */
	public function setDamageByStr(str:String):void
	{
		var numTxt:Text = new Text();
		numTxt.font = GameConstant.GAME_RED_FONT_NAME;
		numTxt.text = str;
		this.addChild(numTxt);
	}
	
	/**
	 * 根据数字显示伤害
	 * @param	num		数字
	 * @param	flag	加减
	 */
	public function setDamageByNum(num:int, flag:Boolean):void
	{
		var numTxt:Text = new Text();
		numTxt.font = GameConstant.GAME_RED_FONT_NAME;
		var str:String = "-";
		if (flag) 
		{
			numTxt.font = GameConstant.GAME_FONT_NAME
			str = "+";
		}
		numTxt.text = str + num.toString();
		this.addChild(numTxt);
	}
	
	public function update():void
	{
		this.x += this.vx;
		this.y += this.vy;
		this.vy += this.g;
	}
}