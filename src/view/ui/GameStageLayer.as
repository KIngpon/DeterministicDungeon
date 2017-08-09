package view.ui
{
import config.GameConstant;
import laya.display.Sprite;
import laya.ui.Image;
import laya.ui.Label;
import laya.utils.Ease;
import laya.utils.Handler;
import laya.utils.Tween;
import model.po.StagePo;
import model.proxy.StageProxy;
import model.vo.EnemyVo;
import model.vo.PlayerVo;
import view.components.HpBar;
import view.components.PlayerBar;

/**
 * ...战斗场景
 * @author ...Kanon
 */
public class GameStageLayer extends Sprite
{
	//玩家
	public var player:Sprite;
	//敌人列表
	private var enemyAry:Array = [];
	//血条数组
	private var hpBarAry:Array = [];
	private var allHpBarAry:Array = [];
	//箭头
	public var arrowImg:Image;
	//前景
	private var fontBg:Image;
	private var bgBg:Image;
	//ui的背景
	private var uiBg:Image;
	//人物血条
	public var playerHpBar:PlayerBar;
	//人物经验条
	public var playerExpBar:PlayerBar;
	public function GameStageLayer()
	{
		this.initUI();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		this.bgBg = new Image();
		this.fontBg = new Image();
		this.addChild(this.bgBg);
		this.addChild(this.fontBg);
		this.bgBg.scale(1.55, 1.55);
		this.fontBg.scale(1.55, 1.55);
		this.bgBg.anchorX = .5;
		this.bgBg.x = GameConstant.GAME_WIDTH / 2;
		this.fontBg.anchorX = .5;
		this.fontBg.x = GameConstant.GAME_WIDTH / 2;
		this.uiBg = new Image("frame/uiBg.png");
		this.addChild(this.uiBg);
		this.uiBg.anchorX = .5;
		this.uiBg.x = GameConstant.GAME_WIDTH / 2;
		this.uiBg.scale(1.53, 1.53);
		this.uiBg.y = 510;
		
		this.player = new Sprite();
		this.player.width = 70;
		this.player.height = 120;
		this.player.graphics.drawRect(-this.player.width / 2, -this.player.height, this.player.width, this.player.height, "#ff0000");
		this.addChild(this.player);
		this.player.x = -this.player.width / 2;
		this.player.y = GameConstant.ROLE_POS_Y;
		
		if (!this.arrowImg) this.arrowImg = new Image("comp/roundArrow.png");
		this.arrowImg.anchorX = .5;
		this.arrowImg.x = this.player.x;
		this.arrowImg.y = this.player.y + 20;
		Layer.GAME_UI.addChild(this.arrowImg);
		this.arrowImg.visible = false;
		this.arrowImgMove();
		
		//血条
		this.playerHpBar = new PlayerBar();
		this.playerHpBar.initUI("bar/playerHp.png", "bar/playerHpBar.png");
		this.playerHpBar.x = 4;
		this.playerHpBar.y = 520;
		this.addChild(this.playerHpBar);
		
		//经验条
		this.playerExpBar = new PlayerBar();
		this.playerExpBar.initUI("bar/playerExp.png", "bar/playerExpBar.png");
		this.playerExpBar.x = this.playerHpBar.x;
		this.playerExpBar.y = 583;
		this.addChild(this.playerExpBar);
		
		var lineBg:Image = new Image("frame/line.png");
		lineBg.x = 225;
		lineBg.y = 530;
		this.addChild(lineBg);
		
		
		var levelBg:Image = new Image("frame/levelBg.png");
		levelBg.x = 275;
		levelBg.y = 590;
		this.addChild(levelBg);

	}
	
	/**
	 * 箭头移动
	 */
	private function arrowImgMove():void 
	{
		Tween.to(this.arrowImg, { y: this.arrowImg.y - 10 }, 200, Ease.circOut);
		Tween.to(this.arrowImg, { y: this.arrowImg.y }, 200, Ease.circOut, Handler.create(this, arrowImgMove), 100);
	}
	
	/**
	 * 初始化角色
	 */
	public function initPlayer(pVo:PlayerVo):void
	{
		if (!this.player || !pVo) return;
		this.player.x = -this.player.width / 2;
		this.player.y = GameConstant.ROLE_POS_Y;
		this.arrowImg.visible = false;
		
		this.playerHpBar.setMaxValue(pVo.maxHp);
		this.playerHpBar.setValue(pVo.curHp);
		this.playerExpBar.setMaxValue(pVo.maxExp);
		this.playerExpBar.setValue(pVo.curExp);
	}
	
	/**
	 * 初始化敌人
	 * @param	num		敌人数量
	 */
	public function initEnemy(num:int):void
	{
		this.removeAllEnemy();
		var gap:Number = 60;
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
		}
	}
	
	/**
	 * 初始化血条
	 * @param	num		数量
	 */
	public function initHpBar(num:int):void
	{
		this.removeAllHpBar();
		var gap:Number = 15;
		var startX:Number = 660;
		if (num > GameConstant.ENEMY_NUM) num = GameConstant.ENEMY_NUM;
		for (var i:int = 0; i < num; i++)
		{
			var hpBar:HpBar = new HpBar();
			hpBar.x = startX + i * (hpBar.width + gap);
			hpBar.y = 565;
			hpBar.pivotX = hpBar.width / 2;
			hpBar.pivotY = hpBar.height / 2;
			hpBar.scale(0, 0);
			this.addChild(hpBar);
			this.hpBarAry.push(hpBar);
			this.allHpBarAry.push(hpBar);
		}
	}
	
	/**
	 * 血条显示效果
	 * @param	flag	显示或隐藏
	 */
	public function hpBarShow(flag:Boolean):void
	{
		if (!this.allHpBarAry) return;
		var count:int = this.allHpBarAry.length;
		for (var i:int = 0; i < count; i++) 
		{
			var hpBar:HpBar = this.allHpBarAry[i];
			if (flag) Tween.to(hpBar, { scaleX:1, scaleY:1 }, 200, Ease.circOut);
			else Tween.to(hpBar, { y:hpBar.y + 150 }, 350, Ease.circIn, null, 200 * (3 - i));
		}
	}
	
	/**
	 * 更新地图背景
	 * @param	stagePo		关卡数据
	 * @param	stageProxy	关卡数据代理
	 */
	public function updateStageBg(stagePo:StagePo, stageProxy:StageProxy):void
	{
		if (!stagePo || !stageProxy) return;
		trace("stagePo.level", stagePo.level);
		trace("stagePo.points", stagePo.points);
		trace(" stageProxy.getCurStagePointsCount()",  stageProxy.getCurStagePointsCount());
		this.bgBg.skin = "stage/" + "stage" + stagePo.level + "/stageBg.png";
		this.fontBg.skin = "stage/" + "stage" + stagePo.level + "/stageBg1.png";
		//var scale:Number = GameConstant.GAME_WIDTH / this.bgBg.width;
		//trace("GameConstant.GAME_WIDTH", GameConstant.GAME_WIDTH);
		//trace("this.bgBg.width", this.bgBg.width);
		//this.bgBg.width = GameConstant.GAME_WIDTH;
		//this.bgBg.height *= scale; 
		if (stagePo.points == 1)
		{
			
		}
		else if (stagePo.points == stageProxy.getCurStagePointsCount())
		{
			
		}
		else
		{
			
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
			var hpBar:HpBar = this.allHpBarAry[i];
			hpBar.nameTxt.text = eVo.enemyPo.name;
			hpBar.setIconByEnemyNo(eVo.no);
		}
	}
	
	/**
	 * 更新敌人血条数据
	 * @param	enemyVoList		敌人数据列表
	 */
	public function updateEnemyHpBar(enemyVoList:Array):void
	{
		var count:int = enemyVoList.length;
		for (var i:int = 0; i < count; i++) 
		{
			var eVo:EnemyVo = enemyVoList[i];
			var hpBar:HpBar = this.hpBarAry[i];
			hpBar.setMaxHp(eVo.enemyPo.hp);
			hpBar.setHp(eVo.hp);
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
	 * 删除所有血条
	 */
	public function removeAllHpBar():void
	{
		var count:int = this.allHpBarAry.length;
		for (var i:int = count - 1; i >= 0; --i)
		{
			var hpBar:HpBar = this.allHpBarAry[i];
			hpBar.removeSelf();
			this.allHpBarAry.splice(i, 1);
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
		this.arrowImg.visible = false;
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
				Tween.to(enemy, {x: enemy.x - 450}, 1000, Ease.linearNone, complete);
			else
				Tween.to(enemy, {x: enemy.x - 450}, 1000, Ease.linearNone);
		}
	}
	
	/**
	 * 角色攻击
	 * @param	complete	攻击结束
	 */
	public function playerAtk(complete:Handler = null):void
	{
		if (!this.player) return;
		this.arrowImg.visible = true;
		this.arrowImg.x = this.player.x;
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
			Tween.to(this.player, {x: this.player.x}, 500, Ease.strongOut, complete, 200);
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
		this.arrowImg.visible = true;
		this.arrowImg.x = enemy.x;
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
			Tween.to(enemy, {x: enemy.x}, 500, Ease.strongOut, complete, 200);
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
	
	/**
	 * 根据索引获取血条
	 * @return		血条UI
	 */
	public function getHpBarByIndex(index:int):HpBar
	{
		if (!this.hpBarAry) return null;
		if (index < 0 || index > this.hpBarAry.length - 1) return null;
		var hpBar:HpBar = this.hpBarAry[index];
		return hpBar;
	}
	
	/**
	 * 根据索引删除血条
	 * @param	index	索引
	 */
	public function removeHpBarByIndex(index:int):void
	{
		if (!this.hpBarAry) return;
		if (index < 0 || index > this.hpBarAry.length - 1) return;
		var hpBar:HpBar = this.hpBarAry[index];
		this.hpBarAry.splice(index, 1);
	}
}
}