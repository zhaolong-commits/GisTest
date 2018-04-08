package GisDataProcess
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import cn.zhrz.arcgis.LogManager;

	public class DataUtil extends EventDispatcher
	{
		public function DataUtil()
		{
			super();
		}
		
		private static var instance : DataUtil;
		
		public static function getInstance():DataUtil{
			if( instance == null ){
				instance = new DataUtil();
			}
			return instance;
		}
		
		private var dateFun : Function;
		private var addNodeFun : Function;
		private var eventName : String;
		
		private var LineArrLength:Number = 0;
		private var LineArr : ArrayCollection;
		private var LineIndex : int = 0;
		private var LineRes : int = 0;
		private var message : String;
		public function getDataAndDrawLine(lineArr:ArrayCollection,getDataFun : Function,addNode:Function,event : String,mess : String):void{
			eventName = event;
			message = mess;
			if( lineArr == null || lineArr.length <= 0 ){
				onlog(message+"当前区域没有结果！！！");
				dispatchEvent(new Event(eventName));
			}else{
				dateFun = getDataFun;
				addNodeFun = addNode;
				LineArrLength = lineArr.length;
				LineArr = lineArr;
				onlog("查询的区域共有"+LineArrLength+"条"+mess+"！");
				getPointByLineID();
			}
		}
		
		private function getPointByLineID():void{
			for(var i : int = LineIndex;i < LineArr.length;i++){
				LineIndex++;
				var lineId : String = LineArr[i].id;
				onlog("当前查询的线ID:"+lineId);
				dateFun(lineId,getHeightWayPointByLineId);
				if( LineIndex%20 == 0 ){
					break;
				}
			}
		}
		private function getHeightWayPointByLineId(pointArr : ArrayCollection):void{
			LineArrLength--;
			LineRes++;
			if( pointArr == null || pointArr.length <= 0 ){
				onlog("查询的这个线段没有值！！");
				return;
			}
			addNodeFun(pointArr);
			if( LineArrLength == 0 ){
				onlog("当前区域的"+message+"画完了！！！！");
				LineIndex = 0;
				LineRes = 0;
				LineArr = null;
				dispatchEvent(new Event(eventName));
			}else{
				onlog("当前区域没有画完的"+message+":"+LineArrLength);
			}
			if( LineRes == 20 ){
				LineRes = 0;
				getPointByLineID();
			}
		}
		
		
		
		private function onlog(message:String):void{
			LogManager.getInstance().onLogMessage(message);
		}
			
	}
}