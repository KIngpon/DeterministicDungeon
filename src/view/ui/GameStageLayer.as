package view.ui 
{
import config.GameConstant;
import laya.display.Sprite;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
/**
 * ...战斗场景
 * @author ...Kanon
 */
public class GameStageLayer extends Sprite 
{
	//玩家
	public var player:Sprite;
	//敌人列表
	public var enemyAry:Array;
	public function GameStageLayer() 
	{
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		this.player = new Sprite();
		this.player.width = 70;
		this.player.height = 120;
		this.player.graphics.drawRect( -this.player.width / 2, -this.player.height, 
										this.player.width, this.player.height, "#ff0000");
		this.addChild(this.player);
		this.player.x = -this.player.width / 2;
		this.player.y = GameConstant.ROLE_POS_Y;
		
		this.enemyAry = [];
		var gap:Number = 30;
		var startX:Number = Laya.stage.width;
		for (var i:int = 0; i < GameConstant.ENEMY_NUM; i++) 
		{
			var enemy:Sprite = new Sprite();
			enemy.width = 70;
			enemy.height = 120;
			enemy.graphics.drawRect( -enemy.width / 2, -enemy.height, 
									  enemy.width, enemy.height, "#ff00ff");
			enemy.x = startX + i * (enemy.width + gap) + enemy.width / 2;
			enemy.y = GameConstant.ROLE_POS_Y;
			this.addChild(enemy);
			this.enemyAry.push(enemy);
		}
	}
	
	/**
	 * 角色移动
	 * @param	targetX		目标位置
	 * @param	complete	移动结束
	 */
	public function playerMove(targetX:Number, complete:Handler = null):void
	{
		if (!this.player) return;
		Tween.to(this.player, { x: targetX}, 1000, Ease.linearNone, complete);
	}
	
	/**
	 * 敌人移动
	 * @param	complete	移动结束
	 */
	public function enemyMove(complete:Handler = null):void
	{
		var count:int = this.enemyAry.length;
		for (var i:int = 0; i < count; ++i) 
		{
			var enemy:Sprite = this.enemyAry[i];
			if (i == 0) 
				Tween.to(enemy, { x: enemy.x - 300}, 1000, Ease.linearNone, complete);
			else
				Tween.to(enemy, { x: enemy.x - 300}, 1000, Ease.linearNone);
		}
	}
	
	/**
	 * 角色攻击
	 * @param	complete	攻击结束
	 */
	public function playerAtk(complete:Handler = null):void
	{
		if (!this.player) return;
		Tween.to(this.player, {x:this.player.x + 50}, 100, Ease.strongOut);
		Tween.to(this.player, {x:this.player.x}, 200, Ease.strongOut, complete, 100);
	}
	
	/**
	 * 角色受伤
	 * @param	complete	受伤动作结束
	 */
	public function playerHurt(complete:Handler = null):void
	{
		if (!this.player) return;
		Tween.to(this.player, {x:this.player.x - 50}, 100, Ease.strongOut);
		Tween.to(this.player, {x:this.player.x}, 200, Ease.strongOut, null, 100);
		Tween.to(this.player, {x:this.player.x}, 300, Ease.strongOut, complete, 200);
	}
	
	/**
	 * 单个敌人受伤
	 * @param	index		位置索引
	 * @param	complete	动作结束
	 */
	public function enemyAtk(index:int, complete:Handler = null):void
	{
		if (!this.enemyAry) return;
		if (index < 0 || index > this.enemyAry.length - 1) return;
		var enemy:Sprite = this.enemyAry[index];
		if (!enemy) return;
		Tween.to(enemy, {x:enemy.x - 50}, 100, Ease.strongOut);
		Tween.to(enemy, {x:enemy.x}, 200, Ease.strongOut, complete, 100);
	}
	
	/**
	 * 单个敌人受伤
	 * @param	index		位置索引
	 * @param	complete	动作结束
	 */
	public function enemyHurt(index:int, complete:Handler = null):void
	{
		if (!this.enemyAry) return;
		if (index < 0 || index > this.enemyAry.length - 1) return;
		var enemy:Sprite = this.enemyAry[index];
		if (!enemy) return;
		Tween.to(enemy, {x:enemy.x + 50}, 100, Ease.strongOut);
		Tween.to(enemy, {x:enemy.x}, 200, Ease.strongOut, null, 100);
		Tween.to(enemy, {x:enemy.x}, 300, Ease.strongOut, complete, 200);

	}
}
}