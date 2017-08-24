package view.mediator 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Sprite;
import laya.events.Event;
import laya.events.Keyboard;
import laya.utils.Handler;
import laya.utils.Tween;
import model.po.EnemyPo;
import model.po.PlayerPo;
import model.po.StagePo;
import model.proxy.EnemyProxy;
import model.proxy.PlayerProxy;
import model.proxy.ResProxy;
import model.proxy.StageProxy;
import model.vo.EnemyVo;
import model.vo.PlayerVo;
import model.vo.PointVo;
import mvc.Mediator;
import mvc.Notification;
import utils.MathUtil;
import utils.Random;
import view.components.Damage;
import view.components.FloatTips;
import view.components.Shake;
import view.components.SlotsPanel;
import view.ui.GameStageLayer;
import view.ui.Layer;

/**
 * ...战斗系统中介
 * 战斗流程
 * 1.1.选择地形
 * 1.2.选择宝箱位置
 * 1.3.选择boss位置
 * 1.4.选择移动位置
 * 1.5。角色进入
 * 2.选择敌人数量
 * 3.选择敌人类型
 * 4.敌人进入
 * 5.选择攻击强度
 * 5.1攻击
 * 5.2buff攻击
 * 5.3判断升级
 * 6.选择掉落个数
 * 7.选择掉落类型
 * 8.角色出去
 * 8.1提示是否下一层
 * @author ...Kanon
 */
