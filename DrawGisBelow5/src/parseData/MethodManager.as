package parseData
{
	import com.esri.ags.layers.TiledMapServiceLayer;
	
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import Utils.GisUtil;
	import Utils.LogManager;
	
	import arcGis.ArcGisMap;
	
	import manager.NodeAndLineManager;

	public class MethodManager
	{
		public function MethodManager()
		{
			
		}
		
		private static var instance : MethodManager;

		public static function getInstance():MethodManager{
			if( instance == null ){
				instance = new MethodManager();
			}
			return instance;
		}
		
		private var _gisMap:ArcGisMap;
	
		public function get gisMap():ArcGisMap
		{
			return _gisMap;
		}
		
		public function set gisMap(value:ArcGisMap):void
		{
			_gisMap = value;
			if( _gisMap ){
				_gisMap.addEventListener("saveOneAreaSuccessed",savePictureSuccessed);
			}
		}
		//所有的省ID
		public var provinceArr : ArrayCollection;
		
		public function getAllProvincialIds():void{
			ParseGisData.getAllProvincialIds(getProvinceReback);
		}
		
		private function getProvinceReback(idArr :ArrayCollection):void{
			if( idArr == null || idArr.length <= 0 ){
				onLog("获取所有的省ID失败");
			}else{
				provinceArr = idArr;
				onLog("获取所有的省ID成功！省数量:"+idArr.length);
			}
		}
		
		public var manyLoadTime : Number;
		
		//需要特殊处理的数据
		private var specialData : Object ={
			4:[{"col":11,"row":6},{"col":12,"row":6},{"col":13,"row":6},{"col":13,"row":5}]
		};

		
		private var manyLoadObj : Array;
		
		private var isDivided : Boolean = false;
		private var currentArea : Number = 0;
		
		private function divideArea(startCol:Number,startRow:Number,zoom:Number):void{
			
			var endCol : Number = startCol+1;
			var endRow : Number = startRow+1;
			var startCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(startCol,startRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域开始的坐标点："+startCoordinateArr);
			var endCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(endCol,endRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域结束的坐标点:"+endCoordinateArr);
			//经度
			var minLongitude : Number = startCoordinateArr[0];				
			var maxLongitude : Number = endCoordinateArr[0];
			//纬度
			var minLatitude : Number = endCoordinateArr[1];	
			var maxLatitude : Number = startCoordinateArr[1];
			if( manyLoadTime ){
				//平方根
				var sqrt : Number = Math.sqrt(manyLoadTime); 
				//单个经度
				var singleLongitude : Number = (maxLongitude - minLongitude)/sqrt;
				//单个纬度
				var singleLatitude : Number = (maxLatitude - minLatitude)/sqrt;
				
				manyLoadObj = new Array();
				
				for( var i : int = 0; i < sqrt ; i++ ){
					for( var j : int = 0;j < sqrt;j++ ){
						var oneArea : Object = new Object();
						
						oneArea.startLat = minLatitude + ((sqrt - i - 1)*singleLatitude);
						oneArea.endLat = minLatitude  + (( sqrt - i) * singleLatitude);
						
						oneArea.startLon = minLongitude + (j * singleLongitude);
						oneArea.endLon = minLongitude + ((j+1)*singleLongitude);
			
						manyLoadObj.push(oneArea);
					}
				}
				
				getAreaProvinceByParams(manyLoadObj[0].startLon,manyLoadObj[0].endLon,manyLoadObj[0].startLat,manyLoadObj[0].endLat);
				isDivided = true;
				
			}else{
				getAreaProvinceByParams(minLongitude,maxLongitude,minLatitude,maxLatitude);
			}
		}
		public function getAreaProvince():void{
			var specialArr : Array = specialData[gisMap.level];
			for each( var item in specialArr ){
				if( gisMap.currentCol == Number(item.col) && gisMap.currentRow == Number(item.row) ){
					divideArea(gisMap.currentCol,gisMap.currentRow,gisMap.level);
					return;
				}
			}
			ParseGisData.getAreaRangeProvincePolygonIds(gisMap.currentCol,gisMap.currentRow,gisMap.level,getAreaProvinceReback);		
		}
		
		private function getAreaProvinceByParams(minLon:Number,maxLon:Number,minLat:Number,maxLat : Number):void{
			ParseGisData.getAreaDataByParams("getAreaRangeProvincePolygonPoints",[minLon,maxLon,minLat,maxLat],getAreaProvinceReback);
		}
		
		
		private var currentLineArr : ArrayCollection;
		private var lineIndex : Number = 0;
		/**
		 * 获取边线成功回调函数
		 */
		private function getAreaProvinceReback(lineArr : ArrayCollection):void{
			
			if( lineArr == null || lineArr.length <=0 ){
				LogManager.getInstance().onLogMessage("当前区域没有边界线");
				setTimeout(gisMap.saveImage,6000,isDivided,currentArea);
			}else{
				onLog("当前区域获取的边界线!"+lineArr.length);
				currentLineArr = lineArr;
				addBorder();
			}
		}
		private function addBorder():void{
			for( var i :int = 0; i< currentLineArr.length; i++ ){
				onLog("添加第"+(i+1)+"个边界线！！");
				NodeAndLineManager.getInstance().addBoundary(currentLineArr[i]);
				onLog("添加第"+(i+1)+"个边界线成功！！");
			}
			setTimeout(gisMap.saveImage,6000,isDivided,currentArea);
		}
		
		private function savePictureSuccessed(e:Event):void{
			e.stopPropagation();
			NodeAndLineManager.getInstance().clearAllNodes();
			currentArea++;
			isDivided = false;
			if( currentArea < manyLoadObj.length ){
				isDivided = true;
				getAreaProvinceByParams(manyLoadObj[currentArea].startLon,manyLoadObj[currentArea].endLon,manyLoadObj[currentArea].startLat,manyLoadObj[currentArea].endLat);
			}else{
				currentArea = 0;
				manyLoadObj = null;
				manyLoadObj = new Array();
			}
//			onLog("一条线画成功！！");
//			addBorder();
		}
		
		private function onLog(message : String):void{
			LogManager.getInstance().onLogMessage(message);
		}
	}
}