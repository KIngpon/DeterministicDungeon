/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 

	public class ThroughFloorLayerUI extends View {
		public var floorBg:Image;
		public var nameTxt:Label;

		public static var uiView:Object ={"type":"View","props":{"width":1136,"height":640},"child":[{"type":"Sprite","props":{"y":0,"x":0,"width":1136,"height":640,"alpha":0.6},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":1136,"lineWidth":1,"height":640,"fillColor":"#000000"}}]},{"type":"Image","props":{"y":327,"x":564,"width":314,"var":"floorBg","skin":"comp/floor.png","scaleX":-1,"pivotY":139.6551724137931,"pivotX":153.44827586206895,"height":265}},{"type":"Label","props":{"y":478,"x":421.9655172413793,"width":630,"var":"nameTxt","text":"通过泥土1-1前往泥土1-2","pivotY":20.68965517241378,"pivotX":168.9655172413793,"height":30,"fontSize":30,"font":"Microsoft YaHei","color":"#ffffff","align":"center"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}