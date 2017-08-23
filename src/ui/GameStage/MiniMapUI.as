/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 

	public class MiniMapUI extends View {

		public static var uiView:Object ={"type":"View","props":{"width":160,"height":200},"child":[{"type":"Image","props":{"y":12,"x":18,"width":124,"skin":"frame/smallMapBg.png","height":104}},{"type":"Label","props":{"y":116,"x":31,"width":98,"text":"泥土 1-1","height":25,"fontSize":26,"font":"Microsoft YaHei","color":"#ffffff"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}