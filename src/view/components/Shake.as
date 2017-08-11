package view.components 
{
import laya.display.Sprite;
import utils.Random;
/**
 * ...晃动
 * @author Kanon
 */
public class Shake 
{
	private static var target:Sprite;
	private static var delay:int;
	private static var shakeDelta:Number;
	private static var targetY:Number;
	private static var targetX:Number;
	public function Shake() 
	{
		
	}
	
	/**
	 * 晃动
	 * @param	target		目标
	 * @param	delay		时间
	 * @param	shakeDelta	幅度
	 */
	public static function shake(target:Sprite, delay:int = 5, shakeDelta:Number = 3):void
	{
		Shake.target = target;
		Shake.targetY = target.y;
		Shake.targetX = target.x;
		Shake.delay = delay;
		Shake.shakeDelta = shakeDelta;
	}
	
	
	public static function update():void
	{
		if (Shake.target)
		{
			Shake.delay--;
			if (Shake.delay > 0)
			{
				Shake.target.x += Shake.shakeDelta * Random.randint(-2, 2);
				Shake.target.y += Shake.shakeDelta * Random.randint(-1, 1);
			}
			else
			{
				Shake.target.x = Shake.targetX;
				Shake.target.y = Shake.targetY;
				Shake.delay = 0;
			}
		}
	}
}
}