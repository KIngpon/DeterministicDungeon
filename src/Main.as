package 
{
import config.GameConstant;
import laya.display.Stage;
import view.ui.Layer;
/**
 * ...主文件
 * @author ...Kanon
 */
public class Main 
{
	public function Main() 
	{
		Laya.init(GameConstant.GAME_WIDTH, GameConstant.GAME_HEIGHT);
		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
		Layer.init(Laya.stage);
	}
}
}