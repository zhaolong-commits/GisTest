package GisDataProcess
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import arcGis.ArcGisMap;
	
	import cn.zhrz.arcgis.LogManager;
	
	import manager.NodeAndLineManager;

	public class MethodManager extends EventDispatcher
	{
		public function MethodManager()
		{
			super();
		}
		
		private static var instance : MethodManager;
		
		public static function getInstance():MethodManager{
			if( instance == null ){
				instance = new MethodManager();
			}
			return instance;
		}
		
		public var loadObj : Object;
		
		public var gisMap : ArcGisMap;
		
		/**
		 *	先加载火车站，飞机场，省会，城市，县市，乡镇等点
		 */
		public function firstCall():void{
			for( var key : String in loadObj ){
				
				if( key == "isAddSite" ){
					getSite();
				}
				if(key == "isAddAirPort"){
					getAirPort();
				}
				
				if( key == "isAddCapital" ){
					getCapital();
				}
				if( key == "isAddCity" ){
					getCityName();
				}
				if(key == "isAddCounty"){
					getCounty();
				}
				if( key == "isAddTown" ){
					getTown();
				}
			}
		}
		
		/**
		 *	添加省界，城市边界，县界 
		 * 	铁路，高速公路，国道，省道，城市快速车道，县道 等需要重复调用的方法
		 */
		public function CallMethod():void{
			if( !hasKey(loadObj) ){
//				saveImage();
				dispatchEvent(new Event("drawSuccessed"));
			}
			loadData();
		}
		
		private function loadData():void{
			for( var key : String in loadObj ){
				//添加省界，城市边界，县边界
				if( key == "isAddBounder" && loadObj[key] == false ){
					if( gisMap.level > 4 ){
						getAreaProvince();
					}else{
						getProvincialLineInMaxMinCoordinate();
					}
					return;
				}
				
				if( key == "isAddCityBorder" && loadObj[key] == false ){
					getCityPoints();
					return;
				}
				if( key == "isAddCountyBorder" && loadObj[key] == false ){
					getCountyBorder();
					return;
				}
				
				//铁路，高速公路，国道，省道，城市快速车道，县道
				if( key == "isAddrailway" && loadObj[key] == false ){
					getRoadLines();
					return;
				}
				if( key == "isAddHighwayLine" && loadObj[key] == false ){
					getHeightwayLines();
					return;
				}
				if( key == "isAddNationalHighwayLine" && loadObj[key] == false ){
					getNationalHighwayLine();
					return;
				}
				if( key == "isAddProvincialHighway" && loadObj[key] == false ){
					getProvincialHighway();
					return;
				}
				if( key == "isAddExpressway" && loadObj[key] == false ){
					getExpressway();
					return;
				}
				if( key == "isAddCountyHighway" && loadObj[key] == false ){
					getCountyHighway();	
					return;
				}
			}
		}
		
		/**
		 *	判断是否存在需要重复调用的方法 （火车站，飞机场，省会，城市，县市，乡镇等一次加载的不需要重复加载）
		 */
		private function hasKey(obj:Object):Boolean{
			var bol : Boolean = false;
			if( bol == null ){
				return bol
			}
			for( var key : String in obj ){
				if( key != "isAddSite" && key !="isAddAirPort" && key !="isAddCapital" && key != "isAddCity" &&  key != "isAddCounty" && key != "isAddTown" ){
					bol = true;
					break;
				}
			}
			return bol;
		}		
		//添加火车站点
		private function getSite():void{
			ParseGisData.getAllRailwayStn(addSitePoint);
		}
		//添加飞机场
		private function getAirPort():void{
			ParseGisData.getAllAirportStn(addAirPort);
		}
		
		//添加省会			
		private function getCapital():void{
			ParseGisData.getAllProvinicalCapitals(getCaptialRebackFun);
		}
		//查询城市
		private function getCityName():void{
			ParseGisData.getAllCityPoints(getAllCityPointsReback);
		}
		//添加县
		private function getCounty():void{
			ParseGisData.getAllCountyPoints(getCountyReback);
		}
		//添加乡镇
		private function getTown():void{
			ParseGisData.getAllTownPoints(getTownReback);
		}
		//添加飞机场
		private function addAirPort( airArr : ArrayCollection ):void{
			if( airArr && airArr.length > 0 ){
				NodeAndLineManager.getInstance().addAirPort(airArr);
			}
			else{
				onlog("添加飞机场点失败");
			}
			loadObj.isAddAirPort = true;
		}
		
		//添加火车站点
		private function addSitePoint(siteArr : ArrayCollection):void{
			if( siteArr && siteArr.length > 0 ){
				NodeAndLineManager.getInstance().addSite(siteArr);
			}else{
				onlog("添加火车站点失败！！！");
			}
			loadObj.isAddSite = true;
		}
		
		//获取省会的返回点
		private function getCaptialRebackFun(capitalArr : ArrayCollection):void{
			if( capitalArr == null || capitalArr.length <= 0 ){
				onlog("获取省会失败！");
			}else{
				NodeAndLineManager.getInstance().addCapitalPoint(capitalArr);
			}
			loadObj.isAddCapital = true;
		}
		
		//添加城市名
		private function getAllCityPointsReback(cityArr : ArrayCollection):void{
			if( cityArr && cityArr.length > 0 ){
				NodeAndLineManager.getInstance().addCity(cityArr);
			}else{
				onlog("获取城市集合失败！！！！！！");
			}
			loadObj.isAddCity = true;
		}
		//添加县市
		private function getCountyReback( countyArr : ArrayCollection ):void{
			if( countyArr && countyArr.length > 0 ){
				NodeAndLineManager.getInstance().addCounty(countyArr);
			}else{
				onlog("获取县失败!!!");
			}
			loadObj.isAddCounty = true;
		}
		//获取乡镇
		private function getTownReback( townArr : ArrayCollection ):void{
			if( townArr && townArr.length > 0 ){
				NodeAndLineManager.getInstance().addTown(townArr);
			}else{
				onlog("添加乡镇失败！！！");
			}
			loadObj.isAddTown = true;
		}
		//边界线
		//单独调用画省边线
		private function getAreaProvince():void{
			ParseGisData.getAreaRangeProvincePolygonIds(gisMap.currentCol,gisMap.currentRow,gisMap.level,getAreaProvinceReback);	
		}	
		//省边界线
		private function getProvincialLineInMaxMinCoordinate():void{
			ParseGisData.getProvincialLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getAreaProvinceReback2);
		}
		//查询市边界线
		private function getCityPoints():void{
			ParseGisData.getAreaRangeCityPolygonPoints(gisMap.currentCol,gisMap.currentRow,gisMap.level,getCityPointsReback);
		}
		//添加县市边界
		private function getCountyBorder():void{
			ParseGisData.getAreaRangeCountyPolygonPoints(gisMap.currentCol,gisMap.currentRow,gisMap.level,getCountyBorderReback);
		}
		
		/**
		 * 获取边线成功回调函数
		 */
		private function getAreaProvinceReback(lineArr : ArrayCollection):void{
			
			if( lineArr == null || lineArr.length <=0 ){
				LogManager.getInstance().onLogMessage("当前区域没有边界线");
			}else{
				for( var i :int = 0; i< lineArr.length; i++ ){
					onlog("添加第"+(i+1)+"个边界线！！");
					NodeAndLineManager.getInstance().addBoundary(lineArr[i]);
				}
			}
			loadObj.isAddBounder = true;
			checkIsAllLoad();
		}
		
		/**
		 * 获取边线成功回调函数2
		 */
		private function getAreaProvinceReback2(lineArr : ArrayCollection):void{
			var eventName : String = "addProvince";
			DataUtil.getInstance().addEventListener(eventName,addProvinceSuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getProvincialLinePointById,NodeAndLineManager.getInstance().addBoundary,eventName,"添加省界");
		}
		private function addProvinceSuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addProvince",addProvinceSuccessed);
			loadObj.isAddBounder = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的城市快速车道-----------------------------------------------------------//
		private function getExpresswayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addExpressway";
			DataUtil.getInstance().addEventListener(eventName,addExpressWaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getExpresswayLinePointById,NodeAndLineManager.getInstance().addExpresswayLine,eventName,"城市快线");
		}
		private function addExpressWaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addExpressway",addExpressWaySuccessed);
			loadObj.isAddExpressway = true;
			checkIsAllLoad();
		}
		
		//添加城市边界
		private function getCityPointsReback(cityPointArr : ArrayCollection):void{
			if( cityPointArr && cityPointArr.length > 0 ){
				for( var i :int = 0; i< cityPointArr.length; i++ ){
					onlog("添加第"+(i+1)+"个边界线！！");
					NodeAndLineManager.getInstance().addCityBorder(cityPointArr[i]);
				}
			}else{
				onlog("该区域内没有城市边界线！");
			}
			loadObj.isAddCityBorder = true;
			checkIsAllLoad();
		}
		
		//添加县市边界
		private function getCountyBorderReback(countyArr : ArrayCollection):void{
			if( countyArr && countyArr.length > 0 ){
				var i : int = 1;
				for each( var item : ArrayCollection in countyArr ){
					onlog("添加第"+i+"条县市边界线");
					NodeAndLineManager.getInstance().addCountyBorder(item);
				}
			}else{
				onlog("该区域没有县市边界线！！！！！！");
			}
			loadObj.isAddCountyBorder = true;
			checkIsAllLoad();
		}
		
		//铁路，高速，国道，省道，城市快速车道，县道
		//画铁路线
		private function getRoadLines():void{
			ParseGisData.getAreaLines(gisMap.currentCol,gisMap.currentRow,gisMap.level,getLinesSuccessed);
		}
		//添加高速道路
		private function getHeightwayLines():void{
			ParseGisData.getHighwayLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getHeightwayLinesReback);
		}
		//添加国道
		private function getNationalHighwayLine():void{
			ParseGisData.getNationalHighwayLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getNationalHighwayLineReback);
		}
		//添加省道
		private function getProvincialHighway():void{
			ParseGisData.getProvincialHighwayLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getProvincialHighwayReback);
		}
		//添加城市快速车道
		private function getExpressway():void{
			ParseGisData.getExpresswayLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getExpresswayReback);
		}
		//添加县道路
		private function getCountyHighway():void{
			ParseGisData.getCountyHighwayLineInMaxMinCoordinate(gisMap.currentCol,gisMap.currentRow,gisMap.level,getCountyHighwayReback);
		}
		//-------------------------------------------------区域内的铁路线-----------------------------------------------------------//
		private var roadLineArr : ArrayCollection;
		private var lineLength:Number; 
		private var lineIndex: int = 0;
		private var resNum : int = 0;
		private function getLinesSuccessed(lineArr:ArrayCollection):void{
			if( lineArr == null || lineArr.length <= 0 ){
				LogManager.getInstance().onLogMessage("查询的区域没有铁路线！");
				loadObj.isAddrailway = true;
				checkIsAllLoad();
			}else{
				LogManager.getInstance().onLogMessage("查询的区域共有"+lineArr.length+"铁路线！");
				lineLength = lineArr.length;
				roadLineArr = lineArr;
				getPoint();
			}
		}
		private function getPoint():void{
			for( var i:int = lineIndex;i < roadLineArr.length;i++ ){
				lineIndex++;
				var lineID : String = roadLineArr[i].id;
				if( StringUtil.trim(lineID) != "" ){
					LogManager.getInstance().onLogMessage("根据线ID查询！线ID是："+lineID);
					ParseGisData.getPointByLineId(lineID,getPointByLineIDSuccessed);
				}
				if( lineIndex%20 == 0 ){
					break;	
				}
			}
		}
		private function getPointByLineIDSuccessed(pointArr : ArrayCollection):void{
			lineLength--;
			resNum++;	
			if( pointArr == null || pointArr.length <= 0 ){
				LogManager.getInstance().onLogMessage("查询的线没有点！");
				return;
			}
			NodeAndLineManager.getInstance().addNodeAndLine(pointArr);
			if( lineLength == 0 ){
				trace("当前区域的线画完了。");
				resNum = 0;
				lineIndex = 0;
				roadLineArr = null;
				loadObj.isAddrailway = true;
				checkIsAllLoad();
			}else{
				onlog("没有画完的铁路线:"+lineLength);
			}
			if( resNum == 20 ){
				resNum = 0;
				getPoint();
			}
		}
		//-------------------------------------------------区域内的高速-----------------------------------------------------------//
		private var heightWayLineArrLength:Number = 0;
		private var heightWayLineArr : ArrayCollection;
		private var wayLineIndex : int = 0;
		private var wayLineRes : int = 0;
		private function getHeightwayLinesReback(heightwayArr : ArrayCollection):void{
			if(heightwayArr == null || heightwayArr.length <= 0){
				onlog("高速路路段当前区域没有结果！！！");
				loadObj.isAddHighwayLine = true;
				checkIsAllLoad();
			}else{
				heightWayLineArrLength = heightwayArr.length;
				heightWayLineArr = heightwayArr;
				getEveryLineByID();
			}
		}
		private function getEveryLineByID():void{
			for( var i : int = wayLineIndex; i < heightWayLineArr.length;i++ ){
				wayLineIndex++;
				var lineId : String = heightWayLineArr[i].id;
				onlog("当前区域高速公路查询的线ID:"+lineId);
				ParseGisData.getHighwayLinePointById(lineId,getHeightWayPointByLineId);
				if( wayLineIndex%20 == 0 ){
					break;
				}
			}
		}
		private function getHeightWayPointByLineId(pointArr : ArrayCollection):void{
			heightWayLineArrLength--;
			wayLineRes++;
			if( pointArr == null || pointArr.length <= 0 ){
				onlog("查询的这个线段没有值！！");
				return;
			}
			NodeAndLineManager.getInstance().addHeightWayLine(pointArr);
			if( heightWayLineArrLength == 0 ){
				onlog("当前区域的高速路画完了！！！！");
				wayLineIndex = 0;
				wayLineRes = 0;
				heightWayLineArr = null;
				loadObj.isAddHighwayLine = true;
				checkIsAllLoad();
			}else{
				onlog("当前区域没有画完的高速线:"+heightWayLineArrLength);
			}
			if( wayLineRes == 20 ){
				wayLineRes = 0;
				getEveryLineByID();
			}
		}	
		//-------------------------------------------------区域内的国道-----------------------------------------------------------//
		private function getNationalHighwayLineReback(lineArr : ArrayCollection):void{
			var eventName : String = "addNationalHighway";
			DataUtil.getInstance().addEventListener(eventName,addNationalHightwaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getNationalHighwayLinePointById,NodeAndLineManager.getInstance().addNationalHeightWayLine,eventName,"国道");
		}
		private function addNationalHightwaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addNationalHighway",addNationalHightwaySuccessed);
			loadObj.isAddNationalHighwayLine = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的省道-----------------------------------------------------------//
		
		private function getProvincialHighwayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addProvincialHighway";
			DataUtil.getInstance().addEventListener(eventName,addProvincialHighwaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getProvincialHighwayLinePointById,NodeAndLineManager.getInstance().addProvincialHighwayLine,eventName,"省道");
		}
		private function addProvincialHighwaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addProvincialHighway",addProvincialHighwaySuccessed);
			loadObj.isAddProvincialHighway = true;
			checkIsAllLoad();
		}
		
		//-------------------------------------------------区域内的县道-----------------------------------------------------------//
		private function getCountyHighwayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addCountyHightWay";
			DataUtil.getInstance().addEventListener(eventName,addCountyHighWaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getCountyHighwayLinePointById,NodeAndLineManager.getInstance().addCountyHighwayLine,eventName,"县道");
		}
		private function addCountyHighWaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addCountyHightWay",addCountyHighWaySuccessed);
			loadObj.isAddCountyHighway = true;
			checkIsAllLoad();
		}
		
		
		/**
		 *	判断当前区域内的线是否全部加载成功！ 
		 */
		private function checkIsAllLoad():void{
			
			loadData();
			
			for each( var item : Boolean in loadObj){
				if( item == false ){
					return;
				}
			}
			for( var key : String in loadObj ){
				if( key != "isAddAirPort" && key != "isAddSite" && key != "isAddCapital" && key != "isAddCity" &&  key != "isAddCounty" && key != "isAddTown"  ){
					loadObj[key] = false;
				}
			}
			dispatchEvent(new Event("drawSuccessed"));
		}

		private function onlog(message:String):void{
			LogManager.getInstance().onLogMessage(message);
		}
	}
}