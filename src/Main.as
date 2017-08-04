package 
{
import config.GameConstant;
import controller.InitDataCommand;
import controller.ModelCommand;
import controller.ViewCommand;
import laya.display.Stage;
import laya.utils.Stat;
import view.ui.Layer;
/**
 * ...主文件
 * TODO 
 * [damage 出文字未击中！]
 * [选择敌人类型]
 * [敌人icon大小缩放]
 * [slots大小缩放接口]
 * 关卡表配置
 * 掉落表
 * 道具表
 * 特殊道处理
 * 关卡表对应关卡背景图片，敌人id
 * 选择关卡地形
 * 选择移动格子
 * 本地化文本
 * 中文字体图
 * @author ...Kanon
 */
public class Main 
{
	public function Main() 
	{
		Laya.init(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		Laya.stage.scaleMode = Stage.SCALE_FIXED_HEIGHT;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Laya.stage.bgColor = "#0F1312";
		Layer.init(Laya.stage);
		Stat.show(0, 0);
		this.startMvc();
	}
	
	/**
	 * 启动mvc
	 */
	private function startMvc():void
	{
		var m:ModelCommand = new ModelCommand();
		var v:ViewCommand = new ViewCommand();
		var initDataCommand:InitDataCommand = new InitDataCommand();
		m.execute(null);
		v.execute(null);
		initDataCommand.execute(null);
	}
}
}