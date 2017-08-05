package view.ui
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Label;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
import model.vo.EnemyVo;

/**
 * ...战斗场景
 * @author ...Kanon
 */
public class GameStageLayer extends Sprite
{
	//玩家
	public var player:Sprite;
	//敌人列表
	public var enemyAry:Array = [];
	
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
		this.player.graphics.drawRect(-this.player.width / 2, -this.player.height, this.player.width, this.player.height, "#ff0000");
		this.addChild(this.player);
		this.player.x = -this.player.width / 2;
		this.player.y = GameConstant.ROLE_POS_Y;
	}
	
	/**
	 * 初始化角色
	 */
	public function initPlayer():void
	{
		if (!this.player) return;
		this.player.x = -this.player.width / 2;
		this.player.y = GameConstant.ROLE_POS_Y;
	}
	
	/**
	 * 初始化敌人
	 * @param	num		敌人数量
	 */
	public function initEnemy(num:int):void
	{
		this.removeAllEnemy();
		var gap:Number = 30;
		var startX:Number = Laya.stage.width;
		if (num > GameConstant.ENEMY_NUM) num = GameConstant.ENEMY_NUM;
		for (var i:int = 0; i < num; i++)
		{
			var enemy:Sprite = new Sprite();
			enemy.width = 70;
			enemy.height = 120;
			enemy.graphics.drawRect(-enemy.width / 2, -enemy.height, enemy.width, enemy.height, "#ff00ff");
			enemy.x = startX + i * (enemy.width + gap) + enemy.width / 2;
			enemy.y = GameConstant.ROLE_POS_Y;
			this.addChild(enemy);
			this.enemyAry.push(enemy);
			
			var nameTxt:Label = new Label();
			nameTxt.name = "nameLabel";
			nameTxt.color = "#CCFFAA";
			nameTxt.fontSize = 15;
			nameTxt.x = -enemy.width / 2;
			enemy.addChild(nameTxt);
			
			var hpTxt:Label = new Label();
			hpTxt.name = "hpTxt";
			hpTxt.color = "#CCFFAA";
			hpTxt.fontSize = 25;
			hpTxt.x = -enemy.width / 2;
			hpTxt.y = nameTxt.y + 50;
			enemy.addChild(hpTxt);
		}
	}
	
	/**
	 * 初始化敌人UI
	 * @param	enemyVoList	敌人数据列表
	 */
	public function updateEnemyUI(enemyVoList:Array):void
	{
		var count:int = enemyVoList.length;
		for (var i:int = 0; i < count; i++) 
		{
			var eVo:EnemyVo = enemyVoList[i];
			var enemy:Sprite = this.enemyAry[i];
			var nameTxt:Label = enemy.getChildByName("nameLabel") as Label;
			nameTxt.text = eVo.enemyPo.name;
			var hpTxt:Label = enemy.getChildByName("hpTxt") as Label;
			hpTxt.text = eVo.hp;
		}
	}
	
	/**
	 * 删除所有敌人
	 */
	public function removeAllEnemy():void
	{
		var count:int = this.enemyAry.length;
		for (var i:int = count - 1; i >= 0; --i)
		{
			var enemy:Sprite = this.enemyAry[i];
			enemy.removeSelf();
			this.enemyAry.splice(i, 1);
		}
	}
	
	/**
	 * 角色移动
	 * @param	targetX		目标位置
	 * @param	duration	移动时间
	 * @param	complete	移动结束
	 */
	public function playerMove(targetX:Number, duration:int=1000, complete:Handler = null):void
	{
		if (!this.player) return;
		Tween.to(this.player, {x: targetX}, duration, Ease.linearNone, complete);
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
				Tween.to(enemy, {x: enemy.x - 300}, 1000, Ease.linearNone, complete);
			else
				Tween.to(enemy, {x: enemy.x - 300}, 1000, Ease.linearNone);
		}
	}
	
	/**
	 * 角色攻击
	 * @param	complete	攻击结束
	 */
	public function playerAtk(complete:Handler = null):void
	{
		if (!this.player) return;
		Tween.to(this.player, {x: this.player.x + 50}, 100, Ease.strongOut);
		Tween.to(this.player, {x: this.player.x}, 200, Ease.strongOut, complete, 100);
	}
	
	/**
	 * 角色受伤
	 * @param	isMiss		是否miss
	 * @param	complete	受伤动作结束
	 */
	public function playerHurt(isMiss:Boolean = false, complete:Handler = null):void
	{
		if (!this.player) return;
		if (!isMiss)
		{
			Tween.to(this.player, {x: this.player.x - 50}, 100, Ease.strongOut);
			Tween.to(this.player, {x: this.player.x}, 200, Ease.strongOut, null, 100);
			Tween.to(this.player, {x: this.player.x}, 300, Ease.strongOut, complete, 200);
		}
		else
		{
			Tween.to(this.player, {x: this.player.x}, 500, Ease.linearNone, complete);
		}
	}
	
	/**
	 * 单个敌人攻击
	 * @param	index		位置索引
	 * @param	complete	动作结束
	 */
	public function enemyAtk(index:int, complete:Handler = null):void
	{
		if (!this.enemyAry) return;
		if (index < 0 || index > this.enemyAry.length - 1) return;
		var enemy:Sprite = this.enemyAry[index];
		if (!enemy) return;
		Tween.to(enemy, {x: enemy.x - 50}, 100, Ease.strongOut);
		Tween.to(enemy, {x: enemy.x}, 200, Ease.strongOut, complete, 100);
	}
	
	/**
	 * 单个敌人受伤
	 * @param	index		位置索引
	 * @param	isMiss		是否miss
	 * @param	complete	动作结束
	 */
	public function enemyHurt(index:int, isMiss:Boolean = false, complete:Handler = null):void
	{
		if (!this.enemyAry) return;
		if (index < 0 || index > this.enemyAry.length - 1) return;
		var enemy:Sprite = this.enemyAry[index];
		if (!enemy) return;
		if (!isMiss)
		{
			Tween.to(enemy, {x: enemy.x + 50}, 100, Ease.strongOut);
			Tween.to(enemy, {x: enemy.x}, 200, Ease.strongOut, null, 100);
			Tween.to(enemy, {x: enemy.x}, 300, Ease.strongOut, complete, 200);
		}
		else
		{
			Tween.to(enemy, {x: enemy.x}, 500, Ease.strongOut, complete);
		}
	}
	
	/**
	 * 根据索引获取敌人
	 * @param	index		位置索引
	 * @return	敌人
	 */
	public function getEnemyByIndex(index:int):Sprite
	{
		if (!this.enemyAry) return null;
		if (index < 0 || index > this.enemyAry.length - 1) return null;
		var enemy:Sprite = this.enemyAry[index];
		return enemy;
	}
	
	/**
	 * 根据索引删除敌人
	 * @param	index	索引
	 */
	public function removeEnemyByIndex(index:int):void
	{
		if (!this.enemyAry) return;
		if (index < 0 || index > this.enemyAry.length - 1) return;
		var enemy:Sprite = this.enemyAry[index];
		enemy.removeSelf();
		this.enemyAry.splice(index, 1);
	}
}
}