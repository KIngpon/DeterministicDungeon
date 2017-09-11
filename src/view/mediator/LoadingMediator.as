package view.mediator 
{
import config.MsgConstant;
import mvc.Mediator;
import mvc.Notification;
import ui.GameStage.LoadingLayerUI;
import view.ui.Layer;
/**
 * ...loading 中介
 * @author ...Kanon
 */
public class LoadingMediator extends Mediator 
{
	public static const NAME:String = "LoadingMediator";
	private var loading:LoadingLayerUI;
	public function LoadingMediator() 
	{
		this.mediatorName = NAME;
	}
	
	override protected function listNotificationInterests():Vector.<String> 
	{
		var vect:Vector.<String> = new Vector.<String>();
		vect.push(MsgConstant.LOAD_PROGRESS_FIGHT_STAGE);
		vect.push(MsgConstant.REMOVE_LOADING);
		return vect;
	}
	
	override protected function handleNotification(notification:Notification):void 
	{
		switch (notification.notificationName) 
		{
			case MsgConstant.LOAD_PROGRESS_FIGHT_STAGE:
				this.updateLoading(notification.body);
			break;
			case MsgConstant.REMOVE_LOADING:
				this.removeLoading();
			break;
			default:
		}
	}
	
	/**
	 * 删除loading
	 */
	private function removeLoading():void
	{
		if (this.loading) this.loading.removeSelf();
		this.loading = null;
	}
	
	/**
	 * 更新loading
	 * @param	pro	
	 */
	private function updateLoading(per:Number):void
	{
		if (!this.loading)
		{
			this.loading = new LoadingLayerUI();
			Layer.GAME_LOADNG.addChild(this.loading);
		}
		trace(Math.floor(per * 100));
		this.loading.perTxt.text = "正在加载关卡图片..." + Math.floor(per * 100) + "%";
	}
	
	
}
}