/**Created by the LayaAirIDE,do not modify.*/
package ui.GameStage {
	import laya.ui.*;
	import laya.display.*; 

	public class SlotsPanelUI extends Dialog {
		public var titleTxt:Label;
		public var selectBtn:Button;
		public var bgSpt:Sprite;
		public var contentSpt:Sprite;
		public var frameSpt:Sprite;
		public var selectedImg:Image;
		public var handImg:Image;

		public static var uiView:Object ={"type":"Dialog","props":{"width":1136,"height":640,"alpha":100},"child":[{"type":"Image","props":{"y":325,"x":512,"skin":"frame/slotsPanelBg.png","anchorY":0.5,"anchorX":0.5}},{"type":"Image","props":{"y":188,"x":512,"skin":"comp/slotsPanelTitleBg.png","anchorY":0.5,"anchorX":0.5}},{"type":"Image","props":{"y":142,"x":512,"skin":"comp/slotsTitle.png","anchorX":0.5}},{"type":"Label","props":{"y":205,"x":512,"width":219,"var":"titleTxt","text":"房间敌人数量","overflow":"visible","height":25,"fontSize":20,"font":"Microsoft YaHei","color":"#033297","bold":true,"anchorY":0.5,"anchorX":0.5,"align":"center"}},{"type":"Button","props":{"y":463,"x":758,"var":"selectBtn","stateNum":"3","skin":"btn/selectBtn.png","anchorY":1,"anchorX":0.5}},{"type":"Sprite","props":{"y":231,"x":373,"width":279,"var":"bgSpt","height":224},"child":[{"type":"Image","props":{"y":7,"x":0,"width":84,"name":"bg1","height":63}},{"type":"Image","props":{"y":7,"x":97,"width":84,"name":"bg2","height":63}},{"type":"Image","props":{"y":7,"x":193,"width":84,"name":"bg3","height":63}},{"type":"Image","props":{"y":80,"x":0,"width":84,"name":"bg4","height":63}},{"type":"Image","props":{"y":80,"x":97,"width":84,"name":"bg5","height":63}},{"type":"Image","props":{"y":80,"x":193,"width":84,"name":"bg6","height":63}},{"type":"Image","props":{"y":152,"x":0,"width":84,"name":"bg7","height":63}},{"type":"Image","props":{"y":152,"x":97,"width":84,"name":"bg8","height":63}},{"type":"Image","props":{"y":152,"x":193,"width":84,"name":"bg9","height":63}}]},{"type":"Sprite","props":{"y":231,"x":373,"width":279,"var":"contentSpt","height":224},"child":[{"type":"Sprite","props":{"y":7,"x":0,"width":84,"name":"m1","height":63}},{"type":"Sprite","props":{"y":7,"x":97,"width":84,"name":"m2","height":63}},{"type":"Sprite","props":{"y":7,"x":193,"width":84,"name":"m3","height":63}},{"type":"Sprite","props":{"y":80,"x":0,"width":84,"name":"m4","height":63}},{"type":"Sprite","props":{"y":80,"x":97,"width":84,"name":"m5","height":63}},{"type":"Sprite","props":{"y":80,"x":193,"width":84,"name":"m6","height":63}},{"type":"Sprite","props":{"y":152,"x":0,"width":84,"name":"m7","height":63}},{"type":"Sprite","props":{"y":152,"x":97,"width":84,"name":"m8","height":63}},{"type":"Sprite","props":{"y":152,"x":193,"width":84,"name":"m9","height":63}}]},{"type":"Sprite","props":{"y":231,"x":373,"width":279,"var":"frameSpt","height":224},"child":[{"type":"Image","props":{"y":7,"x":0,"width":84,"pivotX":0.5,"name":"frame1","height":63}},{"type":"Image","props":{"y":7,"x":97,"width":84,"name":"frame2","height":63}},{"type":"Image","props":{"y":7,"x":193,"width":84,"name":"frame3","height":63}},{"type":"Image","props":{"y":80,"x":0,"width":84,"name":"frame4","height":63}},{"type":"Image","props":{"y":80,"x":97,"width":84,"name":"frame5","height":63}},{"type":"Image","props":{"y":80,"x":193,"width":84,"name":"frame6","height":63}},{"type":"Image","props":{"y":152,"x":0,"width":84,"name":"frame7","height":63}},{"type":"Image","props":{"y":152,"x":97,"width":84,"name":"frame8","height":63}},{"type":"Image","props":{"y":152,"x":193,"width":84,"name":"frame9","height":63}},{"type":"Image","props":{"y":7,"var":"selectedImg","skin":"frame/slotsSelectedBg.png"}}]},{"type":"Image","props":{"y":229,"x":717,"var":"handImg","skin":"comp/hand.png"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}