public class GameStageMediator extends Mediator 
{
	public static const NAME:String = "GameStageMediator";
	//ui
	private var gameStage:GameStageLayer;
	//角色数据代理
	private var playerProxy:PlayerProxy;
	//关卡数据
	private var stageProxy:StageProxy;
	//敌人数据代理
	private var enemyProxy:EnemyProxy;
	//资源数据代理
	private var resProxy:ResProxy;
	//角色数据
	private var playerVo:PlayerVo;
	//回合数
	private var roundIndex:int;
	//滚动
	private var slots:SlotsPanel;
	//是否选择了敌人数量
	private var isSelectEnemyCount:Boolean;
	//是否选择敌人类型
	private var isSelectEnemyType:Boolean;
	//是否选择了攻击力
	private var isSelectAtkIndex:Boolean;
	//敌人可选择数量
	private var enemyCanSelectCount:int;
	//当前数量
	private var curEnemySelectCount:int;
	//关卡数据
	private var curStagePo:StagePo;
	//当前关卡点
	private var curPointVo:PointVo;
	//敌人列表
	private var enemyPoList:Array;
	public function GameStageMediator() 
	{
		this.mediatorName = NAME;
		this.playerProxy = this.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
		this.stageProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
		this.enemyProxy = this.retrieveProxy(EnemyProxy.NAME) as EnemyProxy;
		this.resProxy = this.retrieveProxy(ResProxy.NAME) as ResProxy;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.INIT_FIGHT_STAGE);
		vect.push(MsgConstant.START_FIGHT);
		vect.push(MsgConstant.SELECT_STAGE_COMPLETE);
		vect.push(MsgConstant.SELECT_NEXT_POINT);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.INIT_FIGHT_STAGE:
				this.initEvent();
				this.sendNotification(MsgConstant.START_FIGHT);
				break;
			case MsgConstant.START_FIGHT:
				this.initData();
				this.resetPointsAry();
				this.initUI();
				this.gameStage.initPlayer(this.playerVo);
				this.gameStage.setPlayerProp(this.playerVo);
				break;
			case MsgConstant.SELECT_STAGE_COMPLETE:
				this.stageProxy.initStartPointVo();
				this.curPointVo = this.stageProxy.curPointVo;
				this.gameStage.updateStageBg(this.curStagePo, this.stageProxy);
				this.gameStage.miniMap.updateAllPointPassView(this.stageProxy.pointsAry, this.stageProxy.curPointVo);
				this.gameStage.miniMap.updateAllPointTypeView(this.stageProxy.pointsAry);
				this.gameStage.playerMove(250, 1000, Handler.create(this, playerMoveComplete));
				break;
			case MsgConstant.SELECT_NEXT_POINT:
				this.initData();
				this.curPointVo = this.stageProxy.curPointVo;
				this.gameStage.initPlayer(this.playerVo);
				this.gameStage.updateStageBg(this.curStagePo, this.stageProxy);
				this.gameStage.miniMap.updateAllPointPassView(this.stageProxy.pointsAry, this.stageProxy.curPointVo);
				this.gameStage.miniMap.updateAllPointTypeView(this.stageProxy.pointsAry);
				this.gameStage.playerMove(250, 1000, Handler.create(this, playerMoveComplete));
				break;
			default:
				break;
		}
	}
	
	/**
	 * 初始化事件
	 */
	private function initEvent():void
	{
		if (GameConstant.DEBUG)
		{
			Laya.stage.on(Event.CLICK, this, clickHandler);
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDownHandler);
		}
		Laya.timer.loop(1 / 60 * 1000, this, loopHandler);
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this.isSelectEnemyCount = false;
		this.isSelectEnemyType = false;
		this.isSelectAtkIndex = false;
		this.roundIndex = 0;
		this.curEnemySelectCount = 0;
		this.curStagePo = this.stageProxy.getCurStagePo();
		this.playerVo = this.playerProxy.pVo;
		this.enemyPoList = this.stageProxy.getCurStagePoEnemyPoList();
		this.enemyProxy.clearStageEnemyList();
	}
	
	/**
	 * 重置关卡点数据
	 */
	private function resetPointsAry():void
	{
		if (this.stageProxy)
			this.stageProxy.initPointsAry();
	}
	
	/**
	 * 初始化UI
	 */
	private function initUI():void
	{
		if (!this.slots) 
		{
			this.slots = new SlotsPanel();
			this.slots.visible = false;
			this.slots.selectedBtn.on(Event.MOUSE_DOWN, this, selectedBtnMouseDown);
			Layer.GAME_ALERT.addChild(this.slots);
		}
		
		if (!this.gameStage)
		{
			this.gameStage = new GameStageLayer();
			Layer.GAME_STAGE.addChild(this.gameStage);
		}
	}
	
	/**
	 * 初始化选择敌人数量
	 */
	private function initSlotsSelectEnemyCount():void
	{
		//选择敌人数量
		this.slots.visible = true;
		this.slots.selectedBtn.mouseEnabled = true;
		this.slots.startNumSlotsByAry([0, 1, 2, 3], this.playerVo.slotsDelay, 0, -5);
		this.slots.setTitle("选择敌人数量");
	}
	
	/**
	 * 初始化攻击力滚动
	 */
	private function initSlotsAtk():void
	{
		//选择攻击力
		this.isSelectAtkIndex = false;
		this.slots.visible = true;
		this.slots.selectedBtn.mouseEnabled = true;
		this.slots.startNumSlotsByAry(this.playerProxy.getPlayerAtk(), this.playerVo.slotsDelay, 0, -5);
		this.slots.setTitle("攻击强度");
	}
	
	/**
	 * 初始化选择敌人类型
	 */
	private function initSlotsSelectEnemyType():void
	{
		this.slots.visible = true;
		this.slots.selectedBtn.mouseEnabled = true;
		this.slots.startEnemySlots(this.enemyPoList, this.playerVo.slotsDelay);
		this.slots.setTitle("放入" + this.curEnemySelectCount + "个敌人/" + this.enemyCanSelectCount);
	}
	
	//event handler
	////////////////////////////////////////////////////
	////////////////////////////////////////////////////
	////////////////////////////////////////////////////
	
	/**
	 * 点击选择按钮
	 */
	private function selectedBtnMouseDown():void 
	{
		this.slots.stop();
		this.slots.selectedBtn.mouseEnabled = false;
		this.slots.flashing(Handler.create(this, flashingCompleteHandler));
	}
	
	/**
	 * 闪烁结束
	 */
	private function flashingCompleteHandler():void 
	{
		this.slots.visible = false;
		if (!this.isSelectEnemyCount) 
		{
			this.isSelectEnemyCount = true;
			this.enemyCanSelectCount = this.slots.indexValue;
			this.curEnemySelectCount++;
			if (this.enemyCanSelectCount > 0)
				this.initSlotsSelectEnemyType();
			else 
				this.gameStage.playerMove(GameConstant.GAME_WIDTH, 300, Handler.create(this, playerMoveOutComplete));
			//直接移动出舞台
		}
		else if (!this.isSelectEnemyType)
		{
			var id:int = this.slots.getSelectId();
			var ePo:EnemyPo = this.enemyProxy.getEnemyPoById(id);
			this.enemyProxy.createEnemyVo(ePo);
			if (this.curEnemySelectCount == this.enemyCanSelectCount)
			{
				//数量选择够了
				this.isSelectEnemyType = true;
				this.gameStage.initEnemy(this.enemyCanSelectCount);
				this.gameStage.initHpBar(this.enemyCanSelectCount);
				this.gameStage.updateEnemyUI(this.enemyProxy.enemyVoList);
				this.gameStage.updateEnemyHpBar(this.enemyProxy.enemyVoList);
				this.gameStage.hpBarShow(true);
				this.gameStage.enemyMove(Handler.create(this, initSlotsAtk));
			}
			else
			{
				this.curEnemySelectCount++;
				this.initSlotsSelectEnemyType();
			}
		}
		else
		{
			if (!this.isSelectAtkIndex)
			{
				this.isSelectAtkIndex = true;
				this.gameStage.playerAtk(Handler.create(this, playerAtkComplete));
			}
		}
	}
	
	/**
	 * 角色移动结束
	 */
	private function playerMoveComplete():void
	{
		this.initSlotsSelectEnemyCount();
	}
	
	private function playerMoveOutComplete():void 
	{
		//下一关
		//TODO 选择下一个关卡点
		//胜利
		
		if (this.curPointVo.type == PointVo.DOWN_FLOOR)
		{
			//弹出对话框
		}
		else if (this.curPointVo.type == PointVo.UP_FLOOR)
		{
			//弹出对话框
		}
		else
		{
			this.sendNotification(MsgConstant.SHOW_SELECT_NEXT_POINT_LAYER);
		}
		
		//选择下楼梯
		//关卡数累加
		
		//this.stageProxy.curPoints++;
		//if (this.stageProxy.curPoints > this.stageProxy.getCurStagePointsCount())
		//{
			//this.stageProxy.curPoints = 1;
			//this.stageProxy.curLevel++;
			//if (this.stageProxy.curLevel > this.stageProxy.totalLevel)
			//{
				//trace("通关了");
				////TODO 过关动画
				//return;
			//}
		//}
		//this.sendNotification(MsgConstant.START_FIGHT);
	}
	
	/**
	 * 角色攻击动作结束
	 */
	private function playerAtkComplete():void
	{
		var enemy:Sprite = this.gameStage.getEnemyByIndex(this.roundIndex);
		var playerPo:PlayerPo = this.playerProxy.getPlayerPoByLevel(this.playerVo.level);
		//伤害
		//trace("伤害", this.slots.indexValue,  playerPo.atk);
		var hurt:Number = MathUtil.round(this.slots.indexValue * this.playerProxy.getAktByLevel());
		trace("hurt", hurt);
		this.gameStage.enemyHurt(this.roundIndex, hurt == 0, Handler.create(this, enemyHurtComplete));
		if (hurt == 0)
		{
			Damage.showDamageByStr("miss!", enemy.x, enemy.y - 100, 1.5);
		}
		else
		{
			var eVo:EnemyVo = this.enemyProxy.getEnemyVoByIndex(this.roundIndex);
			eVo.hp -= hurt;
			Damage.show(hurt, enemy.x, enemy.y - 100, 1.5);
			Shake.shake(Layer.GAME_STAGE);
		}
		this.gameStage.updateEnemyHpBar(this.enemyProxy.enemyVoList);
	}
	
	/**
	 * 敌人受伤还动作结束
	 */
	private function enemyHurtComplete():void
	{
		var eVo:EnemyVo = this.enemyProxy.getEnemyVoByIndex(this.roundIndex);
		var enemy:Sprite = this.gameStage.getEnemyByIndex(this.roundIndex);
		var isDead:Boolean = false;
		var isLevelUp:Boolean = false;
		if (eVo.hp <= 0)
		{
			//TODO show dead;
			isDead = true;
			this.gameStage.removeEnemyByIndex(this.roundIndex);
			this.gameStage.removeHpBarByIndex(this.roundIndex);
			this.enemyProxy.removeEnemyVoById(eVo.id);
			var curLevel:int = this.playerVo.level;
			this.playerProxy.addExp(eVo.enemyPo.exp);
			this.gameStage.playerExpBar.setValue(this.playerVo.curExp);
			FloatTips.show("+" + eVo.enemyPo.exp + "EXP", enemy.x, enemy.y, enemy.y - 100);
			if (curLevel < this.playerVo.level)
			{
				isLevelUp = true;
				//TODO 升级效果
				this.gameStage.playerHpBar.setValue(this.playerVo.curHp);
				this.gameStage.playerHpBar.setMaxValue(this.playerVo.maxHp);
				
				this.gameStage.playerExpBar.setValue(this.playerVo.curExp);
				this.gameStage.playerExpBar.setMaxValue(this.playerVo.maxExp);
				this.gameStage.setPlayerProp(this.playerVo);
				
				FloatTips.show("LEVEL UP!", this.gameStage.player.x, this.gameStage.player.y, this.gameStage.player.y - 100);
				Tween.to(this.gameStage.player, {x:this.gameStage.player.x}, 1, null, Handler.create(this, function():void
				{
					this.enemyHurt(isDead);
				}), 1200);
			}
		}
		if(!isLevelUp) this.enemyHurt(isDead);
	}
	
	/**
	 * 敌人受伤
	 * @param	isDead	是否死亡
	 */
	private function enemyHurt(isDead:Boolean):void
	{
		if (this.enemyProxy.getCurStageEnemyCount() == 0)
		{
			//all dead;
			this.gameStage.hpBarShow(false);
			this.gameStage.playerMove(GameConstant.GAME_WIDTH, 3000, Handler.create(this, playerMoveOutComplete));
		}
		else
		{
			if (this.roundIndex > this.enemyProxy.getCurStageEnemyCount() - 1) this.roundIndex = 0;
			this.gameStage.enemyAtk(this.roundIndex, Handler.create(this, enemyAtkComplete));
		}
		
		if (!isDead)
		{
			this.roundIndex++;
			if (this.roundIndex > this.enemyProxy.getCurStageEnemyCount() - 1) this.roundIndex = 0;
		}
	}
	
	/**
	 * 敌人进攻结束
	 */
	private function enemyAtkComplete():void
	{
		//TODO 敌人攻击力随机
		var eVo:EnemyVo = this.enemyProxy.getEnemyVoByIndex(this.roundIndex);
		//trace("受伤害", this.slots.indexValue,  eVo.enemyPo.atk);
		var hurt:Number = MathUtil.round(this.slots.indexValue * eVo.enemyPo.atk);
		//trace("hurt", hurt);
		this.playerVo.curHp -= hurt;
		this.gameStage.playerHpBar.setValue(this.playerVo.curHp);
		this.gameStage.playerHurt(hurt == 0, Handler.create(this, playerHurtComplete));
		if (hurt == 0)
		{
			Damage.showDamageByStr("miss!", this.gameStage.player.x, this.gameStage.player.y - 100, 1.5);
		}
		else
		{
			Damage.show(hurt, this.gameStage.player.x, this.gameStage.player.y - 100, 1.5);
			Shake.shake(Layer.GAME_STAGE);
		}
	}
	
	/**
	 * 角色受伤动作结束
	 */
	private function playerHurtComplete():void
	{
		//弹出选择攻击界面
		this.initSlotsAtk();
		this.gameStage.arrowImg.visible = false;
	}
	
	/**
	 * 游戏循环
	 */
	private function loopHandler():void 
	{
		Damage.update();
		FloatTips.update();
		Shake.update();
		//shake
	}
	
	/**
	 * 点击事件
	 */
	private function clickHandler(event:Event):void 
	{
		//trace(1 * 1.2);
		//Damage.floatStr("+10EXP", event.stageX, event.stageY, 1.5);
		//Damage.floatStr("LEVEL UP!", this.gameStage.player.x, this.gameStage.player.y - 100, 1.5, 800);
		//Damage.floatStr("+10EXP", event.stageX, event.stageY, 1.5);
		//FloatTips.show("LEVEL UP!", this.gameStage.player.x, this.gameStage.player.y, this.gameStage.player.y - 100);
	}
	
	private function onKeyDownHandler(event:Event):void 
	{
		if (!this.gameStage) return;
		if (event.keyCode == Keyboard.A) this.gameStage.playerAtk(Handler.create(this, playerAtkComplete));
		if (event.keyCode == Keyboard.D) this.gameStage.playerHurt();
		if (event.keyCode == Keyboard.Z) this.gameStage.enemyAtk(Random.randint(0, 2));
		if (event.keyCode == Keyboard.X) this.gameStage.enemyHurt(Random.randint(0, 2));
	}
}
}