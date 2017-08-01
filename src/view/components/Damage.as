package view.components 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.display.Text;
import laya.filters.ColorFilter;
import view.ui.Layer;
/**
 * ...伤害或者加经验（跳数字）特效
 * @author ...Kanon
 */
public class Damage 
{
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
		var spt:Sprite = new Sprite();
		var numTxt:Text = new Text();
		numTxt.font = GameConstant.GAME_FONT_NAME;
		var str:String = "-";
		var color:String = "#ff0000";
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
		spt.addChild(numTxt);
		//创建颜色滤镜
		var fliter:ColorFilter = new ColorFilter(colorMatrix)
		spt.filters = [fliter];
		spt.scale(scale, scale);
		Layer.GAME_DAMAGE.addChild(spt);
		spt.x = x;
		spt.y = y;
		
		
	}
	
}
}