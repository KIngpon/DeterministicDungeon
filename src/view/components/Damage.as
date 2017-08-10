package view.components 
{
import laya.display.Sprite;
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
		numTxt.font = GameConstant.GAME_FONT_NAME;
		var colorMatrix:Array = [1, 0, 0, 0, 0, //R
								 0, 0, 0, 0, 0, //G
								 0, 0, 0, 0, 0, //B
								 0, 0, 0, 1, 0, //A
								];
		numTxt.text = str;
		this.addChild(numTxt);
		//创建颜色滤镜
		var fliter:ColorFilter = new ColorFilter(colorMatrix)
		this.filters = [fliter];
	}
	
	/**
	 * 根据数字显示伤害
	 * @param	num		数字
	 * @param	flag	加减
	 */
	public function setDamageByNum(num:int, flag:Boolean):void
	{
		var numTxt:Text = new Text();
		numTxt.font = GameConstant.GAME_FONT_NAME;
		var str:String = "-";
		var colorMatrix:Array = [1, 0, 0, 0, 0, //R
								 0, 0, 0, 0, 0, //G
								 0, 0, 0, 0, 0, //B
								 0, 0, 0, 1, 0, //A
								];
		if (flag) 
		{
			str = "+";
			colorMatrix= [0, 0, 0, 0, 0, //R
						  1, 0, 0, 0, 0, //G
						  0, 0, 0, 0, 0, //B
						  0, 0, 0, 1, 0, //A
						 ];
		}
		numTxt.text = str + num.toString();
		this.addChild(numTxt);
		//创建颜色滤镜
		var fliter:ColorFilter = new ColorFilter(colorMatrix)
		this.filters = [fliter];
	}
	
	public function update():void
	{
		this.x += this.vx;
		this.y += this.vy;
		this.vy += this.g;
	}
}