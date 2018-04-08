package parseData
{
	import Config.PathManager;
	
	import Utils.GisUtil;
	import Utils.LogManager;
	
	import manager.RTMPRpcManager;

	public class ParseGisData
	{
		public function ParseGisData()
		{
			
		}
		
		private static var url:String = PathManager.getInstance().getValue("endPoint");
		
		public static var pos : Number= 0;
		/**
		 * 获取区域内的省边界
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
		public static function getAreaRangeProvincePolygonIds(startCol:Number,startRow:Number,zoom:Number,rebackFun:Function):void{
			getAreaInfo("getAreaRangeProvincePolygonPoints",[startCol,startRow,zoom],rebackFun);
		}
		
		/**
		 *	获取所有的省ID 
		 */
		public static function getAllProvincialIds(rebackFun : Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllProvincialIds",rebackFun,[]);
		}
		/**
		 * 根据省ID获取这个省所有的边界线 
		 */
		public static function getAllProvincialPolygonIds(provinceID:String,rebackFun : Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllProvincialPolygonIds",rebackFun,[provinceID]);
		}
		
		/**
		 *	根据线ID获取线 
		 */
		public static function getProvincialLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getProvincialLinePointById",rebackFun,[LineId]);
		}
		
		private static function getAreaInfo(method:String,args:Array,rebackFun:Function):void{
//			if( !checkUrl())	return;
			var startCol : Number = args[0];
			var startRow : Number = args[1];
			var zoom : Number = args[2];
			
			var endCol : Number = startCol+1;
			var endRow : Number = startRow+1;
			var startCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(startCol,startRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域开始的坐标点："+startCoordinateArr);
			var endCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(endCol,endRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域结束的坐标点:"+endCoordinateArr);
			var minLongitude : Number = startCoordinateArr[0] - pos;
			var maxLongitude : Number = endCoordinateArr[0] + pos;
			var minLatitude : Number = endCoordinateArr[1] - pos;
			var maxLatitude : Number = startCoordinateArr[1] + pos;
			
			
			
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService",method,rebackFun,[minLongitude+"",maxLongitude+"",minLatitude+"",maxLatitude+""]);
			//			HttpRpcManager.getInstance().executeHttpRpc("GisCoordinateService","getLineInMaxMinCoordinate",getAreaLinesSuccessed,getAreaLinesFault,[startCoordinateArr[0]+"",endCoordinateArr[0]+"",endCoordinateArr[1]+"",startCoordinateArr[1]+""]);	
		}
		//直接传递经纬度调用
		public static function getAreaDataByParams(method:String,args:Array,rebackFun:Function):void{
			var minLongitude : String = args[0] - 0.01+"";
			var maxLongitude : String = args[1] + 0.01 +"";
			var minLatitude : String = args[2] - 0.1 + "";
			var maxLatitude : String = args[3] + 0.5 + "";
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService",method,rebackFun,[minLongitude,maxLongitude,minLatitude,maxLatitude]);

		}
		
		
		
	}
}