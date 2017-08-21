/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class LoadingLayerUI extends View {
		public var perTxt:Text;

		public static var uiView:Object ={"type":"View","props":{"width":1136,"height":640},"child":[{"type":"Text","props":{"y":327.2096774193548,"x":562.3548387096774,"width":450,"var":"perTxt","text":"正在加载图片..... 10%","pivotY":38.70967741935482,"pivotX":219.35483870967744,"height":71,"fontSize":"30","font":"Microsoft YaHei","color":"#ffffff","align":"center"}}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);
		}
	}
}