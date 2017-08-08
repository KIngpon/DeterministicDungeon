package view.mediator 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Sprite;
import laya.events.Event;
import laya.events.Keyboard;
import laya.utils.Handler;
import model.po.EnemyPo;
import model.po.PlayerPo;
import model.po.StagePo;
import model.proxy.EnemyProxy;
import model.proxy.PlayerProxy;
import model.proxy.StageProxy;
import model.vo.EnemyVo;
import model.vo.PlayerVo;
import mvc.Mediator;
import mvc.Notification;
import utils.MathUtil;
import utils.Random;
import view.components.Damage;
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
	private var gameStage:GameStageLayer;
	//角色数据代理
	private var playerProxy:PlayerProxy;
	//关卡数据
	private var stageProxy:StageProxy;
	//敌人数据代理
	private var enemyProxy:EnemyProxy;
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
	//敌人列表
	private var enemyPoList:Array;
	public function GameStageMediator() 
	{
		this.mediatorName = NAME;
		this.playerProxy = this.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
		this.stageProxy = this.retrieveProxy(StageProxy.NAME) as StageProxy;
		this.enemyProxy = this.retrieveProxy(EnemyProxy.NAME) as EnemyProxy;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.INIT_FIGHT_STAGE);
		vect.push(MsgConstant.START_FIGHT);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.INIT_FIGHT_STAGE:
				this.initUI();
				this.initEvent();
				this.sendNotification(MsgConstant.START_FIGHT, null);
				break;
			case MsgConstant.START_FIGHT:
				this.initData();
				if (this.playerVo.isFirstStep)
				{
					// 选择地形
					// 选择宝箱位置
					if (this.stageProxy.curLevel == 3)
					{
						// 选择boss位置
					}
				}
				else
				{
					//选择移动位置
					//角色移动
				}
				
				this.gameStage.initPlayer();
				this.gameStage.updateStageBg(this.curStagePo, this.stageProxy);
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
				this.gameStage.playerMove(GameConstant.GAME_WIDTH, 3000, Handler.create(this, playerMoveOutComplete));
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
		//胜利
		this.stageProxy.curPoints++;
		if (this.stageProxy.curPoints > this.stageProxy.getCurStagePointsCount())
		{
			this.stageProxy.curPoints = 1;
			this.stageProxy.curLevel++;
			if (this.stageProxy.curLevel > this.stageProxy.totalLevel)
			{
				trace("通关了");
				//TODO 过关动画
				return;
			}
		}
		this.sendNotification(MsgConstant.START_FIGHT);
	}
	
	/**
	 * 角色攻击动作结束
	 */
	private function playerAtkComplete():void
	{
		var enemy:Sprite = this.gameStage.getEnemyByIndex(this.roundIndex);
		var playerPo:PlayerPo = this.playerProxy.getPlayerPoByLevel(this.playerVo.level);
		//伤害
		trace("this.slots.indexValue", this.slots.indexValue);
		var hurt:Number = MathUtil.round(this.slots.indexValue * playerPo.atk);
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
		if (eVo.hp <= 0)
		{
			//TODO show dead;
			this.gameStage.removeEnemyByIndex(this.roundIndex);
			this.gameStage.removeHpBarByIndex(this.roundIndex);
			this.enemyProxy.removeEnemyVoById(eVo.id);
			isDead = true;
		}
		//this.gameStage.updateEnemyUI(this.enemyProxy.enemyVoList);
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
		this.gameStage.playerHurt(this.slots.indexValue == 0, Handler.create(this, playerHurtComplete));
		if (this.slots.indexValue == 0)
			Damage.showDamageByStr("miss!", this.gameStage.player.x, this.gameStage.player.y - 100, 1.5);
		else
			Damage.show(this.slots.indexValue, this.gameStage.player.x, this.gameStage.player.y - 100, 1.5);
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
		//shake
	}
	
	/**
	 * 点击事件
	 */
	private function clickHandler(event:Event):void 
	{
		//Damage.show(100, event.stageX, event.stageY, 1.5);
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