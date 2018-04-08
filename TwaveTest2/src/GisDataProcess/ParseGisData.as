package GisDataProcess
{
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import Config.PathManager;
	
	import Utils.GisUtil;
	
	import cn.zhrz.arcgis.LogManager;
	
	import manager.RTMPRpcManager;

	public class ParseGisData
	{
		public function ParseGisData()
		{
		}
		
		private static var RebackFun1: Function;
		
		private static var url:String = PathManager.getInstance().getValue("endPoint");
		public static var pos : Number;

		/**
		 * 获取区域内的线
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
//		public static function getAreaLines(startCol:Number,startRow:Number,zoom:Number,rebackFun:Function):void{
//			getAreaInfo("getLineInMaxMinCoordinate",[startCol,startRow,zoom],rebackFun,getAreaLinesSuccessed,getAreaLinesFault);
//		}
//			
//		private static function getAreaLinesSuccessed(e:ResultEvent):void{
//			if( e.result != null ){
//				var resultArr : ArrayCollection = e.result as ArrayCollection;
//				LogManager.getInstance().onLogMessage("获取区域内线成功———— 线的条数："+resultArr.length);
//			}
//			RebackFun1.apply(null,[resultArr]);
//		}
//		
//		private static function getAreaLinesFault(e:FaultEvent):void{
//			var faultMessage : String;
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("获取区域内线失败！！！ 失败原因："+faultMessage);
//			RebackFun1.apply(null,[null]);
//		}
		
//		private static var RebackFun2 : Function
		/**
		 * 根据线的ID获取这条线的点
		 * @param LineId:String 线的id
		 * @param rebackFun:Function 回调函数 
		 */
//		public static function getPointByLineId( LineId: String,rebackFun:Function):void{
//			if( !checkUrl())	return;
//			RebackFun2 = rebackFun;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getLinePointById",getPointSuccessed,getPointFault,[LineId]);
////			HttpRpcManager.getInstance().executeHttpRpc("GisCoordinateService","getLinePointById",getPointSuccessed,getPointFault,[LineId]);
//		}
//		private static function getPointSuccessed(e:ResultEvent):void{
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			if( resultArr ){
//				LogManager.getInstance().onLogMessage("根据线ID获取点成功！———— 点的个数："+resultArr.length);
//			}else{
//				LogManager.getInstance().onLogMessage("根据线ID获取点成功!———— 返回的点的集合为null");
//			}
//			RebackFun2.apply(null,[resultArr]);
//		}
		
//		private static function getPointFault(e:FaultEvent):void{
//			var faultMessage : String ="";
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("根据线ID获取点失败！！！ 失败原因："+faultMessage);
//			RebackFun2.apply(null,[null]);
//		}
		
//		private static var RebackFun3 : Function; 
		//获取所有的火车站点
//		public static function getAllRailwayStn(rebackFun : Function):void{
//			if( !checkUrl())	return;
//			RebackFun3 = rebackFun;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllRailwayStn",getAllRailWaySuccessed,getAllRailWayFault,[]);
////			HttpRpcManager.getInstance().executeHttpRpc("GisCoordinateService","getAllRailwayStn",getAllRailWaySuccessed,getAllRailWayFault,[]);
//		}
//		private static function getAllRailWaySuccessed(e:ResultEvent):void{
//			trace("获取所有的站点成功");
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			if(resultArr){
//				LogManager.getInstance().onLogMessage("获取所有的站点成功！-- 站点的个数："+resultArr.length);
//			}else{
//				LogManager.getInstance().onLogMessage("获取所有的站点成功！-- 返回的集合为null");
//			}
//			
//			RebackFun3.apply(null,[resultArr]);
//		}
//		private static function getAllRailWayFault(e:FaultEvent):void{
//			if( e.fault && e.fault.faultString ){
//				trace(e.fault.faultString);
//			}else if( e.fault && e.fault.faultDetail){
//				trace(e.fault.faultDetail);
//			}
//			RebackFun3.apply(null,[null]);
//		}
		
//		private static var RebackFun4 : Function;
		/**
		 * 获取区域内的面
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
//		public static function getAreaRangeProvincePolygonIds(startCol:Number,startRow:Number,zoom:Number,rebackFun:Function):void{
//			if( !checkUrl())	return;
//			RebackFun4 = rebackFun;
//			var endCol : Number = startCol+1;
//			var endRow : Number = startRow+1;
//			var startCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(startCol,startRow,zoom);
//			LogManager.getInstance().onLogMessage("当前区域开始的坐标点："+startCoordinateArr);
//			var endCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(endCol,endRow,zoom);
//			LogManager.getInstance().onLogMessage("当前区域结束的坐标点:"+endCoordinateArr);
//			var minLongitude : Number = startCoordinateArr[0] - pos;
//			var maxLongitude : Number = endCoordinateArr[0] + pos;
//			var minLatitude : Number = endCoordinateArr[1] - pos;
//			var maxLatitude : Number = startCoordinateArr[1] + pos;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAreaRangeProvincePolygonPoints",getProvinceSuccessed,getProvinceFault,[minLongitude+"",maxLongitude+"",minLatitude+"",maxLatitude+""]);	
////			HttpRpcManager.getInstance().executeHttpRpc("GisCoordinateService","getAreaRangeProvincePolygonPoints",getProvinceSuccessed,getProvinceFault,[startCoordinateArr[0]+"",endCoordinateArr[0]+"",endCoordinateArr[1]+"",startCoordinateArr[1]+""]);
//		}
		
//		private static function getProvinceSuccessed(e:ResultEvent):void{
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			var message : String = "";
//			if( resultArr ){
//				message = "结果集的长度："+resultArr.length;
//			}else{
//				message = "返回的结果集为null";
//			}
//			LogManager.getInstance().onLogMessage("获取边线成功！-- "+message);
//			RebackFun4.apply(null,[resultArr]);
//		}
//		private static function getProvinceFault(e:FaultEvent):void{
//			var faultMessage : String = "";
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail ){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("根据最大最小经纬度查询所在区域内的所有面！"+faultMessage);
//			RebackFun4.apply(null,[null]);
//		}
		
//		private static var RebackFun5 : Function; 
		/**
		 *	调用rpc获取省会集合
		 *  @param reBackFun 回调函数 
		 */
//		public static function getAllProvinicalCapitals(reBackFun : Function):void{
//			if( !checkUrl())	return;
//			RebackFun5 = reBackFun;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllProvinicalCapitals",getAllProvinicalCapitalsSuccessed,getAllProvinicalCapitalsFault,[]);
//		}
//		
//		private static function getAllProvinicalCapitalsSuccessed(e:ResultEvent):void{
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			var message : String = "";
//			if( resultArr ){
//				message = "结果集的长度："+resultArr.length;
//			}else{
//				message = "返回的结果集为null";
//			}
//			LogManager.getInstance().onLogMessage("获取省会集合成功 ！！-- "+message);
//			RebackFun5.apply(null,[resultArr]);
//		}
//		
//		private static function getAllProvinicalCapitalsFault(e:FaultEvent):void{
//			var faultMessage : String = "";
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail ){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("获取省会信息失败！"+faultMessage);
//			RebackFun5.apply(null,[null]);
//		}
		
//		private static var rebackFun6 : Function;
		/**
		 *	获取范围内的市边界
		 *  @param startCol 开始列
		 * 	@param startRow 开始行
		 * 	@param zoom 级别
		 * 	@param rebackFun 回调函数 
		 */
//		public static function getAreaRangeCityPolygonPoints(startCol:Number,startRow:Number,zoom:Number,rebackFun:Function):void{
//			if( !checkUrl())	return;
//			rebackFun6 = rebackFun;
//			var endCol : Number = startCol+1;
//			var endRow : Number = startRow+1;
//			var startCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(startCol,startRow,zoom);
//			LogManager.getInstance().onLogMessage("当前区域开始的坐标点："+startCoordinateArr);
//			var endCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(endCol,endRow,zoom);
//			LogManager.getInstance().onLogMessage("当前区域结束的坐标点:"+endCoordinateArr);
//			var minLongitude : Number = startCoordinateArr[0] - pos;
//			var maxLongitude : Number = endCoordinateArr[0] + pos;
//			var minLatitude : Number = endCoordinateArr[1] - pos;
//			var maxLatitude : Number = startCoordinateArr[1] + pos;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAreaRangeCityPolygonPoints",getAreaRangeCityPolygonPointsSuccessed,getAreaRangeCityPolygonPointsFault,[minLongitude+"",maxLongitude+"",minLatitude+"",maxLatitude+""]);	
//		}
//		private static function getAreaRangeCityPolygonPointsSuccessed(e:ResultEvent):void{
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			var message : String = "";
//			if( resultArr ){
//				message = "结果集的长度："+resultArr.length;
//			}else{
//				message = "返回的结果集为null";
//			}
//			LogManager.getInstance().onLogMessage("获取城市边界边线成功！-- "+message);
//			rebackFun6.apply(null,[resultArr]);
//		}
//		private static function getAreaRangeCityPolygonPointsFault(e:FaultEvent):void{
//			var faultMessage : String = "";
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail ){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("获取城市边界边线失败！"+faultMessage);
//			rebackFun6.apply(null,[null]);
//		}
		
//		private static var reBackFun7 : Function;
		/**
		 * 获取所有的市名
		 * @param reBackFun 回调函数
		 */
//		public static function getAllCityPoints(reBackFun : Function):void{
//			if( !checkUrl())	return;
//			reBackFun7 = reBackFun;
//			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllCityPoints",getAllCityPointsSuccessed,getAllCityPointsFault,[]);
//		}
//		
//		private static function getAllCityPointsSuccessed(e:ResultEvent):void{
//			var resultArr : ArrayCollection = e.result as ArrayCollection;
//			var message : String = "";
//			if( resultArr ){
//				message = "结果集的长度："+resultArr.length;
//			}else{
//				message = "返回的结果集为null";
//			}
//			LogManager.getInstance().onLogMessage("获取城市成功！-- "+message);
//			reBackFun7.apply(null,[resultArr]);
//		}
//		private static function getAllCityPointsFault(e:FaultEvent):void{
//			var faultMessage : String = "";
//			if( e.fault && e.fault.faultString ){
//				faultMessage = e.fault.faultString;
//			}else if( e.fault && e.fault.faultDetail ){
//				faultMessage = e.fault.faultDetail;
//			}
//			LogManager.getInstance().onLogMessage("获取城市失败！"+faultMessage);
//			reBackFun7.apply(null,[null]);
//		}
		
		/**
		 *	获取所有的火车站点 
		 */
		public static function getAllRailwayStn(rebackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllRailwayStn",rebackFun,[]);
		}
		/**
		 *	获取所有的飞机场 
		 */
		public static function getAllAirportStn(reBackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllAirportStn",reBackFun,[]);
		}
		
		/**
		 * 获取所有的省会 
		 */
		public static function getAllProvinicalCapitals(reBackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllProvincialCapitals",reBackFun,[]);
		}
		/**
		 * 获取所有的城市 
		 */
		public static function getAllCityPoints(reBackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllCityPoints",reBackFun,[]);
		}
		/**
		 * 获取所有的区 
		 */
		public static function getAllAreaPoints(reBackFun:Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllAreaPoints",reBackFun,[]);
		}
		/**
		 * 获取县
		 */
		public static function getAllCountyPoints(reBackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllCountyPoints",reBackFun,[]);
		}
		/**
		 *	获取乡镇 
		 */
		public static function getAllTownPoints(reBackFun : Function):void{
			if( !checkUrl())	return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllTownPoints",reBackFun,[]);
		}
		/**
		 *	获取街道办事处 
		 */
		public static function getAllStreetPoints(reBackFun:Function):void{
			if( !checkUrl() ) return;
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getAllStreetPoints",reBackFun,[]);
		}
		
		/**
		 * 获取区域内的省边界
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
		public static function getAreaRangeProvincePolygonIds(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeProvincePolygonPoints",args,rebackFun);
		}
		
		public static function getProvincialLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getProvincialLineInMaxMinCoordinate",args,rebackFun);
		}
		
		public static function getProvincialLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getProvincialLinePointById",rebackFun,[LineId]);
		}
		
		/**
		 * 获取区域内的市边界
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
		public static function getAreaRangeCityPolygonPoints(args:Array,rebackFun:Function):void{
			if( !checkUrl())	return;
			getAreaInfo("getAreaRangeCityPolygonPoints",args,rebackFun);
		}
		/**
		 * 获取区域内县的边界 
		 */
		public static function getAreaRangeCountyPolygonPoints(args:Array,rebackFun:Function):void{
			if( !checkUrl())	return;
			getAreaInfo("getAreaRangeCountyPolygonPoints",args,rebackFun);
		}
		
		
		
		/**
		 * 获取区域内的火车线
		 * @param startCol:Number  开始的列
		 * @param startRow:Number 开始的行
		 * @param zoom:int 级别
		 * @param rebackFun:Function 回调函数
		 */
		public static function getAreaLines(args:Array,rebackFun:Function):void{
			getAreaInfo("getRailwayLineInMaxMinCoordinate",args,rebackFun);
		}
		
		public static function getPointByLineId( LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getRailwayLinePointById",rebackFun,[LineId]);
		}
		/**
		 *	获取高速公路的线段 
		 */
		public static function getHighwayLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getHighwayLineInMaxMinCoordinate",args,rebackFun);
		}
		public static function getHighwayLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getHighwayLinePointById",rebackFun,[LineId]);
		}
		//获取区域内的高速线道集合
		public static function  getAreaRangeHightWayPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeHightWayPoints",args,rebackFun);
		}
		/***************************************end*******************************************************/
		
		/**
		 * 获取国道线段 
		 */
		public static function getNationalHighwayLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getNationalHighwayLineInMaxMinCoordinate",args,rebackFun);
		}
		public static function getNationalHighwayLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getNationalHighwayLinePointById",rebackFun,[LineId]);
		}
		//获取区域内国道的所有点
		public static function getAreaRangeNationalHighWayPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeNationalHighWayPoints",args,rebackFun);
		}
		
		/**
		 *	 省道公路线
		 */
		public static function getProvincialHighwayLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getProvincialHighwayLineInMaxMinCoordinate",args,rebackFun);
		}
		public static function getProvincialHighwayLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getProvincialHighwayLinePointById",rebackFun,[LineId]);
		}
		//获取区域内省道的所有点
		public static function getAreaRangeProvincialHighWayPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeProvincialHighWayPoints",args,rebackFun);
		}
		/**
		 * 县道公路线
		 */
		public static function getCountyHighwayLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getCountyHighwayLineInMaxMinCoordinate",args,rebackFun);
		}
		public static function getCountyHighwayLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getCountyHighwayLinePointById",rebackFun,[LineId]);
		}
		//获取区域内县道
		public static function getAreaRangeCountyHighWayPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeCountyHighWayPoints",args,rebackFun);
		}
		
		public static function getAreaTownPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeTownsPoints",args,rebackFun);
		}
		//获取乡村车道
		public static function getAreaRangeXZCDPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeXZCDPoints",args,rebackFun);
		}
		// 获取区域内的加油站
		public static function getAreaRangeGasStations(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeGasStations",args,rebackFun);
		}
		// 获取区域内的金融中心
		public static function getAreaRangeFinancePoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeFinancePoints",args,rebackFun);
		}
		// 获取区域内的九级道路点
		public static function getAreaRangeNineGradePoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeNineGradePoints",args,rebackFun);
		}
		/**
		 *	城市快速公路线 
		 */
		public static function getExpresswayLineInMaxMinCoordinate(args:Array,rebackFun:Function):void{
			getAreaInfo("getExpresswayLineInMaxMinCoordinate",args,rebackFun);
		}
		public static function getExpresswayLinePointById(LineId: String,rebackFun:Function):void{
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService","getExpresswayLinePointById",rebackFun,[LineId]);
		}
		
		public static function getAreaRangeExpressWayPoints(args:Array,rebackFun:Function):void{
			getAreaInfo("getAreaRangeExpressWayPoints",args,rebackFun);
		}
		
		/**
		 *	获取区域内的线(铁路，省界，市界，高速，省内高速)
		 *  @param method 调用远程的方法
		 * 	@param args 参数集合
		 *  @param successedFun 远程调用成功函数
		 * 	@param faultFun 远程调用失败函数
		 */
		private static function getAreaInfo(method:String,args:Array,rebackFun:Function):void{
			if( !checkUrl())	return;
			var minLongitude : Number = args[0];
			var maxLongitude : Number = args[1];
			var minLatitude : Number = args[2];
			var maxLatitude : Number = args[3];
			RTMPRpcManager.getInstance().executeRtmpRpc(url,"GisCoordinateService",method,rebackFun,[minLongitude+"",maxLongitude+"",minLatitude+"",maxLatitude+""]);
//			HttpRpcManager.getInstance().executeHttpRpc("GisCoordinateService","getLineInMaxMinCoordinate",getAreaLinesSuccessed,getAreaLinesFault,[startCoordinateArr[0]+"",endCoordinateArr[0]+"",endCoordinateArr[1]+"",startCoordinateArr[1]+""]);	
		}
		/**
		 *	校验是否配置服务器路径 
		 */
		private static function checkUrl():Boolean{
			if(StringUtil.trim(url) == ""){
				LogManager.getInstance().onLogMessage("服务器地址没有配置！");
				return false;
			}
			return true;
		}
	}
}