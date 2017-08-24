/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 

	public class AlertLayerUI extends View {
		public var okBtn:Button;
		public var closeBtn:Button;
		public var contentTxt:Label;

		public static var uiView:Object ={"type":"View","props":{"width":1136,"height":640},"child":[{"type":"Sprite","props":{"y":201.5,"x":358.5,"width":419,"height":237},"child":[{"type":"Image","props":{"y":-5.684341886080802e-14,"x":5.684341886080802e-14,"skin":"frame/alertFrame.png"}},{"type":"Button","props":{"y":116.49999999999994,"x":92.24999999999989,"var":"okBtn","stateNum":"1","skin":"btn/okBtn.png","scaleY":1.5,"scaleX":1.5}},{"type":"Button","props":{"y":122.49999999999989,"x":220.74999999999977,"var":"closeBtn","stateNum":"1","skin":"btn/closeBtn.png","scaleY":1.5,"scaleX":1.5}},{"type":"Label","props":{"y":27.5,"x":139.49999999999977,"var":"contentTxt","text":"前往下一层","fontSize":28,"font":"Microsoft YaHei","color":"#ffffff","bold":false}}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}