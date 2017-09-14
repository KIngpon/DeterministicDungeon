package view.mediator 
{
import config.MsgConstant;
import laya.utils.Timer;
import model.po.StagePo;
import model.vo.AlertVo;
import mvc.Mediator;
import mvc.Notification;
import ui.GameStage.ThroughFloorLayerUI;
import view.ui.Layer;
/**
 * ...下楼梯过场
 * @author ...Kanon
 */
public class ThroughFloorMediator extends Mediator 
{
	//上下楼过场UI
	public static const NAME:String = "ThroughFloorMediator";
	private var throughFloorUI:ThroughFloorLayerUI;
	private var timer:Timer = new Timer();
	private var aVo:AlertVo;
	public function ThroughFloorMediator() 
	{
		super();
		this.mediatorName = NAME;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.SHOW_THROUGH_FLOOR);
		vect.push(MsgConstant.REMOVE_THROUGH_FLOOR);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.SHOW_THROUGH_FLOOR:
				if (!this.throughFloorUI)
				{
					this.throughFloorUI = new ThroughFloorLayerUI();
					Layer.GAME_UI.addChild(this.throughFloorUI);
					var arr:Array = notification.body as Array;
					this.aVo = arr[0];
					var prevStagePo:StagePo = arr[1];
					var nextStagePo:StagePo = arr[2];
					var prevStagePointsCount:int = arr[3];
					var nextStagePointsCount:int = arr[4];
					if (this.aVo.type == AlertVo.UP_FLOOR)
						this.throughFloorUI.floorBg.scaleX = 1;
					else
						this.throughFloorUI.floorBg.scaleX = -1;
					
					this.throughFloorUI.nameTxt.text = "通过" + 
							prevStagePo.name + " " + prevStagePo.points + "-" + prevStagePointsCount + "前往" + 
							nextStagePo.name + " " + nextStagePo.points + "-" + nextStagePointsCount;
					this.timer.once(2000, this, timerCompleteHandler);
				}
			break;
			case MsgConstant.REMOVE_THROUGH_FLOOR:
				if (this.throughFloorUI)
				{
					this.throughFloorUI.removeSelf();
					this.throughFloorUI = null;
				}
			break;
		}
	}
	
	private function timerCompleteHandler():void 
	{
		this.sendNotification(MsgConstant.REMOVE_THROUGH_FLOOR, this.aVo);
	}
}
}