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
 * [关卡表配置]
 * [掉落表]
 * [随机的0个敌人直接胜利]
 * [屏幕震动]
 * [选择关卡地形]
 * [关卡表对应关卡背景图片，敌人id]
 * [选择移动格子]
 * 小地图
 * 本地化表
 * 导航菜单
 * 自由选择敌人
 * 抽掉落
 * 敌人扣血死亡胜利流程
 * 数据存储
 * 道具表
 * 装备icon
 * 特殊道处理
 * 开宝箱
 * 中文字体图
 * 角色动画
 * @author ...Kanon
 */
public class Main 
{
	public function Main() 
	{
		Laya.init(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
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