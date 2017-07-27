package view.mediator 
{
import config.GameConstant;
import config.MsgConstant;
import laya.events.Event;
import laya.events.Keyboard;
import laya.utils.Handler;
import model.proxy.PlayerProxy;
import model.vo.PlayerVo;
import mvc.Mediator;
import mvc.Notification;
import utils.Random;
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
	private var playerProxy:PlayerProxy;
	private var playerVo:PlayerVo;
	public function GameStageMediator() 
	{
		this.mediatorName = NAME;
		this.playerProxy = this.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
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
				this.initStage();
				this.initEvent();
				this.playerVo = this.playerProxy.pVo;
				this.sendNotification(MsgConstant.START_FIGHT);
				break;
			case MsgConstant.START_FIGHT:
				if (this.playerVo.isFirstStep)
				{
					// 选择地形
					// 选择宝箱位置
					if (this.playerVo.curLevelNum == 3)
					{
						// 选择boss位置
					}
				}
				else
				{
					//选择移动位置
					//角色移动
				}
				this.gameStage.playerMove(200, Handler.create(this, playerMoveComplete));
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
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDownHandler);
		}
	}
	
	private function onKeyDownHandler(event:Event):void 
	{
		if (!this.gameStage) return;
		if (event.keyCode == Keyboard.A) this.gameStage.playerAtk();
		if (event.keyCode == Keyboard.D) this.gameStage.playerHurt();
		
		if (event.keyCode == Keyboard.Z) this.gameStage.enemyAtk(Random.randint(0, 2));
		if (event.keyCode == Keyboard.X) this.gameStage.enemyHurt(Random.randint(0, 2));
	}
	
	/**
	 * 初始化舞台
	 */
	private function initStage():void
	{
		if (this.gameStage) return;
		this.gameStage = new GameStageLayer();
		Layer.GAME_STAGE.addChild(this.gameStage);
	}
	
	/**
	 * 角色移动结束
	 */
	private function playerMoveComplete():void
	{
		this.gameStage.enemyMove(Handler.create(this, enemyMoveComplete));
	}
	
	/**
	 * 敌人移动结束
	 */
	private function enemyMoveComplete():void
	{
		//出现选择伤害界面
		trace("选择伤害界面");
		this.gameStage.playerAtk();
	}
}
}