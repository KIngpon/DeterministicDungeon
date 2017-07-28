/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 

	public class SlotsPanelUI extends Dialog {

		public static var uiView:Object ={"type":"Dialog","props":{"width":1024,"height":640,"alpha":100},"child":[{"type":"Image","props":{"y":345,"x":487,"skin":"comp/slotsPanelBg.png","anchorY":0.5,"anchorX":0.5}},{"type":"Image","props":{"y":482,"x":662,"skin":"comp/selectBtn.png","anchorY":1}},{"type":"Image","props":{"y":482,"x":662,"skin":"comp/selectClickedBtn.png","anchorY":1}},{"type":"Image","props":{"y":208,"x":487,"skin":"comp/slotsPanelTitleBg.png","anchorY":0.5,"anchorX":0.5}},{"type":"Image","props":{"y":162,"x":487,"skin":"comp/slotsTitle.png","anchorX":0.5}},{"type":"Label","props":{"y":225,"x":487,"width":219,"text":"房间敌人数量","overflow":"visible","height":25,"fontSize":22,"font":"SimHei","color":"#033297","bold":true,"anchorY":0.5,"anchorX":0.5,"align":"center"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}